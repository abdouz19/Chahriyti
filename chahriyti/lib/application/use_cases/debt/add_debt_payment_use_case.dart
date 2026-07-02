import '../../../domain/repositories/debt_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../savings/withdraw_savings_use_case.dart';

class AddDebtPaymentUseCase {
  final DebtRepository _repository;
  final WithdrawSavingsUseCase? _withdrawSavings;
  final SavingsRepository? _savingsRepository;

  AddDebtPaymentUseCase(
    this._repository, [
    this._withdrawSavings,
    this._savingsRepository,
  ]);

  Future<void> call({
    required int debtId,
    required int amount,
    bool fromSavings = false,
    int savingsAmount = 0,
  }) async {
    if (amount <= 0) throw ArgumentError('Payment amount must be greater than zero');

    final debt = await _repository.getDebtById(debtId);
    if (debt == null) throw ArgumentError('Debt not found');

    final remainingBalance = debt.totalAmount - debt.paidAmount;
    if (amount > remainingBalance) {
      throw ArgumentError('مبلغ السداد ($amount) يتجاوز المبلغ المتبقي ($remainingBalance)');
    }

    final effectiveSavingsAmount = fromSavings ? amount : savingsAmount.clamp(0, amount);

    if (effectiveSavingsAmount > 0 && _withdrawSavings != null) {
      final savingsBalance = await _savingsRepository!.getSavingsBalance();
      if (effectiveSavingsAmount > savingsBalance) {
        throw StateError('رصيد المدخرات غير كافي ($savingsBalance دج متاح)');
      }
    }

    await _repository.addPayment(
      debtId: debtId,
      amount: amount,
      fromSavings: fromSavings,
      savingsAmount: effectiveSavingsAmount,
    );

    if (effectiveSavingsAmount > 0 && _withdrawSavings != null) {
      await _withdrawSavings.call(
        amount: effectiveSavingsAmount,
        description: 'سداد دين - ${debt.creditorName}',
        debtPaymentId: debtId,
      );
    }

    if ((remainingBalance - amount) <= 0) {
      await _repository.markDebtCompleted(debtId);
    }
  }
}
