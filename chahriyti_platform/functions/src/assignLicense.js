const admin = require('firebase-admin');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { verifyRole } = require('./middleware');
const { stripLicenseKey, validateChecksum } = require('./license');

if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

/**
 * assignLicense — Manager/Admin Cloud Function
 *
 * Pre-delivery assignment: records who a license is intended for
 * without marking it as used. The license remains "available" until
 * the end user activates it in the Flutter app.
 *
 * Expected data:
 *   - licenseKey  {string} — formatted key
 *   - clientName  {string} — client's display name
 *   - phone       {string} — client's phone number
 *
 * Returns:
 *   { success: true }
 */
const assignLicense = onCall(async (request) => {
  // 1. Auth
  const { uid } = verifyRole(request, ['manager', 'admin']);

  // 2. Validate inputs
  const { licenseKey, clientName, phone } = request.data || {};

  if (!licenseKey || typeof licenseKey !== 'string') {
    throw new HttpsError('invalid-argument', 'License key is required.');
  }

  if (!clientName || typeof clientName !== 'string' || clientName.trim().length === 0) {
    throw new HttpsError('invalid-argument', 'Client name is required.');
  }

  if (!phone || typeof phone !== 'string' || phone.trim().length === 0) {
    throw new HttpsError('invalid-argument', 'Phone number is required.');
  }

  // 3. Validate key format and checksum
  const cleaned = licenseKey.trim().toUpperCase();
  const raw = stripLicenseKey(cleaned);

  if (raw.length !== 16 || !validateChecksum(raw)) {
    throw new HttpsError('invalid-argument', 'Invalid license key.');
  }

  // 4. Look up license and assign
  const docRef = db.collection('licenses').doc(raw);
  const doc = await docRef.get();

  if (!doc.exists) {
    throw new HttpsError('not-found', 'License key not found in pool.');
  }

  const data = doc.data();

  if (data.status === 'used') {
    throw new HttpsError('failed-precondition', 'License already activated. Cannot assign.');
  }

  // 5. Look up manager name
  let managerName = '';
  try {
    const managerDoc = await db.collection('users').doc(uid).get();
    if (managerDoc.exists) {
      managerName = managerDoc.data().displayName || '';
    }
  } catch (err) {
    console.warn('Could not fetch manager name:', err.message);
  }

  // 6. Update assignment fields
  await docRef.update({
    assignedTo: clientName.trim(),
    assignedPhone: phone.trim(),
    assignedBy: uid,
    assignedByName: managerName,
    assignedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { success: true };
});

module.exports = { assignLicense };
