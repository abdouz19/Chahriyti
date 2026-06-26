import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/insights/calculate_financial_classification_use_case.dart';
import '../../../application/use_cases/insights/detect_financial_leaks_use_case.dart' as leak_usecase;
import '../../../application/use_cases/insights/generate_spending_trends_use_case.dart' as trend_usecase;
import '../../../domain/repositories/cycle_repository.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class InsightsState {
  const InsightsState();
}

class InsightsLoading extends InsightsState {
  const InsightsLoading();
}

class ClassificationLoaded extends InsightsState {
  final FinancialClassification classification;
  final double savingsRate;

  const ClassificationLoaded({
    required this.classification,
    required this.savingsRate,
  });
}

class InsightsLoaded extends InsightsState {
  final FinancialClassification classification;
  final double savingsRate;
  final List<leak_usecase.LeakInsight> leaks;
  final List<trend_usecase.SpendingTrend> trends;

  const InsightsLoaded({
    required this.classification,
    required this.savingsRate,
    required this.leaks,
    required this.trends,
  });
}

class InsightsError extends InsightsState {
  final String message;

  const InsightsError(this.message);
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class InsightsCubit extends Cubit<InsightsState> {
  final CalculateFinancialClassificationUseCase
      _calculateFinancialClassificationUseCase;
  final leak_usecase.DetectLeaksUseCase? _detectLeaksUseCase;
  final trend_usecase.GenerateSpendingTrendsUseCase? _generateTrendsUseCase;
  final CycleRepository? _cycleRepository;

  InsightsCubit({
    required CalculateFinancialClassificationUseCase
        calculateFinancialClassificationUseCase,
    leak_usecase.DetectLeaksUseCase? detectLeaksUseCase,
    trend_usecase.GenerateSpendingTrendsUseCase? generateTrendsUseCase,
    CycleRepository? cycleRepository,
  })  : _calculateFinancialClassificationUseCase =
            calculateFinancialClassificationUseCase,
        _detectLeaksUseCase = detectLeaksUseCase,
        _generateTrendsUseCase = generateTrendsUseCase,
        _cycleRepository = cycleRepository,
        super(const InsightsLoading());

  Future<void> loadClassification(int cycleId) async {
    emit(const InsightsLoading());
    try {
      final classification =
          await _calculateFinancialClassificationUseCase.call(cycleId);
      final savingsRate =
          await _calculateFinancialClassificationUseCase.getSavingsRate(cycleId);

      emit(ClassificationLoaded(
        classification: classification,
        savingsRate: savingsRate,
      ));
    } catch (e) {
      debugPrint('❌ INSIGHTS ERROR: $e');
      emit(InsightsError('حدث خطأ في تحميل التصنيف: ${e.toString()}'));
    }
  }

  Future<void> loadInsights() async {
    emit(const InsightsLoading());
    try {
      // Get active cycle
      final cycle = await _cycleRepository?.getActiveCycle();
      if (cycle == null) {
        emit(const InsightsError('لا توجد دورة مالية نشطة'));
        return;
      }

      // Load classification
      final classification =
          await _calculateFinancialClassificationUseCase.call(cycle.id);
      final savingsRate =
          await _calculateFinancialClassificationUseCase.getSavingsRate(cycle.id);

      // Load leaks
      final leaks =
          await _detectLeaksUseCase?.call(cycle.id) ?? [];

      // Load trends
      final trends =
          await _generateTrendsUseCase?.call(cycle.id) ?? [];

      emit(InsightsLoaded(
        classification: classification,
        savingsRate: savingsRate,
        leaks: leaks,
        trends: trends,
      ));
    } catch (e) {
      debugPrint('❌ INSIGHTS ERROR: $e');
      emit(InsightsError('حدث خطأ في تحميل البصائر: ${e.toString()}'));
    }
  }
}
