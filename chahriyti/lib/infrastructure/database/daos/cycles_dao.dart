import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/financial_cycles_table.dart';

part 'cycles_dao.g.dart';

@DriftAccessor(tables: [FinancialCycles])
class CyclesDao extends DatabaseAccessor<AppDatabase> with _$CyclesDaoMixin {
  CyclesDao(super.db);

  Future<FinancialCycleRow?> getActiveCycle() => (select(financialCycles)
        ..where((t) => t.isActive.equals(true))
        ..limit(1))
      .getSingleOrNull();

  Future<FinancialCycleRow?> getCycleById(int id) =>
      (select(financialCycles)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertCycle(FinancialCyclesCompanion cycle) =>
      into(financialCycles).insert(cycle);

  Future<void> closeCycle(int id) async {
    await (update(financialCycles)..where((t) => t.id.equals(id)))
        .write(const FinancialCyclesCompanion(isActive: Value(false)));
  }

  Future<List<FinancialCycleRow>> getCycleHistory({int limit = 6}) =>
      (select(financialCycles)
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)])
            ..limit(limit))
          .get();

  Future<void> updateCycleSalary(int cycleId, int salaryAmount) async {
    await (update(financialCycles)..where((t) => t.id.equals(cycleId)))
        .write(FinancialCyclesCompanion(salaryAmount: Value(salaryAmount)));
  }

  Future<void> updateCycleDates(
      int cycleId, DateTime startDate, DateTime endDate) async {
    await (update(financialCycles)..where((t) => t.id.equals(cycleId))).write(
      FinancialCyclesCompanion(
        startDate: Value(startDate),
        endDate: Value(endDate),
      ),
    );
  }
}
