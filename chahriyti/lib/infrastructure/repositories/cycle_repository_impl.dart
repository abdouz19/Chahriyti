import 'package:drift/drift.dart';

import '../../domain/entities/financial_cycle_entity.dart';
import '../../domain/repositories/cycle_repository.dart';
import '../database/app_database.dart';
import '../database/daos/cycles_dao.dart';

class CycleRepositoryImpl implements CycleRepository {
  final CyclesDao _dao;

  CycleRepositoryImpl(this._dao);

  FinancialCycleEntity _toEntity(FinancialCycleRow row) => FinancialCycleEntity(
        id: row.id,
        startDate: row.startDate,
        endDate: row.endDate,
        salaryAmount: row.salaryAmount,
        salarySplitAmount: row.salarySplitAmount,
        isActive: row.isActive,
      );

  @override
  Future<FinancialCycleEntity?> getActiveCycle() async {
    final row = await _dao.getActiveCycle();
    return row != null ? _toEntity(row) : null;
  }

  @override
  Future<FinancialCycleEntity?> getCycleById(int id) async {
    final row = await _dao.getCycleById(id);
    return row != null ? _toEntity(row) : null;
  }

  @override
  Future<FinancialCycleEntity?> getPreviousCycle(int cycleId) async {
    final cycle = await _dao.getCycleById(cycleId);
    if (cycle == null) return null;

    final history = await _dao.getCycleHistory(limit: 10);
    final currentIndex = history.indexWhere((c) => c.id == cycleId);

    if (currentIndex > 0) {
      return _toEntity(history[currentIndex + 1]);
    }

    return null;
  }

  @override
  Future<FinancialCycleEntity> createCycle({
    required DateTime startDate,
    required DateTime endDate,
    required int salaryAmount,
    int salarySplitAmount = 0,
  }) async {
    await _dao.insertCycle(
      FinancialCyclesCompanion(
        startDate: Value(startDate),
        endDate: Value(endDate),
        salaryAmount: Value(salaryAmount),
        salarySplitAmount: Value(salarySplitAmount),
        isActive: const Value(true),
      ),
    );
    final row = await _dao.getActiveCycle();
    return _toEntity(row!);
  }

  @override
  Future<void> closeCycle(int id) => _dao.closeCycle(id);

  @override
  Future<List<FinancialCycleEntity>> getCycleHistory({int limit = 6, int offset = 0}) async {
    final rows = await _dao.getCycleHistory(limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<void> updateCycleSalary(int cycleId, int salaryAmount) =>
      _dao.updateCycleSalary(cycleId, salaryAmount);

  @override
  Future<void> updateCycleSalarySplit(int cycleId, int salarySplitAmount) =>
      _dao.updateCycleSalarySplit(cycleId, salarySplitAmount);

  @override
  Future<FinancialCycleEntity?> getCycleForMonth(int year, int month) async {
    final row = await _dao.getCycleForMonth(year, month);
    return row != null ? _toEntity(row) : null;
  }

  @override
  Future<void> updateCycleSalaryDay(int cycleId, int salaryDay) async {
    // No-op: active cycle dates are never retroactively modified.
    // The new salary day is stored on the user record and takes effect
    // when the next cycle is auto-created by CheckAndStartCycleUseCase.
  }
}
