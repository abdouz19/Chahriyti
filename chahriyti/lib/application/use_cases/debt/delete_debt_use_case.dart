import '../../../domain/repositories/debt_repository.dart';
import '../../../domain/repositories/savings_repository.dart';

class DeleteDebtUseCase {
  final DebtRepository _repository;
  final SavingsRepository? _savingsRepo;

  DeleteDebtUseCase(this._repository, [this._savingsRepo]);

  Future<void> call(int debtId) async {
    if (debtId <= 0) {
      throw ArgumentError('Debt ID must be valid');
    }

    // Reverse savings withdrawals for any fromSavings payments
    if (_savingsRepo != null) {
      final paymentIds = await _repository.getSavingsPaymentIds(debtId);
      for (final paymentId in paymentIds) {
        await _savingsRepo.deleteWithdrawalByDebtPaymentId(paymentId);
      }
    }

    await _repository.deleteDebt(debtId);
  }
}
