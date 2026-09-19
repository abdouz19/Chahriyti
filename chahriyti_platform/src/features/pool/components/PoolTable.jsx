import React from 'react';
import { Badge } from '../../../components/ui';
import { formatLicenseKey } from '../../../utils/formatters';

/**
 * License pool table.
 */
export function PoolTable({ licenses, onAssign, loading }) {
  const formatDate = (ts) => {
    if (!ts) return '—';
    const d = ts.toDate ? ts.toDate() : new Date(ts);
    return d.toLocaleDateString('ar-DZ', { year: 'numeric', month: 'short', day: 'numeric' });
  };

  return (
    <div className="overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b border-border">
            <th className="px-4 py-3 text-right text-text-secondary font-medium">مفتاح الترخيص</th>
            <th className="px-4 py-3 text-right text-text-secondary font-medium">الحالة</th>
            <th className="px-4 py-3 text-right text-text-secondary font-medium">الطباعة</th>
            <th className="px-4 py-3 text-right text-text-secondary font-medium">رقم الجهاز</th>
            <th className="px-4 py-3 text-right text-text-secondary font-medium">مخصص لـ</th>
            <th className="px-4 py-3 text-right text-text-secondary font-medium">تاريخ التفعيل</th>
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
                <span className="font-mono text-text-primary" dir="ltr">
                  {formatLicenseKey(license.licenseKey)}
                </span>
              </td>
              <td className="px-4 py-3">
                <Badge variant={license.status === 'available' ? 'success' : 'warning'}>
                  {license.status === 'available' ? 'متاحة' : 'مستخدمة'}
                </Badge>
              </td>
              <td className="px-4 py-3">
                {license.printed ? (
                  <Badge variant="info">مطبوعة</Badge>
                ) : (
                  <span className="text-text-secondary text-xs">—</span>
                )}
              </td>
              <td className="px-4 py-3 text-text-secondary">
                {license.deviceId ? (
                  <span className="font-mono text-xs" dir="ltr">{license.deviceId}</span>
                ) : '—'}
              </td>
              <td className="px-4 py-3 text-text-secondary">
                {license.assignedTo || '—'}
              </td>
              <td className="px-4 py-3 text-text-secondary">
                {formatDate(license.usedAt || license.createdAt)}
              </td>
              <td className="px-4 py-3">
                {license.status === 'available' && (
                  <button
                    onClick={() => onAssign(license)}
                    className="text-xs text-primary hover:text-primary/80 font-medium transition-colors"
                  >
                    تخصيص
                  </button>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
