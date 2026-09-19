import { useState, useEffect, useCallback } from 'react';
import toast from 'react-hot-toast';
import { callGetDashboardStats } from '../../../services/functions';
import { PERIODS } from '../../../config/constants';

/**
 * Hook for admin dashboard — aggregate stats and daily activation counts.
 */
export function useAdminDashboard() {
  const [stats, setStats] = useState(null);
  const [dailyCounts, setDailyCounts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedPeriod, setSelectedPeriod] = useState(PERIODS.MONTH);

  const fetchStats = useCallback(async (period) => {
    try {
      setLoading(true);
      const result = await callGetDashboardStats({ period });
      if (result?.success && result.data) {
        setStats({
          monthClients: result.data.monthClients ?? 0,
          todayClients: result.data.todayClients ?? 0,
          growthPercent: result.data.growthPercent ?? 0,
        });
        setDailyCounts(result.data.dailyCounts ?? []);
      }
    } catch (err) {
      toast.error('فشل في تحميل إحصائيات لوحة التحكم');
      console.error('useAdminDashboard fetch error:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchStats(selectedPeriod);
  }, [selectedPeriod, fetchStats]);

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
