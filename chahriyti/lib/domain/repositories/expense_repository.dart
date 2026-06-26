import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<ExpenseEntity> addExpense({
    required int cycleId,
    required String category,
    required String subcategory,
    required String itemName,
    required int amount,
    String? notes,
  });

  Future<void> editExpense(ExpenseEntity expense);

  Future<void> deleteExpense(int id);

  Future<List<ExpenseEntity>> getExpenses(
    int cycleId, {
    int? limit,
    int? offset,
  });

  Future<List<ExpenseEntity>> getRecentExpenses(
    int cycleId, {
    int limit = 5,
  });

  Future<List<ExpenseEntity>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  Future<int> getTotalExpenses(int cycleId);

  Future<Map<String, int>> getExpensesByCategory(int cycleId);
}
