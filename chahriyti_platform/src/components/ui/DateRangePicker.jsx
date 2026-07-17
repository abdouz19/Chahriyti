import React from 'react';

/**
 * Returns an ISO date string (YYYY-MM-DD) for a Date object.
 */
function toISO(date) {
  return date.toISOString().split('T')[0];
}

/**
 * Preset date range calculations.
 * Each preset returns { startDate, endDate } as ISO strings.
 */
const PRESETS = [
  {
    label: 'Today',
    range: () => {
      const today = toISO(new Date());
      return { startDate: today, endDate: today };
    },
  },
  {
    label: 'This Week',
    range: () => {
      const now = new Date();
      const day = now.getDay();
      // Monday as start of week
      const diff = day === 0 ? 6 : day - 1;
      const start = new Date(now);
      start.setDate(now.getDate() - diff);
      return { startDate: toISO(start), endDate: toISO(now) };
    },
  },
  {
    label: 'This Month',
    range: () => {
      const now = new Date();
      const start = new Date(now.getFullYear(), now.getMonth(), 1);
      return { startDate: toISO(start), endDate: toISO(now) };
    },
  },
  {
    label: 'Last 30 Days',
    range: () => {
      const now = new Date();
      const start = new Date(now);
      start.setDate(now.getDate() - 29);
      return { startDate: toISO(start), endDate: toISO(now) };
    },
  },
];

/**
 * Simple date range picker with two date inputs and preset shortcuts.
 *
 * @param {Object} props
 * @param {string} props.startDate - Start date in YYYY-MM-DD format
 * @param {string} props.endDate - End date in YYYY-MM-DD format
 * @param {Function} props.onChange - Called with { startDate, endDate }
 * @param {string} props.className - Additional CSS classes
 */
export function DateRangePicker({
  startDate,
  endDate,
  onChange,
  className = '',
}) {
  return (
    <div className={`flex flex-col gap-3 ${className}`}>
      {/* Date inputs row */}
      <div className="flex items-center gap-2">
        <div className="flex-1">
          <label className="block text-xs font-medium text-text-secondary mb-1">
            From
          </label>
          <input
            type="date"
            value={startDate}
            max={endDate}
            onChange={(e) =>
              onChange({ startDate: e.target.value, endDate })
            }
            className="input-field text-sm"
          />
        </div>

        {/* Separator dash */}
        <span className="text-text-secondary mt-5 select-none">&ndash;</span>

        <div className="flex-1">
          <label className="block text-xs font-medium text-text-secondary mb-1">
            To
          </label>
          <input
            type="date"
            value={endDate}
            min={startDate}
            onChange={(e) =>
              onChange({ startDate, endDate: e.target.value })
            }
            className="input-field text-sm"
          />
        </div>
      </div>

      {/* Preset buttons */}
      <div className="flex flex-wrap gap-1.5">
        {PRESETS.map((preset) => {
          const { startDate: ps, endDate: pe } = preset.range();
          const isActive = startDate === ps && endDate === pe;

          return (
            <button
              key={preset.label}
              type="button"
              onClick={() => onChange(preset.range())}
              className={[
                'px-3 py-1.5 rounded-lg text-xs font-medium transition-colors duration-150',
                isActive
                  ? 'bg-primary/10 text-primary ring-1 ring-inset ring-primary/20'
                  : 'text-text-secondary hover:bg-surface hover:text-text-primary',
              ].join(' ')}
            >
              {preset.label}
            </button>
          );
        })}
      </div>
    </div>
  );
}
