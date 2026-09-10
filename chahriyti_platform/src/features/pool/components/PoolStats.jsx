import React from 'react';

/**
 * Pool statistics cards — available, used, total.
 */
export function PoolStats({ stats }) {
  const total = stats?.totalLicenses || 0;
  const available = stats?.availableLicenses || 0;
  const used = total - available;

  const items = [
    { label: 'إجمالي التراخيص', value: total, color: 'text-primary' },
    { label: 'متاحة', value: available, color: 'text-positive' },
    { label: 'مستخدمة', value: used, color: 'text-warning' },
  ];

  return (
    <div className="grid grid-cols-3 gap-4">
      {items.map((item) => (
        <div
          key={item.label}
          className="bg-card border border-border rounded-2xl p-4 text-center"
        >
          <p className={`text-2xl font-bold ${item.color}`}>
            {item.value.toLocaleString()}
          </p>
          <p className="text-xs text-text-secondary mt-1">{item.label}</p>
        </div>
      ))}
    </div>
  );
}
