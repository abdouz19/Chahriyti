import '../entities/additional_income_entity.dart';

abstract class IncomeRepository {
  Future<AdditionalIncomeEntity> addIncome({
    required int cycleId,
    required String description,
    required int amount,
  });

  Future<List<AdditionalIncomeEntity>> getIncomesForCycle(int cycleId);

  Future<List<AdditionalIncomeEntity>> getIncomesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  Future<int> getTotalIncomeForCycle(int cycleId);
}
