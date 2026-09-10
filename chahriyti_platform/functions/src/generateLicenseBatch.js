const admin = require('firebase-admin');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { verifyRole } = require('./middleware');
const { generatePoolLicenseKey, stripLicenseKey } = require('./license');

if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

/**
 * generateLicenseBatch — Admin-only Cloud Function
 *
 * Generates a batch of cryptographically random pool license keys
 * and stores them in the `licenses` collection.
 *
 * Expected data:
 *   - count {number} — number of keys to generate (1–1000)
 *
 * Returns:
 *   { success: true, batchId: string, count: number }
 */
const generateLicenseBatch = onCall(
  { timeoutSeconds: 300 },
  async (request) => {
    // 1. Auth — admin only
    verifyRole(request, ['admin']);

    // 2. Validate count
    const { count } = request.data || {};
    if (!count || typeof count !== 'number' || count < 1 || count > 1000) {
      throw new HttpsError(
        'invalid-argument',
        'Count must be a number between 1 and 1000.'
      );
    }

    // 3. Generate unique keys
    const batchId = `batch_${new Date().toISOString().slice(0, 19).replace(/[T:]/g, '-')}`;
    const keys = new Set();

    // Generate keys, ensuring uniqueness within this batch
    while (keys.size < count) {
      const key = generatePoolLicenseKey();
      keys.add(key);
    }

    // 4. Write to Firestore in batches of 500 (Firestore limit)
    const keysArray = Array.from(keys);
    const BATCH_SIZE = 500;
    let written = 0;

    for (let i = 0; i < keysArray.length; i += BATCH_SIZE) {
      const chunk = keysArray.slice(i, i + BATCH_SIZE);
      const batch = db.batch();

      for (const formattedKey of chunk) {
        const docId = stripLicenseKey(formattedKey);
        const ref = db.collection('licenses').doc(docId);
        batch.set(ref, {
          licenseKey: formattedKey,
          status: 'available',
          batchId,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      written += chunk.length;
    }

    // 5. Update global pool stats
    const statsRef = db.collection('stats').doc('pool');
    await statsRef.set(
      {
        totalLicenses: admin.firestore.FieldValue.increment(written),
        availableLicenses: admin.firestore.FieldValue.increment(written),
        lastBatchId: batchId,
        lastBatchAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );

    return {
      success: true,
      batchId,
      count: written,
    };
  }
);

module.exports = { generateLicenseBatch };
