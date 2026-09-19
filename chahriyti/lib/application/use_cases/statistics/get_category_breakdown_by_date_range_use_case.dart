import 'package:flutter/material.dart' show DateTimeRange;

import '../../../domain/repositories/custom_category_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import 'get_category_breakdown_use_case.dart';

class GetCategoryBreakdownByDateRangeUseCase {
  final ExpenseRepository _expenseRepository;
  final CustomCategoryRepository _customCategoryRepository;

  const GetCategoryBreakdownByDateRangeUseCase({
    required ExpenseRepository expenseRepository,
    required CustomCategoryRepository customCategoryRepository,
  })  : _expenseRepository = expenseRepository,
        _customCategoryRepository = customCategoryRepository;

  Future<CategoryBreakdownResult> call(DateTimeRange range) async {
    final expenses = await _expenseRepository.getExpensesByDateRange(
        range.start, range.end);
    if (expenses.isEmpty) return CategoryBreakdownResult.empty;

    final amounts = <String, int>{};
    for (final e in expenses) {
      amounts[e.category] = (amounts[e.category] ?? 0) + e.amount;
    }

    final total = amounts.values.fold<int>(0, (s, v) => s + v);
    if (total == 0) return CategoryBreakdownResult.empty;

    final sortedEntries = amounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final sortedAmounts = Map<String, int>.fromEntries(sortedEntries);
    final percentages =
        sortedAmounts.map((k, v) => MapEntry(k, (v / total) * 100));

    Map<String, String> displayNames = {};
    final hasCustom = amounts.keys.any((k) => k.startsWith('custom_'));
    if (hasCustom) {
      final customs = await _customCategoryRepository.getAll();
      final customMap = {for (final c in customs) c.categoryKey: c.name};
      displayNames = Map.fromEntries(
        amounts.keys
            .where((k) => k.startsWith('custom_'))
            .map((k) => MapEntry(k, customMap[k] ?? k)),
      );
    }

    return CategoryBreakdownResult(
      percentages: percentages,
      amounts: sortedAmounts,
      displayNames: displayNames,
    );
  }
}
