import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/savings_history_table.dart';

part 'savings_dao.g.dart';

@DriftAccessor(tables: [SavingsHistory])
class SavingsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsDaoMixin {
  SavingsDao(super.db);

  Future<int> insertRecord(SavingsHistoryCompanion record) =>
      into(savingsHistory).insert(record);

  Future<List<SavingsHistoryRow>> getAllRecords({int? limit, int? offset}) =>
      (select(savingsHistory)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit ?? 100, offset: offset ?? 0))
          .get();

  Future<int> getSavingsBalance() async {
    final result = await customSelect(
      'SELECT COALESCE('
      '(SELECT SUM(amount) FROM savings_history WHERE type = \'deposit\'), 0) - '
      'COALESCE('
      '(SELECT SUM(amount) FROM savings_history WHERE type = \'withdrawal\'), 0) '
      'AS balance',
    ).getSingle();
    return result.data['balance'] as int? ?? 0;
  }

  Future<void> deleteByRelatedExpenseId(int expenseId) =>
      (delete(savingsHistory)
            ..where((t) => t.relatedExpenseId.equals(expenseId)))
          .go();

  Future<void> deleteByRelatedDebtPaymentId(int debtPaymentId) =>
      (delete(savingsHistory)
            ..where((t) => t.relatedDebtPaymentId.equals(debtPaymentId)))
          .go();

  Future<void> deleteByRelatedLendingId(int lendingId) =>
      (delete(savingsHistory)
            ..where((t) => t.relatedLendingId.equals(lendingId)))
          .go();

  Future<void> updateAmountByRelatedExpenseId(
      int expenseId, int newAmount) =>
      (update(savingsHistory)
            ..where((t) => t.relatedExpenseId.equals(expenseId)))
          .write(SavingsHistoryCompanion(amount: Value(newAmount)));

  Future<void> updateAmountByRelatedDebtPaymentId(
      int debtPaymentId, int newAmount) =>
      (update(savingsHistory)
            ..where((t) => t.relatedDebtPaymentId.equals(debtPaymentId)))
          .write(SavingsHistoryCompanion(amount: Value(newAmount)));
}
