import '../../../domain/entities/savings_history_entity.dart';
import '../../../domain/repositories/savings_repository.dart';

class WithdrawSavingsUseCase {
  final SavingsRepository _repository;

  const WithdrawSavingsUseCase(this._repository);

  /// Creates a savings withdrawal record. Validates that amount doesn't exceed
  /// available savings balance.
  Future<SavingsHistoryEntity> call({
    required int amount,
    required String description,
    int? expenseId,
    int? debtPaymentId,
    int? lendingId,
  }) async {
    if (amount <= 0) throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');

    final balance = await _repository.getSavingsBalance();
    if (amount > balance) {
      throw StateError('رصيد المدخرات غير كافي ($balance دج متاح)');
    }

    return _repository.createWithdrawal(
      amount: amount,
      description: description,
      expenseId: expenseId,
      debtPaymentId: debtPaymentId,
      lendingId: lendingId,
    );
  }
}
