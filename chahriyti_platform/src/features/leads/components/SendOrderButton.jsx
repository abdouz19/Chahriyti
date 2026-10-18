import React, { useState } from 'react';
import toast from 'react-hot-toast';
import { Button, Modal } from '../../../components/ui';
import { callSendLeadToWooCommerce } from '../../../services/functions';
import { formatSalary, formatPlace } from '../leadStatus';

function Row({ label, children }) {
  return (
    <div className="flex items-center justify-between gap-4 py-2">
      <span className="text-sm text-text-secondary">{label}</span>
      <span className="text-sm font-medium text-text-primary text-left">{children}</span>
    </div>
  );
}

/**
 * "Send order" for an app lead: confirm, then create the WooCommerce order.
 * Once sent, shows the WooCommerce order number instead.
 * Store leads already are WooCommerce orders, so nothing is shown for them.
 */
export function SendOrderButton({ lead, onSent, size = 'sm' }) {
  const [open, setOpen] = useState(false);
  const [sending, setSending] = useState(false);

  if (lead.source === 'woocommerce') return null;

  if (lead.wcOrderId) {
    return (
      <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-semibold bg-emerald-50 text-emerald-700">
        <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
          <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
        </svg>
        أُرسل #{lead.wcOrderId}
      </span>
    );
  }

  const send = async () => {
    setSending(true);
    try {
      const { wcOrderId } = await callSendLeadToWooCommerce(lead.id);
      toast.success(`تم إرسال الطلب إلى المتجر #${wcOrderId}`);
      setOpen(false);
      onSent?.();
    } catch (err) {
      toast.error(err.message || 'تعذّر الإرسال إلى المتجر');
    } finally {
      setSending(false);
    }
  };

  const isOrder = Boolean(lead.deliveryType);

  return (
    <>
      <button
        onClick={(e) => { e.stopPropagation(); setOpen(true); }}
        className={`inline-flex items-center gap-1.5 rounded-lg font-semibold text-white bg-primary hover:bg-primary-dark transition-colors ${
          size === 'sm' ? 'px-3 py-1.5 text-xs' : 'px-4 py-2.5 text-sm'
        }`}
      >
        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
          <path strokeLinecap="round" strokeLinejoin="round" d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5" />
        </svg>
        إرسال الطلب
      </button>

      <Modal isOpen={open} onClose={() => !sending && setOpen(false)} title="إرسال الطلب إلى المتجر" size="sm">
        <div onClick={(e) => e.stopPropagation()}>
          <p className="text-sm text-text-secondary mb-3">
            سيُنشأ طلب في WooCommerce بهذه المعلومات. لا يمكن إرساله مرتين.
          </p>
          <div className="divide-y divide-divider border-y border-divider">
            <Row label="الاسم">{lead.name ?? '—'}</Row>
            <Row label="الهاتف"><span dir="ltr">{lead.phone ?? '—'}</span></Row>
            <Row label="العنوان">{formatPlace(lead)}</Row>
            {isOrder ? (
              <>
                <Row label="التوصيل">
                  {lead.deliveryType === 'bureau' ? 'للمكتب' : 'للمنزل'} · {formatSalary(lead.deliveryFee)}
                </Row>
                <Row label="المجموع"><span className="text-primary font-bold">{formatSalary(lead.total)}</span></Row>
              </>
            ) : (
              <Row label="التوصيل">
                <span className="text-amber-700">لم يُحدَّد، اتفق عليه في المتجر</span>
              </Row>
            )}
          </div>
          <div className="flex gap-2 justify-end mt-5">
            <Button variant="secondary" onClick={() => setOpen(false)} disabled={sending}>إلغاء</Button>
            <Button variant="primary" onClick={send} loading={sending}>إرسال الطلب</Button>
          </div>
        </div>
      </Modal>
    </>
  );
}
