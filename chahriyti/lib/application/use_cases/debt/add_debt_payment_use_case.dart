import '../../../domain/entities/debt_entity.dart';
import '../../../domain/repositories/debt_repository.dart';

class AddDebtPaymentUseCase {
  final DebtRepository _repository;

  AddDebtPaymentUseCase(this._repository);

  Future<void> call({
    required int debtId,
    required int amount, // in centimes
  }) async {
    // Validate
    if (amount <= 0) {
      throw ArgumentError('Payment amount must be greater than zero');
    }

    // Get debt to check remaining balance
    final debt = await _repository.getDebtById(debtId);
    if (debt == null) {
      throw ArgumentError('Debt not found');
    }

    // Calculate remaining balance
    final payments = debt.payments.fold<int>(0, (sum, p) => sum + p.amount);
    final remainingBalance = debt.totalAmount - payments;

    if (amount > remainingBalance) {
      throw ArgumentError(
        'Payment amount ($amount) exceeds remaining balance ($remainingBalance)',
      );
    }

    // Add payment
    await _repository.addPayment(debtId: debtId, amount: amount);

    // Mark as completed if balance is now zero
    if ((remainingBalance - amount) <= 0) {
      await _repository.markDebtCompleted(debtId);
    }
  }
}
