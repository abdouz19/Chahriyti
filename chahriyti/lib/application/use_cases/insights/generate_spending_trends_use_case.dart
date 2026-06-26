import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

class SpendingTrend {
  final String category;
  final int previousAmount;
  final int currentAmount;
  final double percentageChange;
  final bool isIncreasing;
  final String suggestion;

  SpendingTrend({
    required this.category,
    required this.previousAmount,
    required this.currentAmount,
    required this.percentageChange,
    required this.isIncreasing,
    required this.suggestion,
  });

  String get amountText =>
      '${_formatAmount(previousAmount)} → ${_formatAmount(currentAmount)}';

  String _formatAmount(int centimes) {
    final dzd = centimes / 100;
    return '${dzd.toStringAsFixed(0)} دج';
  }
}

class GenerateSpendingTrendsUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;

  GenerateSpendingTrendsUseCase(
    this._cycleRepository,
    this._expenseRepository,
  );

  Future<List<SpendingTrend>> call(int cycleId) async {
    final currentCycle = await _cycleRepository.getCycleById(cycleId);
    if (currentCycle == null) return [];

    // Get previous cycle
    final previousCycle =
        await _cycleRepository.getPreviousCycle(currentCycle.id);
    if (previousCycle == null) return []; // No previous data for comparison

    // Get current cycle expenses grouped by category
    final currentExpenses = await _expenseRepository.getExpensesByDateRange(
      currentCycle.startDate,
      currentCycle.endDate,
    );

    // Get previous cycle expenses grouped by category
    final previousExpenses = await _expenseRepository.getExpensesByDateRange(
      previousCycle.startDate,
      previousCycle.endDate,
    );

    // Group by category
    final currentByCategory = _groupByCategory(currentExpenses);
    final previousByCategory = _groupByCategory(previousExpenses);

    // Get all categories
    final allCategories = {...currentByCategory.keys, ...previousByCategory.keys};

    final trends = <SpendingTrend>[];

    for (final category in allCategories) {
      final currentAmount = currentByCategory[category] ?? 0;
      final previousAmount = previousByCategory[category] ?? 0;

      if (previousAmount > 0) {
        final percentageChange =
            (((currentAmount - previousAmount) / previousAmount) * 100).toDouble();
        final isIncreasing = currentAmount > previousAmount;

        final suggestion = _generateSuggestion(
          category,
          previousAmount,
          currentAmount,
          percentageChange,
          isIncreasing,
        );

        trends.add(
          SpendingTrend(
            category: category,
            previousAmount: previousAmount,
            currentAmount: currentAmount,
            percentageChange: percentageChange.abs(),
            isIncreasing: isIncreasing,
            suggestion: suggestion,
          ),
        );
      }
    }

    // Sort by absolute percentage change (highest impact first)
    trends.sort((a, b) => b.percentageChange.compareTo(a.percentageChange));

    return trends;
  }

  Map<String, int> _groupByCategory(List<dynamic> expenses) {
    final grouped = <String, int>{};
    for (final expense in expenses) {
      grouped.putIfAbsent(expense.category, () => 0);
      grouped[expense.category] = (grouped[expense.category] ?? 0) + (expense.amount as int);
    }
    return grouped;
  }

  String _generateSuggestion(
    String category,
    int previousAmount,
    int currentAmount,
    double percentageChange,
    bool isIncreasing,
  ) {
    if (isIncreasing) {
      return 'مصروف "$category" ارتفع بنسبة ${percentageChange.toStringAsFixed(1)}%. '
          'حاول التخطيط بشكل أفضل لتقليل هذا المصروف.';
    } else {
      return 'مصروف "$category" انخفض بنسبة ${percentageChange.toStringAsFixed(1)}%. '
          'أحسنت! حافظ على هذا التقدم.';
    }
  }
}
