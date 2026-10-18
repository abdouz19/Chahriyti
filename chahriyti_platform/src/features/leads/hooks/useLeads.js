import { useState, useCallback } from 'react';
import { getLeads, searchLeadsByPhone } from '../../../services/firestore';

// range: { from, to } submittedAt bounds from the period filter (either may be null)
export function useLeads(range) {
  const [leads, setLeads] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [hasMore, setHasMore] = useState(false);
  const [lastDoc, setLastDoc] = useState(null);
  const [statusFilter, setStatusFilter] = useState('pending');
  const [phoneQuery, setPhoneQuery] = useState('');

  const load = useCallback(async ({ reset = true } = {}) => {
    setLoading(true);
    setError(null);
    try {
      // Phone search: one prefix query, status filter applied locally
      if (phoneQuery) {
        const found = await searchLeadsByPhone(phoneQuery);
        const time = (l) => (l.submittedAt?.toDate ? l.submittedAt.toDate() : null);
        setLeads(found.filter((l) =>
          (!statusFilter || (l.status ?? 'pending') === statusFilter) &&
          (!range.from || (time(l) && time(l) >= range.from)) &&
          (!range.to || (time(l) && time(l) < range.to))
        ));
        setHasMore(false);
        setLastDoc(null);
        return;
      }
      const cursor = reset ? null : lastDoc;
      const result = await getLeads({ lastDoc: cursor, status: statusFilter || undefined, from: range.from, to: range.to });
      setLeads((prev) => (reset ? result.docs : [...prev, ...result.docs]));
      setHasMore(result.hasMore);
      setLastDoc(result.lastDoc);
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  }, [lastDoc, statusFilter, phoneQuery, range]);

  const refresh = useCallback(() => load({ reset: true }), [load]);
  const loadMore = useCallback(() => load({ reset: false }), [load]);

  return {
    leads, loading, error, hasMore,
    statusFilter, setStatusFilter,
    phoneQuery, setPhoneQuery,
    refresh, loadMore,
  };
}
