import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/expense/edit_expense_use_case.dart';
import 'package:chahriyti/domain/entities/expense_entity.dart';
import 'package:chahriyti/domain/entities/financial_cycle_entity.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/repositories/cycle_repository.dart';
import 'package:chahriyti/domain/repositories/expense_repository.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';

class FakeExpenseRepository extends Fake implements ExpenseRepository {
  ExpenseEntity? saved;

  @override
  Future<void> editExpense(ExpenseEntity expense) async => saved = expense;
}

class FakeCycleRepository extends Fake implements CycleRepository {
  @override
  Future<FinancialCycleEntity?> getActiveCycle() async => FinancialCycleEntity(
        id: 1,
        startDate: DateTime(2026, 10, 1),
        endDate: DateTime(2026, 10, 31),
        salaryAmount: 80000,
        isActive: true,
      );
}

class FakeSavingsRepository extends Fake implements SavingsRepository {
  int balance = 100000;
  int? withdrawalAmount; // amount currently linked to the expense

  SavingsHistoryEntity _entry(int amount) => SavingsHistoryEntity(
        id: 1,
        type: SavingsTransactionType.withdrawal,
        amount: amount,
        description: '',
        createdAt: DateTime(2026, 10, 7),
      );

  @override
  Future<int> getSavingsBalance() async => balance;

  @override
  Future<SavingsHistoryEntity> createWithdrawal({
    required int amount,
    required String description,
    int? expenseId,
    int? debtPaymentId,
    int? lendingId,
  }) async {
    withdrawalAmount = amount;
    return _entry(amount);
  }

  @override
  Future<void> updateWithdrawalAmountByExpenseId(
          int expenseId, int newAmount) async =>
      withdrawalAmount = newAmount;

  @override
  Future<void> deleteWithdrawalByExpenseId(int expenseId) async =>
      withdrawalAmount = null;
}

void main() {
  late FakeExpenseRepository expenses;
  late FakeSavingsRepository savings;
  late EditExpenseUseCase useCase;

  ExpenseEntity expense({
    required int amount,
    int savingsAmount = 0,
    bool fromSavings = false,
    int cycleId = 1,
  }) =>
      ExpenseEntity(
        id: 9,
        cycleId: cycleId,
        category: 'food',
        subcategory: '',
        itemName: 'x',
        amount: amount,
        fromSavings: fromSavings,
        savingsAmount: savingsAmount,
        createdAt: DateTime(2026, 10, 7),
        updatedAt: DateTime(2026, 10, 7),
      );

  setUp(() {
    expenses = FakeExpenseRepository();
    savings = FakeSavingsRepository()..withdrawalAmount = null;
    useCase = EditExpenseUseCase(expenses, FakeCycleRepository(), savings);
  });

  test('raising a savings-paid expense charges savings the new amount',
      () async {
    savings.withdrawalAmount = 5000;
    await useCase(expense(amount: 8000, savingsAmount: 5000, fromSavings: true),
        originalSavingsAmount: 5000);
    expect(savings.withdrawalAmount, 8000);
    expect(expenses.saved!.savingsAmount, 8000);
  });

  test('lowering a savings-paid expense refunds savings', () async {
    savings.withdrawalAmount = 5000;
    await useCase(expense(amount: 3000, savingsAmount: 5000, fromSavings: true),
        originalSavingsAmount: 5000);
    expect(savings.withdrawalAmount, 3000);
  });

  test('lowering a split expense below its savings part caps it', () async {
    savings.withdrawalAmount = 4000;
    await useCase(expense(amount: 3000, savingsAmount: 4000),
        originalSavingsAmount: 4000);
    expect(savings.withdrawalAmount, 3000);
    // Balance part can never go negative
    final saved = expenses.saved!;
    expect(saved.amount - saved.savingsAmount, 0);
  });

  test('savings increase beyond savings balance is refused', () async {
    savings.balance = 1000;
    savings.withdrawalAmount = 5000;
    await expectLater(
      useCase(expense(amount: 8000, savingsAmount: 5000, fromSavings: true),
          originalSavingsAmount: 5000),
      throwsA(isA<StateError>()),
    );
    expect(expenses.saved, isNull);
  });

  test('past-cycle expense is refused', () async {
    await expectLater(
      useCase(expense(amount: 1000, cycleId: 99)),
      throwsA(isA<StateError>()),
    );
  });
}
