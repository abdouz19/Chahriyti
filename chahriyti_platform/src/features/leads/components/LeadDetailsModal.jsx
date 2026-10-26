import React, { useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Modal } from '../../../components/ui';
import { formatLeadDate, formatSalary } from '../leadStatus';
import { StatusSelect } from './StatusSelect';
import { LeadAvatar, SourceTag } from './LeadBits';
import { SendOrderButton } from './SendOrderButton';
import { StatusChip } from './StatusChangeModal';
import { getLeadHistory } from '../../../services/firestore';

function formatDateTime(ts) {
  if (!ts) return '';
  const d = ts.toDate ? ts.toDate() : new Date(ts);
  return d.toLocaleString('ar-DZ', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' });
}

/**
 * Every status change on this lead, newest first, with its comment.
 */
function LeadHistory({ leadId, version }) {
  const [entries, setEntries] = useState(null);

  useEffect(() => {
    let cancelled = false;
    getLeadHistory(leadId)
      .then((list) => !cancelled && setEntries(list))
      .catch(() => !cancelled && setEntries([]));
    return () => { cancelled = true; };
  }, [leadId, version]);

  return (
    <div>
      <div className="text-sm font-semibold text-text-primary mb-3">سجل الحالات</div>
      {entries === null ? (
        <div className="text-sm text-text-secondary">...</div>
      ) : entries.length === 0 ? (
        <div className="text-sm text-text-secondary">لم تتغير الحالة بعد</div>
      ) : (
        <ol className="relative border-s border-border ms-2 space-y-4">
          {entries.map((e) => (
            <li key={e.id} className="ms-4">
              <span className="absolute -start-1.5 mt-1.5 w-3 h-3 rounded-full bg-white ring-2 ring-primary/40" />
              <div className="flex flex-wrap items-center gap-2 text-xs">
                <StatusChip status={e.from} />
                <span className="text-text-secondary">إلى</span>
                <StatusChip status={e.to} />
              </div>
              {e.comment && (
                <p className="mt-1.5 text-sm text-text-primary bg-surface rounded-lg px-3 py-2 whitespace-pre-wrap">{e.comment}</p>
              )}
              <div className="mt-1 text-xs text-text-secondary">
                {[e.byName, formatDateTime(e.createdAt)].filter(Boolean).join('، ')}
              </div>
            </li>
          ))}
        </ol>
      )}
    </div>
  );
}

// 0665… / +213665… → 213665… for wa.me links
function toWhatsAppNumber(phone) {
  const digits = (phone ?? '').replace(/\D/g, '');
  if (digits.startsWith('213')) return digits;
  if (digits.startsWith('0')) return `213${digits.slice(1)}`;
  return digits;
}

function yesNo(value) {
  if (value === true) return 'نعم';
  if (value === false) return 'لا';
  return '—';
}

function Field({ label, children }) {
  return (
    <div className="rounded-xl bg-surface px-4 py-3">
      <div className="text-xs text-text-secondary mb-1">{label}</div>
      <div className="text-sm font-medium text-text-primary">{children || '—'}</div>
    </div>
  );
}

function ActionLink({ href, onClick, children, tone = 'neutral' }) {
  const toneClass = tone === 'whatsapp'
    ? 'bg-emerald-500 text-white hover:bg-emerald-600'
    : 'bg-white text-text-primary ring-1 ring-inset ring-border hover:bg-surface';
  const className = `flex-1 inline-flex items-center justify-center gap-2 px-3 py-2.5 rounded-xl text-sm font-medium transition-colors ${toneClass}`;
  return href
    ? <a href={href} target="_blank" rel="noreferrer" className={className}>{children}</a>
    : <button type="button" onClick={onClick} className={className}>{children}</button>;
}

export function LeadDetailsModal({ lead, onClose, onStatusChange, saving, onSent }) {
  if (!lead) return null;

  const copyPhone = async () => {
    try {
      await navigator.clipboard.writeText(lead.phone ?? '');
      toast.success('تم نسخ الرقم');
    } catch {
      toast.error('تعذر النسخ');
    }
  };

  return (
    <Modal isOpen onClose={onClose} title="تفاصيل المسجل" size="lg">
      <div className="space-y-6 max-h-[70vh] overflow-y-auto -mx-1 px-1">
        {/* Identity */}
        <div className="flex items-center justify-between gap-4">
          <div className="flex items-center gap-4 min-w-0">
            <LeadAvatar name={lead.name} size="lg" />
            <div className="min-w-0">
              <div className="text-lg font-bold text-text-primary truncate">{lead.name ?? '—'}</div>
              <div className="text-sm text-text-secondary tabular-nums text-right" dir="ltr">{lead.phone ?? '—'}</div>
            </div>
          </div>
          <StatusSelect lead={lead} onChange={onStatusChange} disabled={saving} />
        </div>

        {/* Quick actions */}
        {lead.phone && (
          <div className="flex gap-2">
            <ActionLink href={`tel:${lead.phone}`}>اتصال</ActionLink>
            <ActionLink href={`https://wa.me/${toWhatsAppNumber(lead.phone)}`} tone="whatsapp">واتساب</ActionLink>
            <ActionLink onClick={copyPhone}>نسخ الرقم</ActionLink>
          </div>
        )}

        {lead.source !== 'woocommerce' && (
          <div className="flex items-center justify-between gap-3 rounded-xl bg-surface px-4 py-3">
            <span className="text-sm text-text-secondary">
              {lead.wcOrderId ? 'هذا الطلب في المتجر' : 'بعد التأكيد مع الزبون، أرسل الطلب إلى المتجر'}
            </span>
            <SendOrderButton lead={lead} onSent={onSent} size="md" />
          </div>
        )}

        {/* Profile */}
        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
          <Field label="الولاية">{lead.wilayaCode ? `ولاية ${lead.wilayaCode}` : null}</Field>
          <Field label="البلدية">{lead.commune}</Field>
          <Field label="الراتب">{formatSalary(lead.salary)}</Field>
          <Field label="يوم الراتب">{lead.salaryDay}</Field>
          <Field label="الفئة العمرية">{lead.ageGroup}</Field>
          <Field label="الحالة الاجتماعية">{lead.maritalStatus}</Field>
          <Field label="يتتبع مصاريفه">{yesNo(lead.tracksExpenses)}</Field>
          <Field label="تاريخ التسجيل">{formatLeadDate(lead.submittedAt)}</Field>
          <Field label="المصدر"><SourceTag source={lead.source} /></Field>
          {lead.email && <Field label="البريد الإلكتروني"><span dir="ltr">{lead.email}</span></Field>}
          {lead.wcOrderId && <Field label="رقم طلب المتجر">#{lead.wcOrderId}</Field>}
          {lead.wcTotal && <Field label="مبلغ الطلب">{lead.wcTotal} دج</Field>}
          {lead.deliveryType && (
            <Field label="التوصيل">
              {lead.deliveryType === 'bureau' ? 'للمكتب' : 'للمنزل'} · {formatSalary(lead.deliveryFee)}
            </Field>
          )}
          {lead.total && <Field label="المبلغ الإجمالي">{formatSalary(lead.total)}</Field>}
        </div>

        <LeadHistory leadId={lead.id} version={lead.statusUpdatedAt?.toMillis?.() ?? lead.status} />

        {/* Goals */}
        <div>
          <div className="text-sm font-semibold text-text-primary mb-2">
            الأهداف {lead.goals?.length ? <span className="text-text-secondary font-normal">({lead.goals.length})</span> : null}
          </div>
          {lead.goals?.length ? (
            <div className="flex flex-wrap gap-2">
              {lead.goals.map((g) => (
                <span key={g} className="px-3 py-1.5 rounded-lg bg-primary/5 text-primary text-xs font-medium ring-1 ring-inset ring-primary/10">
                  {g}
                </span>
              ))}
            </div>
          ) : (
            <div className="text-sm text-text-secondary">—</div>
          )}
        </div>
      </div>
    </Modal>
  );
}
