import '../entities/financial_cycle_entity.dart';

abstract class CycleRepository {
  Future<FinancialCycleEntity?> getActiveCycle();

  Future<FinancialCycleEntity?> getCycleById(int id);

  Future<FinancialCycleEntity?> getPreviousCycle(int cycleId);

  Future<FinancialCycleEntity> createCycle({
    required DateTime startDate,
    required DateTime endDate,
    required int salaryAmount,
  });

  Future<void> closeCycle(int id);

  Future<void> updateCycleSalary(int cycleId, int salaryAmount);

  Future<void> updateCycleSalaryDay(int cycleId, int salaryDay);

  Future<List<FinancialCycleEntity>> getCycleHistory({int limit = 6});
}
