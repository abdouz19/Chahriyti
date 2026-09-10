import { useState, useEffect, useCallback } from 'react';
import { getLicenses, onPoolStatsSnapshot } from '../../../services/firestore';

/**
 * Hook for managing the license pool list with filtering and pagination.
 */
export function useLicensePool() {
  const [licenses, setLicenses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [statusFilter, setStatusFilter] = useState(''); // '' = all
  const [lastDoc, setLastDoc] = useState(null);
  const [hasMore, setHasMore] = useState(false);
  const [poolStats, setPoolStats] = useState(null);

  // Real-time pool stats
  useEffect(() => {
    const unsub = onPoolStatsSnapshot(setPoolStats);
    return unsub;
  }, []);

  // Fetch licenses
  const fetchLicenses = useCallback(async (resetPagination = true) => {
    setLoading(true);
    setError(null);
    try {
      const opts = { pageSize: 50 };
      if (statusFilter) opts.status = statusFilter;
      if (!resetPagination && lastDoc) opts.lastDoc = lastDoc;

      const result = await getLicenses(opts);

      if (resetPagination) {
        setLicenses(result.licenses);
      } else {
        setLicenses((prev) => [...prev, ...result.licenses]);
      }
      setLastDoc(result.lastDoc);
      setHasMore(result.hasMore);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, [statusFilter, lastDoc]);

  // Refetch when filter changes
  useEffect(() => {
    fetchLicenses(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [statusFilter]);

  const loadMore = useCallback(() => {
    if (hasMore && !loading) {
      fetchLicenses(false);
    }
  }, [hasMore, loading, fetchLicenses]);

  const refresh = useCallback(() => {
    setLastDoc(null);
    fetchLicenses(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [statusFilter]);

  return {
    licenses,
    loading,
    error,
    statusFilter,
    setStatusFilter,
    hasMore,
    loadMore,
    refresh,
    poolStats,
  };
}
