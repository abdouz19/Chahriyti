import React from 'react';
import { LICENSE_STATUS } from '../../../config/constants';

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
    { value: LICENSE_STATUS.AVAILABLE, label: 'متاحة' },
    { value: LICENSE_STATUS.USED, label: 'مستخدمة' },
  ];

  const printedOptions = [
    { value: '', label: 'الكل' },
    { value: 'printed', label: 'مطبوعة' },
    { value: 'unprinted', label: 'غير مطبوعة' },
  ];

  const btnClass = (active) => [
    'px-3 py-1.5 rounded-lg text-sm font-medium transition-colors duration-150',
    active
      ? 'bg-primary text-white'
      : 'bg-surface text-text-secondary hover:text-text-primary hover:bg-surface/80',
  ].join(' ');

  return (
    <div className="flex flex-wrap items-center gap-4">
      {/* Status filter */}
      <div className="flex items-center gap-2">
        <span className="text-sm text-text-secondary">الحالة:</span>
        <div className="flex gap-1.5">
          {statusOptions.map((opt) => (
            <button
              key={opt.value}
              onClick={() => onStatusChange(opt.value)}
              className={btnClass(statusFilter === opt.value)}
            >
              {opt.label}
            </button>
          ))}
        </div>
      </div>

      {/* Printed filter */}
      <div className="flex items-center gap-2">
        <span className="text-sm text-text-secondary">الطباعة:</span>
        <div className="flex gap-1.5">
          {printedOptions.map((opt) => (
            <button
              key={opt.value}
              onClick={() => onPrintedChange(opt.value)}
              className={btnClass(printedFilter === opt.value)}
            >
              {opt.label}
            </button>
          ))}
        </div>
      </div>

      {/* Device ID search */}
      <div className="flex items-center gap-2 mr-auto">
        <div className="relative">
          <svg
            className="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-secondary pointer-events-none"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            strokeWidth={1.5}
          >
            <path strokeLinecap="round" strokeLinejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
          </svg>
          <input
            type="text"
            value={deviceSearch}
            onChange={(e) => onDeviceSearchChange(e.target.value)}
            placeholder="بحث برقم الجهاز..."
            className="w-56 pr-9 pl-3 py-1.5 border border-border rounded-lg text-sm bg-surface focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary"
            dir="ltr"
          />
        </div>
      </div>
    </div>
  );
}
