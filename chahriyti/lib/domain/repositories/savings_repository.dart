import '../entities/savings_history_entity.dart';

abstract class SavingsRepository {
  Future<int> getSavingsBalance();
  Future<List<SavingsHistoryEntity>> getSavingsHistory({int? limit, int? offset});
  Future<SavingsHistoryEntity> createDeposit({
    required int amount,
    required String description,
    required int cycleId,
  });
  Future<void> createInitialDeposit({required int amount});

  /// Moves money between the balance of [cycleId] and savings.
  Future<SavingsHistoryEntity> createTransfer({
    required bool toSavings,
    required int amount,
    required String description,
    required int cycleId,
  });

  /// Deposit of an income sent to savings, linked so it follows the income.
  Future<void> createIncomeDeposit({
    required int amount,
    required String description,
    required int cycleId,
    required int incomeId,
  });

  Future<void> updateDepositAmountByIncomeId(int incomeId, int amount);

  Future<void> deleteDepositByIncomeId(int incomeId);

  /// Net money moved from savings into the balance of [cycleId].
  Future<int> getNetTransfersToBalanceForCycle(int cycleId);
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
  Future<void> deleteTransaction(int id);
  Future<void> updateTransaction(int id, {required int amount, required String description});
}
