import { Spinner } from '../../../components/ui';
import { KPICard, TrendChart } from '../../../components/charts';
import { ManagerLeaderboard } from '../components/ManagerLeaderboard';
import { GrowthIndicator } from '../components/GrowthIndicator';
import { ManagerDrilldown } from '../components/ManagerDrilldown';
import { useAdminDashboard } from '../hooks/useAdminDashboard';
import { chartColors } from '../../../config/theme';
import { PERIODS } from '../../../config/constants';

const PERIOD_OPTIONS = [PERIODS.WEEK, PERIODS.MONTH, PERIODS.QUARTER, PERIODS.YEAR];

/** Icon: total clients */
function UsersIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path d="M7 8a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm8-2a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM1 18a6 6 0 0 1 12 0H1Zm12.93-1a5 5 0 0 1 6.07 0h-6.07Z" />
    </svg>
  );
}

/** Icon: calendar / this month */
function CalendarIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path fillRule="evenodd" d="M5.75 2a.75.75 0 0 1 .75.75V4h7V2.75a.75.75 0 0 1 1.5 0V4h.25A2.75 2.75 0 0 1 18 6.75v8.5A2.75 2.75 0 0 1 15.25 18H4.75A2.75 2.75 0 0 1 2 15.25v-8.5A2.75 2.75 0 0 1 4.75 4H5V2.75A.75.75 0 0 1 5.75 2ZM4.75 5.5c-.69 0-1.25.56-1.25 1.25V8h13V6.75c0-.69-.56-1.25-1.25-1.25H4.75ZM16.5 9.5h-13v5.75c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25V9.5Z" clipRule="evenodd" />
    </svg>
  );
}

/** Icon: today */
function TodayIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path fillRule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm.75-13a.75.75 0 0 0-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 0 0 0-1.5h-3.25V5Z" clipRule="evenodd" />
    </svg>
  );
}

/** Icon: managers */
function TeamIcon() {
  return (
    <svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
      <path d="M10 9a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM6 8a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm-4.51 7.326a.78.78 0 0 1-.358-.442 3 3 0 0 1 4.308-3.516 6.484 6.484 0 0 0-1.905 3.959c-.023.222-.014.442.025.654a4.97 4.97 0 0 1-2.07-.655ZM18 8a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm-2.44 7.326c.507-.2.96-.496 1.345-.87a.78.78 0 0 0 .358-.442 3 3 0 0 0-4.308-3.516 6.484 6.484 0 0 1 1.905 3.959c.023.222.014.442-.025.654a4.97 4.97 0 0 0 2.07-.655v-.13ZM10 11a6 6 0 0 0-5.996 5.775l-.003.124A.78.78 0 0 0 4.36 17.5c1.69.889 3.61 1.5 5.64 1.5s3.95-.611 5.64-1.5a.78.78 0 0 0 .36-.601 6 6 0 0 0-6-5.899Z" />
    </svg>
  );
}

/**
 * Admin dashboard page — aggregate KPIs, trend chart, manager leaderboard, drill-down
 */
export function AdminDashboardPage() {
  const {
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
  } = useAdminDashboard();

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <Spinner size="lg" />
      </div>
    );
  }

  // Drill-down view for selected manager
  if (drilldownManagerId) {
    return (
      <ManagerDrilldown
        managerName={drilldownManagerName}
        stats={drilldownStats}
        dailyCounts={drilldownDailyCounts}
        loading={drilldownLoading}
        selectedPeriod={selectedPeriod}
        onPeriodChange={setPeriod}
        onBack={clearDrilldown}
      />
    );
  }

  return (
    <div className="space-y-6">
      {/* KPI cards row */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <KPICard
          icon={<UsersIcon />}
          label="إجمالي العملاء"
          value={stats?.totalClients ?? 0}
          accentColor={chartColors.primary}
          trend={stats?.growthPercent ? { value: stats.growthPercent, isPositive: stats.growthPercent > 0 } : undefined}
        />
        <KPICard
          icon={<CalendarIcon />}
          label="هذا الشهر"
          value={stats?.monthClients ?? 0}
          accentColor={chartColors.secondary}
        />
        <KPICard
          icon={<TodayIcon />}
          label="اليوم"
          value={stats?.todayClients ?? 0}
          accentColor={chartColors.positive}
        />
        <KPICard
          icon={<TeamIcon />}
          label="المسؤولين"
          value={stats?.totalManagers ?? 0}
          accentColor={chartColors.warning}
        />
      </div>

      {/* Growth indicator */}
      {stats?.growthPercent !== undefined && stats.growthPercent !== 0 && (
        <GrowthIndicator value={stats.growthPercent} label="مقارنة بالفترة السابقة" />
      )}

      {/* Main content: chart + leaderboard */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Trend chart — takes 2/3 width */}
        <div className="lg:col-span-2">
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

        {/* Leaderboard — takes 1/3 width */}
        <div>
          <ManagerLeaderboard
            managers={leaderboard}
            onSelect={setDrilldownManager}
            selectedId={drilldownManagerId}
          />
        </div>
      </div>
    </div>
  );
}
