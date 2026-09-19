import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../application/use_cases/statistics/get_category_breakdown_by_date_range_use_case.dart';
import '../../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../../application/use_cases/statistics/get_income_breakdown_use_case.dart';
import '../../../application/use_cases/statistics/get_income_growth_use_case.dart';
import '../../../application/use_cases/statistics/get_income_vs_spending_use_case.dart';
import '../../../application/use_cases/statistics/get_monthly_comparison_use_case.dart';
import '../../../application/use_cases/statistics/get_savings_balance_history_use_case.dart';
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
import '../widgets/classification_badge.dart';
import '../widgets/daily_budget_card.dart';
import '../widgets/income_breakdown_chart.dart';
import '../widgets/income_growth_card.dart';
import '../widgets/income_vs_spending_chart.dart';
import '../widgets/savings_balance_history_chart.dart';
import '../widgets/savings_rate_card.dart';
import '../widgets/spending_trend_chart.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatisticsCubit(
        getCategoryBreakdown: GetCategoryBreakdownByDateRangeUseCase(
          expenseRepository: Injection.expenseRepository,
          customCategoryRepository: Injection.customCategoryRepository,
        ),
        getMonthlyComparison: GetMonthlyComparisonUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
        ),
        getFinancialClassification: GetFinancialClassificationUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
        ),
        getSpendingTrend: GetSpendingTrendUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
        ),
        getIncomeBreakdown: GetIncomeBreakdownUseCase(
          cycleRepository: Injection.cycleRepository,
          incomeRepository: Injection.incomeRepository,
        ),
        getIncomeVsSpending: GetIncomeVsSpendingUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
          incomeRepository: Injection.incomeRepository,
        ),
        getIncomeGrowth: GetIncomeGrowthUseCase(
          cycleRepository: Injection.cycleRepository,
          incomeRepository: Injection.incomeRepository,
        ),
        getSavingsRate: GetSavingsRateUseCase(
          cycleRepository: Injection.cycleRepository,
        ),
        getSavingsBalanceHistory: GetSavingsBalanceHistoryUseCase(
          cycleRepository: Injection.cycleRepository,
          savingsRepository: Injection.savingsRepository,
        ),
        getSpendingInsights: GetSpendingInsightsUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
        ),
      )..loadStatistics(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            context.l10n.statisticsTitle,
            style: AppTypography.headlineSmall.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
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
            const Icon(Icons.error_outline_rounded,
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
    return Column(
      children: [
        // Sticky filter bar
        _FilterBar(
          filter: state.filter,
          dateRange: state.dateRange,
          onChanged: (filter) => _handleFilterChange(context, filter),
        ),
        // Scrollable content
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => context.read<StatisticsCubit>().refresh(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Classification Badge (compact) ──────────────────────
                  if (state.financialTier != null) ...[
                    ClassificationBadge(tier: state.financialTier!),
                    const SizedBox(height: 12),
                  ],

                  // ── KPI 2×2 grid ────────────────────────────────────────
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: IncomeGrowthCard(result: state.incomeGrowth),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SavingsRateCard(result: state.savingsRate),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: DailyBudgetCard(
                              result: state.spendingInsights),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MonthForecastCard(
                              result: state.spendingInsights),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Spending Trend ───────────────────────────────────────
                  if (state.spendingTrend != null) ...[
                    SpendingTrendChart(trend: state.spendingTrend!),
                    const SizedBox(height: 14),
                  ],

                  // ── Category Breakdown (filter-aware) ───────────────────
                  CategoryBreakdownChart(breakdown: state.categoryBreakdown),
                  const SizedBox(height: 14),

                  // ── Income Source Breakdown ──────────────────────────────
                  IncomeBreakdownChart(breakdown: state.incomeBreakdown),
                  const SizedBox(height: 14),

                  // ── Income vs Spending ───────────────────────────────────
                  IncomeVsSpendingChart(points: state.incomeVsSpending),
                  const SizedBox(height: 14),

                  // ── Savings Balance History ──────────────────────────────
                  SavingsBalanceHistoryChart(
                      points: state.savingsBalanceHistory),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleFilterChange(BuildContext context, StatisticsFilter filter) {
    final cubit = context.read<StatisticsCubit>();
    if (filter == StatisticsFilter.custom) {
      final locale = Localizations.localeOf(context).languageCode;
      showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        locale: Locale(locale),
        builder: (ctx, child) => Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.card,
            ),
          ),
          child: child!,
        ),
      ).then((range) {
        if (range != null) {
          cubit.setFilter(filter, customRange: range);
        }
      });
    } else {
      cubit.setFilter(filter);
    }
  }
}

// ─── Filter Bar ────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final StatisticsFilter filter;
  final DateTimeRange dateRange;
  final void Function(StatisticsFilter) onChanged;

  const _FilterBar({
    required this.filter,
    required this.dateRange,
    required this.onChanged,
  });

  String _filterLabel(StatisticsFilter f, BuildContext context) {
    switch (f) {
      case StatisticsFilter.week:
        return context.l10n.filterWeek;
      case StatisticsFilter.month:
        return context.l10n.filterMonth;
      case StatisticsFilter.threeMonths:
        return context.l10n.filterThreeMonths;
      case StatisticsFilter.custom:
        return context.l10n.filterCustom;
    }
  }

  String _customRangeLabel(BuildContext context) {
    if (filter != StatisticsFilter.custom) return '';
    final locale = Localizations.localeOf(context).languageCode;
    final fmt = DateFormat('d MMM', locale);
    return '${fmt.format(dateRange.start)} – ${fmt.format(dateRange.end)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: StatisticsFilter.values.map((f) {
                final isSelected = f == filter;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: () => onChanged(f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _filterLabel(f, context),
                        style: AppTypography.labelSmall.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Custom range label
          if (filter == StatisticsFilter.custom)
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 8, left: 16, right: 16),
              child: Text(
                _customRangeLabel(context),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
