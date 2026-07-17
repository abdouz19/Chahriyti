import 'package:drift/drift.dart';

import '../../domain/entities/lending_collection_entity.dart';
import '../../domain/entities/lending_entity.dart';
import '../../domain/repositories/lending_repository.dart';
import '../database/daos/lendings_dao.dart';
import '../database/app_database.dart';

class LendingRepositoryImpl implements LendingRepository {
  final LendingsDao _dao;

  LendingRepositoryImpl(this._dao);

  @override
  Future<LendingEntity> createLending({
    required String borrowerName,
    required int totalAmount,
    required bool fromSavings,
    int savingsAmount = 0,
    int? cycleId,
    String? notes,
  }) async {
    final row = await _dao.insertLending(
      LendingsCompanion(
        borrowerName: Value(borrowerName),
        totalAmount: Value(totalAmount),
        fromSavings: Value(fromSavings),
        savingsAmount: Value(savingsAmount),
        cycleId: cycleId != null ? Value(cycleId) : const Value.absent(),
        notes: notes != null ? Value(notes) : const Value.absent(),
      ),
    );
    return _toEntity(row);
  }

  @override
  Future<LendingEntity?> getLendingById(int id) async {
    final row = await _dao.getLendingById(id);
    return row != null ? _toEntity(row) : null;
  }

  @override
  Future<List<LendingEntity>> getActiveLendings({int? limit, int? offset}) async {
    final rows = await _dao.getActiveLendings(limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<LendingEntity>> getCollectedLendings({int? limit, int? offset}) async {
    final rows = await _dao.getCollectedLendings(limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<void> deleteLending(int id) async {
    await _dao.deleteLendingById(id);
  }

  @override
  Future<void> updateLending({
    required int id,
    String? borrowerName,
    String? notes,
    int? totalAmount,
  }) async {
    await _dao.updateLending(
      id: id,
      borrowerName: borrowerName,
      notes: notes,
      totalAmount: totalAmount,
    );
  }

  @override
  Future<void> addCollection({
    required int lendingId,
    required int amount,
    bool toSavings = false,
  }) async {
    await _dao.insertCollection(
      lendingId: lendingId,
      amount: amount,
      toSavings: toSavings,
    );
  }

  @override
  Future<List<LendingCollectionEntity>> getCollectionsForLending(
      int lendingId) async {
    final rows = await _dao.getCollectionsForLending(lendingId);
    return rows.map(_toCollectionEntity).toList();
  }

  @override
  Future<int> getTotalLendingsFromBalanceForCycle(int cycleId) async {
    return _dao.getTotalLendingsFromBalanceForCycle(cycleId);
  }

  @override
  Future<int> getTotalLendingsFromSavingsForCycle(int cycleId) async {
    return _dao.getTotalLendingsFromSavingsForCycle(cycleId);
  }

  @override
  Future<int> getTotalCollectionsToBalanceForCycle(int cycleId) async {
    return _dao.getTotalCollectionsToBalanceForCycle(cycleId);
  }

  @override
  Future<int> getTotalOutstandingLendingAmount() async {
    return _dao.getTotalOutstandingLendingAmount();
  }

  LendingEntity _toEntity(LendingRow row) {
    return LendingEntity(
      id: row.id,
      borrowerName: row.borrowerName,
      totalAmount: row.totalAmount,
      collectedAmount: row.collectedAmount,
      isFullyCollected: row.isFullyCollected,
      fromSavings: row.fromSavings,
      savingsAmount: row.savingsAmount,
      cycleId: row.cycleId,
      notes: row.notes,
      createdAt: row.createdAt,
    );
  }

  LendingCollectionEntity _toCollectionEntity(LendingCollectionRow row) {
    return LendingCollectionEntity(
      id: row.id,
      lendingId: row.lendingId,
      amount: row.amount,
      toSavings: row.toSavings,
      createdAt: row.createdAt,
    );
  }
}
