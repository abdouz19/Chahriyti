const admin = require('firebase-admin');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { verifyRole } = require('./middleware');
const { incrementManagerCount } = require('./stats');

// Ensure Firebase Admin is initialised exactly once
if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

/**
 * createManager — HTTPS Callable Cloud Function
 *
 * Allows admins to create a new manager account.
 *
 * Expected data:
 *   - email       {string} — valid email address
 *   - displayName {string} — non-empty display name
 *   - password    {string} — minimum 8 characters
 *
 * Returns:
 *   { success: true, data: { uid, email, displayName, role: 'manager' } }
 */
const createManager = onCall(async (request) => {
  // 1. Authenticate & authorise — only admins may call this
  const { uid: callerUid } = verifyRole(request, ['admin']);

  // 2. Extract and validate inputs
  const { email, displayName, password } = request.data || {};

  if (!email || typeof email !== 'string' || email.trim().length === 0) {
    throw new HttpsError('invalid-argument', 'Email is required.');
  }

  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailPattern.test(email.trim())) {
    throw new HttpsError('invalid-argument', 'Invalid email address.');
  }

  if (!displayName || typeof displayName !== 'string' || displayName.trim().length === 0) {
    throw new HttpsError('invalid-argument', 'Display name is required.');
  }

  if (!password || typeof password !== 'string' || password.length < 8) {
    throw new HttpsError('invalid-argument', 'Password must be at least 8 characters.');
  }

  // 3. Create Firebase Auth user
  let userRecord;
  try {
    userRecord = await admin.auth().createUser({
      email: email.trim(),
      password,
      displayName: displayName.trim(),
    });
  } catch (error) {
    if (error.code === 'auth/email-already-exists') {
      throw new HttpsError('already-exists', 'A user with this email already exists.');
    }
    throw new HttpsError('internal', 'Failed to create user account.');
  }

  // 4. Set custom claims
  await admin.auth().setCustomUserClaims(userRecord.uid, { role: 'manager' });

  // 5. Create user document in Firestore
  await db.collection('users').doc(userRecord.uid).set({
    uid: userRecord.uid,
    email: email.trim(),
    displayName: displayName.trim(),
    role: 'manager',
    status: 'active',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    createdBy: callerUid,
  });

  // 6. Update global stats
  await incrementManagerCount(db, 1);

  // 7. Return success payload
  return {
    success: true,
    data: {
      uid: userRecord.uid,
      email: email.trim(),
      displayName: displayName.trim(),
      role: 'manager',
    },
  };
});

module.exports = { createManager };
