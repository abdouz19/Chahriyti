import '../../../domain/entities/financial_cycle_entity.dart';
import '../../../domain/repositories/custom_category_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

class CategoryBreakdownResult {
  final Map<String, double> percentages; // category → %
  final Map<String, int> amounts;        // category → DZD
  /// Display name overrides for custom categories (key: "custom_3" → "اسم الفئة")
  final Map<String, String> displayNames;

  const CategoryBreakdownResult({
    required this.percentages,
    required this.amounts,
    this.displayNames = const {},
  });

  static const empty = CategoryBreakdownResult(percentages: {}, amounts: {});
}

class GetCategoryBreakdownUseCase {
  final ExpenseRepository _expenseRepository;
  final CustomCategoryRepository _customCategoryRepository;

  const GetCategoryBreakdownUseCase({
    required ExpenseRepository expenseRepository,
    required CustomCategoryRepository customCategoryRepository,
  })  : _expenseRepository = expenseRepository,
        _customCategoryRepository = customCategoryRepository;

  Future<CategoryBreakdownResult> call(FinancialCycleEntity cycle) async {
    final byCategory = await _expenseRepository.getExpensesByCategory(cycle.id);
    if (byCategory.isEmpty) return CategoryBreakdownResult.empty;

    final total = byCategory.values.fold<int>(0, (sum, v) => sum + v);
    if (total == 0) return CategoryBreakdownResult.empty;

    final percentages = byCategory.map(
      (category, amount) => MapEntry(category, (amount / total) * 100),
    );

    // Build display name map for custom categories present in breakdown
    final hasCustom = byCategory.keys.any((k) => k.startsWith('custom_'));
    Map<String, String> displayNames = {};
    if (hasCustom) {
      final customs = await _customCategoryRepository.getAll();
      final customMap = {for (final c in customs) c.categoryKey: c.name};
      displayNames = Map.fromEntries(
        byCategory.keys
            .where((k) => k.startsWith('custom_'))
            .map((k) => MapEntry(k, customMap[k] ?? k)),
      );
    }

    return CategoryBreakdownResult(
      percentages: percentages,
      amounts: byCategory,
      displayNames: displayNames,
    );
  }
}
