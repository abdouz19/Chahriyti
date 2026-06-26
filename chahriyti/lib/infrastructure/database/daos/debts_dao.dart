import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/debt_payments_table.dart';
import '../tables/debts_table.dart';

part 'debts_dao.g.dart';

@DriftAccessor(tables: [Debts, DebtPayments])
class DebtsDao extends DatabaseAccessor<AppDatabase> with _$DebtsDaoMixin {
  DebtsDao(super.db);

  Future<int> insertDebt(DebtsCompanion debt) => into(debts).insert(debt);

  Future<List<DebtRow>> getDebts() => select(debts).get();

  Future<List<DebtRow>> getActiveDebts() =>
      (select(debts)..where((t) => t.isFullyPaid.equals(false))).get();

  Future<void> insertPayment({
    required int debtId,
    required int cycleId,
    required int amount,
  }) async {
    await transaction(() async {
      // Insert payment record
      await into(debtPayments).insert(
        DebtPaymentsCompanion(
          debtId: Value(debtId),
          cycleId: Value(cycleId),
          amount: Value(amount),
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

  Future<int> getTotalPaymentsForCycle(int cycleId) async {
    final sum = debtPayments.amount.sum();
    final query = selectOnly(debtPayments)
      ..addColumns([sum])
      ..where(debtPayments.cycleId.equals(cycleId));
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }
}
