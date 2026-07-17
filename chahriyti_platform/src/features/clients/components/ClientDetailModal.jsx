import React from 'react';
import toast from 'react-hot-toast';
import { Modal, Button } from '../../../components/ui';
import { formatDate, formatPhone, formatLicenseKey } from '../../../utils/formatters';

/**
 * Copy text to clipboard and show a toast notification.
 *
 * @param {string} text  - Value to copy.
 * @param {string} label - Human-readable label for the toast message.
 */
async function copyToClipboard(text, label) {
  try {
    await navigator.clipboard.writeText(text);
    toast.success(`تم نسخ ${label}`);
  } catch {
    toast.error('فشل النسخ');
  }
}

/**
 * Read-only detail row used inside the modal body.
 *
 * @param {Object}  props
 * @param {string}  props.label    - Field label.
 * @param {string}  props.value    - Field value.
 * @param {boolean} props.mono     - Render value in monospace font.
 * @param {boolean} props.copyable - Show a copy button next to the value.
 * @param {string}  props.dir      - Text direction ('ltr' for phone/IDs).
 */
function DetailRow({ label, value, mono = false, copyable = false, dir }) {
  return (
    <div className="flex flex-col gap-1">
      <span className="text-xs font-medium text-text-secondary">{label}</span>
      <div className="flex items-center gap-2">
        <span
          className={[
            'text-sm text-text-primary break-all',
            mono ? 'font-mono' : '',
          ]
            .filter(Boolean)
            .join(' ')}
          dir={dir}
        >
          {value || '—'}
        </span>

        {copyable && value && (
          <button
            type="button"
            onClick={() => copyToClipboard(value, label)}
            className="shrink-0 p-1 rounded-md text-text-secondary hover:text-primary hover:bg-primary/8 transition-colors duration-150"
            aria-label={`نسخ ${label}`}
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
        )}
      </div>
    </div>
  );
}

/**
 * Modal displaying full details for a single client record.
 *
 * @param {Object}       props
 * @param {object|null}  props.client - Client data object (null when closed).
 * @param {boolean}      props.isOpen - Controls modal visibility.
 * @param {Function}     props.onClose - Called when the modal requests close.
 */
export function ClientDetailModal({ client, isOpen, onClose }) {
  if (!client) return null;

  const licenseKey = formatLicenseKey(client.licenseKey);

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="تفاصيل العميل" size="md">
      <div className="flex flex-col gap-5">
        {/* Client name */}
        <DetailRow label="الاسم الكامل" value={client.clientName} />

        {/* Phone */}
        <DetailRow
          label="رقم الهاتف"
          value={formatPhone(client.phone)}
          dir="ltr"
          copyable
        />

        {/* Device ID */}
        <DetailRow
          label="معرّف الجهاز"
          value={client.deviceId}
          mono
          dir="ltr"
          copyable
        />

        {/* License key — prominent copy button */}
        <div className="flex flex-col gap-2">
          <span className="text-xs font-medium text-text-secondary">
            مفتاح الترخيص
          </span>
          <div className="flex items-center gap-3 p-3 rounded-lg bg-surface/60 border border-border/30">
            <span
              className="flex-1 text-sm font-mono text-text-primary break-all select-all"
              dir="ltr"
            >
              {licenseKey || '—'}
            </span>
            {licenseKey && (
              <Button
                variant="secondary"
                size="sm"
                onClick={() => copyToClipboard(licenseKey, 'مفتاح الترخيص')}
                icon={
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
                }
              >
                نسخ
              </Button>
            )}
          </div>
        </div>

        {/* Dates row */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <DetailRow
            label="تاريخ الإنشاء"
            value={formatDate(client.createdAt)}
            dir="ltr"
          />
          <DetailRow
            label="تاريخ الانتهاء"
            value={formatDate(client.expiresAt)}
            dir="ltr"
          />
        </div>
      </div>
    </Modal>
  );
}
