import React from 'react';
import { Card } from '../../../components/ui';
import { useGenerateLicense } from '../hooks/useGenerateLicense';
import { LicenseForm } from '../components/LicenseForm';
import { LicenseResult } from '../components/LicenseResult';
import { DuplicateWarning } from '../components/DuplicateWarning';

/**
 * GenerateLicensePage — the main page for the license generation flow.
 *
 * Three visual states:
 *   1. **Form** — user fills in client details
 *   2. **Duplicate warning** — device ID already exists; confirm or cancel
 *   3. **Result** — license key generated successfully
 */
export function GenerateLicensePage() {
  const {
    formData,
    errors,
    loading,
    error,
    result,
    duplicateWarning,
    updateField,
    generate,
    reset,
    confirmDuplicate,
    cancelDuplicate,
  } = useGenerateLicense();

  // Determine whether to show the duplicate warning dialog.
  // We show it when there is a duplicate, no result yet, and the user
  // has just attempted to submit (i.e., the form would be valid).
  const showDuplicate = duplicateWarning && !result;

  return (
    <div className="max-w-lg mx-auto">
      {/* Page header */}
      <div className="mb-6">
        <h1 className="text-xl font-bold text-text-primary">توليد ترخيص</h1>
        <p className="text-sm text-text-secondary mt-1">
          أدخل بيانات العميل لتوليد مفتاح ترخيص جديد
        </p>
      </div>

      <Card variant="elevated">
        {/* ---- State 3: Result ---- */}
        {result ? (
          <LicenseResult
            licenseKey={result.licenseKey}
            expiryDate={result.expiryDate}
            generatedAt={result.generatedAt}
            clientName={formData.clientName}
            phone={formData.phone}
            deviceId={formData.deviceId}
            onReset={reset}
          />
        ) : (
          <>
            {/* ---- General server error ---- */}
            {error && (
              <div className="bg-negative/5 border border-negative/20 rounded-xl px-4 py-3 text-sm text-negative mb-5">
                {error}
              </div>
            )}

            {/* ---- State 2: Duplicate warning ---- */}
            {showDuplicate && (
              <div className="mb-5">
                <DuplicateWarning
                  existingClient={duplicateWarning}
                  onProceed={confirmDuplicate}
                  onCancel={cancelDuplicate}
                />
              </div>
            )}

            {/* ---- State 1: Form ---- */}
            <LicenseForm
              formData={formData}
              errors={errors}
              loading={loading}
              onFieldChange={updateField}
              onSubmit={generate}
            />
          </>
        )}
      </Card>
    </div>
  );
}
