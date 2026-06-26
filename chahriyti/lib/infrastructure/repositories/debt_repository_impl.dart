import 'package:drift/drift.dart';

import '../../domain/entities/debt_entity.dart';
import '../../domain/repositories/debt_repository.dart';
import '../database/app_database.dart';
import '../database/daos/debts_dao.dart';

class DebtRepositoryImpl implements DebtRepository {
  final DebtsDao _dao;

  DebtRepositoryImpl(this._dao);

  DebtEntity _toEntity(DebtRow row) => DebtEntity(
        id: row.id,
        creditorName: row.creditorName,
        totalAmount: row.totalAmount,
        paidAmount: row.paidAmount,
        isFullyPaid: row.isFullyPaid,
        createdAt: row.createdAt,
      );

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
    final rows = await _dao.getDebts();
    final row = rows.firstWhere((r) => r.id == id);
    return _toEntity(row);
  }

  @override
  Future<void> makePayment({
    required int debtId,
    required int amount,
    required int cycleId,
  }) =>
      _dao.insertPayment(
        debtId: debtId,
        cycleId: cycleId,
        amount: amount,
      );

  @override
  Future<List<DebtEntity>> getDebts() async {
    final rows = await _dao.getDebts();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<DebtEntity>> getActiveDebts() async {
    final rows = await _dao.getActiveDebts();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<int> getTotalDebtPaymentsForCycle(int cycleId) =>
      _dao.getTotalPaymentsForCycle(cycleId);
}
