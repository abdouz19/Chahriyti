import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_category_breakdown_use_case.dart';
import 'package:chahriyti/domain/entities/custom_category_entity.dart';

import 'fakes.dart';

void main() {
  late FakeExpenseRepository expenseRepo;
  late FakeCustomCategoryRepository customCategoryRepo;
  late GetCategoryBreakdownUseCase useCase;

  setUp(() {
    expenseRepo = FakeExpenseRepository();
    customCategoryRepo = FakeCustomCategoryRepository();
    useCase = GetCategoryBreakdownUseCase(
      expenseRepository: expenseRepo,
      customCategoryRepository: customCategoryRepo,
    );
  });

  final cycle = makeCycle(id: 1);

  test('returns empty when no expenses', () async {
    expenseRepo.setByCategory(1, {});
    final result = await useCase(cycle);
    expect(result.percentages, isEmpty);
    expect(result.amounts, isEmpty);
  });

  test('single category gets 100%', () async {
    expenseRepo.setByCategory(1, {'essentials': 10000});
    final result = await useCase(cycle);
    expect(result.percentages['essentials'], closeTo(100, 0.01));
    expect(result.amounts['essentials'], 10000);
  });

  test('two categories split correctly', () async {
    expenseRepo.setByCategory(1, {'essentials': 30000, 'luxuries': 70000});
    final result = await useCase(cycle);
    expect(result.percentages['essentials'], closeTo(30, 0.01));
    expect(result.percentages['luxuries'], closeTo(70, 0.01));
    expect(result.amounts['essentials'], 30000);
    expect(result.amounts['luxuries'], 70000);
  });

  test('three categories percentages sum to 100', () async {
    expenseRepo.setByCategory(1, {
      'essentials': 25000,
      'transport': 25000,
      'restaurants': 50000,
    });
    final result = await useCase(cycle);
    final sum = result.percentages.values.fold(0.0, (a, b) => a + b);
    expect(sum, closeTo(100, 0.01));
  });

  test('returns empty when total is zero', () async {
    expenseRepo.setByCategory(1, {'essentials': 0});
    final result = await useCase(cycle);
    expect(result.percentages, isEmpty);
  });

  test('custom categories include display names', () async {
    expenseRepo.setByCategory(1, {'custom_5': 20000, 'essentials': 80000});
    customCategoryRepo.categories = [
      const CustomCategoryEntity(id: 5, name: 'رياضة', iconCodePoint: 0xe3c9),
    ];
    final result = await useCase(cycle);
    expect(result.displayNames['custom_5'], 'رياضة');
    expect(result.displayNames.containsKey('essentials'), isFalse);
  });

  test('custom category missing from DB falls back to key', () async {
    expenseRepo.setByCategory(1, {'custom_99': 5000});
    customCategoryRepo.categories = []; // not found
    final result = await useCase(cycle);
    expect(result.displayNames['custom_99'], 'custom_99');
  });
}
