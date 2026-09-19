import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_savings_rate_use_case.dart';

import 'fakes.dart';

void main() {
  late FakeCycleRepository cycleRepo;
  late GetSavingsRateUseCase useCase;

  setUp(() {
    cycleRepo = FakeCycleRepository();
    useCase = GetSavingsRateUseCase(cycleRepository: cycleRepo);
  });

  test('returns empty when no active cycle', () async {
    cycleRepo.activeCycle = null;
    final result = await useCase();
    expect(result.salaryAmount, 0);
    expect(result.rate, 0);
  });

  test('returns empty when salary is zero', () async {
    cycleRepo.activeCycle = makeCycle(id: 1, salaryAmount: 0, salarySplitAmount: 0);
    final result = await useCase();
    expect(result, SavingsRateResult.empty);
  });

  test('correct rate calculation', () async {
    cycleRepo.activeCycle = makeCycle(id: 1, salaryAmount: 50000, salarySplitAmount: 10000);
    cycleRepo.history = [];
    final result = await useCase();
    expect(result.rate, closeTo(20.0, 0.01)); // 10000/50000 * 100
    expect(result.salarySplitAmount, 10000);
    expect(result.salaryAmount, 50000);
  });

  test('zero split gives 0% rate', () async {
    cycleRepo.activeCycle = makeCycle(id: 1, salaryAmount: 50000, salarySplitAmount: 0);
    cycleRepo.history = [];
    final result = await useCase();
    expect(result.rate, 0.0);
  });

  test('100% split gives 100% rate', () async {
    cycleRepo.activeCycle = makeCycle(id: 1, salaryAmount: 50000, salarySplitAmount: 50000);
    cycleRepo.history = [];
    final result = await useCase();
    expect(result.rate, closeTo(100.0, 0.01));
  });

  test('no comparison when no closed cycles', () async {
    cycleRepo.activeCycle = makeCycle(id: 1, salaryAmount: 50000, salarySplitAmount: 10000);
    cycleRepo.history = [makeCycle(id: 1, isActive: true)];
    final result = await useCase();
    expect(result.hasComparison, isFalse);
    expect(result.previousRate, isNull);
    expect(result.rateDelta, isNull);
  });

  test('positive delta when rate improved vs last cycle', () async {
    cycleRepo.activeCycle =
        makeCycle(id: 2, salaryAmount: 50000, salarySplitAmount: 15000);
    cycleRepo.history = [
      makeCycle(id: 2, isActive: true, startDate: DateTime(2024, 2, 1)),
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1),
          salaryAmount: 50000, salarySplitAmount: 10000),
    ];
    final result = await useCase();
    // current=30%, previous=20%, delta=+10%
    expect(result.rate, closeTo(30.0, 0.01));
    expect(result.previousRate, closeTo(20.0, 0.01));
    expect(result.rateDelta, closeTo(10.0, 0.01));
    expect(result.isDeltaPositive, isTrue);
    expect(result.hasComparison, isTrue);
  });

  test('negative delta when rate dropped vs last cycle', () async {
    cycleRepo.activeCycle =
        makeCycle(id: 2, salaryAmount: 50000, salarySplitAmount: 5000);
    cycleRepo.history = [
      makeCycle(id: 2, isActive: true, startDate: DateTime(2024, 2, 1)),
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1),
          salaryAmount: 50000, salarySplitAmount: 20000),
    ];
    final result = await useCase();
    // current=10%, previous=40%, delta=-30%
    expect(result.rateDelta, closeTo(-30.0, 0.01));
    expect(result.isDeltaPositive, isFalse);
  });

  test('zero delta when rate unchanged', () async {
    cycleRepo.activeCycle =
        makeCycle(id: 2, salaryAmount: 50000, salarySplitAmount: 10000);
    cycleRepo.history = [
      makeCycle(id: 2, isActive: true, startDate: DateTime(2024, 2, 1)),
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1),
          salaryAmount: 50000, salarySplitAmount: 10000),
    ];
    final result = await useCase();
    expect(result.rateDelta, closeTo(0.0, 0.01));
    expect(result.isDeltaPositive, isTrue); // 0 is treated as positive
  });

  test('picks most recent closed cycle for comparison', () async {
    cycleRepo.activeCycle =
        makeCycle(id: 3, salaryAmount: 50000, salarySplitAmount: 10000);
    cycleRepo.history = [
      makeCycle(id: 3, isActive: true, startDate: DateTime(2024, 3, 1)),
      // Most recent closed
      makeCycle(id: 2, isActive: false, startDate: DateTime(2024, 2, 1),
          salaryAmount: 50000, salarySplitAmount: 5000),
      // Older closed
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1),
          salaryAmount: 50000, salarySplitAmount: 25000),
    ];
    final result = await useCase();
    // Should compare against cycle 2 (10%), not cycle 1 (50%)
    expect(result.previousRate, closeTo(10.0, 0.01));
  });

  test('ignores closed cycles with zero salary in comparison', () async {
    cycleRepo.activeCycle =
        makeCycle(id: 2, salaryAmount: 50000, salarySplitAmount: 10000);
    cycleRepo.history = [
      makeCycle(id: 2, isActive: true, startDate: DateTime(2024, 2, 1)),
      // zero salary — should be excluded
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1),
          salaryAmount: 0, salarySplitAmount: 0),
    ];
    final result = await useCase();
    expect(result.hasComparison, isFalse);
  });
}
