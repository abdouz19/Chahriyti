import '../entities/debt_entity.dart';

abstract class DebtRepository {
  Future<int> createDebt({
    required String creditorName,
    required int totalAmount,
    String? notes,
    int? cycleId,
  });

  Future<DebtEntity> addDebt({
    required String creditorName,
    required int totalAmount,
    required int paidAmount,
  });

  Future<DebtEntity?> getDebtById(int id);

  Future<List<DebtEntity>> getUserDebts({
    int limit = 20,
    int offset = 0,
  });

  Future<List<DebtEntity>> getActiveDebts({int? limit, int? offset});

  Future<List<DebtEntity>> getCompletedDebts({int? limit, int? offset});

  Future<void> updateDebt({
    required int id,
    String? creditorName,
    int? totalAmount,
    String? notes,
  });

  Future<void> deleteDebt(int id);

  Future<void> addPayment({
    required int debtId,
    required int amount,
    bool fromSavings = false,
    int savingsAmount = 0,
  });

  Future<void> markDebtCompleted(int id);

  Future<void> makePayment({
    required int debtId,
    required int amount,
    required int cycleId,
    bool fromSavings = false,
  });

  Future<int> getTotalDebtPaymentsForCycle(int cycleId);

  Future<int> getTotalDebtPaymentsFromSavingsForCycle(int cycleId);

  Future<int> getTotalDebtsCreatedForCycle(int cycleId);

  Future<List<int>> getSavingsPaymentIds(int debtId);

  Future<int> getTotalActiveRemainingAmount();
}
