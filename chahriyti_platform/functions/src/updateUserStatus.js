const admin = require('firebase-admin');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { verifyRole } = require('./middleware');
const { incrementManagerCount, decrementManagerCount } = require('./stats');

// Ensure Firebase Admin is initialised exactly once
if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

/**
 * updateUserStatus — HTTPS Callable Cloud Function
 *
 * Allows admins to activate or deactivate a user account.
 *
 * Expected data:
 *   - uid    {string} — the target user's UID
 *   - status {string} — 'active' or 'inactive'
 *
 * Returns:
 *   { success: true, data: { uid, status, updatedAt } }
 */
const updateUserStatus = onCall(async (request) => {
  // 1. Authenticate & authorise — only admins may call this
  const { uid: callerUid } = verifyRole(request, ['admin']);

  // 2. Extract and validate inputs
  const { uid, status } = request.data || {};

  if (!uid || typeof uid !== 'string' || uid.trim().length === 0) {
    throw new HttpsError('invalid-argument', 'User UID is required.');
  }

  if (!status || !['active', 'inactive'].includes(status)) {
    throw new HttpsError('invalid-argument', 'Status must be "active" or "inactive".');
  }

  // 3. Prevent self-lockout
  if (uid === callerUid) {
    throw new HttpsError('failed-precondition', 'You cannot change your own status.');
  }

  // 4. If deactivating, ensure this is not the last active admin
  if (status === 'inactive') {
    const userDoc = await db.collection('users').doc(uid).get();
    if (userDoc.exists && userDoc.data().role === 'admin') {
      const activeAdmins = await db
        .collection('users')
        .where('role', '==', 'admin')
        .where('status', '==', 'active')
        .get();

      if (activeAdmins.size <= 1) {
        throw new HttpsError(
          'failed-precondition',
          'Cannot deactivate the last active admin.'
        );
      }
    }
  }

  // 5. Update user document status
  const updatedAt = admin.firestore.FieldValue.serverTimestamp();
  await db.collection('users').doc(uid).update({
    status,
    updatedAt,
  });

  // 6. If deactivating, revoke refresh tokens to force sign-out
  if (status === 'inactive') {
    await admin.auth().revokeRefreshTokens(uid);
  }

  // 7. Update stats counters
  if (status === 'active') {
    await incrementManagerCount(db, 1);
  } else {
    await decrementManagerCount(db, 1);
  }

  // 8. Return success payload
  return {
    success: true,
    data: {
      uid,
      status,
      updatedAt: new Date().toISOString(),
    },
  };
});

module.exports = { updateUserStatus };
