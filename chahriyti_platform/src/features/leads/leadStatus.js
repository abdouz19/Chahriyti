// Label and colors for each lead status, shared by the filter chips, table and details
// Order matters: it's the call-centre pipeline, left to right in the chips
export const LEAD_STATUSES = {
  pending: {
    label: 'انتظار',
    dot: 'bg-amber-500',
    pill: 'bg-amber-50 text-amber-700 ring-amber-200',
  },
  no_answer: {
    label: 'لم يرد',
    dot: 'bg-orange-500',
    pill: 'bg-orange-50 text-orange-700 ring-orange-200',
  },
  postponed: {
    label: 'مؤجل',
    dot: 'bg-violet-500',
    pill: 'bg-violet-50 text-violet-700 ring-violet-200',
  },
  contacted: {
    label: 'تم التواصل',
    dot: 'bg-blue-500',
    pill: 'bg-blue-50 text-blue-700 ring-blue-200',
  },
  confirmed: {
    label: 'مؤكد',
    dot: 'bg-teal-600',
    pill: 'bg-teal-50 text-teal-700 ring-teal-200',
  },
  converted: {
    label: 'مُفعَّل',
    dot: 'bg-emerald-500',
    pill: 'bg-emerald-50 text-emerald-700 ring-emerald-200',
  },
  canceled: {
    label: 'ملغى',
    dot: 'bg-slate-400',
    pill: 'bg-slate-100 text-slate-600 ring-slate-200',
  },
  rejected: {
    label: 'مرفوض',
    dot: 'bg-red-500',
    pill: 'bg-red-50 text-red-700 ring-red-200',
  },
};

export function leadStatusOf(lead) {
  return LEAD_STATUSES[lead.status] ?? LEAD_STATUSES.pending;
}

export function formatLeadDate(ts) {
  if (!ts) return '—';
  const d = ts.toDate ? ts.toDate() : new Date(ts);
  return d.toLocaleDateString('ar-DZ', { year: 'numeric', month: 'short', day: 'numeric' });
}

export function formatSalary(salary) {
  return salary ? `${salary.toLocaleString('ar-DZ')} دج` : '—';
}

export function formatPlace(lead) {
  if (!lead.wilayaCode) return lead.commune ?? '—';
  return lead.commune ? `${lead.wilayaCode} · ${lead.commune}` : `ولاية ${lead.wilayaCode}`;
}
