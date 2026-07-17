import React from 'react';
import toast from 'react-hot-toast';
import { Spinner } from '../../../components/ui';
import { formatDateShort, formatPhone } from '../../../utils/formatters';

/**
 * Truncate a string to `len` characters and append "..." if it exceeds.
 *
 * @param {string} str
 * @param {number} len
 * @returns {string}
 */
function truncate(str, len) {
  if (!str || typeof str !== 'string') return '';
  return str.length > len ? `${str.slice(0, len)}...` : str;
}

/**
 * Small copy-to-clipboard icon button.
 *
 * @param {Object} props
 * @param {string} props.text   - Text to copy.
 * @param {string} props.label  - Toast confirmation label (e.g. "مفتاح الترخيص").
 */
function CopyButton({ text, label }) {
  const handleCopy = async (e) => {
    e.stopPropagation(); // Prevent row click
    try {
      await navigator.clipboard.writeText(text);
      toast.success(`تم نسخ ${label}`);
    } catch {
      toast.error('فشل النسخ');
    }
  };

  return (
    <button
      type="button"
      onClick={handleCopy}
      className="p-1.5 rounded-md text-text-secondary hover:text-primary hover:bg-primary/8 transition-colors duration-150"
      aria-label={`نسخ ${label}`}
      title={`نسخ ${label}`}
    >
      <svg
        className="w-4 h-4"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
        strokeWidth={2}
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
        />
      </svg>
    </button>
  );
}

/**
 * Clients data table with zebra striping, hover highlight, and responsive columns.
 *
 * @param {Object}   props
 * @param {object[]} props.clients    - Array of client objects.
 * @param {boolean}  props.loading    - Whether data is currently loading.
 * @param {Function} props.onRowClick - Called with the client object when a row is clicked.
 * @param {Function} props.onCopyKey  - (Optional) Called after a license key is copied.
 */
export function ClientsTable({ clients, loading, onRowClick, onCopyKey }) {
  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <Spinner size="lg" />
      </div>
    );
  }

  return (
    <div className="overflow-x-auto rounded-xl border border-border/40">
      <table className="w-full text-sm">
        {/* Header */}
        <thead>
          <tr className="bg-surface/60 text-text-secondary text-right">
            <th className="px-4 py-3 font-medium">الاسم</th>
            <th className="px-4 py-3 font-medium hidden sm:table-cell">الهاتف</th>
            <th className="px-4 py-3 font-medium hidden lg:table-cell">معرّف الجهاز</th>
            <th className="px-4 py-3 font-medium">مفتاح الترخيص</th>
            <th className="px-4 py-3 font-medium hidden md:table-cell">التاريخ</th>
            <th className="px-4 py-3 font-medium w-12">نسخ</th>
          </tr>
        </thead>

        {/* Body */}
        <tbody>
          {clients.map((client, index) => (
            <tr
              key={client.id}
              onClick={() => onRowClick(client)}
              className={[
                'cursor-pointer transition-colors duration-100 text-right',
                'hover:bg-primary/5',
                index % 2 === 0 ? 'bg-card' : 'bg-surface/30',
              ].join(' ')}
            >
              {/* Name */}
              <td className="px-4 py-3 font-medium text-text-primary whitespace-nowrap">
                {client.clientName || '—'}
              </td>

              {/* Phone — hidden on mobile */}
              <td className="px-4 py-3 text-text-secondary hidden sm:table-cell whitespace-nowrap" dir="ltr">
                {formatPhone(client.phone) || '—'}
              </td>

              {/* Device ID — hidden below lg */}
              <td className="px-4 py-3 text-text-secondary hidden lg:table-cell font-mono text-xs" dir="ltr">
                {truncate(client.deviceId, 8)}
              </td>

              {/* License Key */}
              <td className="px-4 py-3 text-text-secondary font-mono text-xs whitespace-nowrap" dir="ltr">
                {truncate(client.licenseKey, 12)}
              </td>

              {/* Date — hidden below md */}
              <td className="px-4 py-3 text-text-secondary hidden md:table-cell whitespace-nowrap" dir="ltr">
                {formatDateShort(client.createdAt)}
              </td>

              {/* Copy button */}
              <td className="px-4 py-3">
                <CopyButton text={client.licenseKey} label="مفتاح الترخيص" />
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
