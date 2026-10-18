import React from 'react';

const PRESETS = [
  { value: 'all', label: 'كل الفترات' },
  { value: 'today', label: 'اليوم' },
  { value: 'yesterday', label: 'أمس' },
  { value: '7d', label: 'آخر 7 أيام' },
  { value: '30d', label: 'آخر 30 يوماً' },
  { value: 'month', label: 'هذا الشهر' },
  { value: 'custom', label: 'مخصص' },
];

// Local midnight, so "today" means today in Algeria, not in UTC
function dayStart(d, offsetDays = 0) {
  return new Date(d.getFullYear(), d.getMonth(), d.getDate() + offsetDays);
}

// "2026-10-18" → local midnight of that day
function parseDay(value) {
  if (!value) return null;
  const [y, m, d] = value.split('-').map(Number);
  return new Date(y, m - 1, d);
}

function toInputValue(d) {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
}

/**
 * Turns a period selection into a [from, to) date range; null means unbounded.
 */
export function periodToRange({ preset, customFrom, customTo }) {
  const now = new Date();
  switch (preset) {
    case 'today': return { from: dayStart(now), to: null };
    case 'yesterday': return { from: dayStart(now, -1), to: dayStart(now) };
    case '7d': return { from: dayStart(now, -6), to: null };
    case '30d': return { from: dayStart(now, -29), to: null };
    case 'month': return { from: new Date(now.getFullYear(), now.getMonth(), 1), to: null };
    case 'custom': {
      const from = parseDay(customFrom);
      const last = parseDay(customTo);
      return { from, to: last ? dayStart(last, 1) : null };
    }
    default: return { from: null, to: null };
  }
}

/**
 * Date period selector: quick presets plus an optional custom from/to range.
 */
export function PeriodFilter({ value, onChange }) {
  const today = toInputValue(new Date());
  const set = (patch) => onChange({ ...value, ...patch });

  return (
    <div className="flex flex-wrap items-center gap-3">
      <div className="inline-flex flex-wrap p-1 rounded-xl bg-white border border-border">
        {PRESETS.map((p) => (
          <button
            key={p.value}
            onClick={() => set({ preset: p.value })}
            className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-colors ${
              value.preset === p.value
                ? 'bg-primary/10 text-primary'
                : 'text-text-secondary hover:text-text-primary'
            }`}
          >
            {p.label}
          </button>
        ))}
      </div>

      {value.preset === 'custom' && (
        <div className="flex items-center gap-2 text-sm">
          <label className="text-text-secondary">من</label>
          <input
            type="date"
            value={value.customFrom}
            max={value.customTo || today}
            onChange={(e) => set({ customFrom: e.target.value })}
            className="px-3 py-1.5 rounded-lg border border-border bg-white text-text-primary focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary"
          />
          <label className="text-text-secondary">إلى</label>
          <input
            type="date"
            value={value.customTo}
            min={value.customFrom || undefined}
            max={today}
            onChange={(e) => set({ customTo: e.target.value })}
            className="px-3 py-1.5 rounded-lg border border-border bg-white text-text-primary focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary"
          />
        </div>
      )}
    </div>
  );
}
