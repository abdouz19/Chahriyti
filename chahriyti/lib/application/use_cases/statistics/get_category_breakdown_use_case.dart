import '../../../domain/entities/financial_cycle_entity.dart';
import '../../../domain/repositories/expense_repository.dart';

class GetCategoryBreakdownUseCase {
  final ExpenseRepository _expenseRepository;

  const GetCategoryBreakdownUseCase({
    required ExpenseRepository expenseRepository,
  }) : _expenseRepository = expenseRepository;

  /// Returns a map of category name → percentage of total spending.
  /// Empty map if no expenses exist for the cycle.
  Future<Map<String, double>> call(FinancialCycleEntity cycle) async {
    final byCategory = await _expenseRepository.getExpensesByCategory(cycle.id);

    if (byCategory.isEmpty) return {};

    final total = byCategory.values.fold<int>(0, (sum, v) => sum + v);
    if (total == 0) return {};

    return byCategory.map(
      (category, amount) => MapEntry(
        category,
        (amount / total) * 100,
      ),
    );
  }
}
