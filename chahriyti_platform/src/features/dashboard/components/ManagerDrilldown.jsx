import React from 'react';
import { Spinner } from '../../../components/ui';
import { KPICard, ActivityChart } from '../../../components/charts';
import { GrowthIndicator } from './GrowthIndicator';
import { chartColors } from '../../../config/theme';
import { PERIODS } from '../../../config/constants';

/** Period labels for the activity chart inside the drill-down. */
const PERIOD_OPTIONS = [PERIODS.WEEK, PERIODS.MONTH, PERIODS.QUARTER, PERIODS.YEAR];

/** SVG icon for total clients. */
function UsersIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path d="M7 8a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm8-2a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM1 18a6 6 0 0 1 12 0H1Zm12.93-1a5 5 0 0 1 6.07 0h-6.07Z" />
    </svg>
  );
}

/** SVG icon for period clients. */
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

/** SVG icon for today. */
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

/**
 * Drill-down panel for a selected manager.
 *
 * Shows the manager's name, their KPI cards, growth indicator, and an
 * activity chart. Includes a back button to return to the aggregate view.
 *
 * @param {Object} props
 * @param {string} props.managerName - Display name of the selected manager
 * @param {{ totalClients: number, monthClients: number, todayClients: number, growthPercent: number } | null} props.stats
 * @param {{ date: string, count: number }[]} props.dailyCounts
 * @param {boolean} props.loading
 * @param {string} props.selectedPeriod
 * @param {(period: string) => void} props.onPeriodChange
 * @param {() => void} props.onBack
 */
export function ManagerDrilldown({
  managerName,
  stats,
  dailyCounts,
  loading,
  selectedPeriod,
  onPeriodChange,
  onBack,
}) {
  return (
    <div className="space-y-5">
      {/* Header with back button */}
      <div className="flex items-center gap-3">
        <button
          onClick={onBack}
          className="w-8 h-8 rounded-lg bg-surface flex items-center justify-center hover:bg-border/40 transition-colors shrink-0"
          aria-label="Back to overview"
        >
          <svg
            viewBox="0 0 20 20"
            fill="currentColor"
            width="16"
            height="16"
            className="text-text-primary"
          >
            <path
              fillRule="evenodd"
              d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z"
              clipRule="evenodd"
            />
          </svg>
        </button>

        <div className="flex-1 min-w-0">
          <h2 className="text-base font-semibold text-text-primary truncate">
            {managerName}
          </h2>
          <p className="text-xs text-text-secondary">Manager stats</p>
        </div>

        {stats && stats.growthPercent !== 0 && (
          <GrowthIndicator value={stats.growthPercent} label="vs prev" />
        )}
      </div>

      {loading ? (
        <div className="flex items-center justify-center py-16">
          <Spinner size="lg" />
        </div>
      ) : (
        <>
          {/* KPI cards */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <KPICard
              icon={<UsersIcon />}
              label="Total Clients"
              value={stats?.totalClients ?? 0}
              accentColor={chartColors.primary}
            />
            <KPICard
              icon={<CalendarIcon />}
              label="This Period"
              value={stats?.monthClients ?? 0}
              accentColor={chartColors.secondary}
            />
            <KPICard
              icon={<TodayIcon />}
              label="Today"
              value={stats?.todayClients ?? 0}
              accentColor={chartColors.positive}
            />
          </div>

          {/* Activity chart */}
          <ActivityChart
            data={dailyCounts}
            title="Daily Activations"
            periodOptions={PERIOD_OPTIONS}
            selectedPeriod={selectedPeriod}
            onPeriodChange={onPeriodChange}
            height={280}
          />
        </>
      )}
    </div>
  );
}
