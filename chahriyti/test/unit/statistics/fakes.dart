import 'package:chahriyti/domain/entities/additional_income_entity.dart';
import 'package:chahriyti/domain/entities/custom_category_entity.dart';
import 'package:chahriyti/domain/entities/expense_entity.dart';
import 'package:chahriyti/domain/entities/financial_cycle_entity.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/repositories/custom_category_repository.dart';
import 'package:chahriyti/domain/repositories/cycle_repository.dart';
import 'package:chahriyti/domain/repositories/expense_repository.dart';
import 'package:chahriyti/domain/repositories/income_repository.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

FinancialCycleEntity makeCycle({
  int id = 1,
  bool isActive = true,
  int salaryAmount = 50000,
  int salarySplitAmount = 0,
  DateTime? startDate,
  DateTime? endDate,
}) {
  final start = startDate ?? DateTime(2024, 1, 1);
  final end = endDate ?? DateTime(2024, 1, 30);
  return FinancialCycleEntity(
    id: id,
    startDate: start,
    endDate: end,
    salaryAmount: salaryAmount,
    salarySplitAmount: salarySplitAmount,
    isActive: isActive,
  );
}

AdditionalIncomeEntity makeIncome({
  int id = 1,
  int cycleId = 1,
  required String description,
  required int amount,
}) =>
    AdditionalIncomeEntity(
      id: id,
      cycleId: cycleId,
      description: description,
      amount: amount,
      createdAt: DateTime(2024, 1, 10),
    );

// ─── Fake repositories ────────────────────────────────────────────────────────

class FakeCycleRepository implements CycleRepository {
  FinancialCycleEntity? activeCycle;
  List<FinancialCycleEntity> history = [];

  @override
  Future<FinancialCycleEntity?> getActiveCycle() async => activeCycle;

  @override
  Future<List<FinancialCycleEntity>> getCycleHistory({
    int limit = 6,
    int offset = 0,
  }) async =>
      history.take(limit).toList();

  @override
  Future<FinancialCycleEntity?> getCycleById(int id) async =>
      history.where((c) => c.id == id).firstOrNull ?? activeCycle;

  @override
  Future<FinancialCycleEntity?> getPreviousCycle(int cycleId) async => null;
  @override
  Future<FinancialCycleEntity> createCycle({
    required DateTime startDate,
    required DateTime endDate,
    required int salaryAmount,
    int salarySplitAmount = 0,
  }) async =>
      throw UnimplementedError();
  @override
  Future<void> closeCycle(int id) async {}
  @override
  Future<void> updateCycleSalary(int cycleId, int salaryAmount) async {}
  @override
  Future<void> updateCycleSalarySplit(int cycleId, int salarySplitAmount) async {}
  @override
  Future<void> updateCycleSalaryDay(int cycleId, int salaryDay) async {}
  @override
  Future<FinancialCycleEntity?> getCycleForMonth(int year, int month) async => null;
}

class FakeExpenseRepository implements ExpenseRepository {
  /// cycleId → total expenses
  final Map<int, int> _totals = {};
  /// cycleId → category → amount
  final Map<int, Map<String, int>> _byCategory = {};
  /// cycleId → list of expenses
  final Map<int, List<ExpenseEntity>> _expenses = {};

  void setTotal(int cycleId, int total) => _totals[cycleId] = total;
  void setByCategory(int cycleId, Map<String, int> data) => _byCategory[cycleId] = data;
  void setExpenses(int cycleId, List<ExpenseEntity> data) => _expenses[cycleId] = data;

  @override
  Future<int> getTotalExpenses(int cycleId) async => _totals[cycleId] ?? 0;

  @override
  Future<Map<String, int>> getExpensesByCategory(int cycleId) async =>
      _byCategory[cycleId] ?? {};

  @override
  Future<List<ExpenseEntity>> getExpenses(int cycleId, {int? limit, int? offset}) async =>
      _expenses[cycleId] ?? [];

  @override
  Future<ExpenseEntity> addExpense({
    required int cycleId,
    required String category,
    required String subcategory,
    required String itemName,
    required int amount,
    String? notes,
    bool fromSavings = false,
    int savingsAmount = 0,
  }) async =>
      throw UnimplementedError();
  @override
  Future<void> editExpense(ExpenseEntity expense) async {}
  @override
  Future<void> deleteExpense(int id) async {}
  @override
  Future<List<ExpenseEntity>> getRecentExpenses(int cycleId, {int limit = 5}) async => [];
  @override
  Future<List<ExpenseEntity>> getAllExpenses({int? limit, int? offset}) async => [];
  @override
  Future<List<ExpenseEntity>> getExpensesByDateRange(
          DateTime startDate, DateTime endDate) async =>
      [];
  @override
  Future<int> getTotalExpensesFromSavingsForCycle(int cycleId) async => 0;
}

class FakeIncomeRepository implements IncomeRepository {
  /// cycleId → total additional income
  final Map<int, int> _totals = {};
  /// cycleId → list of income entities
  final Map<int, List<AdditionalIncomeEntity>> _incomes = {};

  void setTotal(int cycleId, int total) => _totals[cycleId] = total;
  void setIncomes(int cycleId, List<AdditionalIncomeEntity> data) =>
      _incomes[cycleId] = data;

  @override
  Future<int> getTotalIncomeForCycle(int cycleId) async => _totals[cycleId] ?? 0;

  @override
  Future<List<AdditionalIncomeEntity>> getIncomesForCycle(int cycleId) async =>
      _incomes[cycleId] ?? [];

  @override
  Future<AdditionalIncomeEntity> addIncome({
    required int cycleId,
    required String description,
    required int amount,
    bool toSavings = false,
  }) async =>
      throw UnimplementedError();
  @override
  Future<List<AdditionalIncomeEntity>> getIncomesByDateRange(
          DateTime startDate, DateTime endDate) async =>
      [];
  @override
  Future<void> updateIncome({required int id, required String description}) async {}
  @override
  Future<void> deleteIncome(int id) async {}
}

class FakeSavingsRepository implements SavingsRepository {
  List<SavingsHistoryEntity> history = [];

  void addTransaction({
    required int id,
    required SavingsTransactionType type,
    required int amount,
    required DateTime createdAt,
    String description = '',
  }) =>
      history.add(SavingsHistoryEntity(
        id: id,
        type: type,
        amount: amount,
        description: description,
        createdAt: createdAt,
      ));

  @override
  Future<List<SavingsHistoryEntity>> getSavingsHistory(
          {int? limit, int? offset}) async =>
      history;

  @override
  Future<int> getSavingsBalance() async {
    int sum = 0;
    for (final tx in history) {
      sum += tx.type == SavingsTransactionType.deposit ? tx.amount : -tx.amount;
    }
    return sum;
  }

  @override
  Future<SavingsHistoryEntity> createDeposit({
    required int amount,
    required String description,
    required int cycleId,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> createInitialDeposit({required int amount}) async {}

  @override
  Future<SavingsHistoryEntity> createWithdrawal({
    required int amount,
    required String description,
    int? expenseId,
    int? debtPaymentId,
    int? lendingId,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteWithdrawalByExpenseId(int expenseId) async {}
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

class FakeCustomCategoryRepository implements CustomCategoryRepository {
  List<CustomCategoryEntity> categories = [];

  @override
  Future<List<CustomCategoryEntity>> getAll() async => categories;
  @override
  Future<CustomCategoryEntity> create({
    required String name,
    required int iconCodePoint,
  }) async =>
      throw UnimplementedError();
  @override
  Future<void> delete(int id) async {}
}
