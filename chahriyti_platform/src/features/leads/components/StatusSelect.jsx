import React from 'react';
import { LEAD_STATUSES, leadStatusOf } from '../leadStatus';

/**
 * Status pill that doubles as a dropdown to change the lead's status.
 */
export function StatusSelect({ lead, onChange, disabled = false }) {
  const status = leadStatusOf(lead);

  return (
    <div className={`relative inline-flex items-center rounded-full ring-1 ring-inset ${status.pill}`}>
      <span className={`absolute right-3 w-1.5 h-1.5 rounded-full pointer-events-none ${status.dot}`} />
      <select
        value={lead.status ?? 'pending'}
        disabled={disabled}
        onClick={(e) => e.stopPropagation()}
        onChange={(e) => onChange(e.target.value)}
        className="appearance-none bg-transparent text-xs font-semibold pr-7 pl-7 py-1.5 rounded-full cursor-pointer focus:outline-none focus:ring-2 focus:ring-primary/30 disabled:cursor-wait"
      >
        {Object.entries(LEAD_STATUSES).map(([val, { label }]) => (
          <option key={val} value={val}>{label}</option>
        ))}
      </select>
      <svg className="absolute left-2.5 w-3 h-3 pointer-events-none opacity-60" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
        <path strokeLinecap="round" strokeLinejoin="round" d="M19 9l-7 7-7-7" />
      </svg>
    </div>
  );
}
