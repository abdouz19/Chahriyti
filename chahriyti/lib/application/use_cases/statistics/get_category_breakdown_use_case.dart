import '../../../domain/entities/financial_cycle_entity.dart';
import '../../../domain/repositories/expense_repository.dart';

class CategoryBreakdownResult {
  final Map<String, double> percentages; // category → %
  final Map<String, int> amounts;        // category → DZD

  const CategoryBreakdownResult({
    required this.percentages,
    required this.amounts,
  });

  static const empty = CategoryBreakdownResult(percentages: {}, amounts: {});
}

class GetCategoryBreakdownUseCase {
  final ExpenseRepository _expenseRepository;

  const GetCategoryBreakdownUseCase({
    required ExpenseRepository expenseRepository,
  }) : _expenseRepository = expenseRepository;

  Future<CategoryBreakdownResult> call(FinancialCycleEntity cycle) async {
    final byCategory = await _expenseRepository.getExpensesByCategory(cycle.id);
    if (byCategory.isEmpty) return CategoryBreakdownResult.empty;

    final total = byCategory.values.fold<int>(0, (sum, v) => sum + v);
    if (total == 0) return CategoryBreakdownResult.empty;

    final percentages = byCategory.map(
      (category, amount) => MapEntry(category, (amount / total) * 100),
    );

    return CategoryBreakdownResult(percentages: percentages, amounts: byCategory);
  }
}
