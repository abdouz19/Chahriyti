import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/additional_incomes_table.dart';

part 'incomes_dao.g.dart';

@DriftAccessor(tables: [AdditionalIncomes])
class IncomesDao extends DatabaseAccessor<AppDatabase> with _$IncomesDaoMixin {
  IncomesDao(super.db);

  Future<int> insertIncome(AdditionalIncomesCompanion income) =>
      into(additionalIncomes).insert(income);

  Future<List<AdditionalIncomeRow>> getIncomesForCycle(int cycleId) =>
      (select(additionalIncomes)
            ..where((t) => t.cycleId.equals(cycleId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<AdditionalIncomeRow>> getIncomesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) =>
      (select(additionalIncomes)
            ..where((t) => t.createdAt.isBiggerOrEqualValue(startDate))
            ..where((t) => t.createdAt.isSmallerOrEqualValue(endDate))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<int> getTotalIncomeForCycle(int cycleId) async {
    final sum = additionalIncomes.amount.sum();
    final query = selectOnly(additionalIncomes)
      ..addColumns([sum])
      ..where(additionalIncomes.cycleId.equals(cycleId))
      ..where(additionalIncomes.toSavings.equals(false));
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  Future<void> updateIncome({required int id, required String description}) async {
    await (update(additionalIncomes)..where((t) => t.id.equals(id))).write(
      AdditionalIncomesCompanion(description: Value(description)),
    );
  }

  Future<void> deleteIncome(int id) async {
    final rows = await (select(additionalIncomes)..where((t) => t.id.equals(id))).get();
    if (rows.isEmpty) return;
    final row = rows.first;
    if (row.toSavings) {
      throw ArgumentError('لا يمكن حذف دخل محوّل للمدخرات');
    }
    await (delete(additionalIncomes)..where((t) => t.id.equals(id))).go();
  }
}
