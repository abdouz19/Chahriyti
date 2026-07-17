import React from 'react';

/**
 * Card container component.
 * Uses .card and .card-elevated CSS classes from index.css.
 *
 * @param {Object} props
 * @param {'default'|'elevated'} props.variant - Shadow intensity
 * @param {string} props.className - Additional CSS classes
 * @param {{ title: string, action?: React.ReactNode }} props.header - Optional header with title and action slot
 * @param {React.ReactNode} props.children
 */
export function Card({
  variant = 'default',
  className = '',
  header,
  children,
}) {
  const baseClass = variant === 'elevated' ? 'card-elevated' : 'card';

  return (
    <div className={`${baseClass} ${className}`}>
      {/* Optional header row */}
      {header && (
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-base font-semibold text-text-primary">
            {header.title}
          </h3>
          {header.action && (
            <div className="shrink-0">{header.action}</div>
          )}
        </div>
      )}

      {children}
    </div>
  );
}
