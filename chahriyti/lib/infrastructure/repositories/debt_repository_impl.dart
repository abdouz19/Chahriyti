import 'package:drift/drift.dart';

import '../../domain/entities/debt_entity.dart';
import '../../domain/repositories/cycle_repository.dart';
import '../../domain/repositories/debt_repository.dart';
import '../database/app_database.dart';
import '../database/daos/debts_dao.dart';

class DebtRepositoryImpl implements DebtRepository {
  final DebtsDao _dao;
  final CycleRepository _cycleRepository;

  DebtRepositoryImpl(this._dao, this._cycleRepository);

  DebtEntity _toEntity(DebtRow row) => DebtEntity(
        id: row.id,
        creditorName: row.creditorName,
        totalAmount: row.totalAmount,
        paidAmount: row.paidAmount,
        isFullyPaid: row.isFullyPaid,
        isSpent: row.isSpent,
        createdAt: row.createdAt,
        notes: row.notes,
      );

  @override
  Future<int> createDebt({
    required String creditorName,
    required int totalAmount,
    String? notes,
    int? cycleId,
    bool isSpent = true,
  }) async {
    return _dao.insertDebt(
      DebtsCompanion(
        creditorName: Value(creditorName),
        totalAmount: Value(totalAmount),
        paidAmount: const Value(0),
        isFullyPaid: const Value(false),
        notes: notes != null ? Value(notes) : const Value.absent(),
        cycleId: cycleId != null ? Value(cycleId) : const Value.absent(),
        isSpent: Value(isSpent),
      ),
    );
  }

  @override
  Future<DebtEntity> addDebt({
    required String creditorName,
    required int totalAmount,
    required int paidAmount,
  }) async {
    final id = await _dao.insertDebt(
      DebtsCompanion(
        creditorName: Value(creditorName),
        totalAmount: Value(totalAmount),
        paidAmount: Value(paidAmount),
        isFullyPaid: Value(paidAmount >= totalAmount),
      ),
    );
    final row = await _dao.getDebtById(id);
    return _toEntity(row!);
  }

  @override
  Future<DebtEntity?> getDebtById(int id) async {
    final row = await _dao.getDebtById(id);
    return row != null ? _toEntity(row) : null;
  }

  @override
  Future<List<DebtEntity>> getUserDebts({
    int limit = 20,
    int offset = 0,
  }) async {
    final rows = await _dao.getDebtsByUser(limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<DebtEntity>> getActiveDebts({int? limit, int? offset}) async {
    final rows = await _dao.getActiveDebts(limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<DebtEntity>> getCompletedDebts({int? limit, int? offset}) async {
    final rows = await _dao.getCompletedDebts(limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<void> updateDebt({
    required int id,
    String? creditorName,
    int? totalAmount,
    String? notes,
    bool? isSpent,
  }) =>
      _dao.updateDebt(
        id: id,
        creditorName: creditorName,
        totalAmount: totalAmount,
        notes: notes,
        isSpent: isSpent,
      );

  @override
  Future<void> deleteDebt(int id) => _dao.deleteDebtById(id);

  @override
  Future<void> addPayment({
    required int debtId,
    required int amount,
    bool fromSavings = false,
    int savingsAmount = 0,
  }) async {
    final cycle = await _cycleRepository.getActiveCycle();
    final cycleId = cycle?.id ?? 1;
    await _dao.insertPayment(
      debtId: debtId,
      cycleId: cycleId,
      amount: amount,
      fromSavings: fromSavings,
      savingsAmount: savingsAmount,
    );
  }

  @override
  Future<void> markDebtCompleted(int id) => _dao.markDebtCompleted(id);

  @override
  Future<void> makePayment({
    required int debtId,
    required int amount,
    required int cycleId,
    bool fromSavings = false,
  }) =>
      _dao.insertPayment(
        debtId: debtId,
        cycleId: cycleId,
        amount: amount,
        fromSavings: fromSavings,
      );

  @override
  Future<int> getTotalDebtPaymentsForCycle(int cycleId) =>
      _dao.getTotalPaymentsForCycle(cycleId);

  @override
  Future<int> getTotalDebtPaymentsFromSavingsForCycle(int cycleId) =>
      _dao.getTotalDebtPaymentsFromSavingsForCycle(cycleId);

  @override
  Future<int> getTotalDebtsCreatedForCycle(int cycleId) =>
      _dao.getTotalDebtsCreatedForCycle(cycleId);

  @override
  Future<List<int>> getSavingsPaymentIds(int debtId) =>
      _dao.getSavingsPaymentIds(debtId);

  @override
  Future<int> getTotalActiveRemainingAmount() =>
      _dao.getTotalActiveRemainingAmount();
}
