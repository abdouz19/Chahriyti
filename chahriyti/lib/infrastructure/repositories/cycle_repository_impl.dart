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
  }) async {
    await _dao.insertCycle(
      FinancialCyclesCompanion(
        startDate: Value(startDate),
        endDate: Value(endDate),
        salaryAmount: Value(salaryAmount),
        isActive: const Value(true),
      ),
    );
    final row = await _dao.getActiveCycle();
    return _toEntity(row!);
  }

  @override
  Future<void> closeCycle(int id) => _dao.closeCycle(id);

  @override
  Future<List<FinancialCycleEntity>> getCycleHistory({int limit = 6}) async {
    final rows = await _dao.getCycleHistory(limit: limit);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<void> updateCycleSalary(int cycleId, int salaryAmount) =>
      _dao.updateCycleSalary(cycleId, salaryAmount);

  @override
  Future<void> updateCycleSalaryDay(int cycleId, int salaryDay) async {
    final row = await _dao.getActiveCycle();
    if (row == null) return;

    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, salaryDay);
    final cycleStart = startDate.isAfter(now)
        ? DateTime(now.year, now.month - 1, salaryDay)
        : startDate;
    final cycleEnd = DateTime(
      cycleStart.year,
      cycleStart.month + 1,
      salaryDay,
    ).subtract(const Duration(days: 1));

    await _dao.updateCycleDates(cycleId, cycleStart, cycleEnd);
  }
}
