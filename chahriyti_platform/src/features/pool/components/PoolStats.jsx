import React from 'react';

const ICONS = {
  total: 'M15.75 5.25a3 3 0 013 3m3 0a6 6 0 01-7.029 5.912c-.563-.097-1.159.026-1.563.43L10.5 17.25H8.25v2.25H6v2.25H2.25v-2.818c0-.597.237-1.17.659-1.591l6.499-6.499c.404-.404.527-1 .43-1.563A6 6 0 1121.75 8.25z',
  available: 'M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
  used: 'M10.5 1.5H8.25A2.25 2.25 0 006 3.75v16.5a2.25 2.25 0 002.25 2.25h7.5A2.25 2.25 0 0018 20.25V3.75a2.25 2.25 0 00-2.25-2.25H13.5m-3 0V3h3V1.5m-3 0h3m-3 18.75h3',
};

/**
 * Pool statistics cards — total, available, used, with usage progress.
 */
export function PoolStats({ stats }) {
  const total = stats?.totalLicenses || 0;
  const available = stats?.availableLicenses || 0;
  const used = total - available;
  const pct = (n) => (total ? Math.round((n / total) * 1000) / 10 : 0);

  const items = [
    { key: 'total', label: 'إجمالي التراخيص', value: total, tone: 'text-primary bg-primary/10', bar: null },
    { key: 'available', label: 'متاحة', value: available, tone: 'text-emerald-600 bg-emerald-50', bar: 'bg-emerald-500', pct: pct(available) },
    { key: 'used', label: 'مستخدمة', value: used, tone: 'text-amber-600 bg-amber-50', bar: 'bg-amber-500', pct: pct(used) },
  ];

  return (
    <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
      {items.map((item) => (
        <div key={item.key} className="bg-card border border-border rounded-2xl p-5 shadow-card">
          <div className="flex items-center justify-between">
            <span className="text-sm font-medium text-text-secondary">{item.label}</span>
            <span className={`w-9 h-9 rounded-xl flex items-center justify-center ${item.tone}`}>
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.75}>
                <path strokeLinecap="round" strokeLinejoin="round" d={ICONS[item.key]} />
              </svg>
            </span>
          </div>
          <p className="mt-3 text-3xl font-bold text-text-primary tabular-nums">
            {item.value.toLocaleString('en-US')}
          </p>
          {item.bar ? (
            <div className="mt-3 flex items-center gap-3">
              <div className="flex-1 h-1.5 rounded-full bg-divider overflow-hidden">
                <div className={`h-full rounded-full ${item.bar}`} style={{ width: `${item.pct}%` }} />
              </div>
              <span className="text-xs text-text-secondary tabular-nums">{item.pct}%</span>
            </div>
          ) : (
            <p className="mt-3 text-xs text-text-secondary">كل التراخيص المولدة</p>
          )}
        </div>
      ))}
    </div>
  );
}
