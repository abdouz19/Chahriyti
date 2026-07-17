import React, { useCallback, useState } from 'react';
import { Button } from '../../../components/ui';
import { formatLicenseKey } from '../../../utils/formatters';
import { callSendToDelivery } from '../../../services/functions';
import { useAuth } from '../../../hooks/useAuth';
import toast from 'react-hot-toast';

/**
 * Animated checkmark circle displayed on successful generation.
 */
function SuccessCheckmark() {
  return (
    <div className="flex items-center justify-center mb-6">
      <div className="relative w-20 h-20">
        {/* Outer pulse ring */}
        <div className="absolute inset-0 rounded-full bg-positive/20 animate-ping" />
        {/* Inner solid circle with checkmark */}
        <div className="relative w-20 h-20 rounded-full bg-positive flex items-center justify-center animate-scale-in">
          <svg
            className="w-10 h-10 text-white animate-draw-check"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            strokeWidth={3}
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M4.5 12.75l6 6 9-13.5"
              style={{
                strokeDasharray: 30,
                strokeDashoffset: 30,
                animation: 'draw-check 0.4s ease-out 0.3s forwards',
              }}
            />
          </svg>
        </div>
      </div>
    </div>
  );
}

/**
 * LicenseResult — success display after generating a license.
 *
 * Shows the license key in large monospace text, expiry date, and
 * provides copy-to-clipboard and "Generate Another" actions.
 *
 * Props:
 *   licenseKey — the generated key string (e.g. "CHRY-ABCD-1234-EF56-7890")
 *   expiryDate — expiry in YYYYMM format
 *   onReset()  — callback to return to the form
 */
export function LicenseResult({ licenseKey, expiryDate, generatedAt, clientName, phone, deviceId, onReset }) {
  const [copied, setCopied] = useState(false);
  const [sending, setSending] = useState(false);
  const [sent, setSent] = useState(false);
  const { user } = useAuth();

  // Format the expiry for display: "202707" -> "07 / 2027"
  const formattedExpiry = expiryDate
    ? `${expiryDate.slice(4, 6)} / ${expiryDate.slice(0, 4)}`
    : '';

  // Copy license key to clipboard
  const handleCopy = useCallback(async () => {
    try {
      await navigator.clipboard.writeText(licenseKey);
      setCopied(true);
      toast.success('تم نسخ مفتاح الترخيص');
      // Reset the copied state after 2 seconds
      setTimeout(() => setCopied(false), 2000);
    } catch {
      toast.error('تعذر النسخ — حاول يدوياً');
    }
  }, [licenseKey]);

  const handleSendToDelivery = useCallback(async () => {
    setSending(true);
    try {
      await callSendToDelivery({
        clientName,
        phone,
        deviceId,
        licenseKey,
        expiryDate,
        managerName: user?.displayName || user?.email || '',
        generatedAt,
      });
      setSent(true);
      toast.success('تم إرسال الترخيص لوكيل التوصيل');
    } catch {
      toast.error('فشل إرسال البريد الإلكتروني');
    } finally {
      setSending(false);
    }
  }, [clientName, phone, deviceId, licenseKey, expiryDate, generatedAt, user]);

  return (
    <div className="text-center">
      {/* Success animation */}
      <SuccessCheckmark />

      {/* Heading */}
      <h3 className="text-lg font-semibold text-text-primary mb-1">
        تم توليد الترخيص بنجاح
      </h3>
      <p className="text-sm text-text-secondary mb-6">
        مفتاح الترخيص جاهز للاستخدام
      </p>

      {/* License key display */}
      <div className="bg-surface border border-border rounded-2xl p-5 mb-4">
        <p className="text-xs text-text-secondary mb-2 font-medium">مفتاح الترخيص</p>
        <p
          className="text-2xl md:text-3xl font-mono font-bold text-primary tracking-wider select-all break-all"
          dir="ltr"
        >
          {formatLicenseKey(licenseKey)}
        </p>
      </div>

      {/* Expiry date */}
      {formattedExpiry && (
        <div className="flex items-center justify-center gap-2 mb-6 text-sm text-text-secondary">
          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5"
            />
          </svg>
          <span>
            تاريخ الانتهاء: <span className="font-medium text-text-primary" dir="ltr">{formattedExpiry}</span>
          </span>
        </div>
      )}

      {/* Action buttons */}
      <div className="flex flex-col sm:flex-row gap-3">
        {/* Copy button */}
        <Button
          variant="primary"
          fullWidth
          onClick={handleCopy}
          icon={
            copied ? (
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
              </svg>
            ) : (
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M15.666 3.888A2.25 2.25 0 0013.5 2.25h-3c-1.03 0-1.9.693-2.166 1.638m7.332 0c.055.194.084.4.084.612v0a.75.75 0 01-.75.75H9.75a.75.75 0 01-.75-.75v0c0-.212.03-.418.084-.612m7.332 0c.646.049 1.288.11 1.927.184 1.1.128 1.907 1.077 1.907 2.185V19.5a2.25 2.25 0 01-2.25 2.25H6.75A2.25 2.25 0 014.5 19.5V6.257c0-1.108.806-2.057 1.907-2.185a48.208 48.208 0 011.927-.184"
                />
              </svg>
            )
          }
        >
          {copied ? 'تم النسخ' : 'نسخ المفتاح'}
        </Button>

        {/* Generate Another */}
        <Button
          variant="secondary"
          fullWidth
          onClick={onReset}
          icon={
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182"
              />
            </svg>
          }
        >
          توليد ترخيص آخر
        </Button>
      </div>

      {/* Send to Delivery button */}
      <div className="mt-3">
        <Button
          variant={sent ? 'secondary' : 'primary'}
          fullWidth
          onClick={handleSendToDelivery}
          loading={sending}
          disabled={sent || sending}
          icon={
            sent ? (
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
              </svg>
            ) : (
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5" />
              </svg>
            )
          }
          className={sent ? '!bg-positive/10 !text-positive !border-positive/20' : '!bg-blue-600 hover:!bg-blue-700'}
        >
          {sent ? 'تم الإرسال للتوصيل' : 'إرسال للتوصيل'}
        </Button>
      </div>

      {/* Inline keyframe styles for the success animation */}
      <style>{`
        @keyframes scale-in {
          from {
            opacity: 0;
            transform: scale(0.5);
          }
          to {
            opacity: 1;
            transform: scale(1);
          }
        }
        @keyframes draw-check {
          to {
            stroke-dashoffset: 0;
          }
        }
        .animate-scale-in {
          animation: scale-in 0.3s ease-out both;
        }
      `}</style>
    </div>
  );
}
