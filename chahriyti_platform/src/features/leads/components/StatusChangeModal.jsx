import React, { useEffect, useState } from 'react';
import { Button, Modal } from '../../../components/ui';
import { LEAD_STATUSES } from '../leadStatus';

function StatusChip({ status }) {
  const s = LEAD_STATUSES[status] ?? LEAD_STATUSES.pending;
  return (
    <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold ring-1 ring-inset ${s.pill}`}>
      <span className={`w-1.5 h-1.5 rounded-full ${s.dot}`} />
      {s.label}
    </span>
  );
}

/**
 * Asked on every status change: an optional comment explaining it.
 * "Save" keeps the comment, "No comment" changes the status without one.
 */
export function StatusChangeModal({ change, onConfirm, onCancel, saving }) {
  const [comment, setComment] = useState('');

  useEffect(() => { if (change) setComment(''); }, [change]);

  if (!change) return null;
  const { lead, to } = change;

  return (
    <Modal isOpen onClose={() => !saving && onCancel()} title="تغيير الحالة" size="sm">
      <div onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center gap-2 mb-4 text-sm text-text-secondary">
          <span className="font-semibold text-text-primary">{lead.name ?? '—'}</span>
          <StatusChip status={lead.status ?? 'pending'} />
          <svg className="w-4 h-4 rtl:rotate-180" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
            <path strokeLinecap="round" strokeLinejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
          </svg>
          <StatusChip status={to} />
        </div>
        <label className="block text-sm font-medium text-text-primary mb-1.5" htmlFor="status-comment">
          تعليق
        </label>
        <textarea
          id="status-comment"
          autoFocus
          rows={3}
          value={comment}
          onChange={(e) => setComment(e.target.value)}
          placeholder="مثال: طلب الاتصال به بعد الساعة 6 مساءً"
          className="w-full px-3 py-2.5 border border-border rounded-xl text-sm resize-none focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary"
        />
        <div className="flex gap-2 justify-end mt-4">
          <Button variant="secondary" onClick={() => onConfirm(null)} disabled={saving}>
            بدون تعليق
          </Button>
          <Button variant="primary" onClick={() => onConfirm(comment.trim() || null)} loading={saving}>
            حفظ
          </Button>
        </div>
      </div>
    </Modal>
  );
}

export { StatusChip };
