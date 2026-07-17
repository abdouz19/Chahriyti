import { useState, useEffect, useRef, useCallback } from 'react';
import { callGenerateLicense } from '../../../services/functions';
import { getClientByDeviceId } from '../../../services/firestore';
import {
  validateName,
  validatePhone,
  validateDeviceId,
} from '../../../utils/validators';

/**
 * Initial form state — all fields blank.
 */
const INITIAL_FORM = {
  clientName: '',
  phone: '',
  deviceId: '',
};

/**
 * useGenerateLicense — manages the full generate-license flow.
 *
 * Exposes:
 *   formData, errors, loading, result, duplicateWarning,
 *   updateField, checkDuplicate, generate, reset,
 *   confirmDuplicate, cancelDuplicate
 */
export function useGenerateLicense() {
  // -----------------------------------------------------------------------
  // State
  // -----------------------------------------------------------------------
  const [formData, setFormData] = useState(INITIAL_FORM);
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [result, setResult] = useState(null);
  const [duplicateWarning, setDuplicateWarning] = useState(null);

  // Track whether the user confirmed the duplicate warning
  const [duplicateConfirmed, setDuplicateConfirmed] = useState(false);

  // Ref for the debounce timer so we can cancel on unmount / re-type
  const debounceRef = useRef(null);

  // -----------------------------------------------------------------------
  // Field updater
  // -----------------------------------------------------------------------
  const updateField = useCallback((field, value) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
    // Clear the field-level error as the user types
    setErrors((prev) => {
      if (!prev[field]) return prev;
      const next = { ...prev };
      delete next[field];
      return next;
    });
    // Clear general error
    setError(null);
  }, []);

  // -----------------------------------------------------------------------
  // Duplicate check — queries Firestore for an existing client with deviceId
  // -----------------------------------------------------------------------
  const checkDuplicate = useCallback(async (deviceId) => {
    if (!deviceId || deviceId.trim().length < 16) {
      setDuplicateWarning(null);
      return;
    }
    try {
      const existing = await getClientByDeviceId(deviceId.trim());
      setDuplicateWarning(existing); // null if not found
    } catch {
      // Silently ignore — the user can still submit
      setDuplicateWarning(null);
    }
  }, []);

  // -----------------------------------------------------------------------
  // Auto-check duplicate when deviceId changes (debounced 500ms)
  // -----------------------------------------------------------------------
  useEffect(() => {
    // Reset duplicate state whenever device ID changes
    setDuplicateConfirmed(false);

    if (debounceRef.current) clearTimeout(debounceRef.current);

    debounceRef.current = setTimeout(() => {
      checkDuplicate(formData.deviceId);
    }, 500);

    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
    };
  }, [formData.deviceId, checkDuplicate]);

  // -----------------------------------------------------------------------
  // Validate all fields — returns true if valid
  // -----------------------------------------------------------------------
  const validate = useCallback(() => {
    const newErrors = {};

    const nameErr = validateName(formData.clientName);
    if (nameErr) newErrors.clientName = nameErr;

    const phoneErr = validatePhone(formData.phone);
    if (phoneErr) newErrors.phone = phoneErr;

    const deviceErr = validateDeviceId(formData.deviceId);
    if (deviceErr) newErrors.deviceId = deviceErr;

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  }, [formData]);

  // -----------------------------------------------------------------------
  // Generate — validate, check duplicate, call Cloud Function
  // -----------------------------------------------------------------------
  const generate = useCallback(async () => {
    setError(null);

    if (!validate()) return;

    // If there is a duplicate and the user has not yet confirmed, stop here
    // so the page can show the DuplicateWarning dialog.
    if (duplicateWarning && !duplicateConfirmed) {
      return;
    }

    setLoading(true);
    try {
      const response = await callGenerateLicense({
        clientName: formData.clientName.trim(),
        phone: formData.phone.trim(),
        deviceId: formData.deviceId.trim(),
      });

      setResult(response.data || response);
    } catch (err) {
      setError(err.message || 'حدث خطأ أثناء توليد الترخيص');
    } finally {
      setLoading(false);
    }
  }, [formData, validate, duplicateWarning, duplicateConfirmed]);

  // -----------------------------------------------------------------------
  // Confirm duplicate — user chose "Continue Anyway"
  // -----------------------------------------------------------------------
  const confirmDuplicate = useCallback(() => {
    setDuplicateConfirmed(true);
  }, []);

  // Automatically trigger generate after confirming duplicate
  useEffect(() => {
    if (duplicateConfirmed && duplicateWarning) {
      generate();
    }
    // Only re-run when duplicateConfirmed flips to true
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [duplicateConfirmed]);

  // -----------------------------------------------------------------------
  // Cancel duplicate — user chose "Cancel"
  // -----------------------------------------------------------------------
  const cancelDuplicate = useCallback(() => {
    setDuplicateWarning(null);
    setDuplicateConfirmed(false);
  }, []);

  // -----------------------------------------------------------------------
  // Reset — clear everything and return to the form state
  // -----------------------------------------------------------------------
  const reset = useCallback(() => {
    setFormData(INITIAL_FORM);
    setErrors({});
    setError(null);
    setResult(null);
    setDuplicateWarning(null);
    setDuplicateConfirmed(false);
  }, []);

  return {
    // State
    formData,
    errors,
    loading,
    error,
    result,
    duplicateWarning,

    // Actions
    updateField,
    checkDuplicate,
    generate,
    reset,
    confirmDuplicate,
    cancelDuplicate,
  };
}
