import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_spending_trend_use_case.dart';
import 'package:chahriyti/domain/entities/expense_entity.dart';

import 'fakes.dart';

ExpenseEntity makeExpense({
  required int id,
  required int cycleId,
  required int amount,
  required DateTime createdAt,
}) =>
    ExpenseEntity(
      id: id,
      cycleId: cycleId,
      category: 'essentials',
      subcategory: '',
      itemName: 'item',
      amount: amount,
      createdAt: createdAt,
      updatedAt: createdAt,
    );

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeExpenseRepository expenseRepo;
  late GetSpendingTrendUseCase useCase;

  setUp(() {
    cycleRepo = FakeCycleRepository();
    expenseRepo = FakeExpenseRepository();
    useCase = GetSpendingTrendUseCase(
      cycleRepository: cycleRepo,
      expenseRepository: expenseRepo,
    );
  });

  test('returns null when no active cycle', () async {
    cycleRepo.activeCycle = null;
    final result = await useCase();
    expect(result, isNull);
  });

  test('budget equals salary minus split', () async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 29));
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 60000,
      salarySplitAmount: 10000,
      startDate: start,
      endDate: end,
    );
    expenseRepo.setExpenses(1, []);

    final result = await useCase();
    expect(result, isNotNull);
    expect(result!.budget, 50000.0);
  });

  test('returns single point on day one with no expenses', () async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 29));
    cycleRepo.activeCycle = makeCycle(id: 1, startDate: start, endDate: end);
    expenseRepo.setExpenses(1, []);

    final result = await useCase();
    expect(result!.points.length, 1);
    expect(result.points.first.dayIndex, 1);
    expect(result.points.first.daily, 0);
    expect(result.points.first.cumulative, 0);
  });

  test('cumulative builds correctly across multiple days', () async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day)
        .subtract(const Duration(days: 2));
    final end = start.add(const Duration(days: 29));
    cycleRepo.activeCycle = makeCycle(id: 1, startDate: start, endDate: end);

    expenseRepo.setExpenses(1, [
      makeExpense(id: 1, cycleId: 1, amount: 5000, createdAt: start),
      makeExpense(id: 2, cycleId: 1, amount: 3000, createdAt: start.add(const Duration(days: 1))),
    ]);

    final result = await useCase();
    expect(result, isNotNull);
    // day 1: daily=5000, cumulative=5000
    expect(result!.points[0].daily, 5000);
    expect(result.points[0].cumulative, 5000);
    // day 2: daily=3000, cumulative=8000
    expect(result.points[1].daily, 3000);
    expect(result.points[1].cumulative, 8000);
    // day 3 (today): daily=0, cumulative=8000
    expect(result.points[2].daily, 0);
    expect(result.points[2].cumulative, 8000);
  });

  test('totalDays matches cycle length', () async {
    final start = DateTime(2024, 1, 1);
    final end = DateTime(2024, 1, 30); // 30 days (inclusive: 30-1+1=30)
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      startDate: start,
      endDate: end,
    );
    expenseRepo.setExpenses(1, []);

    final result = await useCase();
    expect(result!.totalDays, 30);
  });

  test('expenses outside cycle range are ignored', () async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 29));
    cycleRepo.activeCycle = makeCycle(id: 1, startDate: start, endDate: end);

    expenseRepo.setExpenses(1, [
      // before cycle
      makeExpense(id: 1, cycleId: 1, amount: 9999,
          createdAt: start.subtract(const Duration(days: 1))),
      // after cycle
      makeExpense(id: 2, cycleId: 1, amount: 9999,
          createdAt: end.add(const Duration(days: 1))),
    ]);

    final result = await useCase();
    expect(result!.points.first.cumulative, 0);
  });
}
