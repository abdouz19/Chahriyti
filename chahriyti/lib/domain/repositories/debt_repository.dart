import '../entities/debt_entity.dart';

abstract class DebtRepository {
  Future<DebtEntity> addDebt({
    required String creditorName,
    required int totalAmount,
    required int paidAmount,
  });

  Future<void> makePayment({
    required int debtId,
    required int amount,
    required int cycleId,
  });

  Future<List<DebtEntity>> getDebts();

  Future<List<DebtEntity>> getActiveDebts();

  Future<int> getTotalDebtPaymentsForCycle(int cycleId);
}
