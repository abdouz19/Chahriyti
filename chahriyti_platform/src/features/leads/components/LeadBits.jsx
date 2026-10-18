import React from 'react';

export function LeadAvatar({ name, size = 'sm' }) {
  const initial = (name ?? '?').trim().charAt(0).toUpperCase() || '?';
  const sizeClass = size === 'lg' ? 'w-12 h-12 text-lg' : 'w-9 h-9 text-sm';
  return (
    <div className={`${sizeClass} shrink-0 rounded-full bg-primary/10 text-primary font-semibold flex items-center justify-center`}>
      {initial}
    </div>
  );
}

export function SourceTag({ source }) {
  const fromStore = source === 'woocommerce';
  return (
    <span className={`inline-flex items-center px-2 py-0.5 rounded-md text-xs font-medium ${
      fromStore ? 'bg-orange-50 text-orange-700' : 'bg-blue-50 text-blue-700'
    }`}>
      {fromStore ? 'المتجر' : 'التطبيق'}
    </span>
  );
}
