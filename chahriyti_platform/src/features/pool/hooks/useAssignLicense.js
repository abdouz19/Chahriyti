import { useState, useCallback } from 'react';
import { callAssignLicense } from '../../../services/functions';

/**
 * Hook for assigning a pool license to a client (pre-delivery).
 */
export function useAssignLicense() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const assign = useCallback(async ({ licenseKey, clientName, phone }) => {
    setLoading(true);
    setError(null);
    try {
      await callAssignLicense({ licenseKey, clientName, phone });
      return true;
    } catch (err) {
      setError(err.message);
      return false;
    } finally {
      setLoading(false);
    }
  }, []);

  return { loading, error, assign };
}
