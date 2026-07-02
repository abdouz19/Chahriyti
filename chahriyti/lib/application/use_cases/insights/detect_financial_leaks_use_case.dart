import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

class LeakInsight {
  final String category;
  final int totalAmount;
  final int transactionCount;
  final int averageAmount;
  final double percentageOfTotal;
  final int potentialSavings;
  final String suggestion;

  LeakInsight({
    required this.category,
    required this.totalAmount,
    required this.transactionCount,
    required this.averageAmount,
    required this.percentageOfTotal,
    required this.potentialSavings,
    required this.suggestion,
  });
}

class DetectLeaksUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;

  // Constants for leak detection
  static const int minTransactionCount = 3;
  static const int minCategoryTotal = 500;
  static const double minPercentageOfWeekly = 5.0;

  DetectLeaksUseCase(
    this._cycleRepository,
    this._expenseRepository,
  );

  Future<List<LeakInsight>> call(int cycleId) async {
    final cycle = await _cycleRepository.getCycleById(cycleId);
    if (cycle == null) return [];

    final expenses = await _expenseRepository.getExpensesByDateRange(
      cycle.startDate,
      cycle.endDate,
    );

    if (expenses.isEmpty) return [];

    // Group expenses by category
    final categoriesMap = <String, List<int>>{};
    for (final expense in expenses) {
      categoriesMap
          .putIfAbsent(expense.category, () => [])
          .add(expense.amount);
    }

    // Calculate total spending for percentage calculation
    final totalSpending = expenses.fold<int>(0, (sum, e) => sum + e.amount);

    final leaks = <LeakInsight>[];

    for (final MapEntry(:key, :value) in categoriesMap.entries) {
      final transactionCount = value.length;
      final categoryTotal = value.fold<int>(0, (sum, amount) => sum + amount);
      final averageAmount =
          transactionCount > 0 ? categoryTotal ~/ transactionCount : 0;
      final percentageOfTotal = totalSpending > 0
          ? ((categoryTotal / totalSpending) * 100).toDouble()
          : 0.0;

      // Check if this category qualifies as a leak
      if (transactionCount >= minTransactionCount &&
          categoryTotal >= minCategoryTotal &&
          percentageOfTotal >= minPercentageOfWeekly) {
        // Calculate potential savings if reduced to 50%
        final potentialSavings = categoryTotal ~/ 2;

        final suggestion = _generateSuggestion(
          key,
          categoryTotal,
          transactionCount,
          potentialSavings,
        );

        leaks.add(
          LeakInsight(
            category: key,
            totalAmount: categoryTotal,
            transactionCount: transactionCount,
            averageAmount: averageAmount,
            percentageOfTotal: percentageOfTotal,
            potentialSavings: potentialSavings,
            suggestion: suggestion,
          ),
        );
      }
    }

    // Sort by potential savings (highest first)
    leaks.sort((a, b) => b.potentialSavings.compareTo(a.potentialSavings));

    return leaks;
  }

  String _generateSuggestion(
    String category,
    int total,
    int count,
    int savings,
  ) {
    return 'أنفقت $count مرات على "$category" بإجمالي ${_formatAmount(total)}. '
        'لو خفضت هذا للنصف ستتوفر ${_formatAmount(savings)}.';
  }

  String _formatAmount(int amount) {
    return '$amount دج';
  }
}
