import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_income_breakdown_use_case.dart';

import 'fakes.dart';

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeIncomeRepository incomeRepo;
  late GetIncomeBreakdownUseCase useCase;

  setUp(() {
    cycleRepo = FakeCycleRepository();
    incomeRepo = FakeIncomeRepository();
    useCase = GetIncomeBreakdownUseCase(
      cycleRepository: cycleRepo,
      incomeRepository: incomeRepo,
    );
  });

  test('returns empty when no active cycle', () async {
    cycleRepo.activeCycle = null;
    final result = await useCase();
    expect(result.amounts, isEmpty);
    expect(result.total, 0);
  });

  test('returns empty when no additional incomes', () async {
    cycleRepo.activeCycle = makeCycle(id: 1);
    incomeRepo.setIncomes(1, []);
    final result = await useCase();
    expect(result.amounts, isEmpty);
  });

  test('groups same source and sums amounts', () async {
    cycleRepo.activeCycle = makeCycle(id: 1);
    incomeRepo.setIncomes(1, [
      makeIncome(id: 1, cycleId: 1, description: 'Progix', amount: 30000),
      makeIncome(id: 2, cycleId: 1, description: 'Progix', amount: 20000),
    ]);
    final result = await useCase();
    expect(result.amounts['Progix'], 50000);
    expect(result.total, 50000);
  });

  test('multiple sources computed independently', () async {
    cycleRepo.activeCycle = makeCycle(id: 1);
    incomeRepo.setIncomes(1, [
      makeIncome(id: 1, cycleId: 1, description: 'Progix', amount: 50000),
      makeIncome(id: 2, cycleId: 1, description: 'Freelance', amount: 20000),
    ]);
    final result = await useCase();
    expect(result.amounts['Progix'], 50000);
    expect(result.amounts['Freelance'], 20000);
    expect(result.total, 70000);
  });

  test('percentages are correct', () async {
    cycleRepo.activeCycle = makeCycle(id: 1);
    incomeRepo.setIncomes(1, [
      makeIncome(id: 1, cycleId: 1, description: 'A', amount: 75000),
      makeIncome(id: 2, cycleId: 1, description: 'B', amount: 25000),
    ]);
    final result = await useCase();
    expect(result.percentages['A'], closeTo(75.0, 0.01));
    expect(result.percentages['B'], closeTo(25.0, 0.01));
  });

  test('sorted by amount descending', () async {
    cycleRepo.activeCycle = makeCycle(id: 1);
    incomeRepo.setIncomes(1, [
      makeIncome(id: 1, cycleId: 1, description: 'Small', amount: 5000),
      makeIncome(id: 2, cycleId: 1, description: 'Large', amount: 80000),
      makeIncome(id: 3, cycleId: 1, description: 'Mid', amount: 30000),
    ]);
    final result = await useCase();
    final keys = result.amounts.keys.toList();
    expect(keys[0], 'Large');
    expect(keys[1], 'Mid');
    expect(keys[2], 'Small');
  });

  test('excludes رصيد أولي (with hamza)', () async {
    cycleRepo.activeCycle = makeCycle(id: 1);
    incomeRepo.setIncomes(1, [
      makeIncome(id: 1, cycleId: 1, description: 'رصيد أولي', amount: 100000),
      makeIncome(id: 2, cycleId: 1, description: 'Progix', amount: 20000),
    ]);
    final result = await useCase();
    expect(result.amounts.containsKey('رصيد أولي'), isFalse);
    expect(result.amounts['Progix'], 20000);
    expect(result.total, 20000);
  });

  test('excludes رصيد اولي (without hamza)', () async {
    cycleRepo.activeCycle = makeCycle(id: 1);
    incomeRepo.setIncomes(1, [
      makeIncome(id: 1, cycleId: 1, description: 'رصيد اولي', amount: 100000),
      makeIncome(id: 2, cycleId: 1, description: 'Freelance', amount: 15000),
    ]);
    final result = await useCase();
    expect(result.amounts.containsKey('رصيد اولي'), isFalse);
    expect(result.total, 15000);
  });

  test('trims whitespace from descriptions', () async {
    cycleRepo.activeCycle = makeCycle(id: 1);
    incomeRepo.setIncomes(1, [
      makeIncome(id: 1, cycleId: 1, description: '  Progix  ', amount: 30000),
      makeIncome(id: 2, cycleId: 1, description: 'Progix', amount: 20000),
    ]);
    final result = await useCase();
    expect(result.amounts['Progix'], 50000);
    expect(result.amounts.length, 1);
  });

  test('ignores empty description entries', () async {
    cycleRepo.activeCycle = makeCycle(id: 1);
    incomeRepo.setIncomes(1, [
      makeIncome(id: 1, cycleId: 1, description: '', amount: 5000),
      makeIncome(id: 2, cycleId: 1, description: '   ', amount: 3000),
      makeIncome(id: 3, cycleId: 1, description: 'Progix', amount: 10000),
    ]);
    final result = await useCase();
    expect(result.amounts.length, 1);
    expect(result.amounts['Progix'], 10000);
  });
}
