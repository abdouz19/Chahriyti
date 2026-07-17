import React from 'react';
import { Spinner } from './Spinner';

/**
 * Button component with variant, size, loading, and icon support.
 * Uses CSS classes defined in index.css (.btn-primary, .btn-secondary, etc.)
 *
 * @param {Object} props
 * @param {'primary'|'secondary'|'danger'|'ghost'} props.variant - Visual style
 * @param {'sm'|'md'|'lg'} props.size - Button size
 * @param {boolean} props.loading - Shows spinner and disables interaction
 * @param {boolean} props.disabled - Disables the button
 * @param {React.ReactNode} props.icon - Optional icon rendered to the left of children
 * @param {boolean} props.fullWidth - Stretches button to fill container width
 * @param {string} props.className - Additional CSS classes
 * @param {React.ReactNode} props.children
 */
export function Button({
  variant = 'primary',
  size = 'md',
  loading = false,
  disabled = false,
  icon,
  fullWidth = false,
  className = '',
  children,
  ...rest
}) {
  // Map variant to the corresponding CSS class from index.css
  const variantClass = {
    primary: 'btn-primary',
    secondary: 'btn-secondary',
    danger: 'btn-danger',
    ghost: 'btn-ghost',
  }[variant];

  // Size adjustments layered on top of the base CSS classes
  const sizeClass = {
    sm: 'text-sm px-3 py-1.5',
    md: 'text-sm px-4 py-2.5',
    lg: 'text-base px-6 py-3',
  }[size];

  return (
    <button
      className={[
        variantClass,
        sizeClass,
        fullWidth ? 'w-full' : '',
        'inline-flex items-center justify-center gap-2',
        'select-none',
        loading ? 'cursor-wait' : '',
        className,
      ]
        .filter(Boolean)
        .join(' ')}
      disabled={disabled || loading}
      {...rest}
    >
      {/* Show spinner when loading, otherwise show the optional icon */}
      {loading ? (
        <Spinner size="sm" className="shrink-0" />
      ) : icon ? (
        <span className="shrink-0 w-4 h-4 flex items-center justify-center">
          {icon}
        </span>
      ) : null}

      {children}
    </button>
  );
}
