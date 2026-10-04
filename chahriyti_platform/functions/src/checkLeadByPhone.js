const admin = require('firebase-admin');
const { onRequest } = require('firebase-functions/v2/https');

if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

/**
 * checkLeadByPhone — Public HTTPS endpoint
 *
 * Query param: ?phone=<phone_number>
 * Returns { exists: true } if a lead with that phone already exists, else { exists: false }.
 */
const checkLeadByPhone = onRequest(
  { cors: true },
  async (req, res) => {
    const phone = req.query.phone || (req.body && req.body.phone);

    if (!phone) {
      return res.status(400).json({ success: false, error: 'phone required' });
    }

    try {
      const snap = await db
        .collection('leads')
        .where('phone', '==', phone)
        .limit(1)
        .get();

      return res.status(200).json({ success: true, exists: !snap.empty });
    } catch (err) {
      console.error('checkLeadByPhone error:', err);
      return res.status(500).json({ success: false, error: 'internal' });
    }
  }
);

module.exports = { checkLeadByPhone };
