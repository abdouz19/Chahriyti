import React from 'react';
import { Badge } from '../../../components/ui';
import toast from 'react-hot-toast';
import { updateLeadStatus } from '../../../services/firestore';

const STATUS_LABELS = {
  pending:   { label: 'انتظار', color: 'yellow' },
  contacted: { label: 'تم التواصل', color: 'blue' },
  converted: { label: 'مُفعَّل', color: 'green' },
  rejected:  { label: 'مرفوض', color: 'red' },
};

function formatDate(ts) {
  if (!ts) return '—';
  const d = ts.toDate ? ts.toDate() : new Date(ts);
  return d.toLocaleDateString('ar-DZ', { year: 'numeric', month: 'short', day: 'numeric' });
}

export function LeadsTable({ leads, onRefresh }) {
  const handleStatusChange = async (leadId, newStatus) => {
    try {
      await updateLeadStatus(leadId, newStatus);
      toast.success('تم تحديث الحالة');
      onRefresh();
    } catch {
      toast.error('فشل تحديث الحالة');
    }
  };

  return (
    <div className="overflow-x-auto rounded-xl border border-border bg-white">
      <table className="w-full text-sm text-right">
        <thead className="bg-surface border-b border-border">
          <tr>
            {['الاسم', 'الهاتف', 'الولاية / البلدية', 'الراتب', 'يوم الراتب', 'الفئة العمرية', 'الأهداف', 'تاريخ التسجيل', 'الحالة'].map((h) => (
              <th key={h} className="px-4 py-3 font-semibold text-text-secondary whitespace-nowrap">{h}</th>
            ))}
          </tr>
        </thead>
        <tbody className="divide-y divide-border">
          {leads.map((lead) => {
            const statusInfo = STATUS_LABELS[lead.status] ?? STATUS_LABELS.pending;
            return (
              <tr key={lead.id} className="hover:bg-surface/50 transition-colors">
                <td className="px-4 py-3 font-medium text-text-primary whitespace-nowrap">{lead.name ?? '—'}</td>
                <td className="px-4 py-3 text-text-secondary ltr" dir="ltr">{lead.phone ?? '—'}</td>
                <td className="px-4 py-3 text-text-secondary whitespace-nowrap">
                  {lead.wilayaCode ? `ولاية ${lead.wilayaCode}` : '—'}
                  {lead.commune ? ` / ${lead.commune}` : ''}
                </td>
                <td className="px-4 py-3 text-text-secondary whitespace-nowrap">
                  {lead.salary ? `${lead.salary.toLocaleString('ar-DZ')} دج` : '—'}
                </td>
                <td className="px-4 py-3 text-text-secondary">{lead.salaryDay ?? '—'}</td>
                <td className="px-4 py-3 text-text-secondary">{lead.ageGroup ?? '—'}</td>
                <td className="px-4 py-3 text-text-secondary max-w-[160px]">
                  {lead.goals?.length ? (
                    <div className="flex flex-wrap gap-1">
                      {lead.goals.slice(0, 2).map((g) => (
                        <span key={g} className="text-xs bg-surface border border-border rounded-full px-2 py-0.5">{g}</span>
                      ))}
                      {lead.goals.length > 2 && (
                        <span className="text-xs text-text-secondary">+{lead.goals.length - 2}</span>
                      )}
                    </div>
                  ) : '—'}
                </td>
                <td className="px-4 py-3 text-text-secondary whitespace-nowrap">{formatDate(lead.submittedAt)}</td>
                <td className="px-4 py-3">
                  <select
                    value={lead.status ?? 'pending'}
                    onChange={(e) => handleStatusChange(lead.id, e.target.value)}
                    className="text-xs border border-border rounded-lg px-2 py-1 bg-white focus:outline-none focus:ring-1 focus:ring-primary"
                  >
                    {Object.entries(STATUS_LABELS).map(([val, { label }]) => (
                      <option key={val} value={val}>{label}</option>
                    ))}
                  </select>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
