import React from 'react';

/**
 * Small pill-shaped badge for status indicators.
 *
 * @param {Object} props
 * @param {'success'|'warning'|'danger'|'neutral'} props.variant - Color scheme
 * @param {string} props.className - Additional CSS classes
 * @param {React.ReactNode} props.children
 */
export function Badge({ variant = 'neutral', className = '', children }) {
  const variantClasses = {
    success:
      'bg-positive/10 text-positive ring-positive/20',
    warning:
      'bg-warning/10 text-warning ring-warning/20',
    danger:
      'bg-negative/10 text-negative ring-negative/20',
    neutral:
      'bg-text-secondary/10 text-text-secondary ring-text-secondary/20',
  }[variant];

  return (
    <span
      className={[
        'inline-flex items-center',
        'px-2.5 py-0.5 rounded-full',
        'text-xs font-medium',
        'ring-1 ring-inset',
        variantClasses,
        className,
      ]
        .filter(Boolean)
        .join(' ')}
    >
      {children}
    </span>
  );
}
