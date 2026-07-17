import React, { useId } from 'react';
import {
  ResponsiveContainer,
  AreaChart,
  Area,
  XAxis,
  YAxis,
  Tooltip,
  CartesianGrid,
} from 'recharts';
import { chartColors, chartDefaults } from '../../config/theme';

/**
 * Custom tooltip with white card + shadow — no default Recharts chrome.
 */
function CustomTooltip({ active, payload, label, color }) {
  if (!active || !payload?.length) return null;

  return (
    <div className="bg-white rounded-xl shadow-elevated border border-border/40 px-4 py-3 min-w-[120px]">
      <p className="text-xs font-medium text-text-secondary mb-1">{label}</p>
      <p className="text-sm font-semibold tabular-nums" style={{ color }}>
        {payload[0].value.toLocaleString()}
      </p>
    </div>
  );
}

/**
 * Period selector pill group.
 */
function PeriodSelector({ options, selected, onChange }) {
  if (!options?.length) return null;

  return (
    <div className="inline-flex items-center bg-surface rounded-lg p-0.5 gap-0.5">
      {options.map((period) => (
        <button
          key={period}
          onClick={() => onChange?.(period)}
          className={[
            'px-3 py-1 rounded-md text-xs font-medium transition-all duration-200',
            'focus:outline-none',
            selected === period
              ? 'bg-white text-text-primary shadow-card'
              : 'text-text-secondary hover:text-text-primary',
          ].join(' ')}
        >
          {period}
        </button>
      ))}
    </div>
  );
}

/**
 * Line chart for daily activity counts with gradient fill.
 *
 * @param {Object} props
 * @param {{ date: string, count: number }[]} props.data - Data points
 * @param {string} [props.color] - Line/fill color (default: primary)
 * @param {number} [props.height] - Chart height in px (default: 300)
 * @param {string[]} [props.periodOptions] - Period toggle labels, e.g. ['7d','30d','90d']
 * @param {string} [props.selectedPeriod] - Currently active period
 * @param {(period: string) => void} [props.onPeriodChange] - Period change handler
 * @param {string} [props.title] - Optional header text
 * @param {string} [props.className] - Extra classes on the wrapper
 */
export function ActivityChart({
  data = [],
  color = chartColors.primary,
  height = 300,
  periodOptions,
  selectedPeriod,
  onPeriodChange,
  title,
  className = '',
}) {
  // Unique gradient id to avoid collisions when multiple charts render
  const uid = useId();
  const gradientId = `activity-gradient-${uid}`;

  return (
    <div
      className={[
        'bg-white rounded-2xl border border-border/50 shadow-card p-5',
        className,
      ]
        .filter(Boolean)
        .join(' ')}
    >
      {/* Header row */}
      {(title || periodOptions) && (
        <div className="flex items-center justify-between mb-5">
          {title && (
            <h3 className="text-sm font-semibold text-text-primary">{title}</h3>
          )}
          <PeriodSelector
            options={periodOptions}
            selected={selectedPeriod}
            onChange={onPeriodChange}
          />
        </div>
      )}

      <ResponsiveContainer width="100%" height={height}>
        <AreaChart
          data={data}
          margin={{ top: 4, right: 4, bottom: 0, left: -20 }}
        >
          <defs>
            <linearGradient id={gradientId} x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor={color} stopOpacity={0.12} />
              <stop offset="100%" stopColor={color} stopOpacity={0} />
            </linearGradient>
          </defs>

          <CartesianGrid
            stroke="none"
          />

          <XAxis
            dataKey="date"
            axisLine={false}
            tickLine={false}
            tick={{ fontSize: 11, fill: '#94A3B8' }}
            dy={8}
          />

          <YAxis
            axisLine={false}
            tickLine={false}
            tick={{ fontSize: 11, fill: '#94A3B8' }}
            allowDecimals={false}
          />

          <Tooltip
            content={<CustomTooltip color={color} />}
            cursor={{
              stroke: color,
              strokeWidth: 1,
              strokeDasharray: '4 4',
              strokeOpacity: 0.4,
            }}
          />

          <Area
            type="monotone"
            dataKey="count"
            stroke={color}
            strokeWidth={chartDefaults.strokeWidth}
            fill={`url(#${gradientId})`}
            dot={false}
            activeDot={{
              r: chartDefaults.activeDotRadius,
              fill: '#fff',
              stroke: color,
              strokeWidth: 2,
            }}
            animationDuration={chartDefaults.animationDuration}
          />
        </AreaChart>
      </ResponsiveContainer>
    </div>
  );
}
