import React, { useState } from 'react';
import { Badge, Button } from '../../../components/ui';
import { formatLicenseKey } from '../../../utils/formatters';

/**
 * License pool table with selection for bulk printing.
 */
export function PoolTable({ licenses, onAssign, onPrint, loading }) {
  const [selected, setSelected] = useState(new Set());

  const toggleSelect = (id) => {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const toggleAll = () => {
    if (selected.size === licenses.length) {
      setSelected(new Set());
    } else {
      setSelected(new Set(licenses.map((l) => l.id)));
    }
  };

  const selectedLicenses = licenses.filter((l) => selected.has(l.id));

  const formatDate = (ts) => {
    if (!ts) return '—';
    const d = ts.toDate ? ts.toDate() : new Date(ts);
    return d.toLocaleDateString('ar-DZ', { year: 'numeric', month: 'short', day: 'numeric' });
  };

  return (
    <div>
      {/* Bulk actions bar */}
      {selected.size > 0 && (
        <div className="flex items-center justify-between bg-primary/5 border border-primary/20 rounded-xl px-4 py-3 mb-4">
          <span className="text-sm text-primary font-medium">
            {selected.size} ترخيص محدد
          </span>
          <Button
            variant="primary"
            size="sm"
            onClick={() => onPrint(selectedLicenses)}
            icon={
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.231c-.662 0-1.18-.568-1.12-1.227L6.34 18m11.318 0h1.091A2.25 2.25 0 0021 15.75V9.456c0-1.081-.768-2.015-1.837-2.175a48.055 48.055 0 00-1.913-.247M6.34 18H5.25A2.25 2.25 0 013 15.75V9.456c0-1.081.768-2.015 1.837-2.175a48.041 48.041 0 011.913-.247m10.5 0a48.536 48.536 0 00-10.5 0m10.5 0V3.375c0-.621-.504-1.125-1.125-1.125h-8.25c-.621 0-1.125.504-1.125 1.125v3.659M18.75 12h.008v.008h-.008V12zm-2.25 0h.008v.008H16.5V12z" />
              </svg>
            }
          >
            طباعة المحدد
          </Button>
        </div>
      )}

      {/* Table */}
      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border">
              <th className="px-4 py-3 text-right">
                <input
                  type="checkbox"
                  checked={licenses.length > 0 && selected.size === licenses.length}
                  onChange={toggleAll}
                  className="rounded border-border"
                />
              </th>
              <th className="px-4 py-3 text-right text-text-secondary font-medium">مفتاح الترخيص</th>
              <th className="px-4 py-3 text-right text-text-secondary font-medium">الحالة</th>
              <th className="px-4 py-3 text-right text-text-secondary font-medium">مخصص لـ</th>
              <th className="px-4 py-3 text-right text-text-secondary font-medium">تاريخ الإنشاء</th>
              <th className="px-4 py-3 text-right text-text-secondary font-medium">إجراءات</th>
            </tr>
          </thead>
          <tbody>
            {licenses.map((license) => (
              <tr
                key={license.id}
                className="border-b border-border/50 hover:bg-surface/50 transition-colors"
              >
                <td className="px-4 py-3">
                  <input
                    type="checkbox"
                    checked={selected.has(license.id)}
                    onChange={() => toggleSelect(license.id)}
                    className="rounded border-border"
                  />
                </td>
                <td className="px-4 py-3">
                  <span className="font-mono text-text-primary" dir="ltr">
                    {formatLicenseKey(license.licenseKey)}
                  </span>
                </td>
                <td className="px-4 py-3">
                  <Badge variant={license.status === 'available' ? 'success' : 'warning'}>
                    {license.status === 'available' ? 'متاحة' : 'مستخدمة'}
                  </Badge>
                </td>
                <td className="px-4 py-3 text-text-secondary">
                  {license.assignedTo || '—'}
                </td>
                <td className="px-4 py-3 text-text-secondary">
                  {formatDate(license.createdAt)}
                </td>
                <td className="px-4 py-3">
                  {license.status === 'available' && (
                    <div className="flex gap-2">
                      <button
                        onClick={() => onAssign(license)}
                        className="text-xs text-primary hover:text-primary/80 font-medium transition-colors"
                      >
                        تخصيص
                      </button>
                      <button
                        onClick={() => onPrint([license])}
                        className="text-xs text-text-secondary hover:text-text-primary font-medium transition-colors"
                      >
                        طباعة
                      </button>
                    </div>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
