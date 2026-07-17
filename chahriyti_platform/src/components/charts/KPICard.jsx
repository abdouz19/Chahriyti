import React, { useEffect, useRef, useState } from 'react';
import { chartColors } from '../../config/theme';

/**
 * Animated count-up hook. Interpolates from 0 to `end` over `duration` ms.
 * Only runs numbers — returns the raw value for non-numeric inputs.
 */
function useCountUp(end, duration = 800) {
  const [display, setDisplay] = useState(0);
  const rafRef = useRef(null);
  const startTimeRef = useRef(null);

  useEffect(() => {
    const numericEnd = typeof end === 'number' ? end : parseFloat(end);
    if (Number.isNaN(numericEnd)) {
      setDisplay(end);
      return;
    }

    // Determine decimal precision from the target value
    const decimals = String(numericEnd).includes('.')
      ? String(numericEnd).split('.')[1].length
      : 0;

    const step = (timestamp) => {
      if (!startTimeRef.current) startTimeRef.current = timestamp;
      const elapsed = timestamp - startTimeRef.current;
      const progress = Math.min(elapsed / duration, 1);
      // Ease-out cubic for a satisfying deceleration
      const eased = 1 - Math.pow(1 - progress, 3);
      const current = eased * numericEnd;

      setDisplay(Number(current.toFixed(decimals)));

      if (progress < 1) {
        rafRef.current = requestAnimationFrame(step);
      }
    };

    startTimeRef.current = null;
    rafRef.current = requestAnimationFrame(step);

    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
    };
  }, [end, duration]);

  return display;
}

/**
 * KPI stat card for dashboard summaries.
 *
 * @param {Object} props
 * @param {React.ReactNode} props.icon - Icon rendered inside a tinted circle
 * @param {string} props.label - Metric label displayed above the value
 * @param {string|number} props.value - The headline figure
 * @param {{ value: number, isPositive: boolean }} [props.trend] - Optional trend indicator
 * @param {string} [props.accentColor] - Override the default primary accent
 * @param {string} [props.className] - Additional CSS classes on the outer card
 */
export function KPICard({
  icon,
  label,
  value,
  trend,
  accentColor = chartColors.primary,
  className = '',
}) {
  const animatedValue = useCountUp(value);

  // Format large numbers with locale separators
  const formattedValue =
    typeof animatedValue === 'number'
      ? animatedValue.toLocaleString()
      : animatedValue;

  return (
    <div
      className={[
        'bg-white rounded-2xl border border-border/50 p-5',
        'shadow-card hover:shadow-elevated transition-shadow duration-300',
        className,
      ]
        .filter(Boolean)
        .join(' ')}
    >
      <div className="flex items-start justify-between">
        {/* Icon circle */}
        <div
          className="w-10 h-10 rounded-xl flex items-center justify-center shrink-0"
          style={{ backgroundColor: `${accentColor}14` }}
        >
          <span
            className="w-5 h-5 flex items-center justify-center"
            style={{ color: accentColor }}
          >
            {icon}
          </span>
        </div>

        {/* Trend badge */}
        {trend && (
          <span
            className={[
              'inline-flex items-center gap-1 text-xs font-medium px-2 py-0.5 rounded-full',
              trend.isPositive
                ? 'bg-green-50 text-green-600'
                : 'bg-red-50 text-red-500',
            ].join(' ')}
          >
            <svg
              width="12"
              height="12"
              viewBox="0 0 12 12"
              fill="none"
              className={trend.isPositive ? '' : 'rotate-180'}
            >
              <path
                d="M6 2.5L9.5 6.5H2.5L6 2.5Z"
                fill="currentColor"
              />
            </svg>
            {Math.abs(trend.value)}%
          </span>
        )}
      </div>

      {/* Label + Value */}
      <div className="mt-4">
        <p className="text-xs font-medium text-text-secondary tracking-wide uppercase">
          {label}
        </p>
        <p className="text-2xl font-bold text-text-primary mt-1 tabular-nums">
          {formattedValue}
        </p>
      </div>
    </div>
  );
}
