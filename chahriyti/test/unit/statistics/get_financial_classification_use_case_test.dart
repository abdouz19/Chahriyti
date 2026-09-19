import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_financial_classification_use_case.dart';

import 'fakes.dart';

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeExpenseRepository expenseRepo;
  late GetFinancialClassificationUseCase useCase;

  // A 30-day cycle, 10 days elapsed (day 10 of 30)
  final start = DateTime(2024, 1, 1);
  final end = DateTime(2024, 1, 30);

  setUp(() {
    cycleRepo = FakeCycleRepository();
    expenseRepo = FakeExpenseRepository();
    useCase = GetFinancialClassificationUseCase(
      cycleRepository: cycleRepo,
      expenseRepository: expenseRepo,
    );
  });

  test('returns null when no active cycle', () async {
    cycleRepo.activeCycle = null;
    final result = await useCase();
    expect(result, isNull);
  });

  test('returns null when salary is zero', () async {
    cycleRepo.activeCycle =
        makeCycle(id: 1, salaryAmount: 0, startDate: start, endDate: end);
    expenseRepo.setTotal(1, 0);
    final result = await useCase();
    expect(result, isNull);
  });

  // savingsRatio = (50000 - 10000) / 50000 = 0.80 → legendary (> 0.30)
  test('legendary when spent < 70% of salary', () async {
    cycleRepo.activeCycle =
        makeCycle(id: 1, salaryAmount: 50000, startDate: start, endDate: end);
    expenseRepo.setTotal(1, 10000);
    final result = await useCase();
    expect(result, FinancialTier.legendary);
  });

  // savingsRatio = (50000 - 32000) / 50000 = 0.36 → legendary
  // savingsRatio = (50000 - 40000) / 50000 = 0.20 → smart (> 0.15)
  test('smart when savingsRatio between 0.15 and 0.30', () async {
    cycleRepo.activeCycle =
        makeCycle(id: 1, salaryAmount: 50000, startDate: start, endDate: end);
    expenseRepo.setTotal(1, 40000); // ratio = 0.20
    final result = await useCase();
    expect(result, FinancialTier.smart);
  });

  // savingsRatio = (50000 - 46000) / 50000 = 0.08 → balanced (> 0.05)
  test('balanced when savingsRatio between 0.05 and 0.15', () async {
    cycleRepo.activeCycle =
        makeCycle(id: 1, salaryAmount: 50000, startDate: start, endDate: end);
    expenseRepo.setTotal(1, 46000);
    final result = await useCase();
    expect(result, FinancialTier.balanced);
  });

  // savingsRatio = (50000 - 49000) / 50000 = 0.02 → spender (>= 0)
  test('spender when savingsRatio between 0 and 0.05', () async {
    cycleRepo.activeCycle =
        makeCycle(id: 1, salaryAmount: 50000, startDate: start, endDate: end);
    expenseRepo.setTotal(1, 49000);
    final result = await useCase();
    expect(result, FinancialTier.spender);
  });

  // savingsRatio < 0 but cycle > 50% elapsed → danger
  test('danger when negative balance and cycle past halfway', () async {
    // Cycle was 30 days; we simulate it's near end by using a past start
    final pastStart = DateTime.now().subtract(const Duration(days: 25));
    final pastEnd = DateTime.now().add(const Duration(days: 5));
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 50000,
      startDate: pastStart,
      endDate: pastEnd,
    );
    expenseRepo.setTotal(1, 60000); // overspent → negative ratio
    final result = await useCase();
    expect(result, FinancialTier.danger);
  });

  // savingsRatio < 0 AND elapsed < 50% of cycle → earlyBankrupt
  test('earlyBankrupt when negative balance early in cycle', () async {
    final recentStart = DateTime.now().subtract(const Duration(days: 3));
    final farEnd = DateTime.now().add(const Duration(days: 27));
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 50000,
      startDate: recentStart,
      endDate: farEnd,
    );
    expenseRepo.setTotal(1, 60000); // overspent early
    final result = await useCase();
    expect(result, FinancialTier.earlyBankrupt);
  });
}
