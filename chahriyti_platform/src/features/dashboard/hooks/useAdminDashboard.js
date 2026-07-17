import { useState, useEffect, useCallback } from 'react';
import toast from 'react-hot-toast';
import { callGetDashboardStats } from '../../../services/functions';
import { onGlobalStatsSnapshot } from '../../../services/firestore';
import { PERIODS } from '../../../config/constants';

/**
 * Hook that provides admin dashboard state with drill-down support.
 *
 * Fetches aggregate stats on mount and when the period changes.
 * Subscribes to real-time global stats for live counter updates.
 * Supports drilling into a specific manager's stats.
 *
 * @returns {{
 *   stats: { totalClients: number, monthClients: number, todayClients: number, totalManagers: number, growthPercent: number } | null,
 *   dailyCounts: { date: string, count: number }[],
 *   leaderboard: { managerId: string, name: string, count: number }[],
 *   loading: boolean,
 *   selectedPeriod: string,
 *   drilldownManagerId: string | null,
 *   drilldownStats: object | null,
 *   drilldownDailyCounts: { date: string, count: number }[],
 *   drilldownLoading: boolean,
 *   setPeriod: (period: string) => void,
 *   setDrilldownManager: (managerId: string, managerName?: string) => void,
 *   clearDrilldown: () => void,
 * }}
 */
export function useAdminDashboard() {
  // -----------------------------------------------------------------------
  // Aggregate state
  // -----------------------------------------------------------------------
  const [stats, setStats] = useState(null);
  const [dailyCounts, setDailyCounts] = useState([]);
  const [leaderboard, setLeaderboard] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedPeriod, setSelectedPeriod] = useState(PERIODS.MONTH);

  // -----------------------------------------------------------------------
  // Drill-down state
  // -----------------------------------------------------------------------
  const [drilldownManagerId, setDrilldownManagerId] = useState(null);
  const [drilldownManagerName, setDrilldownManagerName] = useState('');
  const [drilldownStats, setDrilldownStats] = useState(null);
  const [drilldownDailyCounts, setDrilldownDailyCounts] = useState([]);
  const [drilldownLoading, setDrilldownLoading] = useState(false);

  // -----------------------------------------------------------------------
  // Fetch aggregate stats
  // -----------------------------------------------------------------------
  const fetchAggregateStats = useCallback(async (period) => {
    try {
      setLoading(true);
      const result = await callGetDashboardStats({ period });
      if (result?.success && result.data) {
        setStats({
          totalClients: result.data.totalClients ?? 0,
          monthClients: result.data.monthClients ?? 0,
          todayClients: result.data.todayClients ?? 0,
          totalManagers: result.data.totalManagers ?? 0,
          growthPercent: result.data.growthPercent ?? 0,
        });
        setDailyCounts(result.data.dailyCounts ?? []);
        setLeaderboard(result.data.managerLeaderboard ?? []);
      }
    } catch (err) {
      toast.error('Failed to load dashboard stats.');
      console.error('useAdminDashboard fetch error:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchAggregateStats(selectedPeriod);
  }, [selectedPeriod, fetchAggregateStats]);

  // -----------------------------------------------------------------------
  // Real-time listener for live global counter updates
  // -----------------------------------------------------------------------
  useEffect(() => {
    const unsubscribe = onGlobalStatsSnapshot((liveData) => {
      if (!liveData) return;

      setStats((prev) => {
        if (!prev) return prev;
        return {
          ...prev,
          totalClients: liveData.totalLicenses ?? prev.totalClients,
          totalManagers: liveData.totalManagers ?? prev.totalManagers,
        };
      });
    });

    return unsubscribe;
  }, []);

  // -----------------------------------------------------------------------
  // Drill-down: fetch a specific manager's stats
  // -----------------------------------------------------------------------
  const fetchDrilldownStats = useCallback(
    async (managerId, period) => {
      try {
        setDrilldownLoading(true);
        const result = await callGetDashboardStats({
          period,
          managerId,
        });
        if (result?.success && result.data) {
          setDrilldownStats({
            totalClients: result.data.totalClients ?? 0,
            monthClients: result.data.monthClients ?? 0,
            todayClients: result.data.todayClients ?? 0,
            growthPercent: result.data.growthPercent ?? 0,
          });
          setDrilldownDailyCounts(result.data.dailyCounts ?? []);
        }
      } catch (err) {
        toast.error('Failed to load manager stats.');
        console.error('useAdminDashboard drilldown error:', err);
      } finally {
        setDrilldownLoading(false);
      }
    },
    [],
  );

  // Refetch drill-down when period changes while a manager is selected
  useEffect(() => {
    if (drilldownManagerId) {
      fetchDrilldownStats(drilldownManagerId, selectedPeriod);
    }
  }, [drilldownManagerId, selectedPeriod, fetchDrilldownStats]);

  // -----------------------------------------------------------------------
  // Actions
  // -----------------------------------------------------------------------
  const setPeriod = useCallback((period) => {
    setSelectedPeriod(period);
  }, []);

  const setDrilldownManager = useCallback((managerId, managerName = '') => {
    setDrilldownManagerId(managerId);
    setDrilldownManagerName(managerName);
    setDrilldownStats(null);
    setDrilldownDailyCounts([]);
  }, []);

  const clearDrilldown = useCallback(() => {
    setDrilldownManagerId(null);
    setDrilldownManagerName('');
    setDrilldownStats(null);
    setDrilldownDailyCounts([]);
  }, []);

  return {
    stats,
    dailyCounts,
    leaderboard,
    loading,
    selectedPeriod,
    drilldownManagerId,
    drilldownManagerName,
    drilldownStats,
    drilldownDailyCounts,
    drilldownLoading,
    setPeriod,
    setDrilldownManager,
    clearDrilldown,
  };
}
