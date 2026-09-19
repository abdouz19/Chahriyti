import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_income_vs_spending_use_case.dart';

import 'fakes.dart';

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeExpenseRepository expenseRepo;
  late FakeIncomeRepository incomeRepo;
  late GetIncomeVsSpendingUseCase useCase;

  setUp(() {
    cycleRepo = FakeCycleRepository();
    expenseRepo = FakeExpenseRepository();
    incomeRepo = FakeIncomeRepository();
    useCase = GetIncomeVsSpendingUseCase(
      cycleRepository: cycleRepo,
      expenseRepository: expenseRepo,
      incomeRepository: incomeRepo,
    );
  });

  test('returns empty when no closed cycles', () async {
    cycleRepo.history = [makeCycle(id: 1, isActive: true)];
    final result = await useCase();
    expect(result, isEmpty);
  });

  test('income = salary + additional income', () async {
    cycleRepo.history = [
      makeCycle(id: 1, isActive: false, salaryAmount: 50000, startDate: DateTime(2024, 1, 1)),
    ];
    incomeRepo.setTotal(1, 15000);
    expenseRepo.setTotal(1, 30000);

    final result = await useCase();
    expect(result.length, 1);
    expect(result[0].income, 65000); // 50000 + 15000
    expect(result[0].spending, 30000);
  });

  test('income with no additional income equals salary only', () async {
    cycleRepo.history = [
      makeCycle(id: 1, isActive: false, salaryAmount: 50000, startDate: DateTime(2024, 1, 1)),
    ];
    incomeRepo.setTotal(1, 0);
    expenseRepo.setTotal(1, 40000);

    final result = await useCase();
    expect(result[0].income, 50000);
  });

  test('surplus = income - spending', () async {
    cycleRepo.history = [
      makeCycle(id: 1, isActive: false, salaryAmount: 60000, startDate: DateTime(2024, 1, 1)),
    ];
    incomeRepo.setTotal(1, 10000);
    expenseRepo.setTotal(1, 45000);

    final result = await useCase();
    expect(result[0].surplus, 25000); // 70000 - 45000
  });

  test('sorted chronologically oldest first', () async {
    cycleRepo.history = [
      makeCycle(id: 2, isActive: false, salaryAmount: 50000, startDate: DateTime(2024, 2, 1)),
      makeCycle(id: 1, isActive: false, salaryAmount: 50000, startDate: DateTime(2024, 1, 1)),
    ];
    incomeRepo.setTotal(1, 0);
    incomeRepo.setTotal(2, 0);
    expenseRepo.setTotal(1, 10000);
    expenseRepo.setTotal(2, 20000);

    final result = await useCase();
    expect(result[0].month, DateTime(2024, 1, 1));
    expect(result[1].month, DateTime(2024, 2, 1));
  });

  test('active cycle excluded', () async {
    cycleRepo.history = [
      makeCycle(id: 1, isActive: false, salaryAmount: 50000, startDate: DateTime(2024, 1, 1)),
      makeCycle(id: 2, isActive: true, salaryAmount: 50000, startDate: DateTime(2024, 2, 1)),
    ];
    incomeRepo.setTotal(1, 0);
    incomeRepo.setTotal(2, 5000);
    expenseRepo.setTotal(1, 10000);
    expenseRepo.setTotal(2, 99999);

    final result = await useCase();
    expect(result.length, 1);
    expect(result[0].spending, 10000);
  });

  test('multiple closed cycles all included', () async {
    cycleRepo.history = [
      makeCycle(id: 1, isActive: false, salaryAmount: 50000, startDate: DateTime(2024, 1, 1)),
      makeCycle(id: 2, isActive: false, salaryAmount: 55000, startDate: DateTime(2024, 2, 1)),
      makeCycle(id: 3, isActive: false, salaryAmount: 55000, startDate: DateTime(2024, 3, 1)),
    ];
    for (final id in [1, 2, 3]) {
      incomeRepo.setTotal(id, 0);
      expenseRepo.setTotal(id, id * 10000);
    }
    final result = await useCase();
    expect(result.length, 3);
  });
}
