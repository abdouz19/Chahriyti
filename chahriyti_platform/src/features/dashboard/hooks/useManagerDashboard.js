import { useState, useEffect, useCallback } from 'react';
import toast from 'react-hot-toast';
import { useAuth } from '../../../hooks/useAuth';
import { callGetDashboardStats } from '../../../services/functions';
import { onManagerStatsSnapshot } from '../../../services/firestore';
import { PERIODS } from '../../../config/constants';

/**
 * Hook that provides manager dashboard state.
 *
 * Fetches stats via the Cloud Function on mount and when the period changes,
 * and subscribes to real-time updates on the manager's stats document.
 *
 * @returns {{
 *   stats: { totalClients: number, monthClients: number, todayClients: number, growthPercent: number } | null,
 *   dailyCounts: { date: string, count: number }[],
 *   loading: boolean,
 *   selectedPeriod: string,
 *   setPeriod: (period: string) => void,
 * }}
 */
export function useManagerDashboard() {
  const { user } = useAuth();

  const [stats, setStats] = useState(null);
  const [dailyCounts, setDailyCounts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedPeriod, setSelectedPeriod] = useState(PERIODS.MONTH);

  // -----------------------------------------------------------------------
  // Fetch stats from Cloud Function
  // -----------------------------------------------------------------------
  const fetchStats = useCallback(
    async (period) => {
      try {
        setLoading(true);
        const result = await callGetDashboardStats({ period });
        if (result?.success && result.data) {
          setStats({
            totalClients: result.data.totalClients ?? 0,
            monthClients: result.data.monthClients ?? 0,
            todayClients: result.data.todayClients ?? 0,
            growthPercent: result.data.growthPercent ?? 0,
          });
          setDailyCounts(result.data.dailyCounts ?? []);
        }
      } catch (err) {
        toast.error('Failed to load dashboard stats.');
        console.error('useManagerDashboard fetch error:', err);
      } finally {
        setLoading(false);
      }
    },
    [],
  );

  // Fetch on mount and when period changes
  useEffect(() => {
    fetchStats(selectedPeriod);
  }, [selectedPeriod, fetchStats]);

  // -----------------------------------------------------------------------
  // Real-time listener for live counter updates
  // -----------------------------------------------------------------------
  useEffect(() => {
    if (!user?.uid) return;

    const unsubscribe = onManagerStatsSnapshot(user.uid, (liveData) => {
      if (!liveData) return;

      // Merge live total into existing stats without a full refetch
      setStats((prev) => {
        if (!prev) return prev;
        return {
          ...prev,
          totalClients: liveData.totalLicenses ?? prev.totalClients,
        };
      });
    });

    return unsubscribe;
  }, [user?.uid]);

  // -----------------------------------------------------------------------
  // Period setter
  // -----------------------------------------------------------------------
  const setPeriod = useCallback((period) => {
    setSelectedPeriod(period);
  }, []);

  return {
    stats,
    dailyCounts,
    loading,
    selectedPeriod,
    setPeriod,
  };
}
