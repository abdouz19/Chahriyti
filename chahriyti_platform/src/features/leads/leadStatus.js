// Label and colors for each lead status, shared by the filter chips, table and details
export const LEAD_STATUSES = {
  pending: {
    label: 'انتظار',
    dot: 'bg-amber-500',
    pill: 'bg-amber-50 text-amber-700 ring-amber-200',
  },
  contacted: {
    label: 'تم التواصل',
    dot: 'bg-blue-500',
    pill: 'bg-blue-50 text-blue-700 ring-blue-200',
  },
  converted: {
    label: 'مُفعَّل',
    dot: 'bg-emerald-500',
    pill: 'bg-emerald-50 text-emerald-700 ring-emerald-200',
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
