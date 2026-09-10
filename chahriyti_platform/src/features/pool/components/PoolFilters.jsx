import React from 'react';
import { LICENSE_STATUS } from '../../../config/constants';

/**
 * Filter bar for the license pool table.
 */
export function PoolFilters({ statusFilter, onStatusChange }) {
  const options = [
    { value: '', label: 'الكل' },
    { value: LICENSE_STATUS.AVAILABLE, label: 'متاحة' },
    { value: LICENSE_STATUS.USED, label: 'مستخدمة' },
  ];

  return (
    <div className="flex items-center gap-2">
      <span className="text-sm text-text-secondary">الحالة:</span>
      <div className="flex gap-1.5">
        {options.map((opt) => (
          <button
            key={opt.value}
            onClick={() => onStatusChange(opt.value)}
            className={[
              'px-3 py-1.5 rounded-lg text-sm font-medium transition-colors duration-150',
              statusFilter === opt.value
                ? 'bg-primary text-white'
                : 'bg-surface text-text-secondary hover:text-text-primary hover:bg-surface/80',
            ].join(' ')}
          >
            {opt.label}
          </button>
        ))}
      </div>
    </div>
  );
}
