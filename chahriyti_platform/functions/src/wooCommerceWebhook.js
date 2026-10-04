const { onRequest } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const crypto = require('crypto');

const wcWebhookSecret = defineSecret('WC_WEBHOOK_SECRET');

exports.wooCommerceWebhook = onRequest(
  { secrets: [wcWebhookSecret] },
  async (req, res) => {
    if (req.method !== 'POST') {
      res.status(405).send('Method Not Allowed');
      return;
    }

    // Verify WooCommerce HMAC-SHA256 signature using raw body bytes
    const signature = req.headers['x-wc-webhook-signature'];
    if (signature) {
      const secret = wcWebhookSecret.value();
      const rawBody = req.rawBody; // Buffer — exact bytes WooCommerce signed
      const expected = crypto
        .createHmac('sha256', secret)
        .update(rawBody)
        .digest('base64');
      if (signature !== expected) {
        console.warn('Invalid webhook signature — rejected');
        console.warn('Expected:', expected, 'Got:', signature);
        res.status(401).send('Unauthorized');
        return;
      }
    }

    const topic = req.headers['x-wc-webhook-topic'] ?? '';
    const order = req.body;

    // Only handle order events
    if (!topic.startsWith('order.')) {
      res.status(200).send('Ignored');
      return;
    }

    const billing = order?.billing ?? {};
    const phone = billing.phone ?? '';
    const name = [billing.first_name ?? '', billing.last_name ?? '']
      .filter(Boolean)
      .join(' ')
      .trim();

    if (!phone && !name) {
      res.status(200).send('No usable data');
      return;
    }

    const db = getFirestore();

    // Skip duplicate phone
    if (phone) {
      const existing = await db
        .collection('leads')
        .where('phone', '==', phone)
        .limit(1)
        .get();
      if (!existing.empty) {
        const doc = existing.docs[0];
        if (!doc.data().wcOrderId) {
          await doc.ref.update({ wcOrderId: order.id });
        }
        res.status(200).send('Duplicate — skipped');
        return;
      }
    }

    // Map wilaya from billing.state (WC stores it as wilaya code string)
    const wilayaCode = parseInt(billing.state ?? '16', 10);

    // Extract product names from line_items
    const products = (order?.line_items ?? []).map((item) => item.name).filter(Boolean);

    const lead = {
      name: name || 'غير معروف',
      phone: phone,
      email: billing.email ?? '',
      wilayaCode: isNaN(wilayaCode) ? 16 : wilayaCode,
      commune: billing.city ?? null,
      salary: 0,
      salaryDay: 1,
      ageGroup: null,
      maritalStatus: null,
      tracksExpenses: null,
      goals: [],
      status: 'pending',
      source: 'woocommerce',
      wcOrderId: order.id ?? null,
      wcOrderStatus: order.status ?? null,
      wcProducts: products,
      wcTotal: order.total ?? null,
      submittedAt: FieldValue.serverTimestamp(),
    };

    await db.collection('leads').add(lead);
    console.log(`Lead created from WooCommerce order ${order.id} — phone: ${phone}`);
    res.status(200).send('OK');
  },
);
