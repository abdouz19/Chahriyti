import React from 'react';

/**
 * Builds an array of page numbers with ellipsis markers ("...") for large ranges.
 * Always shows first page, last page, and a window around the current page.
 */
function getPageNumbers(current, total) {
  if (total <= 7) {
    return Array.from({ length: total }, (_, i) => i + 1);
  }

  const pages = new Set([1, total]);

  // Window of 1 page around current
  for (let i = current - 1; i <= current + 1; i++) {
    if (i > 1 && i < total) pages.add(i);
  }

  const sorted = [...pages].sort((a, b) => a - b);

  // Insert ellipsis markers between non-consecutive entries
  const result = [];
  let prev = 0;
  for (const page of sorted) {
    if (page - prev > 1) result.push('...');
    result.push(page);
    prev = page;
  }
  return result;
}

/**
 * Pagination control with page numbers, prev/next, and ellipsis.
 *
 * @param {Object} props
 * @param {number} props.currentPage - Active page (1-indexed)
 * @param {number} props.totalPages - Total number of pages
 * @param {Function} props.onPageChange - Called with the new page number
 * @param {string} props.className - Additional CSS classes
 */
export function Pagination({
  currentPage,
  totalPages,
  onPageChange,
  className = '',
}) {
  if (totalPages <= 1) return null;

  const pages = getPageNumbers(currentPage, totalPages);

  // Shared button styles
  const baseBtn =
    'inline-flex items-center justify-center min-w-[36px] h-9 rounded-lg text-sm font-medium transition-colors duration-150 select-none';

  return (
    <nav
      className={`flex items-center gap-1 ${className}`}
      aria-label="Pagination"
    >
      {/* Previous */}
      <button
        onClick={() => onPageChange(currentPage - 1)}
        disabled={currentPage <= 1}
        className={`${baseBtn} px-2 text-text-secondary hover:bg-surface disabled:opacity-40 disabled:cursor-not-allowed`}
        aria-label="Previous page"
      >
        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
          <path strokeLinecap="round" strokeLinejoin="round" d="M15 19l-7-7 7-7" />
        </svg>
      </button>

      {/* Page numbers */}
      {pages.map((page, idx) =>
        page === '...' ? (
          <span
            key={`ellipsis-${idx}`}
            className="min-w-[36px] h-9 flex items-center justify-center text-sm text-text-secondary select-none"
          >
            ...
          </span>
        ) : (
          <button
            key={page}
            onClick={() => onPageChange(page)}
            className={[
              baseBtn,
              page === currentPage
                ? 'bg-primary text-white shadow-sm'
                : 'text-text-secondary hover:bg-surface',
            ].join(' ')}
            aria-current={page === currentPage ? 'page' : undefined}
          >
            {page}
          </button>
        ),
      )}

      {/* Next */}
      <button
        onClick={() => onPageChange(currentPage + 1)}
        disabled={currentPage >= totalPages}
        className={`${baseBtn} px-2 text-text-secondary hover:bg-surface disabled:opacity-40 disabled:cursor-not-allowed`}
        aria-label="Next page"
      >
        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
          <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7" />
        </svg>
      </button>
    </nav>
  );
}
