import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_monthly_comparison_use_case.dart';

import 'fakes.dart';

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeExpenseRepository expenseRepo;
  late GetMonthlyComparisonUseCase useCase;

  setUp(() {
    cycleRepo = FakeCycleRepository();
    expenseRepo = FakeExpenseRepository();
    useCase = GetMonthlyComparisonUseCase(
      cycleRepository: cycleRepo,
      expenseRepository: expenseRepo,
    );
  });

  test('returns empty when no closed cycles', () async {
    cycleRepo.history = [makeCycle(id: 1, isActive: true)];
    final result = await useCase();
    expect(result, isEmpty);
  });

  test('returns empty when only one closed cycle', () async {
    cycleRepo.history = [makeCycle(id: 1, isActive: false)];
    final result = await useCase();
    expect(result, isEmpty);
  });

  test('returns comparisons for 2+ closed cycles', () async {
    cycleRepo.history = [
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1)),
      makeCycle(id: 2, isActive: false, startDate: DateTime(2024, 2, 1)),
    ];
    expenseRepo.setTotal(1, 30000);
    expenseRepo.setTotal(2, 45000);

    final result = await useCase();
    expect(result.length, 2);
    expect(result[0].totalSpending, 30000);
    expect(result[1].totalSpending, 45000);
  });

  test('excludes active cycle from comparisons', () async {
    cycleRepo.history = [
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1)),
      makeCycle(id: 2, isActive: false, startDate: DateTime(2024, 2, 1)),
      makeCycle(id: 3, isActive: true, startDate: DateTime(2024, 3, 1)),
    ];
    expenseRepo.setTotal(1, 10000);
    expenseRepo.setTotal(2, 20000);
    expenseRepo.setTotal(3, 99999);

    final result = await useCase();
    expect(result.length, 2);
    expect(result.any((c) => c.totalSpending == 99999), isFalse);
  });

  test('sorted chronologically oldest first', () async {
    // history comes in reverse-chronological order from repo
    cycleRepo.history = [
      makeCycle(id: 2, isActive: false, startDate: DateTime(2024, 2, 1)),
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1)),
    ];
    expenseRepo.setTotal(1, 10000);
    expenseRepo.setTotal(2, 20000);

    final result = await useCase();
    expect(result.first.month, DateTime(2024, 1, 1));
    expect(result.last.month, DateTime(2024, 2, 1));
  });
}
