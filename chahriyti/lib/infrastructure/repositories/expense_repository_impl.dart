import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../database/app_database.dart';
import '../database/daos/expenses_dao.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpensesDao _dao;

  ExpenseRepositoryImpl(this._dao);

  ExpenseEntity _toEntity(ExpenseRow row) => ExpenseEntity(
        id: row.id,
        cycleId: row.cycleId,
        category: row.category,
        subcategory: row.subcategory,
        itemName: row.itemName,
        amount: row.amount,
        notes: row.notes,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        fromSavings: row.fromSavings,
        savingsAmount: row.savingsAmount,
      );

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
  }) async {
    debugPrint('💾 REPO: Adding expense...');
    debugPrint('   - Category: $category / $subcategory');
    debugPrint('   - Item: $itemName');
    debugPrint('   - Amount: $amount (savingsAmount: $savingsAmount)');

    final now = DateTime.now();
    final id = await _dao.insertExpense(
      ExpensesCompanion(
        cycleId: Value(cycleId),
        category: Value(category),
        subcategory: Value(subcategory),
        itemName: Value(itemName),
        amount: Value(amount),
        notes: Value(notes),
        createdAt: Value(now),
        updatedAt: Value(now),
        fromSavings: Value(fromSavings),
        savingsAmount: Value(savingsAmount),
      ),
    );

    // Find the inserted row by id
    final allRows = await _dao.getExpenses(cycleId);
    final row = allRows.firstWhere((r) => r.id == id);
    debugPrint('✅ REPO: Expense saved with ID=$id, stored amount=${row.amount}');
    return _toEntity(row);
  }

  @override
  Future<void> editExpense(ExpenseEntity expense) async {
    await _dao.updateExpense(
      ExpenseRow(
        id: expense.id,
        cycleId: expense.cycleId,
        category: expense.category,
        subcategory: expense.subcategory,
        itemName: expense.itemName,
        amount: expense.amount,
        notes: expense.notes,
        createdAt: expense.createdAt,
        updatedAt: DateTime.now(),
        fromSavings: expense.fromSavings,
        savingsAmount: expense.savingsAmount,
      ),
    );
  }

  @override
  Future<void> deleteExpense(int id) => _dao.deleteExpense(id);

  @override
  Future<List<ExpenseEntity>> getExpenses(
    int cycleId, {
    int? limit,
    int? offset,
  }) async {
    final rows = await _dao.getExpenses(cycleId, limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<ExpenseEntity>> getAllExpenses({int? limit, int? offset}) async {
    final rows = await _dao.getAllExpenses(limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<ExpenseEntity>> getRecentExpenses(
    int cycleId, {
    int limit = 5,
  }) async {
    final rows = await _dao.getRecentExpenses(cycleId, limit: limit);
    debugPrint('📖 REPO: Fetching recent expenses (cycle=$cycleId, limit=$limit)');
    for (final row in rows) {
      debugPrint('   - ${row.itemName}: ${row.amount} DZD');
    }
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final rows = await _dao.getExpensesByDateRange(startDate, endDate);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<int> getTotalExpenses(int cycleId) => _dao.getTotalExpenses(cycleId);

  @override
  Future<int> getTotalExpensesFromSavingsForCycle(int cycleId) =>
      _dao.getTotalExpensesFromSavingsForCycle(cycleId);

  @override
  Future<Map<String, int>> getExpensesByCategory(int cycleId) =>
      _dao.getExpensesByCategory(cycleId);
}
