import React, { useState } from 'react';
import toast from 'react-hot-toast';
import { updateLeadStatus } from '../../../services/firestore';
import { formatLeadDate, formatSalary, formatPlace } from '../leadStatus';
import { StatusSelect } from './StatusSelect';
import { LeadDetailsModal } from './LeadDetailsModal';
import { LeadAvatar, SourceTag } from './LeadBits';
import { SendOrderButton } from './SendOrderButton';

const HEADERS = ['المسجل', 'الولاية · البلدية', 'الراتب', 'المصدر', 'تاريخ التسجيل', 'الحالة', ''];

export function LeadsTable({ leads, onRefresh }) {
  const [selectedId, setSelectedId] = useState(null);
  const [savingId, setSavingId] = useState(null);
  const selected = leads.find((l) => l.id === selectedId) ?? null;

  const handleStatusChange = async (leadId, newStatus) => {
    setSavingId(leadId);
    try {
      await updateLeadStatus(leadId, newStatus);
      toast.success('تم تحديث الحالة');
      onRefresh();
    } catch {
      toast.error('فشل تحديث الحالة');
    } finally {
      setSavingId(null);
    }
  };

  return (
    <>
      <div className="rounded-2xl border border-border bg-white shadow-card overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-right whitespace-nowrap">
            <thead>
              <tr className="border-b border-border bg-surface/70">
                {HEADERS.map((h, i) => (
                  <th key={i} className="px-5 py-3 text-xs font-semibold text-text-secondary">{h}</th>
                ))}
              </tr>
            </thead>
            <tbody className="divide-y divide-divider">
              {leads.map((lead) => (
                <tr
                  key={lead.id}
                  onClick={() => setSelectedId(lead.id)}
                  className="group cursor-pointer hover:bg-surface/80 transition-colors"
                >
                  <td className="px-5 py-3">
                    <div className="flex items-center gap-3">
                      <LeadAvatar name={lead.name} />
                      <div className="min-w-0">
                        <div className="font-semibold text-text-primary truncate max-w-[200px]">{lead.name ?? '—'}</div>
                        <div className="text-xs text-text-secondary tabular-nums text-right" dir="ltr">{lead.phone ?? '—'}</div>
                      </div>
                    </div>
                  </td>
                  <td className="px-5 py-3 text-text-primary/80">{formatPlace(lead)}</td>
                  <td className="px-5 py-3 font-medium text-text-primary tabular-nums">{formatSalary(lead.salary)}</td>
                  <td className="px-5 py-3"><SourceTag source={lead.source} /></td>
                  <td className="px-5 py-3 text-text-secondary">{formatLeadDate(lead.submittedAt)}</td>
                  <td className="px-5 py-3">
                    <StatusSelect
                      lead={lead}
                      disabled={savingId === lead.id}
                      onChange={(s) => handleStatusChange(lead.id, s)}
                    />
                  </td>
                  <td className="px-5 py-3 text-left">
                    <div className="inline-flex items-center gap-2">
                    <SendOrderButton lead={lead} onSent={onRefresh} />
                    <button
                      onClick={(e) => { e.stopPropagation(); setSelectedId(lead.id); }}
                      className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium text-primary hover:bg-primary/10 transition-colors"
                    >
                      <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                        <path strokeLinecap="round" strokeLinejoin="round" d="M2.036 12.322a1 1 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178a1 1 0 010 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z" />
                        <path strokeLinecap="round" strokeLinejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      </svg>
                      عرض
                    </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      <LeadDetailsModal
        lead={selected}
        onClose={() => setSelectedId(null)}
        onStatusChange={(s) => selected && handleStatusChange(selected.id, s)}
        saving={selected && savingId === selected.id}
        onSent={onRefresh}
      />
    </>
  );
}
