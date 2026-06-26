import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

class MonthlyComparison {
  final DateTime month;
  final int totalSpending;

  const MonthlyComparison({
    required this.month,
    required this.totalSpending,
  });
}

class GetMonthlyComparisonUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;

  const GetMonthlyComparisonUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository;

  /// Returns last 6 closed cycles' total spending for comparison.
  /// Returns empty list if less than 2 months of data.
  Future<List<MonthlyComparison>> call() async {
    final history = await _cycleRepository.getCycleHistory(limit: 6);

    // Filter only closed (non-active) cycles
    final closedCycles = history.where((c) => !c.isActive).toList();

    if (closedCycles.length < 2) return [];

    final comparisons = <MonthlyComparison>[];

    for (final cycle in closedCycles) {
      final totalSpending =
          await _expenseRepository.getTotalExpenses(cycle.id);
      comparisons.add(MonthlyComparison(
        month: cycle.startDate,
        totalSpending: totalSpending,
      ));
    }

    // Sort chronologically (oldest first)
    comparisons.sort((a, b) => a.month.compareTo(b.month));

    return comparisons;
  }
}
