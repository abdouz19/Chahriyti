import React from 'react';
import toast from 'react-hot-toast';
import { formatLicenseKey } from '../../../utils/formatters';

const STATUS = {
  available: { label: 'متاحة', pill: 'bg-emerald-50 text-emerald-700 ring-emerald-200', dot: 'bg-emerald-500' },
  used: { label: 'مستخدمة', pill: 'bg-amber-50 text-amber-700 ring-amber-200', dot: 'bg-amber-500' },
};

function formatDate(ts) {
  if (!ts) return '—';
  const d = ts.toDate ? ts.toDate() : new Date(ts);
  return d.toLocaleDateString('ar-DZ', { year: 'numeric', month: 'short', day: 'numeric' });
}

// C6A3DECA-4E00-…-B22AF66A4440 → C6A3DECA…4440
function shortDeviceId(id) {
  return id.length > 16 ? `${id.slice(0, 8)}…${id.slice(-4)}` : id;
}

async function copy(text, message) {
  try {
    await navigator.clipboard.writeText(text);
    toast.success(message);
  } catch {
    toast.error('تعذر النسخ');
  }
}

function CopyButton({ text, message }) {
  return (
    <button
      onClick={() => copy(text, message)}
      title="نسخ"
      className="opacity-0 group-hover:opacity-100 p-1 rounded-md text-text-secondary hover:text-primary hover:bg-primary/10 transition"
    >
      <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
        <path strokeLinecap="round" strokeLinejoin="round" d="M15.75 17.25v3.375c0 .621-.504 1.125-1.125 1.125h-9.75a1.125 1.125 0 01-1.125-1.125V7.875c0-.621.504-1.125 1.125-1.125H6.75a9.06 9.06 0 011.5.124m7.5 10.376h3.375c.621 0 1.125-.504 1.125-1.125V11.25c0-4.46-3.243-8.161-7.5-8.876a9.06 9.06 0 00-1.5-.124H9.375c-.621 0-1.125.504-1.125 1.125v3.5m7.5 10.375H9.375a1.125 1.125 0 01-1.125-1.125v-9.25m12 6.625v-1.875a3.375 3.375 0 00-3.375-3.375h-1.5a1.125 1.125 0 01-1.125-1.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25" />
      </svg>
    </button>
  );
}

const HEADERS = ['مفتاح الترخيص', 'الحالة', 'الطباعة', 'رقم الجهاز', 'مخصص لـ', 'التاريخ', ''];

/**
 * License pool table.
 */
export function PoolTable({ licenses, onAssign }) {
  return (
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
          {licenses.map((license) => {
            const status = STATUS[license.status] ?? STATUS.used;
            const key = formatLicenseKey(license.licenseKey);
            return (
              <tr key={license.id} className="group hover:bg-surface/80 transition-colors">
                <td className="px-5 py-3">
                  <div className="flex items-center gap-1.5">
                    <span className="font-mono text-[13px] font-medium tracking-wide text-text-primary" dir="ltr">{key}</span>
                    <CopyButton text={key} message="تم نسخ المفتاح" />
                  </div>
                </td>
                <td className="px-5 py-3">
                  <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold ring-1 ring-inset ${status.pill}`}>
                    <span className={`w-1.5 h-1.5 rounded-full ${status.dot}`} />
                    {status.label}
                  </span>
                </td>
                <td className="px-5 py-3">
                  {license.printed ? (
                    <span className="inline-flex items-center gap-1 text-xs font-medium text-primary">
                      <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                        <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
                      </svg>
                      مطبوعة
                    </span>
                  ) : (
                    <span className="text-xs text-text-secondary">غير مطبوعة</span>
                  )}
                </td>
                <td className="px-5 py-3">
                  {license.deviceId ? (
                    <div className="flex items-center gap-1.5">
                      <span className="font-mono text-xs text-text-secondary" dir="ltr" title={license.deviceId}>
                        {shortDeviceId(license.deviceId)}
                      </span>
                      <CopyButton text={license.deviceId} message="تم نسخ رقم الجهاز" />
                    </div>
                  ) : <span className="text-text-secondary">—</span>}
                </td>
                <td className="px-5 py-3 text-text-primary/80">{license.assignedTo || <span className="text-text-secondary">—</span>}</td>
                <td className="px-5 py-3 text-text-secondary">{formatDate(license.usedAt || license.createdAt)}</td>
                <td className="px-5 py-3 text-left">
                  {license.status === 'available' && (
                    <button
                      onClick={() => onAssign(license)}
                      className="px-3 py-1.5 rounded-lg text-xs font-semibold text-primary ring-1 ring-inset ring-primary/20 hover:bg-primary hover:text-white transition-colors"
                    >
                      تخصيص
                    </button>
                  )}
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
