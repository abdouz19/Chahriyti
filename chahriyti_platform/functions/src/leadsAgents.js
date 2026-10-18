const admin = require('firebase-admin');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { verifyRole } = require('./middleware');

if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

/**
 * createLeadsAgent — Admin-only callable
 *
 * Creates an account with the 'agent' role, which can only see and update leads.
 *
 * Expected data: { email, displayName, password (min 8) }
 */
const createLeadsAgent = onCall(async (request) => {
  const { uid: callerUid } = verifyRole(request, ['admin']);

  const { email, displayName, password } = request.data || {};
  const cleanEmail = typeof email === 'string' ? email.trim().toLowerCase() : '';
  const cleanName = typeof displayName === 'string' ? displayName.trim() : '';

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(cleanEmail)) {
    throw new HttpsError('invalid-argument', 'البريد الإلكتروني غير صالح');
  }
  if (!cleanName) {
    throw new HttpsError('invalid-argument', 'الاسم مطلوب');
  }
  if (typeof password !== 'string' || password.length < 8) {
    throw new HttpsError('invalid-argument', 'كلمة المرور يجب أن تكون 8 أحرف على الأقل');
  }

  let userRecord;
  try {
    userRecord = await admin.auth().createUser({
      email: cleanEmail,
      password,
      displayName: cleanName,
    });
  } catch (error) {
    if (error.code === 'auth/email-already-exists') {
      throw new HttpsError('already-exists', 'يوجد حساب بهذا البريد الإلكتروني');
    }
    throw new HttpsError('internal', 'فشل إنشاء الحساب');
  }

  await admin.auth().setCustomUserClaims(userRecord.uid, { role: 'agent' });

  await db.collection('users').doc(userRecord.uid).set({
    uid: userRecord.uid,
    email: cleanEmail,
    displayName: cleanName,
    role: 'agent',
    status: 'active',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    createdBy: callerUid,
  });

  return {
    success: true,
    data: { uid: userRecord.uid, email: cleanEmail, displayName: cleanName, role: 'agent' },
  };
});

/**
 * setLeadsAgentStatus — Admin-only callable
 *
 * Enables or disables an agent account. Disabling also signs them out everywhere.
 *
 * Expected data: { uid, status: 'active' | 'inactive' }
 */
const setLeadsAgentStatus = onCall(async (request) => {
  verifyRole(request, ['admin']);

  const { uid, status } = request.data || {};
  if (!uid || typeof uid !== 'string') {
    throw new HttpsError('invalid-argument', 'User UID is required.');
  }
  if (!['active', 'inactive'].includes(status)) {
    throw new HttpsError('invalid-argument', 'Status must be "active" or "inactive".');
  }

  const ref = db.collection('users').doc(uid);
  const snap = await ref.get();
  if (!snap.exists || snap.data().role !== 'agent') {
    throw new HttpsError('not-found', 'Agent not found.');
  }

  const disabled = status === 'inactive';
  await admin.auth().updateUser(uid, { disabled });
  if (disabled) await admin.auth().revokeRefreshTokens(uid);

  await ref.update({ status, updatedAt: admin.firestore.FieldValue.serverTimestamp() });

  return { success: true, data: { uid, status } };
});

module.exports = { createLeadsAgent, setLeadsAgentStatus };
