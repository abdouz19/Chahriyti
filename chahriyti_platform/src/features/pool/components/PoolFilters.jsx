import React from 'react';
import { LICENSE_STATUS } from '../../../config/constants';

function Segmented({ label, options, value, onChange }) {
  return (
    <div className="flex items-center gap-2">
      <span className="text-xs font-medium text-text-secondary">{label}</span>
      <div className="inline-flex p-1 rounded-xl bg-surface border border-border">
        {options.map((opt) => {
          const active = value === opt.value;
          return (
            <button
              key={opt.value}
              onClick={() => onChange(opt.value)}
              className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-sm font-medium transition-all duration-150 ${
                active
                  ? 'bg-white text-text-primary shadow-card'
                  : 'text-text-secondary hover:text-text-primary'
              }`}
            >
              {opt.dot && <span className={`w-1.5 h-1.5 rounded-full ${opt.dot}`} />}
              {opt.label}
            </button>
          );
        })}
      </div>
    </div>
  );
}

/**
 * Filter bar for the license pool table — status, printed, and device search.
 */
export function PoolFilters({
  statusFilter,
  onStatusChange,
  printedFilter,
  onPrintedChange,
  deviceSearch,
  onDeviceSearchChange,
}) {
  const statusOptions = [
    { value: '', label: 'الكل' },
    { value: LICENSE_STATUS.AVAILABLE, label: 'متاحة', dot: 'bg-emerald-500' },
    { value: LICENSE_STATUS.USED, label: 'مستخدمة', dot: 'bg-amber-500' },
  ];

  const printedOptions = [
    { value: '', label: 'الكل' },
    { value: 'printed', label: 'مطبوعة' },
    { value: 'unprinted', label: 'غير مطبوعة' },
  ];

  return (
    <div className="flex flex-wrap items-center gap-x-6 gap-y-3">
      <div className="relative w-full sm:w-72">
        <svg
          className="absolute right-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-text-secondary pointer-events-none"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          strokeWidth={2}
        >
          <path strokeLinecap="round" strokeLinejoin="round" d="M21 21l-4.35-4.35M11 19a8 8 0 100-16 8 8 0 000 16z" />
        </svg>
        <input
          type="text"
          value={deviceSearch}
          onChange={(e) => onDeviceSearchChange(e.target.value)}
          placeholder="ابحث برقم الجهاز..."
          className="w-full pr-10 pl-3 py-2.5 border border-border rounded-xl text-sm bg-white focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition"
        />
      </div>
      <Segmented label="الحالة" options={statusOptions} value={statusFilter} onChange={onStatusChange} />
      <Segmented label="الطباعة" options={printedOptions} value={printedFilter} onChange={onPrintedChange} />
    </div>
  );
}
