import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/debt_payments_table.dart';
import '../tables/debts_table.dart';

part 'debts_dao.g.dart';

@DriftAccessor(tables: [Debts, DebtPayments])
class DebtsDao extends DatabaseAccessor<AppDatabase> with _$DebtsDaoMixin {
  DebtsDao(super.db);

  Future<int> insertDebt(DebtsCompanion debt) => into(debts).insert(debt);

  Future<DebtRow?> getDebtById(int id) =>
      (select(debts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<DebtRow>> getDebts() => select(debts).get();

  Future<List<DebtRow>> getDebtsByUser({
    int limit = 20,
    int offset = 0,
  }) =>
      (select(debts)
            ..limit(limit, offset: offset)
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
          .get();

  Future<List<DebtRow>> getActiveDebts({int? limit, int? offset}) =>
      (select(debts)
            ..where((t) => t.isFullyPaid.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit ?? 100, offset: offset ?? 0))
          .get();

  Future<List<DebtRow>> getCompletedDebts({int? limit, int? offset}) =>
      (select(debts)
            ..where((t) => t.isFullyPaid.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit ?? 100, offset: offset ?? 0))
          .get();

  Future<void> updateDebt({
    required int id,
    String? creditorName,
    int? totalAmount,
    String? notes,
  }) =>
      (update(debts)..where((t) => t.id.equals(id))).write(
        DebtsCompanion(
          creditorName:
              creditorName != null ? Value(creditorName) : const Value.absent(),
          totalAmount:
              totalAmount != null ? Value(totalAmount) : const Value.absent(),
          notes: notes != null ? Value(notes) : const Value.absent(),
        ),
      );

  Future<void> deleteDebtById(int id) async {
    await transaction(() async {
      // Delete payments first (no FK cascade in schema)
      await (delete(debtPayments)..where((t) => t.debtId.equals(id))).go();
      await (delete(debts)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> markDebtCompleted(int id) =>
      (update(debts)..where((t) => t.id.equals(id)))
          .write(const DebtsCompanion(isFullyPaid: Value(true)));

  Future<void> insertPayment({
    required int debtId,
    required int cycleId,
    required int amount,
    bool fromSavings = false,
    int savingsAmount = 0,
  }) async {
    await transaction(() async {
      // Insert payment record
      await into(debtPayments).insert(
        DebtPaymentsCompanion(
          debtId: Value(debtId),
          cycleId: Value(cycleId),
          amount: Value(amount),
          fromSavings: Value(fromSavings),
          savingsAmount: Value(savingsAmount),
        ),
      );

      // Update the debt's paidAmount
      final debt =
          await (select(debts)..where((t) => t.id.equals(debtId))).getSingle();
      final newPaidAmount = debt.paidAmount + amount;
      final isFullyPaid = newPaidAmount >= debt.totalAmount;

      await (update(debts)..where((t) => t.id.equals(debtId))).write(
        DebtsCompanion(
          paidAmount: Value(newPaidAmount),
          isFullyPaid: Value(isFullyPaid),
        ),
      );
    });
  }

  Future<List<int>> getSavingsPaymentIds(int debtId) async {
    final query = select(debtPayments)
      ..where((t) => t.debtId.equals(debtId))
      ..where((t) => t.fromSavings.equals(true));
    final rows = await query.get();
    return rows.map((r) => r.id).toList();
  }

  Future<int> getTotalPaymentsForCycle(int cycleId) async {
    final rows = await (select(debtPayments)
          ..where((t) => t.cycleId.equals(cycleId) & t.fromSavings.equals(false)))
        .get();
    return rows.fold<int>(0, (sum, row) => sum + row.amount - row.savingsAmount);
  }

  Future<int> getTotalDebtPaymentsFromSavingsForCycle(int cycleId) async {
    final rows = await (select(debtPayments)
          ..where((t) => t.cycleId.equals(cycleId) & t.savingsAmount.isBiggerThanValue(0)))
        .get();
    return rows.fold<int>(0, (sum, row) => sum + row.savingsAmount);
  }

  Future<int> getTotalDebtsCreatedForCycle(int cycleId) async {
    final sum = debts.totalAmount.sum();
    final query = selectOnly(debts)
      ..addColumns([sum])
      ..where(debts.cycleId.equalsNullable(cycleId));
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  Future<int> getTotalActiveRemainingAmount() async {
    final remaining = (debts.totalAmount - debts.paidAmount).sum();
    final query = selectOnly(debts)
      ..addColumns([remaining])
      ..where(debts.isFullyPaid.equals(false));
    final result = await query.getSingle();
    return result.read(remaining) ?? 0;
  }
}
