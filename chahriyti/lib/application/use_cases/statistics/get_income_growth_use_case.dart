import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/income_repository.dart';

class IncomeGrowthResult {
  final int currentIncome;
  final int previousIncome;
  final double growthPercent;
  final bool hasComparison;

  const IncomeGrowthResult({
    required this.currentIncome,
    required this.previousIncome,
    required this.growthPercent,
    required this.hasComparison,
  });

  bool get isPositive => growthPercent >= 0;

  static const empty = IncomeGrowthResult(
    currentIncome: 0,
    previousIncome: 0,
    growthPercent: 0,
    hasComparison: false,
  );
}

class GetIncomeGrowthUseCase {
  final CycleRepository _cycleRepository;
  final IncomeRepository _incomeRepository;

  const GetIncomeGrowthUseCase({
    required CycleRepository cycleRepository,
    required IncomeRepository incomeRepository,
  })  : _cycleRepository = cycleRepository,
        _incomeRepository = incomeRepository;

  Future<IncomeGrowthResult> call() async {
    final activeCycle = await _cycleRepository.getActiveCycle();
    if (activeCycle == null) return IncomeGrowthResult.empty;

    final additionalCurrent = await _incomeRepository.getTotalIncomeForCycle(activeCycle.id);
    final currentIncome = activeCycle.salaryAmount + additionalCurrent;

    // Last closed cycle
    final history = await _cycleRepository.getCycleHistory(limit: 6);
    final lastClosed = history.where((c) => !c.isActive).toList();
    if (lastClosed.isEmpty) {
      return IncomeGrowthResult(
        currentIncome: currentIncome,
        previousIncome: 0,
        growthPercent: 0,
        hasComparison: false,
      );
    }

    // Most recent closed cycle
    lastClosed.sort((a, b) => b.startDate.compareTo(a.startDate));
    final prevCycle = lastClosed.first;
    final additionalPrev = await _incomeRepository.getTotalIncomeForCycle(prevCycle.id);
    final previousIncome = prevCycle.salaryAmount + additionalPrev;

    final growthPercent = previousIncome > 0
        ? ((currentIncome - previousIncome) / previousIncome) * 100
        : 0.0;

    return IncomeGrowthResult(
      currentIncome: currentIncome,
      previousIncome: previousIncome,
      growthPercent: growthPercent,
      hasComparison: true,
    );
  }
}
