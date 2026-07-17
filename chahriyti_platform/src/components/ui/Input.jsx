import React, { useId } from 'react';

/**
 * Search icon used when type="search".
 */
function SearchIcon() {
  return (
    <svg
      className="w-4 h-4 text-text-secondary"
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      strokeWidth={2}
    >
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M21 21l-4.35-4.35M11 19a8 8 0 100-16 8 8 0 000 16z"
      />
    </svg>
  );
}

/**
 * Input component with label, error state, and icon support.
 * Uses the .input-field CSS class from index.css.
 *
 * @param {Object} props
 * @param {string} props.label - Label text displayed above the input
 * @param {string} props.error - Validation error message (triggers red border)
 * @param {React.ReactNode} props.icon - Icon rendered inside the input on the left
 * @param {'text'|'password'|'search'|'email'|'number'} props.type - Input type
 * @param {string} props.className - Additional wrapper classes
 */
export function Input({
  label,
  error,
  icon,
  type = 'text',
  className = '',
  ...rest
}) {
  const id = useId();

  // For search inputs, automatically use the search icon if none provided
  const resolvedIcon = icon ?? (type === 'search' ? <SearchIcon /> : null);
  const hasIcon = !!resolvedIcon;

  return (
    <div className={`flex flex-col gap-1.5 ${className}`}>
      {/* Label */}
      {label && (
        <label
          htmlFor={id}
          className="text-sm font-medium text-text-primary"
        >
          {label}
        </label>
      )}

      {/* Input wrapper — positions the icon absolutely inside */}
      <div className="relative">
        {hasIcon && (
          <span className="absolute left-3.5 top-1/2 -translate-y-1/2 pointer-events-none flex items-center justify-center">
            {resolvedIcon}
          </span>
        )}

        <input
          id={id}
          type={type}
          className={[
            'input-field',
            hasIcon ? 'pl-10' : '',
            error
              ? 'border-negative focus:ring-negative/20 focus:border-negative'
              : '',
          ]
            .filter(Boolean)
            .join(' ')}
          aria-invalid={!!error}
          aria-describedby={error ? `${id}-error` : undefined}
          {...rest}
        />
      </div>

      {/* Error message */}
      {error && (
        <p
          id={`${id}-error`}
          className="text-xs text-negative flex items-center gap-1"
          role="alert"
        >
          {/* Small warning circle */}
          <svg
            className="w-3.5 h-3.5 shrink-0"
            fill="currentColor"
            viewBox="0 0 20 20"
          >
            <path
              fillRule="evenodd"
              d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"
              clipRule="evenodd"
            />
          </svg>
          {error}
        </p>
      )}
    </div>
  );
}
