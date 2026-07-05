import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/statistics/get_category_breakdown_use_case.dart';
import '../../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../../application/use_cases/statistics/get_monthly_comparison_use_case.dart';
import '../../../application/use_cases/statistics/get_spending_trend_use_case.dart';
import '../../../domain/repositories/cycle_repository.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final CategoryBreakdownResult categoryBreakdown;
  final List<MonthlyComparison> monthlyComparison;
  final FinancialTier? financialTier;
  final SpendingTrend? spendingTrend;

  StatisticsLoaded({
    required this.categoryBreakdown,
    required this.monthlyComparison,
    required this.financialTier,
    required this.spendingTrend,
  });
}

class StatisticsError extends StatisticsState {
  final String message;
  StatisticsError(this.message);
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class StatisticsCubit extends Cubit<StatisticsState> {
  final GetCategoryBreakdownUseCase _getCategoryBreakdown;
  final GetMonthlyComparisonUseCase _getMonthlyComparison;
  final GetFinancialClassificationUseCase _getFinancialClassification;
  final GetSpendingTrendUseCase _getSpendingTrend;
  final CycleRepository _cycleRepository;

  StatisticsCubit({
    required GetCategoryBreakdownUseCase getCategoryBreakdown,
    required GetMonthlyComparisonUseCase getMonthlyComparison,
    required GetFinancialClassificationUseCase getFinancialClassification,
    required GetSpendingTrendUseCase getSpendingTrend,
    required CycleRepository cycleRepository,
  })  : _getCategoryBreakdown = getCategoryBreakdown,
        _getMonthlyComparison = getMonthlyComparison,
        _getFinancialClassification = getFinancialClassification,
        _getSpendingTrend = getSpendingTrend,
        _cycleRepository = cycleRepository,
        super(StatisticsLoading());

  Future<void> loadStatistics() async {
    emit(StatisticsLoading());
    await _fetchData();
  }

  Future<void> refresh() async {
    await _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final cycle = await _cycleRepository.getActiveCycle();

      final results = await Future.wait([
        cycle != null
            ? _getCategoryBreakdown(cycle)
            : Future.value(CategoryBreakdownResult.empty),
        _getMonthlyComparison(),
        _getFinancialClassification(),
        _getSpendingTrend(),
      ]);

      emit(StatisticsLoaded(
        categoryBreakdown: results[0] as CategoryBreakdownResult,
        monthlyComparison: results[1] as List<MonthlyComparison>,
        financialTier: results[2] as FinancialTier?,
        spendingTrend: results[3] as SpendingTrend?,
      ));
    } catch (e) {
      emit(StatisticsError('حدث خطأ في تحميل الإحصائيات: ${e.toString()}'));
    }
  }
}
