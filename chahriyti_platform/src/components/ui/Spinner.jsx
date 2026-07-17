import React from 'react';

/**
 * Animated SVG loading spinner in the brand primary color.
 *
 * @param {Object} props
 * @param {'sm'|'md'|'lg'} props.size - Spinner diameter
 * @param {string} props.className - Additional CSS classes
 */
export function Spinner({ size = 'md', className = '' }) {
  const sizeClass = {
    sm: 'w-4 h-4',
    md: 'w-6 h-6',
    lg: 'w-10 h-10',
  }[size];

  return (
    <svg
      className={`animate-spin text-primary ${sizeClass} ${className}`}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      role="status"
      aria-label="Loading"
    >
      {/* Faded track circle */}
      <circle
        className="opacity-20"
        cx="12"
        cy="12"
        r="10"
        stroke="currentColor"
        strokeWidth="3"
      />
      {/* Animated arc */}
      <path
        className="opacity-80"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
      />
    </svg>
  );
}
