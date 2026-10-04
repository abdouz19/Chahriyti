import { useState, useCallback } from 'react';
import { getLeads } from '../../../services/firestore';

export function useLeads() {
  const [leads, setLeads] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [hasMore, setHasMore] = useState(false);
  const [lastDoc, setLastDoc] = useState(null);
  const [statusFilter, setStatusFilter] = useState('');

  const load = useCallback(async ({ reset = true } = {}) => {
    setLoading(true);
    setError(null);
    try {
      const cursor = reset ? null : lastDoc;
      const result = await getLeads({ lastDoc: cursor, status: statusFilter || undefined });
      setLeads((prev) => (reset ? result.docs : [...prev, ...result.docs]));
      setHasMore(result.hasMore);
      setLastDoc(result.lastDoc);
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  }, [lastDoc, statusFilter]);

  const refresh = useCallback(() => load({ reset: true }), [load]);
  const loadMore = useCallback(() => load({ reset: false }), [load]);

  return { leads, loading, error, hasMore, statusFilter, setStatusFilter, refresh, loadMore };
}
