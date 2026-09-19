import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_spending_insights_use_case.dart';

import 'fakes.dart';

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeExpenseRepository expenseRepo;
  late GetSpendingInsightsUseCase useCase;

  setUp(() {
    cycleRepo = FakeCycleRepository();
    expenseRepo = FakeExpenseRepository();
    useCase = GetSpendingInsightsUseCase(
      cycleRepository: cycleRepo,
      expenseRepository: expenseRepo,
    );
  });

  test('returns empty when no active cycle', () async {
    cycleRepo.activeCycle = null;
    final result = await useCase();
    expect(result.hasData, isFalse);
    expect(result, SpendingInsightsResult.empty);
  });

  test('returns empty when spendable budget is zero', () async {
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 50000,
      salarySplitAmount: 50000, // all savings
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
    );
    final result = await useCase();
    expect(result.hasData, isFalse);
  });

  test('spendable budget = salary minus savings split', () async {
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 60000,
      salarySplitAmount: 10000,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
    );
    expenseRepo.setTotal(1, 0);
    final result = await useCase();
    expect(result.spendableBudget, 50000);
  });

  test('remaining budget = spendable minus spent', () async {
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 60000,
      salarySplitAmount: 0,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
    );
    expenseRepo.setTotal(1, 20000);
    final result = await useCase();
    expect(result.totalSpent, 20000);
    expect(result.remainingBudget, 40000);
  });

  test('remaining budget is negative when over budget', () async {
    final now = DateTime.now();
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 30000,
      salarySplitAmount: 0,
      startDate: now.subtract(const Duration(days: 5)),
      endDate: now.add(const Duration(days: 10)),
    );
    expenseRepo.setTotal(1, 35000);
    final result = await useCase();
    expect(result.remainingBudget, -5000);
    expect(result.isDailyNegative, isTrue); // daysRemaining > 0 so dailyRemaining < 0
  });

  test('total days computed correctly', () async {
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 60000,
      salarySplitAmount: 0,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 30),
    );
    expenseRepo.setTotal(1, 0);
    final result = await useCase();
    expect(result.totalDays, 30); // Jan 1–30 = 30 days
  });

  test('projected total = zero when no spending yet', () async {
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 60000,
      salarySplitAmount: 0,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
    );
    expenseRepo.setTotal(1, 0);
    final result = await useCase();
    expect(result.projectedTotal, 0.0);
    expect(result.isOverBudget, isFalse);
    expect(result.projectedRatio, 0.0);
  });

  test('isOverBudget true when projected exceeds budget', () async {
    // Cycle: budget=30,000. Already spent 20,000 with 2 of 10 days elapsed.
    // Daily rate = 20,000/2 = 10,000. Remaining 8 days.
    // Projected = 20,000 + 10,000*8 = 100,000 → over 30,000
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 30000,
      salarySplitAmount: 0,
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 8)),
    );
    expenseRepo.setTotal(1, 20000);
    final result = await useCase();
    expect(result.isOverBudget, isTrue);
    expect(result.projectedRatio, greaterThan(1.0));
  });

  test('isNearBudget true when projected is 90–100% of budget', () async {
    // Budget=50,000. Spent=27,000 over ~half the cycle.
    // Daily rate = 27,000/15 = 1,800. 15 days remaining.
    // Projected = 27,000 + 1,800*15 = 54,000 → 108% → over, not near.
    // Adjust: spent=22,000 over 15 days → rate=1,467/day.
    // Projected = 22,000 + 1,467*15 = 44,000 → 88% → under (not near).
    // Make it near: spent=24,000 → rate=1,600 → 24,000+24,000=48,000 → 96% of 50,000 → near
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 50000,
      salarySplitAmount: 0,
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 15)),
    );
    expenseRepo.setTotal(1, 24000);
    final result = await useCase();
    // projected ≈ 48,000 which is 96% of 50,000 → isNearBudget
    expect(result.isNearBudget, isTrue);
    expect(result.isOverBudget, isFalse);
  });

  test('hasData is true when active cycle exists with positive budget', () async {
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 50000,
      salarySplitAmount: 5000,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
    );
    expenseRepo.setTotal(1, 10000);
    final result = await useCase();
    expect(result.hasData, isTrue);
  });
}
