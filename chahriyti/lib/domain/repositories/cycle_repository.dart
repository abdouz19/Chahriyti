import '../entities/financial_cycle_entity.dart';

abstract class CycleRepository {
  Future<FinancialCycleEntity?> getActiveCycle();

  Future<FinancialCycleEntity?> getCycleById(int id);

  Future<FinancialCycleEntity?> getPreviousCycle(int cycleId);

  Future<FinancialCycleEntity> createCycle({
    required DateTime startDate,
    required DateTime endDate,
    required int salaryAmount,
    int salarySplitAmount = 0,
  });

  Future<void> closeCycle(int id);

  Future<void> updateCycleSalary(int cycleId, int salaryAmount);

  Future<void> updateCycleSalarySplit(int cycleId, int salarySplitAmount);

  Future<void> updateCycleSalaryDay(int cycleId, int salaryDay);

  Future<List<FinancialCycleEntity>> getCycleHistory({int limit = 6, int offset = 0});

  Future<FinancialCycleEntity?> getCycleForMonth(int year, int month);
}
