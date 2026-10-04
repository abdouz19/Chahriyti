const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { defineSecret } = require('firebase-functions/params');

const wcKey = defineSecret('WC_KEY');
const wcSecret = defineSecret('WC_SECRET');

const WC_BASE = 'https://darkred-sheep-321101.hostingersite.com/wp-json/wc/v3';
const LICENSE_PRODUCT_ID = 12;

exports.syncLeadToWooCommerce = onDocumentCreated(
  { document: 'leads/{leadId}', secrets: [wcKey, wcSecret] },
  async (event) => {
    const lead = event.data?.data();
    if (!lead) return;

    // Skip leads that came FROM WooCommerce to avoid infinite loop
    if (lead.source === 'woocommerce') return;

    const credentials = Buffer.from(`${wcKey.value()}:${wcSecret.value()}`).toString('base64');
    const headers = {
      'Content-Type': 'application/json',
      Authorization: `Basic ${credentials}`,
    };

    try {
      // Create order with the license product
      const orderBody = {
        status: 'pending',
        billing: {
          first_name: lead.name ?? '',
          phone: lead.phone ?? '',
          state: String(lead.wilayaCode ?? ''),
          city: lead.commune ?? '',
          country: 'DZ',
        },
        line_items: [
          { product_id: LICENSE_PRODUCT_ID, quantity: 1 },
        ],
        meta_data: [
          { key: 'salary', value: String(lead.salary ?? '') },
          { key: 'age_group', value: lead.ageGroup ?? '' },
          { key: 'marital_status', value: lead.maritalStatus ?? '' },
          { key: 'goals', value: (lead.goals ?? []).join(' | ') },
          { key: 'source', value: 'chahriyti_app' },
        ],
      };

      const orderRes = await fetch(`${WC_BASE}/orders`, {
        method: 'POST',
        headers,
        body: JSON.stringify(orderBody),
      });

      const order = await orderRes.json();

      if (orderRes.ok) {
        await event.data.ref.update({ wcOrderId: order.id });
        console.log(`WooCommerce order created: ${order.id} for phone ${lead.phone}`);
      } else {
        console.warn(`WC orders API ${orderRes.status}:`, JSON.stringify(order));
      }
    } catch (err) {
      console.error('WooCommerce sync failed:', err.message);
    }
  },
);
