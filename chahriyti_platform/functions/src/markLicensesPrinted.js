const admin = require('firebase-admin');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { verifyRole } = require('./middleware');
const { stripLicenseKey } = require('./license');

if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

/**
 * markLicensesPrinted — Admin/Manager Cloud Function
 *
 * Marks a list of licenses as printed by setting `printed: true`
 * and `printedAt` to the server timestamp on each license document.
 *
 * Expected data:
 *   - licenseKeys {string[]} — array of formatted license keys (e.g. "CHRY-XXXX-XXXX-XXXX-XXXX")
 *
 * Returns:
 *   { success: true, count: number }
 */
const markLicensesPrinted = onCall(async (request) => {
  // 1. Auth — admin or manager
  verifyRole(request, ['admin', 'manager']);

  // 2. Validate inputs
  const { licenseKeys } = request.data || {};

  if (!Array.isArray(licenseKeys) || licenseKeys.length === 0) {
    throw new HttpsError(
      'invalid-argument',
      'licenseKeys must be a non-empty array of strings.'
    );
  }

  // 3. Strip keys to 16-char doc IDs
  const docIds = licenseKeys.map((key) => {
    if (typeof key !== 'string') {
      throw new HttpsError('invalid-argument', 'Each license key must be a string.');
    }
    return stripLicenseKey(key.trim().toUpperCase());
  });

  // 4. Batched writes (Firestore limit: 500 per batch)
  const BATCH_SIZE = 500;
  let updated = 0;

  for (let i = 0; i < docIds.length; i += BATCH_SIZE) {
    const chunk = docIds.slice(i, i + BATCH_SIZE);
    const batch = db.batch();

    for (const docId of chunk) {
      const ref = db.collection('licenses').doc(docId);
      batch.update(ref, {
        printed: true,
        printedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    updated += chunk.length;
  }

  return { success: true, count: updated };
});

module.exports = { markLicensesPrinted };
