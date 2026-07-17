import React from 'react';
import { Button } from '../../../components/ui';
import { formatDate } from '../../../utils/formatters';

/**
 * Warning triangle icon.
 */
function WarningIcon() {
  return (
    <svg
      className="w-6 h-6 text-warning"
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      strokeWidth={1.5}
    >
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"
      />
    </svg>
  );
}

/**
 * DuplicateWarning — displayed when the entered device ID already belongs
 * to an existing client in the system.
 *
 * Props:
 *   existingClient — { clientName, phone, generatedAt, licenseKey, ... }
 *   onProceed()    — user chose to generate a new license anyway
 *   onCancel()     — user chose to go back and change the device ID
 */
export function DuplicateWarning({ existingClient, onProceed, onCancel }) {
  if (!existingClient) return null;

  return (
    <div className="bg-warning/5 border border-warning/30 rounded-2xl p-5">
      {/* Header */}
      <div className="flex items-start gap-3 mb-4">
        <div className="shrink-0 mt-0.5">
          <WarningIcon />
        </div>
        <div>
          <h4 className="text-base font-semibold text-text-primary">
            هذا الجهاز مسجل مسبقاً
          </h4>
          <p className="text-sm text-text-secondary mt-0.5">
            رقم الجهاز مرتبط بعميل موجود في النظام
          </p>
        </div>
      </div>

      {/* Existing client details */}
      <div className="bg-white/60 rounded-xl p-4 mb-4 space-y-2">
        {/* Client name */}
        <div className="flex items-center justify-between text-sm">
          <span className="text-text-secondary">اسم العميل</span>
          <span className="font-medium text-text-primary">
            {existingClient.clientName || existingClient.name || '—'}
          </span>
        </div>

        {/* Phone */}
        <div className="flex items-center justify-between text-sm">
          <span className="text-text-secondary">رقم الهاتف</span>
          <span className="font-medium text-text-primary" dir="ltr">
            {existingClient.phone || '—'}
          </span>
        </div>

        {/* Previous license date */}
        <div className="flex items-center justify-between text-sm">
          <span className="text-text-secondary">تاريخ الترخيص السابق</span>
          <span className="font-medium text-text-primary" dir="ltr">
            {formatDate(existingClient.generatedAt || existingClient.createdAt) || '—'}
          </span>
        </div>
      </div>

      {/* Action buttons */}
      <div className="flex gap-3">
        <Button
          variant="primary"
          onClick={onProceed}
          className="flex-1"
        >
          المتابعة على أي حال
        </Button>
        <Button
          variant="secondary"
          onClick={onCancel}
          className="flex-1"
        >
          إلغاء
        </Button>
      </div>
    </div>
  );
}
