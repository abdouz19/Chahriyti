const { onCall, HttpsError } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

if (!admin.apps.length) admin.initializeApp();

const { verifyRole } = require('./middleware');
const { formatDate } = require('./stats');

/**
 * Map a period key to the number of days it covers.
 * @param {string} period
 * @returns {number}
 */
function periodToDays(period) {
  switch (period) {
    case 'week':
      return 7;
    case 'quarter':
      return 90;
    case 'year':
      return 365;
    case 'month':
    default:
      return 30;
  }
}

/**
 * getDashboardStats — HTTPS Callable Cloud Function.
 *
 * Returns aggregated dashboard statistics for manager and admin dashboards.
 *
 * @param {object} params
 * @param {string}  [params.period='month']  — one of 'week', 'month', 'quarter', 'year'
 * @param {string}  [params.managerId]       — optional manager ID for admin drill-down
 * @returns {{ success: boolean, data: object }}
 */
const getDashboardStats = onCall(async (request) => {
  const { uid, role } = verifyRole(request, ['admin', 'manager']);

  const period = request.data?.period || 'month';
  let managerId = request.data?.managerId || null;

  // Managers can only view their own stats
  if (role === 'manager') {
    managerId = uid;
  }

  const db = admin.firestore();
  const now = new Date();
  const days = periodToDays(period);

  // Current period start
  const currentStart = new Date(now);
  currentStart.setDate(currentStart.getDate() - days);

  // Previous period start (for growth calculation)
  const previousStart = new Date(currentStart);
  previousStart.setDate(previousStart.getDate() - days);

  // -----------------------------------------------------------------------
  // 1. Global stats
  // -----------------------------------------------------------------------
  const globalSnap = await db.doc('stats/global').get();
  const globalData = globalSnap.exists ? globalSnap.data() : {};
  const totalClients = globalData.totalLicenses || 0;
  const totalManagers = globalData.totalManagers || 0;

  // -----------------------------------------------------------------------
  // 2. Per-manager stats (when applicable)
  // -----------------------------------------------------------------------
  let managerTotalClients = null;
  if (managerId) {
    const managerSnap = await db.doc(`stats_managers/${managerId}`).get();
    const managerData = managerSnap.exists ? managerSnap.data() : {};
    managerTotalClients = managerData.totalLicenses || 0;
  }

  // -----------------------------------------------------------------------
  // 3. Daily stats for current + previous period
  // -----------------------------------------------------------------------
  const previousStartStr = formatDate(previousStart);
  const dailySnap = await db
    .collection('stats_daily')
    .where('date', '>=', previousStartStr)
    .orderBy('date', 'asc')
    .get();

  const currentStartStr = formatDate(currentStart);
  const todayStr = formatDate(now);

  let currentTotal = 0;
  let previousTotal = 0;
  let todayClients = 0;
  const dailyCounts = [];

  dailySnap.forEach((doc) => {
    const data = doc.data();
    const dateStr = data.date || doc.id;
    const count = managerId
      ? (data.byManager?.[managerId] ?? 0)
      : (data.totalLicenses || 0);

    if (dateStr >= currentStartStr) {
      // Current period
      currentTotal += count;
      dailyCounts.push({ date: dateStr, count });

      if (dateStr === todayStr) {
        todayClients = count;
      }
    } else if (dateStr >= previousStartStr) {
      // Previous period (for growth)
      previousTotal += count;
    }
  });

  // -----------------------------------------------------------------------
  // 4. Growth percentage
  // -----------------------------------------------------------------------
  let growthPercent = 0;
  if (previousTotal > 0) {
    growthPercent = Math.round(
      ((currentTotal - previousTotal) / previousTotal) * 100
    );
  } else if (currentTotal > 0) {
    growthPercent = 100;
  }

  // -----------------------------------------------------------------------
  // 5. Manager leaderboard (admin only, aggregate view)
  // -----------------------------------------------------------------------
  let managerLeaderboard = [];
  if (role === 'admin' && !managerId) {
    const usersSnap = await db
      .collection('users')
      .where('role', '==', 'manager')
      .get();

    const leaderboardPromises = usersSnap.docs.map(async (userDoc) => {
      const userData = userDoc.data();
      const statsSnap = await db.doc(`stats_managers/${userDoc.id}`).get();
      const statsData = statsSnap.exists ? statsSnap.data() : {};

      return {
        managerId: userDoc.id,
        name: userData.displayName || userData.email || 'Unknown',
        count: statsData.totalLicenses || 0,
      };
    });

    managerLeaderboard = await Promise.all(leaderboardPromises);
    managerLeaderboard.sort((a, b) => b.count - a.count);
  }

  // -----------------------------------------------------------------------
  // 6. Build response
  // -----------------------------------------------------------------------
  const responseData = {
    totalClients: managerId ? managerTotalClients : totalClients,
    monthClients: currentTotal,
    todayClients,
    totalManagers,
    growthPercent,
    dailyCounts,
    managerLeaderboard,
  };

  return { success: true, data: responseData };
});

module.exports = { getDashboardStats };
