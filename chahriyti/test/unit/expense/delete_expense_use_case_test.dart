import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/expense/delete_expense_use_case.dart';
import 'package:chahriyti/domain/entities/expense_entity.dart';
import 'package:chahriyti/domain/entities/financial_cycle_entity.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/repositories/cycle_repository.dart';
import 'package:chahriyti/domain/repositories/expense_repository.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';

// ─── Fakes ──────────────────────────────────────────────────────────────────

class FakeCycleRepository implements CycleRepository {
  FinancialCycleEntity? cycle;

  @override
  Future<FinancialCycleEntity?> getActiveCycle() async => cycle;

  @override
  Future<FinancialCycleEntity?> getCycleById(int id) async => null;
  @override
  Future<FinancialCycleEntity?> getPreviousCycle(int cycleId) async => null;
  @override
  Future<FinancialCycleEntity> createCycle(
          {required DateTime startDate,
          required DateTime endDate,
          required int salaryAmount,
          int salarySplitAmount = 0}) =>
      throw UnimplementedError();
  @override
  Future<void> closeCycle(int id) async {}
  @override
  Future<void> updateCycleSalary(int cycleId, int salaryAmount) async {}
  @override
  Future<void> updateCycleSalarySplit(
      int cycleId, int salarySplitAmount) async {}
  @override
  Future<void> updateCycleSalaryDay(int cycleId, int salaryDay) async {}
  @override
  Future<List<FinancialCycleEntity>> getCycleHistory(
          {int limit = 6, int offset = 0}) async =>
      [];
  @override
  Future<FinancialCycleEntity?> getCycleForMonth(int year, int month) async => null;
}

class FakeExpenseRepository implements ExpenseRepository {
  int? deletedId;

  @override
  Future<void> deleteExpense(int id) async => deletedId = id;

  @override
  Future<ExpenseEntity> addExpense(
          {required int cycleId,
          required String category,
          required String subcategory,
          required String itemName,
          required int amount,
          String? notes,
          bool fromSavings = false,
          int savingsAmount = 0}) =>
      throw UnimplementedError();
  @override
  Future<void> editExpense(ExpenseEntity expense) async {}
  @override
  Future<List<ExpenseEntity>> getAllExpenses({int? limit, int? offset}) async => [];
  @override
  Future<List<ExpenseEntity>> getExpenses(int cycleId,
          {int? limit, int? offset}) async =>
      [];
  @override
  Future<List<ExpenseEntity>> getRecentExpenses(int cycleId,
          {int limit = 5}) async =>
      [];
  @override
  Future<List<ExpenseEntity>> getExpensesByDateRange(
          DateTime startDate, DateTime endDate) async =>
      [];
  @override
  Future<int> getTotalExpenses(int cycleId) async => 0;
  @override
  Future<int> getTotalExpensesFromSavingsForCycle(int cycleId) async => 0;
  @override
  Future<Map<String, int>> getExpensesByCategory(int cycleId) async => {};
}

class FakeSavingsRepository implements SavingsRepository {
  int? reversedWithdrawalForExpenseId;

  @override
  Future<void> deleteWithdrawalByExpenseId(int expenseId) async =>
      reversedWithdrawalForExpenseId = expenseId;

  @override
  Future<int> getSavingsBalance() async => 0;
  @override
  Future<List<SavingsHistoryEntity>> getSavingsHistory(
          {int? limit, int? offset}) async =>
      [];
  @override
  Future<SavingsHistoryEntity> createDeposit(
          {required int amount,
          required String description,
          required int cycleId}) =>
      throw UnimplementedError();
  @override
  Future<SavingsHistoryEntity> createWithdrawal(
          {required int amount,
          required String description,
          int? expenseId,
          int? debtPaymentId,
          int? lendingId}) =>
      throw UnimplementedError();
  @override
  Future<void> deleteWithdrawalByDebtPaymentId(int debtPaymentId) async {}
  @override
  Future<void> deleteWithdrawalByLendingId(int lendingId) async {}
  @override
  Future<void> updateWithdrawalAmountByExpenseId(
      int expenseId, int newAmount) async {}
  @override
  Future<void> updateWithdrawalAmountByDebtPaymentId(
      int debtPaymentId, int newAmount) async {}
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

FinancialCycleEntity _activeCycle({int id = 1}) => FinancialCycleEntity(
      id: id,
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 1, 31),
      salaryAmount: 100000,
      isActive: true,
    );

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeExpenseRepository expenseRepo;
  late FakeSavingsRepository savingsRepo;
  late DeleteExpenseUseCase useCase;

  setUp(() {
    cycleRepo = FakeCycleRepository();
    expenseRepo = FakeExpenseRepository();
    savingsRepo = FakeSavingsRepository();
    useCase = DeleteExpenseUseCase(expenseRepo, cycleRepo, savingsRepo);
  });

  test('deletes expense and reverses savings withdrawal on success', () async {
    cycleRepo.cycle = _activeCycle(id: 1);

    await useCase.call(expenseId: 42, cycleId: 1);

    expect(expenseRepo.deletedId, 42);
    expect(savingsRepo.reversedWithdrawalForExpenseId, 42);
  });

  test('throws StateError when no active cycle', () async {
    cycleRepo.cycle = null;

    expect(
      () => useCase.call(expenseId: 42, cycleId: 1),
      throwsA(isA<StateError>()),
    );
    expect(expenseRepo.deletedId, isNull);
  });

  test('throws StateError when cycleId does not match active cycle', () async {
    cycleRepo.cycle = _activeCycle(id: 2);

    expect(
      () => useCase.call(expenseId: 42, cycleId: 1),
      throwsA(isA<StateError>()),
    );
    expect(expenseRepo.deletedId, isNull);
  });

  test('deletes expense without savings reversal when savingsRepo is null',
      () async {
    cycleRepo.cycle = _activeCycle(id: 1);
    final useCaseNoSavings =
        DeleteExpenseUseCase(expenseRepo, cycleRepo); // no savingsRepo

    await useCaseNoSavings.call(expenseId: 99, cycleId: 1);

    expect(expenseRepo.deletedId, 99);
    expect(savingsRepo.reversedWithdrawalForExpenseId, isNull);
  });
}
