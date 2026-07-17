import React from 'react';

/**
 * Skeleton loading placeholder with pulse animation.
 *
 * @param {Object} props
 * @param {'text'|'circle'|'card'} props.variant - Shape of the skeleton
 * @param {string|number} props.width - CSS width (e.g. "100%", 200)
 * @param {string|number} props.height - CSS height (e.g. 16, "2rem")
 * @param {number} props.count - Number of skeleton lines (text variant only)
 * @param {string} props.className - Additional CSS classes
 */
export function Skeleton({
  variant = 'text',
  width,
  height,
  count = 1,
  className = '',
}) {
  // Base shimmer styles shared by all variants
  const shimmer = 'animate-pulse bg-border/60 rounded';

  if (variant === 'circle') {
    const size = width || height || 40;
    return (
      <div
        className={`${shimmer} rounded-full shrink-0 ${className}`}
        style={{ width: size, height: size }}
      />
    );
  }

  if (variant === 'card') {
    return (
      <div
        className={`${shimmer} rounded-2xl ${className}`}
        style={{
          width: width || '100%',
          height: height || 160,
        }}
      />
    );
  }

  // Text variant — renders `count` lines with the last line shorter
  return (
    <div className={`flex flex-col gap-2.5 ${className}`}>
      {Array.from({ length: count }, (_, i) => (
        <div
          key={i}
          className={`${shimmer} rounded-md`}
          style={{
            width:
              width ||
              (i === count - 1 && count > 1 ? '66%' : '100%'),
            height: height || 14,
          }}
        />
      ))}
    </div>
  );
}
