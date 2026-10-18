const admin = require('firebase-admin');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const { verifyRole } = require('./middleware');

if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();

const wcKey = defineSecret('WC_KEY');
const wcSecret = defineSecret('WC_SECRET');

const WC_BASE = 'https://chahriyti.app/wp-json/wc/v3';
const LICENSE_PRODUCT_ID = 12;

// A send in progress blocks a second click for this long (then it can retry)
const SEND_LOCK_MS = 2 * 60 * 1000;

/**
 * WooCommerce order body for an app lead: a real order from the in-app
 * order form (delivery chosen, like the website), or an older sign-up that
 * only expressed interest.
 */
function buildOrderBody(lead) {
  const isOrder = Boolean(lead.deliveryType);
  const [firstName, ...rest] = String(lead.name ?? '').trim().split(' ');
  const address = {
    first_name: firstName ?? '',
    last_name: rest.join(' '),
    state: String(lead.wilayaCode ?? ''),
    city: lead.commune ?? '',
    country: 'DZ',
  };

  const body = {
    status: isOrder ? 'processing' : 'pending',
    billing: { ...address, phone: lead.phone ?? '' },
    shipping: address,
    line_items: [{ product_id: LICENSE_PRODUCT_ID, quantity: 1 }],
    meta_data: [
      { key: 'salary', value: String(lead.salary ?? '') },
      { key: 'age_group', value: lead.ageGroup ?? '' },
      { key: 'marital_status', value: lead.maritalStatus ?? '' },
      { key: 'goals', value: (lead.goals ?? []).join(' | ') },
      { key: 'source', value: 'chahriyti_app' },
      ...(isOrder ? [{ key: 'delivery_type', value: lead.deliveryType }] : []),
    ],
  };

  if (isOrder) {
    // Same as the website: cash on delivery plus a delivery line
    body.payment_method = 'cod';
    body.payment_method_title = 'الدفع عند الاستلام';
    body.shipping_lines = [{
      method_id: 'flat_rate',
      method_title: lead.deliveryType === 'bureau' ? 'توصيل للمكتب' : 'توصيل للبيت',
      total: String(lead.deliveryFee ?? 0),
    }];
  }
  return body;
}

/**
 * sendLeadToWooCommerce — callable, from the platform's "send order" button.
 *
 * App leads are no longer pushed automatically: the team confirms them first
 * (usually by phone), then sends. A lead is sent at most once.
 *
 * Expected data: { leadId }
 * Returns: { success: true, wcOrderId }
 */
exports.sendLeadToWooCommerce = onCall(
  { secrets: [wcKey, wcSecret] },
  async (request) => {
    const { uid } = verifyRole(request, ['admin', 'manager', 'agent']);

    const leadId = request.data?.leadId;
    if (!leadId || typeof leadId !== 'string') {
      throw new HttpsError('invalid-argument', 'leadId is required.');
    }
    const ref = db.collection('leads').doc(leadId);

    // Claim the send so two clicks (or two people) can't create two orders
    const lead = await db.runTransaction(async (tx) => {
      const snap = await tx.get(ref);
      if (!snap.exists) throw new HttpsError('not-found', 'الطلب غير موجود');
      const data = snap.data();
      if (data.source === 'woocommerce') {
        throw new HttpsError('failed-precondition', 'هذا الطلب جاء من المتجر أصلاً');
      }
      if (data.wcOrderId) {
        throw new HttpsError('already-exists', `أُرسل من قبل (#${data.wcOrderId})`);
      }
      const lockedAt = data.wcSendLockAt?.toMillis?.() ?? 0;
      if (Date.now() - lockedAt < SEND_LOCK_MS) {
        throw new HttpsError('aborted', 'الإرسال جارٍ، انتظر لحظة');
      }
      tx.update(ref, { wcSendLockAt: admin.firestore.Timestamp.now() });
      return data;
    });

    const credentials = Buffer.from(`${wcKey.value()}:${wcSecret.value()}`).toString('base64');
    let order;
    try {
      const res = await fetch(`${WC_BASE}/orders`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Basic ${credentials}` },
        body: JSON.stringify(buildOrderBody(lead)),
      });
      order = await res.json();
      if (!res.ok) {
        console.warn(`WC orders API ${res.status}:`, JSON.stringify(order));
        throw new Error(order?.message || `WooCommerce ${res.status}`);
      }
    } catch (err) {
      // Release the claim so they can try again
      await ref.update({ wcSendLockAt: admin.firestore.FieldValue.delete() });
      console.error('WooCommerce send failed:', err.message);
      throw new HttpsError('unavailable', 'تعذّر الإرسال إلى المتجر، حاول مجدداً');
    }

    await ref.update({
      wcOrderId: order.id,
      wcSentAt: admin.firestore.FieldValue.serverTimestamp(),
      wcSentBy: uid,
      wcSendLockAt: admin.firestore.FieldValue.delete(),
    });
    console.log(`WooCommerce order ${order.id} created for lead ${leadId}`);
    return { success: true, wcOrderId: order.id };
  },
);
