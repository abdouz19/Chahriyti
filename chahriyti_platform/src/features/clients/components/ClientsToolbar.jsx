import React, { useState } from 'react';
import { Input, Badge, DateRangePicker } from '../../../components/ui';
import { formatNumber } from '../../../utils/formatters';

/**
 * Toolbar above the clients table.
 * Contains search input, date range picker, and summary badges.
 *
 * @param {Object} props
 * @param {string}   props.searchQuery   - Current search value (display only; actual state may be debounced).
 * @param {Function} props.onSearchChange - Called on every keystroke with the raw input value.
 * @param {string}   props.startDate     - Start date in YYYY-MM-DD format.
 * @param {string}   props.endDate       - End date in YYYY-MM-DD format.
 * @param {Function} props.onDateChange  - Called with (startDate, endDate).
 * @param {number}   props.todayCount    - Number of clients generated today.
 * @param {number}   props.totalCount    - Total clients in current result set.
 */
export function ClientsToolbar({
  searchQuery,
  onSearchChange,
  startDate,
  endDate,
  onDateChange,
  todayCount,
  totalCount,
}) {
  const [localSearch, setLocalSearch] = useState(searchQuery);
  const [showDatePicker, setShowDatePicker] = useState(false);

  /**
   * Handle search input change — update local display and propagate
   * the debounced value via onSearchChange.
   */
  const handleSearch = (e) => {
    const value = e.target.value;
    setLocalSearch(value);
    onSearchChange(value);
  };

  /** Whether any date filter is currently active. */
  const hasDateFilter = !!(startDate || endDate);

  return (
    <div className="flex flex-col gap-4">
      {/* Top row: search + date toggle + badges */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center gap-3">
        {/* Search input */}
        <div className="w-full sm:w-72">
          <Input
            type="search"
            placeholder="بحث بالاسم..."
            value={localSearch}
            onChange={handleSearch}
          />
        </div>

        {/* Date filter toggle */}
        <button
          type="button"
          onClick={() => setShowDatePicker((prev) => !prev)}
          className={[
            'inline-flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium transition-colors duration-150',
            hasDateFilter
              ? 'bg-primary/10 text-primary ring-1 ring-inset ring-primary/20'
              : 'text-text-secondary hover:bg-surface hover:text-text-primary',
          ].join(' ')}
        >
          {/* Calendar icon */}
          <svg
            className="w-4 h-4"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            strokeWidth={2}
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
            />
          </svg>
          {hasDateFilter ? 'تصفية بالتاريخ' : 'فلتر التاريخ'}
        </button>

        {/* Clear date filter */}
        {hasDateFilter && (
          <button
            type="button"
            onClick={() => {
              onDateChange('', '');
              setShowDatePicker(false);
            }}
            className="text-xs text-negative hover:underline"
          >
            مسح الفلتر
          </button>
        )}

        {/* Spacer */}
        <div className="flex-1" />

        {/* Summary badges */}
        <div className="flex items-center gap-2">
          <Badge variant="success">
            اليوم: {formatNumber(todayCount)}
          </Badge>
          <Badge variant="neutral">
            الإجمالي: {formatNumber(totalCount)}
          </Badge>
        </div>
      </div>

      {/* Date range picker — conditionally visible */}
      {showDatePicker && (
        <DateRangePicker
          startDate={startDate}
          endDate={endDate}
          onChange={({ startDate: s, endDate: e }) => onDateChange(s, e)}
          className="max-w-md"
        />
      )}
    </div>
  );
}
