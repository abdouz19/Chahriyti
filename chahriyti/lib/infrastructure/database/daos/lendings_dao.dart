import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/lending_collections_table.dart';
import '../tables/lendings_table.dart';

part 'lendings_dao.g.dart';

@DriftAccessor(tables: [Lendings, LendingCollections])
class LendingsDao extends DatabaseAccessor<AppDatabase>
    with _$LendingsDaoMixin {
  LendingsDao(super.db);

  Future<LendingRow> insertLending(LendingsCompanion lending) =>
      into(lendings).insertReturning(lending);

  Future<LendingRow?> getLendingById(int id) =>
      (select(lendings)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<LendingRow>> getActiveLendings({int? limit, int? offset}) =>
      (select(lendings)
            ..where((t) => t.isFullyCollected.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit ?? 100, offset: offset ?? 0))
          .get();

  Future<List<LendingRow>> getCollectedLendings({int? limit, int? offset}) =>
      (select(lendings)
            ..where((t) => t.isFullyCollected.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit ?? 100, offset: offset ?? 0))
          .get();

  Future<void> deleteLendingById(int id) async {
    await transaction(() async {
      // Delete associated collections first
      await (delete(lendingCollections)
            ..where((t) => t.lendingId.equals(id)))
          .go();
      // Delete the lending
      await (delete(lendings)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> insertCollection({
    required int lendingId,
    required int amount,
    bool toSavings = false,
  }) async {
    await transaction(() async {
      // Insert collection record
      await into(lendingCollections).insert(
        LendingCollectionsCompanion(
          lendingId: Value(lendingId),
          amount: Value(amount),
          toSavings: Value(toSavings),
        ),
      );

      // Update the lending's collectedAmount
      final lending = await (select(lendings)
            ..where((t) => t.id.equals(lendingId)))
          .getSingle();
      final newCollectedAmount = lending.collectedAmount + amount;
      final isFullyCollected = newCollectedAmount >= lending.totalAmount;

      await (update(lendings)..where((t) => t.id.equals(lendingId))).write(
        LendingsCompanion(
          collectedAmount: Value(newCollectedAmount),
          isFullyCollected: Value(isFullyCollected),
        ),
      );
    });
  }

  Future<List<LendingCollectionRow>> getCollectionsForLending(
      int lendingId) async {
    return (select(lendingCollections)
          ..where((t) => t.lendingId.equals(lendingId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<int> getTotalLendingsFromBalanceForCycle(int cycleId) async {
    final rows = await (select(lendings)
          ..where((t) => t.cycleId.equals(cycleId) & t.fromSavings.equals(false)))
        .get();
    return rows.fold<int>(0, (sum, row) => sum + row.totalAmount - row.savingsAmount);
  }

  Future<int> getTotalLendingsFromSavingsForCycle(int cycleId) async {
    final rows = await (select(lendings)
          ..where((t) => t.cycleId.equals(cycleId) & t.savingsAmount.isBiggerThanValue(0)))
        .get();
    return rows.fold<int>(0, (sum, row) => sum + row.savingsAmount);
  }

  Future<int> getTotalCollectionsToBalanceForCycle(int cycleId) async {
    final result = await customSelect(
      'SELECT COALESCE(SUM(lc.amount), 0) AS total '
      'FROM lending_collections lc '
      'INNER JOIN lendings l ON l.id = lc.lending_id '
      'WHERE l.cycle_id = ? AND l.from_savings = 0 AND lc.to_savings = 0',
      variables: [Variable.withInt(cycleId)],
      readsFrom: {lendings, lendingCollections},
    ).getSingle();
    return result.read<int>('total');
  }

  Future<void> updateLending({
    required int id,
    String? borrowerName,
    String? notes,
    int? totalAmount,
  }) async {
    if (totalAmount != null) {
      final row = await (select(lendings)..where((t) => t.id.equals(id))).getSingle();
      if (totalAmount < row.collectedAmount) {
        throw ArgumentError('المبلغ الجديد أقل من المبلغ المحصّل');
      }
    }
    await (update(lendings)..where((t) => t.id.equals(id))).write(
      LendingsCompanion(
        borrowerName: borrowerName != null ? Value(borrowerName) : const Value.absent(),
        notes: notes != null ? Value(notes) : const Value.absent(),
        totalAmount: totalAmount != null ? Value(totalAmount) : const Value.absent(),
      ),
    );
  }

  Future<int> getTotalOutstandingLendingAmount() async {
    final remaining = lendings.totalAmount - lendings.collectedAmount;
    final sum = remaining.sum();
    final query = selectOnly(lendings)
      ..addColumns([sum])
      ..where(lendings.isFullyCollected.equals(false));
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }
}
