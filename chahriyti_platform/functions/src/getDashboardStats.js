const { onCall } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

if (!admin.apps.length) admin.initializeApp();

const { verifyRole } = require('./middleware');

function formatDate(d) {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
}

function periodToDays(period) {
  switch (period) {
    case 'week': return 7;
    case 'quarter': return 90;
    case 'year': return 365;
    case 'month':
    default: return 30;
  }
}

/**
 * getDashboardStats — returns activation trend data from stats_daily.
 */
const getDashboardStats = onCall(async (request) => {
  verifyRole(request, ['admin']);

  const period = request.data?.period || 'month';
  const db = admin.firestore();
  const now = new Date();
  const days = periodToDays(period);

  const currentStart = new Date(now);
  currentStart.setDate(currentStart.getDate() - days);

  const previousStart = new Date(currentStart);
  previousStart.setDate(previousStart.getDate() - days);

  const previousStartStr = formatDate(previousStart);
  const currentStartStr = formatDate(currentStart);
  const todayStr = formatDate(now);

  // Query daily stats covering both current and previous periods
  const dailySnap = await db
    .collection('stats_daily')
    .where('date', '>=', previousStartStr)
    .orderBy('date', 'asc')
    .get();

  let currentTotal = 0;
  let previousTotal = 0;
  let todayClients = 0;
  const dailyCounts = [];

  dailySnap.forEach((doc) => {
    const data = doc.data();
    const dateStr = data.date || doc.id;
    const count = data.count || 0;

    if (dateStr >= currentStartStr) {
      currentTotal += count;
      dailyCounts.push({ date: dateStr, count });
      if (dateStr === todayStr) {
        todayClients = count;
      }
    } else if (dateStr >= previousStartStr) {
      previousTotal += count;
    }
  });

  // Growth percentage
  let growthPercent = 0;
  if (previousTotal > 0) {
    growthPercent = Math.round(((currentTotal - previousTotal) / previousTotal) * 100);
  } else if (currentTotal > 0) {
    growthPercent = 100;
  }

  return {
    success: true,
    data: {
      monthClients: currentTotal,
      todayClients,
      growthPercent,
      dailyCounts,
    },
  };
});

module.exports = { getDashboardStats };
