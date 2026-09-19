const admin = require('firebase-admin');
const { onRequest } = require('firebase-functions/v2/https');

if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

/**
 * getAppConfig — Public HTTPS endpoint
 *
 * Returns app configuration values stored in Firestore (config/app doc).
 * The Flutter app fetches this on demand to get remote-controlled values
 * like the store URL.
 */
const getAppConfig = onRequest(
  { cors: true },
  async (req, res) => {
    try {
      const snap = await db.doc('config/app').get();
      const data = snap.exists ? snap.data() : {};
      res.status(200).json({ success: true, data });
    } catch (err) {
      console.error('getAppConfig error:', err);
      res.status(500).json({ success: false, error: 'internal' });
    }
  }
);

module.exports = { getAppConfig };
