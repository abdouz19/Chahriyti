import { useState, useEffect, useCallback, useRef } from 'react';
import { getClients } from '../../../services/firestore';
import { useAuth } from '../../../hooks/useAuth';
import { PAGE_SIZE } from '../../../config/constants';

/**
 * Checks whether a Firestore timestamp / Date falls on today's calendar date.
 *
 * @param {object|Date|number} timestamp - Firestore Timestamp, JS Date, or epoch ms.
 * @returns {boolean}
 */
function isToday(timestamp) {
  if (!timestamp) return false;

  let date;
  if (timestamp.toDate && typeof timestamp.toDate === 'function') {
    date = timestamp.toDate();
  } else if (timestamp instanceof Date) {
    date = timestamp;
  } else if (typeof timestamp === 'number') {
    date = new Date(timestamp);
  } else {
    return false;
  }

  const now = new Date();
  return (
    date.getFullYear() === now.getFullYear() &&
    date.getMonth() === now.getMonth() &&
    date.getDate() === now.getDate()
  );
}

/**
 * React hook for managing the client list with search, date filtering,
 * and cursor-based pagination.
 *
 * @returns {{
 *   clients: object[],
 *   loading: boolean,
 *   error: string|null,
 *   searchQuery: string,
 *   setSearchQuery: (q: string) => void,
 *   startDate: string,
 *   endDate: string,
 *   setDateRange: (start: string, end: string) => void,
 *   currentPage: number,
 *   hasMore: boolean,
 *   totalToday: number,
 *   totalAll: number,
 *   loadMore: () => void,
 *   goToPage: (page: number) => void,
 *   totalPages: number,
 * }}
 */
export function useClients() {
  const { user } = useAuth();

  // --- Data state ---
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // --- Filter state ---
  const [searchQuery, setSearchQueryRaw] = useState('');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');

  // --- Pagination state ---
  const [currentPage, setCurrentPage] = useState(1);
  const [hasMore, setHasMore] = useState(false);

  // --- Aggregation state ---
  const [totalToday, setTotalToday] = useState(0);
  const [totalAll, setTotalAll] = useState(0);

  /**
   * Store cursor snapshots per page so the user can navigate back.
   * Key: page number, Value: Firestore document snapshot (lastDoc).
   * Page 1 has no cursor (null).
   */
  const cursorMapRef = useRef(new Map([[1, null]]));

  // Debounce timer ref for search
  const debounceRef = useRef(null);

  /**
   * Core fetch function. Uses the cursor stored for the requested page.
   *
   * @param {object} options
   * @param {number} options.page - 1-indexed page number to fetch.
   * @param {string} options.search - Current search query.
   * @param {string} options.start - Start date ISO string.
   * @param {string} options.end - End date ISO string.
   */
  const fetchClients = useCallback(
    async ({ page, search, start, end }) => {
      if (!user?.uid) return;

      setLoading(true);
      setError(null);

      try {
        const cursor = cursorMapRef.current.get(page) ?? null;

        const result = await getClients({
          managerId: user.uid,
          searchQuery: search || undefined,
          startDate: start ? new Date(`${start}T00:00:00`) : undefined,
          endDate: end ? new Date(`${end}T23:59:59`) : undefined,
          pageSize: PAGE_SIZE,
          lastDoc: cursor,
        });

        setClients(result.clients);
        setHasMore(result.hasMore);

        // Store the cursor for the *next* page so we can navigate forward later.
        if (result.lastDoc) {
          cursorMapRef.current.set(page + 1, result.lastDoc);
        }

        // Count today's clients from the fetched page (approximation for the
        // visible page; a full count would require a separate query or
        // server-side aggregation).
        const todayCount = result.clients.filter((c) =>
          isToday(c.createdAt),
        ).length;
        setTotalToday(todayCount);
        setTotalAll(result.clients.length);

        setCurrentPage(page);
      } catch (err) {
        setError(err.message || 'Failed to load clients.');
      } finally {
        setLoading(false);
      }
    },
    [user?.uid],
  );

  // --- Fetch on mount and when filters change ---
  useEffect(() => {
    // Reset pagination cursors when filters change.
    cursorMapRef.current = new Map([[1, null]]);

    fetchClients({
      page: 1,
      search: searchQuery,
      start: startDate,
      end: endDate,
    });
  }, [searchQuery, startDate, endDate, fetchClients]);

  /**
   * Debounced search setter (300ms).
   *
   * @param {string} query
   */
  const setSearchQuery = useCallback((query) => {
    if (debounceRef.current) clearTimeout(debounceRef.current);

    debounceRef.current = setTimeout(() => {
      setSearchQueryRaw(query);
    }, 300);
  }, []);

  // Cleanup debounce timer on unmount.
  useEffect(() => {
    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
    };
  }, []);

  /**
   * Set the date range filter. Resets pagination to page 1.
   *
   * @param {string} start - ISO date string (YYYY-MM-DD) or empty string.
   * @param {string} end - ISO date string (YYYY-MM-DD) or empty string.
   */
  const setDateRange = useCallback((start, end) => {
    setStartDate(start);
    setEndDate(end);
  }, []);

  /**
   * Load the next page of results (cursor-based forward pagination).
   */
  const loadMore = useCallback(() => {
    if (!hasMore || loading) return;

    const nextPage = currentPage + 1;
    fetchClients({
      page: nextPage,
      search: searchQuery,
      start: startDate,
      end: endDate,
    });
  }, [hasMore, loading, currentPage, searchQuery, startDate, endDate, fetchClients]);

  /**
   * Navigate to a specific page. Only works for pages whose cursors have
   * been cached (i.e., pages already visited or the immediate next page).
   *
   * @param {number} page - 1-indexed target page.
   */
  const goToPage = useCallback(
    (page) => {
      if (page < 1 || page === currentPage || loading) return;

      // We can only navigate to pages whose cursors we have cached.
      if (!cursorMapRef.current.has(page)) return;

      fetchClients({
        page,
        search: searchQuery,
        start: startDate,
        end: endDate,
      });
    },
    [currentPage, loading, searchQuery, startDate, endDate, fetchClients],
  );

  /**
   * Estimate total pages. Since Firestore doesn't give a total count,
   * we use the hasMore flag to determine the minimum known pages.
   */
  const totalPages = hasMore ? currentPage + 1 : currentPage;

  return {
    clients,
    loading,
    error,
    searchQuery,
    setSearchQuery,
    startDate,
    endDate,
    setDateRange,
    currentPage,
    hasMore,
    totalToday,
    totalAll,
    loadMore,
    goToPage,
    totalPages,
  };
}
