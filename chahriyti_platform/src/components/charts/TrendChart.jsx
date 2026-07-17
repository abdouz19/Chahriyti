import React, { useId } from 'react';
import {
  ResponsiveContainer,
  BarChart,
  Bar,
  AreaChart,
  Area,
  XAxis,
  YAxis,
  Tooltip,
  CartesianGrid,
} from 'recharts';
import { chartColors, chartDefaults } from '../../config/theme';

/**
 * Custom tooltip matching the brand card style.
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
 * Custom rounded-top bar shape for the BarChart variant.
 */
function RoundedBar({ x, y, width, height, fill }) {
  if (!height || height <= 0) return null;
  const radius = Math.min(6, width / 2, height);

  return (
    <path
      d={`
        M${x},${y + height}
        L${x},${y + radius}
        Q${x},${y} ${x + radius},${y}
        L${x + width - radius},${y}
        Q${x + width},${y} ${x + width},${y + radius}
        L${x + width},${y + height}
        Z
      `}
      fill={fill}
    />
  );
}

/**
 * Trend visualisation that renders as either a bar or area chart.
 *
 * @param {Object} props
 * @param {{ date: string, count: number }[]} props.data - Data points
 * @param {string} [props.color] - Fill / stroke color (default: primary)
 * @param {number} [props.height] - Chart height in px (default: 300)
 * @param {'bar'|'area'} [props.type] - Chart variant (default: 'bar')
 * @param {string} [props.title] - Optional header text
 * @param {string} [props.className] - Extra classes on the wrapper
 */
export function TrendChart({
  data = [],
  color = chartColors.primary,
  height = 300,
  type = 'bar',
  title,
  className = '',
}) {
  const uid = useId();
  const gradientId = `trend-gradient-${uid}`;

  const sharedAxisProps = {
    axisLine: false,
    tickLine: false,
    tick: { fontSize: 11, fill: '#94A3B8' },
  };

  const tooltipProps = {
    content: <CustomTooltip color={color} />,
    cursor: type === 'bar'
      ? { fill: `${color}08`, radius: 6 }
      : { stroke: color, strokeWidth: 1, strokeDasharray: '4 4', strokeOpacity: 0.4 },
  };

  return (
    <div
      className={[
        'bg-white rounded-2xl border border-border/50 shadow-card p-5',
        className,
      ]
        .filter(Boolean)
        .join(' ')}
    >
      {title && (
        <h3 className="text-sm font-semibold text-text-primary mb-5">
          {title}
        </h3>
      )}

      <ResponsiveContainer width="100%" height={height}>
        {type === 'bar' ? (
          <BarChart
            data={data}
            margin={{ top: 4, right: 4, bottom: 0, left: -20 }}
            barCategoryGap="25%"
          >
            <CartesianGrid stroke="none" />
            <XAxis dataKey="date" {...sharedAxisProps} dy={8} />
            <YAxis {...sharedAxisProps} allowDecimals={false} />
            <Tooltip {...tooltipProps} />
            <Bar
              dataKey="count"
              fill={color}
              shape={<RoundedBar />}
              animationDuration={chartDefaults.animationDuration}
              fillOpacity={0.85}
            />
          </BarChart>
        ) : (
          <AreaChart
            data={data}
            margin={{ top: 4, right: 4, bottom: 0, left: -20 }}
          >
            <defs>
              <linearGradient id={gradientId} x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor={color} stopOpacity={0.15} />
                <stop offset="100%" stopColor={color} stopOpacity={0} />
              </linearGradient>
            </defs>

            <CartesianGrid stroke="none" />
            <XAxis dataKey="date" {...sharedAxisProps} dy={8} />
            <YAxis {...sharedAxisProps} allowDecimals={false} />
            <Tooltip {...tooltipProps} />
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
        )}
      </ResponsiveContainer>
    </div>
  );
}
