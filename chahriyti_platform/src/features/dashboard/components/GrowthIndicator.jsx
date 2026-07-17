import React from 'react';

/**
 * Compact growth percentage indicator.
 *
 * Shows a percentage value with a directional arrow. Green for positive
 * growth, red for negative, and muted for zero.
 *
 * @param {Object} props
 * @param {number} props.value - Growth percentage (positive or negative)
 * @param {string} [props.label] - Optional description text next to the value
 */
export function GrowthIndicator({ value, label }) {
  const isPositive = value > 0;
  const isNeutral = value === 0;

  const colorClass = isNeutral
    ? 'text-text-secondary'
    : isPositive
      ? 'text-positive'
      : 'text-negative';

  const bgClass = isNeutral
    ? 'bg-text-secondary/8'
    : isPositive
      ? 'bg-positive/8'
      : 'bg-negative/8';

  return (
    <div className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg ${bgClass}`}>
      {/* Arrow icon */}
      {!isNeutral && (
        <svg
          width="14"
          height="14"
          viewBox="0 0 14 14"
          fill="none"
          className={`shrink-0 ${colorClass} ${isPositive ? '' : 'rotate-180'}`}
        >
          <path
            d="M7 2.5L11 7H3L7 2.5Z"
            fill="currentColor"
          />
        </svg>
      )}

      {/* Percentage */}
      <span className={`text-sm font-semibold tabular-nums ${colorClass}`}>
        {isPositive ? '+' : ''}{value}%
      </span>

      {/* Optional label */}
      {label && (
        <span className="text-xs text-text-secondary ml-0.5">{label}</span>
      )}
    </div>
  );
}
