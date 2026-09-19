import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_income_growth_use_case.dart';

import 'fakes.dart';

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeIncomeRepository incomeRepo;
  late GetIncomeGrowthUseCase useCase;

  setUp(() {
    cycleRepo = FakeCycleRepository();
    incomeRepo = FakeIncomeRepository();
    useCase = GetIncomeGrowthUseCase(
      cycleRepository: cycleRepo,
      incomeRepository: incomeRepo,
    );
  });

  test('returns empty when no active cycle', () async {
    cycleRepo.activeCycle = null;
    final result = await useCase();
    expect(result.currentIncome, 0);
    expect(result.hasComparison, isFalse);
  });

  test('no comparison when no closed cycles', () async {
    cycleRepo.activeCycle = makeCycle(id: 1, salaryAmount: 50000);
    cycleRepo.history = [makeCycle(id: 1, isActive: true)];
    incomeRepo.setTotal(1, 5000);

    final result = await useCase();
    expect(result.currentIncome, 55000); // 50000 + 5000
    expect(result.hasComparison, isFalse);
  });

  test('positive growth percent', () async {
    cycleRepo.activeCycle = makeCycle(id: 2, salaryAmount: 60000);
    cycleRepo.history = [
      makeCycle(id: 2, isActive: true, startDate: DateTime(2024, 2, 1)),
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1), salaryAmount: 50000),
    ];
    incomeRepo.setTotal(2, 0); // current: 60000 total
    incomeRepo.setTotal(1, 0); // previous: 50000 total

    final result = await useCase();
    expect(result.currentIncome, 60000);
    expect(result.previousIncome, 50000);
    // growth = (60000 - 50000) / 50000 * 100 = 20%
    expect(result.growthPercent, closeTo(20.0, 0.01));
    expect(result.isPositive, isTrue);
    expect(result.hasComparison, isTrue);
  });

  test('negative growth percent', () async {
    cycleRepo.activeCycle = makeCycle(id: 2, salaryAmount: 40000);
    cycleRepo.history = [
      makeCycle(id: 2, isActive: true, startDate: DateTime(2024, 2, 1)),
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1), salaryAmount: 50000),
    ];
    incomeRepo.setTotal(2, 0);
    incomeRepo.setTotal(1, 0);

    final result = await useCase();
    // growth = (40000 - 50000) / 50000 * 100 = -20%
    expect(result.growthPercent, closeTo(-20.0, 0.01));
    expect(result.isPositive, isFalse);
  });

  test('additional income is included in total', () async {
    cycleRepo.activeCycle = makeCycle(id: 2, salaryAmount: 50000);
    cycleRepo.history = [
      makeCycle(id: 2, isActive: true, startDate: DateTime(2024, 2, 1)),
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1), salaryAmount: 50000),
    ];
    incomeRepo.setTotal(2, 20000); // current: 50000 + 20000 = 70000
    incomeRepo.setTotal(1, 10000); // previous: 50000 + 10000 = 60000

    final result = await useCase();
    expect(result.currentIncome, 70000);
    expect(result.previousIncome, 60000);
    expect(result.growthPercent, closeTo(16.67, 0.01));
  });

  test('zero previous income does not divide by zero', () async {
    cycleRepo.activeCycle = makeCycle(id: 2, salaryAmount: 50000);
    cycleRepo.history = [
      makeCycle(id: 2, isActive: true, startDate: DateTime(2024, 2, 1)),
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1), salaryAmount: 0),
    ];
    incomeRepo.setTotal(2, 0);
    incomeRepo.setTotal(1, 0);

    final result = await useCase();
    expect(result.growthPercent, 0.0); // safe fallback
  });

  test('picks most recent closed cycle for comparison', () async {
    cycleRepo.activeCycle = makeCycle(id: 3, salaryAmount: 50000);
    cycleRepo.history = [
      makeCycle(id: 3, isActive: true, startDate: DateTime(2024, 3, 1)),
      makeCycle(id: 2, isActive: false, startDate: DateTime(2024, 2, 1), salaryAmount: 45000),
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1), salaryAmount: 30000),
    ];
    incomeRepo.setTotal(3, 0);
    incomeRepo.setTotal(2, 0);
    incomeRepo.setTotal(1, 0);

    final result = await useCase();
    // should compare against cycle 2 (most recent closed), not cycle 1
    expect(result.previousIncome, 45000);
  });
}
