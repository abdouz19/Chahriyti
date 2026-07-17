import React from 'react';
import { Button } from './Button';

/**
 * Centered empty-state placeholder for screens with no data.
 *
 * @param {Object} props
 * @param {React.ReactNode} props.icon - Decorative icon displayed above the title
 * @param {string} props.title - Heading text
 * @param {string} props.description - Supporting copy
 * @param {{ label: string, onClick: Function }} props.action - Optional CTA button
 * @param {string} props.className - Additional CSS classes
 */
export function EmptyState({ icon, title, description, action, className = '' }) {
  return (
    <div
      className={`flex flex-col items-center justify-center text-center py-16 px-6 ${className}`}
    >
      {/* Icon container */}
      {icon && (
        <div className="w-14 h-14 rounded-2xl bg-primary/8 flex items-center justify-center text-primary mb-5">
          {icon}
        </div>
      )}

      {/* Title */}
      <h3 className="text-base font-semibold text-text-primary mb-1.5">
        {title}
      </h3>

      {/* Description */}
      {description && (
        <p className="text-sm text-text-secondary max-w-xs mb-6">
          {description}
        </p>
      )}

      {/* Optional action button */}
      {action && (
        <Button variant="secondary" size="sm" onClick={action.onClick}>
          {action.label}
        </Button>
      )}
    </div>
  );
}
