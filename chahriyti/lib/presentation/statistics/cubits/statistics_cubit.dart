import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/statistics/get_category_breakdown_by_date_range_use_case.dart';
import '../../../application/use_cases/statistics/get_category_breakdown_use_case.dart';
import '../../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../../application/use_cases/statistics/get_income_breakdown_use_case.dart';
import '../../../application/use_cases/statistics/get_income_growth_use_case.dart';
import '../../../application/use_cases/statistics/get_income_vs_spending_use_case.dart';
import '../../../application/use_cases/statistics/get_monthly_comparison_use_case.dart';
import '../../../application/use_cases/statistics/get_savings_balance_history_use_case.dart';
import '../../../application/use_cases/statistics/get_savings_rate_use_case.dart';
import '../../../application/use_cases/statistics/get_spending_insights_use_case.dart';
import '../../../application/use_cases/statistics/get_spending_trend_use_case.dart';

// ─── Filter ────────────────────────────────────────────────────────────────

enum StatisticsFilter { week, month, threeMonths, custom }

// ─── States ────────────────────────────────────────────────────────────────

abstract class StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final CategoryBreakdownResult categoryBreakdown;
  final List<MonthlyComparison> monthlyComparison;
  final FinancialTier? financialTier;
  final SpendingTrend? spendingTrend;
  final IncomeBreakdownResult incomeBreakdown;
  final List<IncomeVsSpendingPoint> incomeVsSpending;
  final IncomeGrowthResult incomeGrowth;
  final SavingsRateResult savingsRate;
  final List<SavingsBalancePoint> savingsBalanceHistory;
  final SpendingInsightsResult spendingInsights;
  final StatisticsFilter filter;
  final DateTimeRange dateRange;

  StatisticsLoaded({
    required this.categoryBreakdown,
    required this.monthlyComparison,
    required this.financialTier,
    required this.spendingTrend,
    required this.incomeBreakdown,
    required this.incomeVsSpending,
    required this.incomeGrowth,
    required this.savingsRate,
    required this.savingsBalanceHistory,
    required this.spendingInsights,
    required this.filter,
    required this.dateRange,
  });
}

class StatisticsError extends StatisticsState {
  final String message;
  StatisticsError(this.message);
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class StatisticsCubit extends Cubit<StatisticsState> {
  final GetCategoryBreakdownByDateRangeUseCase _getCategoryBreakdown;
  final GetMonthlyComparisonUseCase _getMonthlyComparison;
  final GetFinancialClassificationUseCase _getFinancialClassification;
  final GetSpendingTrendUseCase _getSpendingTrend;
  final GetIncomeBreakdownUseCase _getIncomeBreakdown;
  final GetIncomeVsSpendingUseCase _getIncomeVsSpending;
  final GetIncomeGrowthUseCase _getIncomeGrowth;
  final GetSavingsRateUseCase _getSavingsRate;
  final GetSavingsBalanceHistoryUseCase _getSavingsBalanceHistory;
  final GetSpendingInsightsUseCase _getSpendingInsights;

  StatisticsFilter _filter = StatisticsFilter.month;
  DateTimeRange? _customRange;

  StatisticsCubit({
    required GetCategoryBreakdownByDateRangeUseCase getCategoryBreakdown,
    required GetMonthlyComparisonUseCase getMonthlyComparison,
    required GetFinancialClassificationUseCase getFinancialClassification,
    required GetSpendingTrendUseCase getSpendingTrend,
    required GetIncomeBreakdownUseCase getIncomeBreakdown,
    required GetIncomeVsSpendingUseCase getIncomeVsSpending,
    required GetIncomeGrowthUseCase getIncomeGrowth,
    required GetSavingsRateUseCase getSavingsRate,
    required GetSavingsBalanceHistoryUseCase getSavingsBalanceHistory,
    required GetSpendingInsightsUseCase getSpendingInsights,
  })  : _getCategoryBreakdown = getCategoryBreakdown,
        _getMonthlyComparison = getMonthlyComparison,
        _getFinancialClassification = getFinancialClassification,
        _getSpendingTrend = getSpendingTrend,
        _getIncomeBreakdown = getIncomeBreakdown,
        _getIncomeVsSpending = getIncomeVsSpending,
        _getIncomeGrowth = getIncomeGrowth,
        _getSavingsRate = getSavingsRate,
        _getSavingsBalanceHistory = getSavingsBalanceHistory,
        _getSpendingInsights = getSpendingInsights,
        super(StatisticsLoading());

  DateTimeRange get _effectiveRange {
    final now = DateTime.now();
    switch (_filter) {
      case StatisticsFilter.week:
        return DateTimeRange(
            start: now.subtract(const Duration(days: 7)), end: now);
      case StatisticsFilter.month:
        return DateTimeRange(
            start: now.subtract(const Duration(days: 30)), end: now);
      case StatisticsFilter.threeMonths:
        return DateTimeRange(
            start: now.subtract(const Duration(days: 90)), end: now);
      case StatisticsFilter.custom:
        return _customRange ??
            DateTimeRange(
                start: now.subtract(const Duration(days: 30)), end: now);
    }
  }

  Future<void> setFilter(StatisticsFilter filter,
      {DateTimeRange? customRange}) async {
    _filter = filter;
    if (customRange != null) _customRange = customRange;
    await _fetchData(emitLoading: false);
  }

  Future<void> loadStatistics() async {
    emit(StatisticsLoading());
    await _fetchData();
  }

  Future<void> refresh() async {
    await _fetchData(emitLoading: false);
  }

  Future<void> _fetchData({bool emitLoading = true}) async {
    if (emitLoading) emit(StatisticsLoading());
    try {
      final range = _effectiveRange;

      final results = await Future.wait([
        _getCategoryBreakdown(range),
        _getMonthlyComparison(),
        _getFinancialClassification(),
        _getSpendingTrend(),
        _getIncomeBreakdown(),
        _getIncomeVsSpending(),
        _getIncomeGrowth(),
        _getSavingsRate(),
        _getSavingsBalanceHistory(),
        _getSpendingInsights(),
      ]);

      emit(StatisticsLoaded(
        categoryBreakdown: results[0] as CategoryBreakdownResult,
        monthlyComparison: results[1] as List<MonthlyComparison>,
        financialTier: results[2] as FinancialTier?,
        spendingTrend: results[3] as SpendingTrend?,
        incomeBreakdown: results[4] as IncomeBreakdownResult,
        incomeVsSpending: results[5] as List<IncomeVsSpendingPoint>,
        incomeGrowth: results[6] as IncomeGrowthResult,
        savingsRate: results[7] as SavingsRateResult,
        savingsBalanceHistory: results[8] as List<SavingsBalancePoint>,
        spendingInsights: results[9] as SpendingInsightsResult,
        filter: _filter,
        dateRange: range,
      ));
    } catch (e) {
      emit(StatisticsError('حدث خطأ في تحميل الإحصائيات: ${e.toString()}'));
    }
  }
}
