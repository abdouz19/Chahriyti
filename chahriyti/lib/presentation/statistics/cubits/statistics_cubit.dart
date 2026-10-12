import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/statistics/get_category_breakdown_use_case.dart';
import '../../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../../application/use_cases/statistics/get_income_breakdown_use_case.dart';
import '../../../application/use_cases/statistics/get_income_growth_use_case.dart';
import '../../../application/use_cases/statistics/get_savings_rate_use_case.dart';
import '../../../application/use_cases/statistics/get_spending_insights_use_case.dart';
import '../../../application/use_cases/statistics/get_spending_trend_use_case.dart';
import '../../../domain/entities/financial_cycle_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/user_repository.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class StatisticsState {}

class StatisticsLoading extends StatisticsState {}

/// Statistics of the current monthly cycle only; past cycles live in the
/// cycle history.
class StatisticsLoaded extends StatisticsState {
  final CategoryBreakdownResult categoryBreakdown;
  final FinancialTier? financialTier;
  final SpendingTrend? spendingTrend;
  final IncomeBreakdownResult incomeBreakdown;
  final IncomeGrowthResult incomeGrowth;
  final SavingsRateResult savingsRate;
  final SpendingInsightsResult spendingInsights;

  /// Set during the first cycle only, when the user joined mid-cycle: the
  /// balance they started with, and when the salary takes over.
  final FirstCycleNote? firstCycleNote;

  StatisticsLoaded({
    this.firstCycleNote,
    required this.categoryBreakdown,
    required this.financialTier,
    required this.spendingTrend,
    required this.incomeBreakdown,
    required this.incomeGrowth,
    required this.savingsRate,
    required this.spendingInsights,
  });
}

class FirstCycleNote {
  final int openingBalance;
  final int salary;
  final DateTime salaryFrom;
  const FirstCycleNote({
    required this.openingBalance,
    required this.salary,
    required this.salaryFrom,
  });
}

class StatisticsError extends StatisticsState {
  final String message;
  StatisticsError(this.message);
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class StatisticsCubit extends Cubit<StatisticsState> {
  final CycleRepository _cycleRepository;
  final UserRepository _userRepository;
  final GetCategoryBreakdownUseCase _getCategoryBreakdown;
  final GetFinancialClassificationUseCase _getFinancialClassification;
  final GetSpendingTrendUseCase _getSpendingTrend;
  final GetIncomeBreakdownUseCase _getIncomeBreakdown;
  final GetIncomeGrowthUseCase _getIncomeGrowth;
  final GetSavingsRateUseCase _getSavingsRate;
  final GetSpendingInsightsUseCase _getSpendingInsights;

  StatisticsCubit({
    required CycleRepository cycleRepository,
    required UserRepository userRepository,
    required GetCategoryBreakdownUseCase getCategoryBreakdown,
    required GetFinancialClassificationUseCase getFinancialClassification,
    required GetSpendingTrendUseCase getSpendingTrend,
    required GetIncomeBreakdownUseCase getIncomeBreakdown,
    required GetIncomeGrowthUseCase getIncomeGrowth,
    required GetSavingsRateUseCase getSavingsRate,
    required GetSpendingInsightsUseCase getSpendingInsights,
  })  : _cycleRepository = cycleRepository,
        _userRepository = userRepository,
        _getCategoryBreakdown = getCategoryBreakdown,
        _getFinancialClassification = getFinancialClassification,
        _getSpendingTrend = getSpendingTrend,
        _getIncomeBreakdown = getIncomeBreakdown,
        _getIncomeGrowth = getIncomeGrowth,
        _getSavingsRate = getSavingsRate,
        _getSpendingInsights = getSpendingInsights,
        super(StatisticsLoading());

  Future<void> loadStatistics() async {
    emit(StatisticsLoading());
    await _fetchData();
  }

  Future<void> refresh() => _fetchData();

  Future<void> _fetchData() async {
    try {
      final cycle = await _cycleRepository.getActiveCycle();
      final results = await Future.wait([
        cycle != null
            ? _getCategoryBreakdown(cycle)
            : Future.value(CategoryBreakdownResult.empty),
        _getFinancialClassification(),
        _getSpendingTrend(),
        _getIncomeBreakdown(),
        _getIncomeGrowth(),
        _getSavingsRate(),
        _getSpendingInsights(),
      ]);

      emit(StatisticsLoaded(
        firstCycleNote: cycle != null ? await _firstCycleNote(cycle) : null,
        categoryBreakdown: results[0] as CategoryBreakdownResult,
        financialTier: results[1] as FinancialTier?,
        spendingTrend: results[2] as SpendingTrend?,
        incomeBreakdown: results[3] as IncomeBreakdownResult,
        incomeGrowth: results[4] as IncomeGrowthResult,
        savingsRate: results[5] as SavingsRateResult,
        spendingInsights: results[6] as SpendingInsightsResult,
      ));
    } catch (e) {
      emit(StatisticsError('حدث خطأ في تحميل الإحصائيات: ${e.toString()}'));
    }
  }

  Future<FirstCycleNote?> _firstCycleNote(FinancialCycleEntity cycle) async {
    final opening = (await _userRepository.getUser())?.initialBalance;
    if (opening == null || opening == cycle.salaryAmount) return null;
    // Only while no cycle has closed yet
    final cycles = await _cycleRepository.getCycleHistory(limit: 2);
    if (cycles.any((c) => !c.isActive)) return null;
    final end = cycle.endDate;
    return FirstCycleNote(
      openingBalance: opening,
      salary: cycle.salaryAmount,
      salaryFrom: DateTime(end.year, end.month, end.day + 1),
    );
  }
}
