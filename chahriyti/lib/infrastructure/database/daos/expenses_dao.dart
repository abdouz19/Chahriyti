import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/expenses_table.dart';

part 'expenses_dao.g.dart';

@DriftAccessor(tables: [Expenses])
class ExpensesDao extends DatabaseAccessor<AppDatabase> with _$ExpensesDaoMixin {
  ExpensesDao(super.db);

  Future<int> insertExpense(ExpensesCompanion expense) =>
      into(expenses).insert(expense);

  Future<bool> updateExpense(ExpenseRow expense) =>
      update(expenses).replace(expense);

  Future<int> deleteExpense(int id) =>
      (delete(expenses)..where((t) => t.id.equals(id))).go();

  Future<List<ExpenseRow>> getExpenses(
    int cycleId, {
    int? limit,
    int? offset,
  }) =>
      (select(expenses)
            ..where((t) => t.cycleId.equals(cycleId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit ?? -1, offset: offset))
          .get();

  Future<List<ExpenseRow>> getRecentExpenses(
    int cycleId, {
    int limit = 5,
  }) =>
      (select(expenses)
            ..where((t) => t.cycleId.equals(cycleId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .get();

  Future<List<ExpenseRow>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) =>
      (select(expenses)
            ..where((t) => t.createdAt.isBiggerOrEqualValue(startDate))
            ..where((t) => t.createdAt.isSmallerOrEqualValue(endDate))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<int> getTotalExpenses(int cycleId) async {
    // Sum only the balance portion: amount - savingsAmount (split expenses count partially)
    final rows = await (select(expenses)
          ..where((t) => t.cycleId.equals(cycleId) & t.fromSavings.equals(false)))
        .get();
    return rows.fold<int>(0, (sum, row) => sum + row.amount - row.savingsAmount);
  }

  Future<Map<String, int>> getExpensesByCategory(int cycleId) async {
    final category = expenses.category;
    final sum = expenses.amount.sum();

    final query = selectOnly(expenses)
      ..addColumns([category, sum])
      ..where(expenses.cycleId.equals(cycleId))
      ..groupBy([category]);

    final rows = await query.get();
    return {
      for (final row in rows)
        row.read(category)!: row.read(sum) ?? 0,
    };
  }
}
