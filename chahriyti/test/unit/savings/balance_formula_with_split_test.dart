import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/savings/deposit_cycle_savings_use_case.dart';
import 'package:chahriyti/domain/entities/financial_cycle_entity.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/repositories/cycle_repository.dart';
import 'package:chahriyti/domain/repositories/debt_repository.dart';
import 'package:chahriyti/domain/repositories/expense_repository.dart';
import 'package:chahriyti/domain/repositories/income_repository.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';

class FakeCycleRepository implements CycleRepository {
  FinancialCycleEntity? activeCycle;

  @override
  Future<FinancialCycleEntity?> getActiveCycle() async => activeCycle;
  @override
  Future<FinancialCycleEntity?> getCycleById(int id) async => activeCycle;

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeExpenseRepository implements ExpenseRepository {
  int totalExpenses = 0;
  @override
  Future<int> getTotalExpenses(int cycleId) async => totalExpenses;
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeIncomeRepository implements IncomeRepository {
  int totalIncome = 0;
  @override
  Future<int> getTotalIncomeForCycle(int cycleId) async => totalIncome;
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeDebtRepository implements DebtRepository {
  int totalPayments = 0;
  int totalDebtsCreated = 0;
  @override
  Future<int> getTotalDebtPaymentsForCycle(int cycleId) async => totalPayments;
  @override
  Future<int> getTotalDebtsCreatedForCycle(int cycleId) async => totalDebtsCreated;
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeSavingsRepository implements SavingsRepository {
  SavingsHistoryEntity? lastDeposit;

  @override
  Future<SavingsHistoryEntity> createDeposit({
    required int amount,
    required String description,
    required int cycleId,
  }) async {
    lastDeposit = SavingsHistoryEntity(
      id: 1,
      type: SavingsTransactionType.deposit,
      amount: amount,
      description: description,
      relatedCycleId: cycleId,
      createdAt: DateTime.now(),
    );
    return lastDeposit!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeExpenseRepository expenseRepo;
  late FakeIncomeRepository incomeRepo;
  late FakeDebtRepository debtRepo;
  late FakeSavingsRepository savingsRepo;
  late DepositCycleSavingsUseCase useCase;

  setUp(() {
    cycleRepo = FakeCycleRepository();
    expenseRepo = FakeExpenseRepository();
    incomeRepo = FakeIncomeRepository();
    debtRepo = FakeDebtRepository();
    savingsRepo = FakeSavingsRepository();
    useCase = DepositCycleSavingsUseCase(
      cycleRepository: cycleRepo,
      expenseRepository: expenseRepo,
      incomeRepository: incomeRepo,
      debtRepository: debtRepo,
      savingsRepository: savingsRepo,
    );
  });

  FinancialCycleEntity makeCycle({
    int salary = 60000,
    int salarySplitAmount = 0,
  }) =>
      FinancialCycleEntity(
        id: 1,
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 7, 1),
        salaryAmount: salary,
        salarySplitAmount: salarySplitAmount,
        isActive: true,
      );

  test('balance formula subtracts salarySplitAmount', () async {
    // salary=60000, split=40000, income=5000, expenses=10000, debt=5000
    // remaining = 60000 - 40000 + 5000 - 10000 - 5000 = 10000
    cycleRepo.activeCycle = makeCycle(salary: 60000, salarySplitAmount: 40000);
    incomeRepo.totalIncome = 5000;
    expenseRepo.totalExpenses = 10000;
    debtRepo.totalPayments = 5000;

    final result = await useCase(1);

    expect(result, isNotNull);
    expect(result!.amount, 10000);
  });

  test('zero split preserves original formula', () async {
    // salary=50000, split=0, income=5000, expenses=30000, debt=10000
    // remaining = 50000 - 0 + 5000 - 30000 - 10000 = 15000
    cycleRepo.activeCycle = makeCycle(salary: 50000, salarySplitAmount: 0);
    incomeRepo.totalIncome = 5000;
    expenseRepo.totalExpenses = 30000;
    debtRepo.totalPayments = 10000;

    final result = await useCase(1);

    expect(result, isNotNull);
    expect(result!.amount, 15000);
  });

  test('full salary split with expenses creates no deposit', () async {
    // salary=60000, split=60000, income=0, expenses=0, debt=0
    // remaining = 60000 - 60000 + 0 - 0 - 0 = 0
    cycleRepo.activeCycle = makeCycle(salary: 60000, salarySplitAmount: 60000);
    incomeRepo.totalIncome = 0;
    expenseRepo.totalExpenses = 0;
    debtRepo.totalPayments = 0;

    final result = await useCase(1);

    expect(result, isNull);
  });

  test('split with overspending creates no deposit', () async {
    // salary=60000, split=40000, income=0, expenses=25000, debt=0
    // remaining = 60000 - 40000 + 0 - 25000 - 0 = -5000
    cycleRepo.activeCycle = makeCycle(salary: 60000, salarySplitAmount: 40000);
    incomeRepo.totalIncome = 0;
    expenseRepo.totalExpenses = 25000;
    debtRepo.totalPayments = 0;

    final result = await useCase(1);

    expect(result, isNull);
  });
}
