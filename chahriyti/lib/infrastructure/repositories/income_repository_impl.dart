import 'package:drift/drift.dart';

import '../../domain/entities/additional_income_entity.dart';
import '../../domain/repositories/income_repository.dart';
import '../database/app_database.dart';
import '../database/daos/incomes_dao.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomesDao _dao;

  IncomeRepositoryImpl(this._dao);

  AdditionalIncomeEntity _toEntity(AdditionalIncomeRow row) =>
      AdditionalIncomeEntity(
        id: row.id,
        cycleId: row.cycleId,
        description: row.description,
        amount: row.amount,
        createdAt: row.createdAt,
      );

  @override
  Future<AdditionalIncomeEntity> addIncome({
    required int cycleId,
    required String description,
    required int amount,
  }) async {
    final now = DateTime.now();
    final id = await _dao.insertIncome(
      AdditionalIncomesCompanion(
        cycleId: Value(cycleId),
        description: Value(description),
        amount: Value(amount),
        createdAt: Value(now),
      ),
    );
    final rows = await _dao.getIncomesForCycle(cycleId);
    final row = rows.firstWhere((r) => r.id == id);
    return _toEntity(row);
  }

  @override
  Future<List<AdditionalIncomeEntity>> getIncomesForCycle(int cycleId) async {
    final rows = await _dao.getIncomesForCycle(cycleId);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<AdditionalIncomeEntity>> getIncomesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final rows = await _dao.getIncomesByDateRange(startDate, endDate);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<int> getTotalIncomeForCycle(int cycleId) =>
      _dao.getTotalIncomeForCycle(cycleId);
}
