const { FieldValue } = require('firebase-admin/firestore');

/**
 * Pad a number to two digits.
 * @param {number} n
 * @returns {string}
 */
function pad(n) {
  return String(n).padStart(2, '0');
}

/**
 * Format a Date object as 'YYYY-MM-DD'.
 * @param {Date} date
 * @returns {string}
 */
function formatDate(date) {
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`;
}

/**
 * Atomically increment global, manager, and daily stats counters
 * when a new license is generated.
 *
 * Firestore paths:
 *   stats/global               — totalLicenses field
 *   stats/managers/{managerId} — totalLicenses field
 *   stats/daily/{YYYY-MM-DD}   — totalLicenses field
 *
 * @param {FirebaseFirestore.Firestore} db - Firestore instance
 * @param {string} managerId - the manager who generated the license
 * @param {Date} date - timestamp of the generation event
 * @returns {Promise<void>}
 */
async function incrementDailyStats(db, managerId, date) {
  const dateId = formatDate(date);
  const batch = db.batch();

  const globalRef = db.doc('stats/global');
  const managerRef = db.doc(`stats_managers/${managerId}`);
  const dailyRef = db.doc(`stats_daily/${dateId}`);

  batch.set(globalRef, { totalLicenses: FieldValue.increment(1) }, { merge: true });
  batch.set(managerRef, { totalLicenses: FieldValue.increment(1) }, { merge: true });

  // Use mergeFields to avoid overwriting other managers in byManager map
  batch.set(dailyRef, {
    date: dateId,
    totalLicenses: FieldValue.increment(1),
    byManager: { [managerId]: FieldValue.increment(1) },
  }, { mergeFields: ['date', 'totalLicenses', `byManager.${managerId}`] });

  await batch.commit();
}

/**
 * Decrement the totalManagers counter in global stats.
 *
 * @param {FirebaseFirestore.Firestore} db - Firestore instance
 * @param {number} count - amount to decrement (positive number)
 * @returns {Promise<void>}
 */
async function decrementManagerCount(db, count) {
  const globalRef = db.doc('stats/global');
  await globalRef.set(
    { totalManagers: FieldValue.increment(-Math.abs(count)) },
    { merge: true }
  );
}

/**
 * Increment the totalManagers counter in global stats.
 *
 * @param {FirebaseFirestore.Firestore} db - Firestore instance
 * @param {number} count - amount to increment (positive number)
 * @returns {Promise<void>}
 */
async function incrementManagerCount(db, count) {
  const globalRef = db.doc('stats/global');
  await globalRef.set(
    { totalManagers: FieldValue.increment(Math.abs(count)) },
    { merge: true }
  );
}

module.exports = {
  incrementDailyStats,
  decrementManagerCount,
  incrementManagerCount,
  formatDate,
};
