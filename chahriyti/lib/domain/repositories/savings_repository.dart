import '../entities/savings_history_entity.dart';

abstract class SavingsRepository {
  Future<int> getSavingsBalance();
  Future<List<SavingsHistoryEntity>> getSavingsHistory({int? limit, int? offset});
  Future<SavingsHistoryEntity> createDeposit({
    required int amount,
    required String description,
    required int cycleId,
  });
  Future<SavingsHistoryEntity> createWithdrawal({
    required int amount,
    required String description,
    int? expenseId,
    int? debtPaymentId,
    int? lendingId,
  });
  Future<void> deleteWithdrawalByExpenseId(int expenseId);
  Future<void> deleteWithdrawalByDebtPaymentId(int debtPaymentId);
  Future<void> deleteWithdrawalByLendingId(int lendingId);
  Future<void> updateWithdrawalAmountByExpenseId(
      int expenseId, int newAmount);
  Future<void> updateWithdrawalAmountByDebtPaymentId(
      int debtPaymentId, int newAmount);
}
