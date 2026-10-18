import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../../application/use_cases/statistics/get_income_breakdown_use_case.dart';
import '../../../application/use_cases/statistics/get_income_growth_use_case.dart';
import '../../../application/use_cases/statistics/get_savings_rate_use_case.dart';
import '../../../application/use_cases/statistics/get_spending_insights_use_case.dart';
import '../../../application/use_cases/statistics/get_spending_trend_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../cubits/statistics_cubit.dart';
import '../widgets/category_breakdown_chart.dart';
import '../widgets/daily_budget_card.dart';
import '../widgets/income_breakdown_chart.dart';
import '../widgets/income_growth_card.dart';
import '../widgets/savings_rate_card.dart';
import '../widgets/spending_trend_chart.dart';
import '../widgets/cycle_overview_card.dart';
import '../widgets/stat_widgets.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatisticsCubit(
        cycleRepository: Injection.cycleRepository,
        userRepository: Injection.userRepository,
        getCategoryBreakdown: Injection.getCategoryBreakdownUseCase,
        getFinancialClassification: GetFinancialClassificationUseCase(
          cycleRepository: Injection.cycleRepository,
          getDashboardData: Injection.getDashboardDataUseCase,
        ),
        getSpendingTrend: GetSpendingTrendUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
          getDashboardData: Injection.getDashboardDataUseCase,
        ),
        getIncomeBreakdown: GetIncomeBreakdownUseCase(
          cycleRepository: Injection.cycleRepository,
          incomeRepository: Injection.incomeRepository,
        ),
        getIncomeGrowth: GetIncomeGrowthUseCase(
          cycleRepository: Injection.cycleRepository,
          incomeRepository: Injection.incomeRepository,
        ),
        getSavingsRate: GetSavingsRateUseCase(
          cycleRepository: Injection.cycleRepository,
          incomeRepository: Injection.incomeRepository,
          savingsRepository: Injection.savingsRepository,
        ),
        getSpendingInsights: GetSpendingInsightsUseCase(
          cycleRepository: Injection.cycleRepository,
          getDashboardData: Injection.getDashboardDataUseCase,
        ),
      )..loadStatistics(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            context.l10n.statisticsTitle,
            style: AppTypography.headlineSmall,
          ),
        ),
        body: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoading) return _buildLoadingState();
            if (state is StatisticsError) {
              return _buildErrorState(context, state.message);
            }
            if (state is StatisticsLoaded) {
              return _buildLoadedState(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          5,
          (i) => const Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: LoadingShimmer(height: 220),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(IconsaxPlusLinear.danger,
                size: 64, color: AppColors.negative),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  context.read<StatisticsCubit>().loadStatistics(),
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, StatisticsLoaded state) {
    final l10n = context.l10n;
    return RefreshIndicator(
      onRefresh: () => context.read<StatisticsCubit>().refresh(),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CycleOverviewCard(
              tier: state.financialTier,
              insights: state.spendingInsights,
              firstCycleNote: state.firstCycleNote,
            ),

            // ── Spending ────────────────────────────────────────────────
            StatSection(
              title: l10n.statSectionThisCycle,
              icon: IconsaxPlusBold.calendar,
              children: [
                _KpiRow(
                  start: MonthForecastCard(result: state.spendingInsights),
                  end: DailyAverageCard(result: state.spendingInsights),
                ),
                if (state.spendingTrend != null)
                  SpendingTrendChart(trend: state.spendingTrend!),
                CategoryBreakdownChart(breakdown: state.categoryBreakdown),
              ],
            ),

            // ── Income & savings ────────────────────────────────────────
            StatSection(
              title: l10n.statSectionIncome,
              icon: IconsaxPlusBold.wallet,
              children: [
                _KpiRow(
                  start: IncomeGrowthCard(result: state.incomeGrowth),
                  end: SavingsRateCard(result: state.savingsRate),
                ),
                IncomeBreakdownChart(breakdown: state.incomeBreakdown),
              ],
            ),

            // ── Past monthly cycles ─────────────────────────────────────
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => context.push('/cycle-history'),
              icon: const Icon(IconsaxPlusBold.clock),
              label: Text(l10n.pastCyclesButton),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two metric cards side by side, same height.
class _KpiRow extends StatelessWidget {
  final Widget start;
  final Widget end;

  const _KpiRow({required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: start),
          const SizedBox(width: 12),
          Expanded(child: end),
        ],
      ),
    );
  }
}
