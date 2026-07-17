import 'package:drift/drift.dart';

import '../../domain/entities/savings_history_entity.dart';
import '../../domain/repositories/savings_repository.dart';
import '../database/app_database.dart';
import '../database/daos/savings_dao.dart';

class SavingsRepositoryImpl implements SavingsRepository {
  final SavingsDao _dao;

  SavingsRepositoryImpl(this._dao);

  SavingsHistoryEntity _toEntity(SavingsHistoryRow row) =>
      SavingsHistoryEntity(
        id: row.id,
        type: row.type == 'deposit'
            ? SavingsTransactionType.deposit
            : SavingsTransactionType.withdrawal,
        amount: row.amount,
        description: row.description,
        relatedCycleId: row.relatedCycleId,
        relatedExpenseId: row.relatedExpenseId,
        relatedDebtPaymentId: row.relatedDebtPaymentId,
        relatedLendingId: row.relatedLendingId,
        createdAt: row.createdAt,
      );

  @override
  Future<int> getSavingsBalance() => _dao.getSavingsBalance();

  @override
  Future<List<SavingsHistoryEntity>> getSavingsHistory({int? limit, int? offset}) async {
    final rows = await _dao.getAllRecords(limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<SavingsHistoryEntity> createDeposit({
    required int amount,
    required String description,
    required int cycleId,
  }) async {
    final id = await _dao.insertRecord(
      SavingsHistoryCompanion(
        type: const Value('deposit'),
        amount: Value(amount),
        description: Value(description),
        relatedCycleId: Value(cycleId),
      ),
    );
    final rows = await _dao.getAllRecords();
    final row = rows.firstWhere((r) => r.id == id);
    return _toEntity(row);
  }

  @override
  Future<SavingsHistoryEntity> createWithdrawal({
    required int amount,
    required String description,
    int? expenseId,
    int? debtPaymentId,
    int? lendingId,
  }) async {
    final id = await _dao.insertRecord(
      SavingsHistoryCompanion(
        type: const Value('withdrawal'),
        amount: Value(amount),
        description: Value(description),
        relatedExpenseId:
            expenseId != null ? Value(expenseId) : const Value.absent(),
        relatedDebtPaymentId:
            debtPaymentId != null ? Value(debtPaymentId) : const Value.absent(),
        relatedLendingId:
            lendingId != null ? Value(lendingId) : const Value.absent(),
      ),
    );
    final rows = await _dao.getAllRecords();
    final row = rows.firstWhere((r) => r.id == id);
    return _toEntity(row);
  }

  @override
  Future<void> deleteWithdrawalByExpenseId(int expenseId) =>
      _dao.deleteByRelatedExpenseId(expenseId);

  @override
  Future<void> deleteWithdrawalByDebtPaymentId(int debtPaymentId) =>
      _dao.deleteByRelatedDebtPaymentId(debtPaymentId);

  @override
  Future<void> deleteWithdrawalByLendingId(int lendingId) =>
      _dao.deleteByRelatedLendingId(lendingId);

  @override
  Future<void> updateWithdrawalAmountByExpenseId(
          int expenseId, int newAmount) =>
      _dao.updateAmountByRelatedExpenseId(expenseId, newAmount);

  @override
  Future<void> updateWithdrawalAmountByDebtPaymentId(
          int debtPaymentId, int newAmount) =>
      _dao.updateAmountByRelatedDebtPaymentId(debtPaymentId, newAmount);

  @override
  Future<void> createInitialDeposit({required int amount}) async {
    await _dao.insertRecord(
      SavingsHistoryCompanion(
        type: const Value('deposit'),
        amount: Value(amount),
        description: const Value('رصيد الادخار الأولي'),
      ),
    );
  }
}
