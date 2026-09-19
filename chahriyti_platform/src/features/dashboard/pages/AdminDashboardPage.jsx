import { useEffect, useState } from 'react';
import { Spinner } from '../../../components/ui';
import { KPICard, TrendChart } from '../../../components/charts';
import { GrowthIndicator } from '../components/GrowthIndicator';
import { useAdminDashboard } from '../hooks/useAdminDashboard';
import { onPoolStatsSnapshot } from '../../../services/firestore';
import { chartColors } from '../../../config/theme';
import { PERIODS } from '../../../config/constants';

const PERIOD_OPTIONS = [PERIODS.WEEK, PERIODS.MONTH, PERIODS.QUARTER, PERIODS.YEAR];

function KeyIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path fillRule="evenodd" d="M8 7a5 5 0 1 1 3.61 4.804l-1.903 1.903A1 1 0 0 1 9 14H8v1a1 1 0 0 1-1 1H6v1a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1v-1.586a1 1 0 0 1 .293-.707l5.902-5.903A5.002 5.002 0 0 1 8 7Zm5-3a.75.75 0 0 0 0 1.5A1.5 1.5 0 0 1 14.5 7 .75.75 0 0 0 16 7a3 3 0 0 0-3-3Z" clipRule="evenodd" />
    </svg>
  );
}

function CheckIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path fillRule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm3.857-9.809a.75.75 0 0 0-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 1 0-1.06 1.061l2.5 2.5a.75.75 0 0 0 1.137-.089l4-5.5Z" clipRule="evenodd" />
    </svg>
  );
}

function TodayIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path fillRule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm.75-13a.75.75 0 0 0-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 0 0 0-1.5h-3.25V5Z" clipRule="evenodd" />
    </svg>
  );
}

function PrintIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path fillRule="evenodd" d="M5 2.75C5 1.784 5.784 1 6.75 1h6.5c.966 0 1.75.784 1.75 1.75v3.552c.377.338.75.753.75 1.25v4.698a2.25 2.25 0 0 1-2.25 2.25H15v1.75c0 .966-.784 1.75-1.75 1.75h-6.5A1.75 1.75 0 0 1 5 15.25V14.5h-.5A2.25 2.25 0 0 1 2.25 12.25V8.552c0-.497.373-.912.75-1.25V2.75ZM6.5 4h7V2.75a.25.25 0 0 0-.25-.25h-6.5a.25.25 0 0 0-.25.25V4Zm-1 10.75c0 .138.112.25.25.25h8.5a.25.25 0 0 0 .25-.25v-3.5a.25.25 0 0 0-.25-.25h-8.5a.25.25 0 0 0-.25.25v3.5Z" clipRule="evenodd" />
    </svg>
  );
}

function StackIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path d="M1 12.5A4.5 4.5 0 0 0 5.5 17H15a4 4 0 0 0 1.866-7.539 3.504 3.504 0 0 0-4.504-4.272A4.5 4.5 0 0 0 4.06 8.235 4.502 4.502 0 0 0 1 12.5Z" />
    </svg>
  );
}

/**
 * Admin dashboard — license pool KPIs and activation trends
 */
export function AdminDashboardPage() {
  const {
    stats,
    dailyCounts,
    loading,
    selectedPeriod,
    setPeriod,
  } = useAdminDashboard();

  const [poolStats, setPoolStats] = useState(null);

  useEffect(() => {
    const unsub = onPoolStatsSnapshot(setPoolStats);
    return unsub;
  }, []);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <Spinner size="lg" />
      </div>
    );
  }

  const totalLicenses = poolStats?.totalLicenses ?? 0;
  const availableLicenses = poolStats?.availableLicenses ?? 0;
  const usedLicenses = totalLicenses - availableLicenses;

  return (
    <div className="space-y-6">
      {/* Pool overview KPIs */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
        <KPICard
          icon={<StackIcon />}
          label="إجمالي التراخيص"
          value={totalLicenses}
          accentColor={chartColors.primary}
        />
        <KPICard
          icon={<KeyIcon />}
          label="متاحة"
          value={availableLicenses}
          accentColor={chartColors.positive}
        />
        <KPICard
          icon={<CheckIcon />}
          label="مفعّلة"
          value={usedLicenses}
          accentColor={chartColors.warning}
          trend={stats?.growthPercent ? { value: stats.growthPercent, isPositive: stats.growthPercent > 0 } : undefined}
        />
        <KPICard
          icon={<TodayIcon />}
          label="تفعيلات اليوم"
          value={stats?.todayClients ?? 0}
          accentColor={chartColors.secondary}
        />
        <KPICard
          icon={<PrintIcon />}
          label="تفعيلات الشهر"
          value={stats?.monthClients ?? 0}
          accentColor="#8b5cf6"
        />
      </div>

      {/* Growth indicator */}
      {stats?.growthPercent !== undefined && stats.growthPercent !== 0 && (
        <GrowthIndicator value={stats.growthPercent} label="مقارنة بالفترة السابقة" />
      )}

      {/* Activation trend chart */}
      <div className="card">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-sm font-semibold text-text-primary">اتجاه التفعيلات</h3>
          <div className="flex gap-1">
            {PERIOD_OPTIONS.map((p) => (
              <button
                key={p}
                onClick={() => setPeriod(p)}
                className={`px-3 py-1 rounded-lg text-xs font-medium transition-colors
                  ${selectedPeriod === p
                    ? 'bg-primary text-white'
                    : 'bg-surface text-text-secondary hover:text-text-primary'
                  }`}
              >
                {p === PERIODS.WEEK ? '7 أيام' : p === PERIODS.MONTH ? '30 يوم' : p === PERIODS.QUARTER ? '90 يوم' : 'سنة'}
              </button>
            ))}
          </div>
        </div>
        <TrendChart
          data={dailyCounts}
          color={chartColors.primary}
          type="bar"
          height={320}
        />
      </div>
    </div>
  );
}
