import { useState, useCallback } from 'react';
import { callGenerateLicenseBatch } from '../../../services/functions';

/**
 * Hook for batch license generation (admin only).
 */
export function useBatchGenerate() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [result, setResult] = useState(null);
  const [progress, setProgress] = useState({ current: 0, total: 0 });

  /**
   * Generate licenses in batches of 1000.
   * @param {number} totalCount — total number to generate (e.g. 10000)
   */
  const generateBatch = useCallback(async (totalCount) => {
    setLoading(true);
    setError(null);
    setResult(null);
    setProgress({ current: 0, total: totalCount });

    const batchSize = 1000;
    let generated = 0;
    const batchIds = [];

    try {
      const batches = Math.ceil(totalCount / batchSize);

      for (let i = 0; i < batches; i++) {
        const count = Math.min(batchSize, totalCount - generated);
        const res = await callGenerateLicenseBatch({ count });
        generated += res.count;
        batchIds.push(res.batchId);
        setProgress({ current: generated, total: totalCount });
      }

      setResult({ totalGenerated: generated, batchIds });
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, []);

  const reset = useCallback(() => {
    setResult(null);
    setError(null);
    setProgress({ current: 0, total: 0 });
  }, []);

  return {
    loading,
    error,
    result,
    progress,
    generateBatch,
    reset,
  };
}
