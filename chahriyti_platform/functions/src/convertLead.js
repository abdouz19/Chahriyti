const admin = require('firebase-admin');
const { onRequest } = require('firebase-functions/v2/https');

if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

/**
 * convertLead — Public HTTPS endpoint (called from Flutter after license activation)
 *
 * Body: { phone: string }
 * Finds the lead with matching phone and sets status to "converted".
 * No-op if lead not found.
 */
const convertLead = onRequest(
  { cors: true },
  async (req, res) => {
    const phone = req.body?.phone;

    if (!phone) {
      return res.status(400).json({ success: false, error: 'phone required' });
    }

    try {
      const snap = await db
        .collection('leads')
        .where('phone', '==', phone)
        .limit(1)
        .get();

      if (!snap.empty) {
        await snap.docs[0].ref.update({ status: 'converted' });
      }

      return res.status(200).json({ success: true });
    } catch (err) {
      console.error('convertLead error:', err);
      return res.status(500).json({ success: false, error: 'internal' });
    }
  }
);

module.exports = { convertLead };
