import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/statistics/get_category_breakdown_use_case.dart';
import '../../../application/use_cases/statistics/get_predictions_use_case.dart';
import '../../../application/use_cases/statistics/get_monthly_comparison_use_case.dart';
import '../../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../../application/use_cases/statistics/detect_financial_leaks_use_case.dart';
import '../../../domain/repositories/cycle_repository.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final Map<String, double> categoryBreakdown;
  final PredictionResult? prediction;
  final List<MonthlyComparison> monthlyComparison;
  final FinancialTier? financialTier;
  final List<FinancialLeak> financialLeaks;

  StatisticsLoaded({
    required this.categoryBreakdown,
    required this.prediction,
    required this.monthlyComparison,
    required this.financialTier,
    required this.financialLeaks,
  });
}

class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError(this.message);
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class StatisticsCubit extends Cubit<StatisticsState> {
  final GetCategoryBreakdownUseCase _getCategoryBreakdown;
  final GetPredictionsUseCase _getPredictions;
  final GetMonthlyComparisonUseCase _getMonthlyComparison;
  final GetFinancialClassificationUseCase _getFinancialClassification;
  final DetectFinancialLeaksUseCase _detectFinancialLeaks;
  final CycleRepository _cycleRepository;

  StatisticsCubit({
    required GetCategoryBreakdownUseCase getCategoryBreakdown,
    required GetPredictionsUseCase getPredictions,
    required GetMonthlyComparisonUseCase getMonthlyComparison,
    required GetFinancialClassificationUseCase getFinancialClassification,
    required DetectFinancialLeaksUseCase detectFinancialLeaks,
    required CycleRepository cycleRepository,
  })  : _getCategoryBreakdown = getCategoryBreakdown,
        _getPredictions = getPredictions,
        _getMonthlyComparison = getMonthlyComparison,
        _getFinancialClassification = getFinancialClassification,
        _detectFinancialLeaks = detectFinancialLeaks,
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

      // Run independent use cases in parallel
      final results = await Future.wait([
        cycle != null
            ? _getCategoryBreakdown(cycle)
            : Future.value(<String, double>{}),
        _getPredictions(),
        _getMonthlyComparison(),
        _getFinancialClassification(),
        _detectFinancialLeaks(),
      ]);

      final categoryBreakdown = results[0] as Map<String, double>;
      final prediction = results[1] as PredictionResult?;
      final monthlyComparison = results[2] as List<MonthlyComparison>;
      final financialTier = results[3] as FinancialTier?;
      final financialLeaks = results[4] as List<FinancialLeak>;

      emit(StatisticsLoaded(
        categoryBreakdown: categoryBreakdown,
        prediction: prediction,
        monthlyComparison: monthlyComparison,
        financialTier: financialTier,
        financialLeaks: financialLeaks,
      ));
    } catch (e) {
      emit(StatisticsError('حدث خطأ في تحميل الإحصائيات: ${e.toString()}'));
    }
  }
}
