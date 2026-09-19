const admin = require('firebase-admin');
const { onRequest } = require('firebase-functions/v2/https');
const { validateChecksum, stripLicenseKey } = require('./license');

if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

/**
 * activateLicense — Public HTTPS endpoint
 *
 * Called by the Flutter app (via http package) to validate and activate
 * a pool license key on a specific device.
 *
 * POST body (JSON):
 *   - licenseKey {string} — formatted key e.g. "CHRY-XXXX-XXXX-XXXX-XXXX"
 *   - deviceId   {string} — unique device identifier
 *
 * Responses:
 *   200 { success: true,  status: "activated" }         — freshly activated
 *   200 { success: true,  status: "already_activated" }  — same device, idempotent
 *   400 { success: false, error: "invalid_format" }
 *   400 { success: false, error: "invalid_checksum" }
 *   404 { success: false, error: "not_found" }
 *   409 { success: false, error: "already_used" }
 *   429 { success: false, error: "rate_limited" }
 */
const activateLicense = onRequest(
  { cors: true },
  async (req, res) => {
    // Only POST allowed
    if (req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'method_not_allowed' });
      return;
    }

    const { licenseKey, deviceId } = req.body || {};

    // 1. Validate inputs
    if (!licenseKey || typeof licenseKey !== 'string') {
      res.status(400).json({ success: false, error: 'invalid_format', message: 'License key is required.' });
      return;
    }

    if (!deviceId || typeof deviceId !== 'string' || deviceId.trim().length < 4) {
      res.status(400).json({ success: false, error: 'invalid_format', message: 'Valid device ID is required.' });
      return;
    }

    // 2. Format validation
    const cleaned = licenseKey.trim().toUpperCase();
    if (!/^CHRY-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{4}$/.test(cleaned)) {
      res.status(400).json({ success: false, error: 'invalid_format', message: 'Invalid license key format.' });
      return;
    }

    // 3. Checksum validation
    const raw = stripLicenseKey(cleaned);
    if (!validateChecksum(raw)) {
      res.status(400).json({ success: false, error: 'invalid_checksum', message: 'License key checksum failed.' });
      return;
    }

    // 4. Rate limiting — simple per-IP counter
    const ip = req.ip || req.headers['x-forwarded-for'] || 'unknown';
    const rateLimitRef = db.collection('rate_limits').doc(ip.replace(/[./]/g, '_'));

    try {
      const rateLimitDoc = await rateLimitRef.get();
      if (rateLimitDoc.exists) {
        const data = rateLimitDoc.data();
        const windowMs = 60 * 1000; // 1 minute window
        const now = Date.now();
        const windowStart = data.windowStart?.toMillis?.() || 0;

        if (now - windowStart < windowMs && data.count >= 10) {
          res.status(429).json({ success: false, error: 'rate_limited', message: 'Too many attempts. Try again later.' });
          return;
        }

        if (now - windowStart >= windowMs) {
          // Reset window
          await rateLimitRef.set({ count: 1, windowStart: admin.firestore.Timestamp.now() });
        } else {
          await rateLimitRef.update({ count: admin.firestore.FieldValue.increment(1) });
        }
      } else {
        await rateLimitRef.set({ count: 1, windowStart: admin.firestore.Timestamp.now() });
      }
    } catch (err) {
      // Non-critical — proceed even if rate limiting fails
      console.warn('Rate limit check failed:', err.message);
    }

    // 5. Activate via Firestore transaction
    const docRef = db.collection('licenses').doc(raw);

    try {
      const result = await db.runTransaction(async (tx) => {
        const doc = await tx.get(docRef);

        if (!doc.exists) {
          return { status: 404, body: { success: false, error: 'not_found', message: 'License key not found.' } };
        }

        const data = doc.data();

        if (data.status === 'used') {
          // Same device re-activation — idempotent success
          if (data.deviceId === deviceId.trim()) {
            return { status: 200, body: { success: true, status: 'already_activated' } };
          }
          // Different device — conflict
          return { status: 409, body: { success: false, error: 'already_used', message: 'License already activated on another device.' } };
        }

        // Mark as used
        tx.update(docRef, {
          status: 'used',
          deviceId: deviceId.trim(),
          usedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        return { status: 200, body: { success: true, status: 'activated' } };
      });

      // Update stats if freshly activated
      if (result.body.status === 'activated') {
        const now = new Date();
        const dateId = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;

        const batch = db.batch();

        // Decrement available count
        batch.set(
          db.doc('stats/pool'),
          { availableLicenses: admin.firestore.FieldValue.increment(-1) },
          { merge: true }
        );

        // Increment daily activation counter
        batch.set(
          db.doc(`stats_daily/${dateId}`),
          { date: dateId, count: admin.firestore.FieldValue.increment(1) },
          { merge: true }
        );

        await batch.commit();
      }

      res.status(result.status).json(result.body);
    } catch (err) {
      console.error('Activation error:', err);
      res.status(500).json({ success: false, error: 'internal', message: 'Internal server error.' });
    }
  }
);

module.exports = { activateLicense };
