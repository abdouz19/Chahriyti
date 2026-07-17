import React from 'react';
import { Spinner } from '../../../components/ui';
import { KPICard, ActivityChart } from '../../../components/charts';
import { useManagerDashboard } from '../hooks/useManagerDashboard';
import { PERIODS } from '../../../config/constants';
import { chartColors } from '../../../config/theme';

/** SVG icon for the "total clients" KPI. */
function UsersIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path d="M7 8a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm8-2a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM1 18a6 6 0 0 1 12 0H1Zm12.93-1a5 5 0 0 1 6.07 0h-6.07Z" />
    </svg>
  );
}

/** SVG icon for "this month" KPI. */
function CalendarIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path
        fillRule="evenodd"
        d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2ZM4.75 5.5c-.69 0-1.25.56-1.25 1.25V8h13V6.75c0-.69-.56-1.25-1.25-1.25H4.75ZM16.5 9.5h-13v5.75c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25V9.5Z"
        clipRule="evenodd"
      />
    </svg>
  );
}

/** SVG icon for "today" KPI. */
function TodayIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path
        fillRule="evenodd"
        d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm.75-13a.75.75 0 0 0-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 0 0 0-1.5h-3.25V5Z"
        clipRule="evenodd"
      />
    </svg>
  );
}

/** Period option labels for the activity chart selector. */
const PERIOD_OPTIONS = [PERIODS.WEEK, PERIODS.MONTH, PERIODS.QUARTER, PERIODS.YEAR];

/**
 * Manager Dashboard page.
 *
 * Displays three KPI cards (total, this month, today) and a daily activity
 * chart with a period selector.
 */
export function ManagerDashboardPage() {
  const { stats, dailyCounts, loading, selectedPeriod, setPeriod } =
    useManagerDashboard();

  if (loading && !stats) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <Spinner size="lg" />
      </div>
    );
  }

  const { totalClients = 0, monthClients = 0, todayClients = 0, growthPercent = 0 } =
    stats || {};

  return (
    <div className="space-y-6">
      {/* Page header */}
      <div>
        <h1 className="text-xl font-bold text-text-primary">Dashboard</h1>
        <p className="text-sm text-text-secondary mt-1">
          Your client activation overview
        </p>
      </div>

      {/* KPI row */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <KPICard
          icon={<UsersIcon />}
          label="Total Clients"
          value={totalClients}
          accentColor={chartColors.primary}
        />
        <KPICard
          icon={<CalendarIcon />}
          label="This Period"
          value={monthClients}
          trend={
            growthPercent !== 0
              ? { value: growthPercent, isPositive: growthPercent > 0 }
              : undefined
          }
          accentColor={chartColors.secondary}
        />
        <KPICard
          icon={<TodayIcon />}
          label="Today"
          value={todayClients}
          accentColor={chartColors.positive}
        />
      </div>

      {/* Activity chart */}
      <ActivityChart
        data={dailyCounts}
        title="Daily Activations"
        periodOptions={PERIOD_OPTIONS}
        selectedPeriod={selectedPeriod}
        onPeriodChange={setPeriod}
        height={320}
      />
    </div>
  );
}
