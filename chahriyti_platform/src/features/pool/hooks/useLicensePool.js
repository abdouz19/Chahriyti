import { useState, useEffect, useCallback } from 'react';
import { getLicenses, searchLicensesByDevice, onPoolStatsSnapshot } from '../../../services/firestore';

/**
 * Hook for managing the license pool list with filtering and pagination.
 * All filters run in Firestore, so they cover the whole pool, not just the loaded page.
 */
export function useLicensePool() {
  const [licenses, setLicenses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [statusFilter, setStatusFilter] = useState(''); // '' = all
  const [printedFilter, setPrintedFilter] = useState(''); // '' | 'printed' | 'unprinted'
  const [deviceSearch, setDeviceSearch] = useState('');
  const [deviceQuery, setDeviceQuery] = useState('');
  const [lastDoc, setLastDoc] = useState(null);
  const [hasMore, setHasMore] = useState(false);
  const [poolStats, setPoolStats] = useState(null);

  // Real-time pool stats
  useEffect(() => {
    const unsub = onPoolStatsSnapshot(setPoolStats);
    return unsub;
  }, []);

  // Search once typing pauses; device IDs are stored uppercase
  useEffect(() => {
    const t = setTimeout(() => setDeviceQuery(deviceSearch.trim().toUpperCase()), 350);
    return () => clearTimeout(t);
  }, [deviceSearch]);

  const fetchLicenses = useCallback(async (resetPagination = true) => {
    setLoading(true);
    setError(null);
    try {
      // Device search: one prefix query, other filters applied locally
      if (deviceQuery) {
        const found = await searchLicensesByDevice(deviceQuery);
        setLicenses(found.filter((l) =>
          (!statusFilter || l.status === statusFilter) &&
          (printedFilter !== 'printed' || l.printed) &&
          (printedFilter !== 'unprinted' || !l.printed)
        ));
        setLastDoc(null);
        setHasMore(false);
        return;
      }

      const result = await getLicenses({
        pageSize: 50,
        status: statusFilter || undefined,
        printed: printedFilter || undefined,
        lastDoc: resetPagination ? null : lastDoc,
      });

      setLicenses((prev) => (resetPagination ? result.licenses : [...prev, ...result.licenses]));
      setLastDoc(result.lastDoc);
      setHasMore(result.hasMore);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, [statusFilter, printedFilter, deviceQuery, lastDoc]);

  // Refetch from the top whenever a filter changes
  useEffect(() => {
    fetchLicenses(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [statusFilter, printedFilter, deviceQuery]);

  const loadMore = useCallback(() => {
    if (hasMore && !loading) {
      fetchLicenses(false);
    }
  }, [hasMore, loading, fetchLicenses]);

  const refresh = useCallback(() => fetchLicenses(true), [fetchLicenses]);

  const hasFilters = !!(statusFilter || printedFilter || deviceQuery);

  return {
    licenses,
    loading,
    error,
    statusFilter,
    setStatusFilter,
    printedFilter,
    setPrintedFilter,
    deviceSearch,
    setDeviceSearch,
    hasFilters,
    hasMore,
    loadMore,
    refresh,
    poolStats,
  };
}
