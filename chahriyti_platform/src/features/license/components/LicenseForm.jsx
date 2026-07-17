import React, { useCallback } from 'react';
import { Button, Input } from '../../../components/ui';
import toast from 'react-hot-toast';

/**
 * Clipboard (paste) icon — small inline SVG.
 */
function ClipboardIcon() {
  return (
    <svg
      className="w-4 h-4"
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      strokeWidth={1.5}
    >
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M15.666 3.888A2.25 2.25 0 0013.5 2.25h-3c-1.03 0-1.9.693-2.166 1.638m7.332 0c.055.194.084.4.084.612v0a.75.75 0 01-.75.75H9.75a.75.75 0 01-.75-.75v0c0-.212.03-.418.084-.612m7.332 0c.646.049 1.288.11 1.927.184 1.1.128 1.907 1.077 1.907 2.185V19.5a2.25 2.25 0 01-2.25 2.25H6.75A2.25 2.25 0 014.5 19.5V6.257c0-1.108.806-2.057 1.907-2.185a48.208 48.208 0 011.927-.184"
      />
    </svg>
  );
}

/**
 * LicenseForm — three-field form for generating a client license.
 *
 * Props:
 *   formData     — { clientName, phone, deviceId }
 *   errors       — field-level validation errors keyed by field name
 *   loading      — disables the form while the request is in flight
 *   onFieldChange(field, value) — called when any input changes
 *   onSubmit()   — called when the form is submitted
 */
export function LicenseForm({ formData, errors, loading, onFieldChange, onSubmit }) {
  // Handle form submission
  const handleSubmit = useCallback(
    (e) => {
      e.preventDefault();
      onSubmit();
    },
    [onSubmit],
  );

  // Paste device ID from clipboard
  const handlePaste = useCallback(async () => {
    try {
      const text = await navigator.clipboard.readText();
      if (text && text.trim()) {
        onFieldChange('deviceId', text.trim());
        toast.success('تم اللصق بنجاح');
      }
    } catch {
      toast.error('تعذر الوصول إلى الحافظة');
    }
  }, [onFieldChange]);

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      {/* Client name */}
      <Input
        label="اسم العميل"
        placeholder="أدخل اسم العميل"
        value={formData.clientName}
        onChange={(e) => onFieldChange('clientName', e.target.value)}
        error={errors.clientName}
        disabled={loading}
        icon={
          <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"
            />
          </svg>
        }
      />

      {/* Phone number */}
      <Input
        label="رقم الهاتف"
        placeholder="0555123456"
        value={formData.phone}
        onChange={(e) => onFieldChange('phone', e.target.value)}
        error={errors.phone}
        disabled={loading}
        type="tel"
        icon={
          <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M10.5 1.5H8.25A2.25 2.25 0 006 3.75v16.5a2.25 2.25 0 002.25 2.25h7.5A2.25 2.25 0 0018 20.25V3.75a2.25 2.25 0 00-2.25-2.25H13.5m-3 0V3h3V1.5m-3 0h3m-3 18.75h3"
            />
          </svg>
        }
      />

      {/* Device ID with paste button */}
      <div>
        <div className="flex items-end gap-2">
          <div className="flex-1">
            <Input
              label="رقم الجهاز"
              placeholder="أدخل أو الصق رقم الجهاز"
              value={formData.deviceId}
              onChange={(e) => onFieldChange('deviceId', e.target.value)}
              error={errors.deviceId}
              disabled={loading}
              className="font-mono"
              icon={
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M9 17.25v1.007a3 3 0 01-.879 2.122L7.5 21h9l-.621-.621A3 3 0 0115 18.257V17.25m6-12V15a2.25 2.25 0 01-2.25 2.25H5.25A2.25 2.25 0 013 15V5.25A2.25 2.25 0 015.25 3h13.5A2.25 2.25 0 0121 5.25z"
                  />
                </svg>
              }
            />
          </div>
          <button
            type="button"
            onClick={handlePaste}
            disabled={loading}
            className="flex items-center gap-1.5 px-3 py-2.5 rounded-xl border border-border
                       text-sm font-medium text-text-secondary
                       hover:bg-surface hover:text-primary transition-colors duration-200
                       disabled:opacity-50 disabled:cursor-not-allowed
                       focus:outline-none focus:ring-2 focus:ring-primary/20 mb-[2px]"
            title="لصق من الحافظة"
          >
            <ClipboardIcon />
            <span>لصق</span>
          </button>
        </div>
      </div>

      {/* Submit button */}
      <Button
        type="submit"
        variant="primary"
        fullWidth
        loading={loading}
        size="lg"
        icon={
          !loading && (
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M15.75 5.25a3 3 0 013 3m3 0a6 6 0 01-7.029 5.912c-.563-.097-1.159.026-1.563.43L10.5 17.25H8.25v2.25H6v2.25H2.25v-2.818c0-.597.237-1.17.659-1.591l6.499-6.499c.404-.404.527-1 .43-1.563A6 6 0 1121.75 8.25z"
              />
            </svg>
          )
        }
      >
        توليد الترخيص
      </Button>
    </form>
  );
}
