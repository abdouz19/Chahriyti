import '../../../domain/entities/expense_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

class FinancialLeak {
  final String subcategory;
  final int totalSpent;
  final int transactionCount;
  final int potentialSavings; // at 50% reduction
  final double? monthOverMonthChange; // percentage change vs previous month

  const FinancialLeak({
    required this.subcategory,
    required this.totalSpent,
    required this.transactionCount,
    required this.potentialSavings,
    this.monthOverMonthChange,
  });
}

class DetectFinancialLeaksUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;

  /// Threshold: 5+ transactions
  static const int _minTransactionCount = 5;

  /// Threshold: 2,000 DZD
  static const int _minTotalAmount = 2000;

  const DetectFinancialLeaksUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository;

  Future<List<FinancialLeak>> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return [];

    // Get all expenses for current cycle
    final currentExpenses = await _expenseRepository.getExpenses(cycle.id);
    if (currentExpenses.isEmpty) return [];

    // Analyze subcategories in current cycle
    final subcategoryAnalysis = _analyzeBySubcategory(currentExpenses);

    // Get previous cycle for month-over-month comparison
    final history = await _cycleRepository.getCycleHistory(limit: 2);
    final previousCycles = history.where((c) => c.id != cycle.id).toList();

    Map<String, int>? previousSubcategoryTotals;
    if (previousCycles.isNotEmpty) {
      final prevExpenses =
          await _expenseRepository.getExpenses(previousCycles.first.id);
      previousSubcategoryTotals = _sumBySubcategory(prevExpenses);
    }

    // Build leaks list
    final leaks = <FinancialLeak>[];

    for (final entry in subcategoryAnalysis.entries) {
      final subcategory = entry.key;
      final data = entry.value;
      final totalSpent = data.totalSpent;
      final count = data.count;

      // Apply thresholds
      if (count < _minTransactionCount || totalSpent < _minTotalAmount) {
        continue;
      }

      // Calculate month-over-month change
      double? monthOverMonthChange;
      if (previousSubcategoryTotals != null) {
        final prevTotal = previousSubcategoryTotals[subcategory];
        if (prevTotal != null && prevTotal > 0) {
          monthOverMonthChange =
              ((totalSpent - prevTotal) / prevTotal) * 100;
        }
      }

      leaks.add(FinancialLeak(
        subcategory: subcategory,
        totalSpent: totalSpent,
        transactionCount: count,
        potentialSavings: totalSpent ~/ 2, // 50% reduction
        monthOverMonthChange: monthOverMonthChange,
      ));
    }

    // Sort by total spent descending
    leaks.sort((a, b) => b.totalSpent.compareTo(a.totalSpent));

    return leaks;
  }

  Map<String, _SubcategoryData> _analyzeBySubcategory(
      List<ExpenseEntity> expenses) {
    final result = <String, _SubcategoryData>{};
    for (final expense in expenses) {
      final existing = result[expense.subcategory];
      if (existing != null) {
        result[expense.subcategory] = _SubcategoryData(
          totalSpent: existing.totalSpent + expense.amount,
          count: existing.count + 1,
        );
      } else {
        result[expense.subcategory] = _SubcategoryData(
          totalSpent: expense.amount,
          count: 1,
        );
      }
    }
    return result;
  }

  Map<String, int> _sumBySubcategory(List<ExpenseEntity> expenses) {
    final result = <String, int>{};
    for (final expense in expenses) {
      result[expense.subcategory] =
          (result[expense.subcategory] ?? 0) + expense.amount;
    }
    return result;
  }
}

class _SubcategoryData {
  final int totalSpent;
  final int count;

  const _SubcategoryData({required this.totalSpent, required this.count});
}
