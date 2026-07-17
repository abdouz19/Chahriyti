const admin = require('firebase-admin');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { verifyRole } = require('./middleware');
const { generateLicenseKey } = require('./license');
const { incrementDailyStats } = require('./stats');

// Ensure Firebase Admin is initialised exactly once
if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

/**
 * generateLicense — HTTPS Callable Cloud Function
 *
 * Allows managers and admins to generate a license key for a client device.
 *
 * Expected data:
 *   - clientName {string} — the client's display name
 *   - phone      {string} — the client's phone number
 *   - deviceId   {string} — unique hex device identifier
 *
 * Returns:
 *   { success: true, data: { clientId, licenseKey, expiryDate, generatedAt } }
 */
const generateLicense = onCall(async (request) => {
  // -----------------------------------------------------------------------
  // 1. Authenticate & authorise — only managers and admins may call this
  // -----------------------------------------------------------------------
  const { uid } = verifyRole(request, ['manager', 'admin']);

  // -----------------------------------------------------------------------
  // 2. Extract and validate inputs
  // -----------------------------------------------------------------------
  const { clientName, phone, deviceId } = request.data || {};

  if (!clientName || typeof clientName !== 'string' || clientName.trim().length === 0) {
    throw new HttpsError('invalid-argument', 'Client name is required.');
  }

  if (!phone || typeof phone !== 'string' || phone.trim().length === 0) {
    throw new HttpsError('invalid-argument', 'Phone number is required.');
  }

  if (!deviceId || typeof deviceId !== 'string' || deviceId.trim().length === 0) {
    throw new HttpsError('invalid-argument', 'Device ID is required.');
  }

  if (deviceId.trim().length < 4) {
    throw new HttpsError('invalid-argument', 'Device ID is too short.');
  }

  // -----------------------------------------------------------------------
  // 3. Compute expiry — 12 months from now in YYYYMM format
  // -----------------------------------------------------------------------
  const now = new Date();
  const expiryDate = new Date(now.getFullYear(), now.getMonth() + 12, 1);
  const expiryYYYYMM = `${expiryDate.getFullYear()}${String(expiryDate.getMonth() + 1).padStart(2, '0')}`;

  // -----------------------------------------------------------------------
  // 4. Generate license key
  // -----------------------------------------------------------------------
  const licenseKey = generateLicenseKey(deviceId.trim(), expiryYYYYMM);

  // -----------------------------------------------------------------------
  // 5. Look up manager name from their user document
  // -----------------------------------------------------------------------
  let managerName = '';
  try {
    const managerDoc = await db.collection('users').doc(uid).get();
    if (managerDoc.exists) {
      managerName = managerDoc.data().displayName || '';
    }
  } catch (err) {
    // Non-critical — proceed with empty manager name
    console.warn('Could not fetch manager name:', err.message);
  }

  // -----------------------------------------------------------------------
  // 6. Write client document to Firestore
  // -----------------------------------------------------------------------
  const clientData = {
    clientName: clientName.trim(),
    phone: phone.trim(),
    deviceId: deviceId.trim(),
    licenseKey,
    expiryDate: expiryYYYYMM,
    generatedAt: admin.firestore.FieldValue.serverTimestamp(),
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    managerId: uid,
    managerName,
  };

  const clientRef = await db.collection('clients').add(clientData);

  // -----------------------------------------------------------------------
  // 7. Increment daily / global / manager stats
  // -----------------------------------------------------------------------
  await incrementDailyStats(db, uid, now);

  // -----------------------------------------------------------------------
  // 8. Return success payload
  // -----------------------------------------------------------------------
  return {
    success: true,
    data: {
      clientId: clientRef.id,
      licenseKey,
      expiryDate: expiryYYYYMM,
      generatedAt: now.toISOString(),
    },
  };
});

module.exports = { generateLicense };
