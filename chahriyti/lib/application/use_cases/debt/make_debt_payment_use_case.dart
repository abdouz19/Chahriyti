import '../../../domain/entities/debt_entity.dart';
import '../../../domain/repositories/debt_repository.dart';

class MakeDebtPaymentUseCase {
  final DebtRepository _repo;

  const MakeDebtPaymentUseCase(this._repo);

  Future<void> call({
    required DebtEntity debt,
    required int amount,
    required int cycleId,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('مبلغ الدفع يجب أن يكون أكبر من الصفر');
    }
    if (amount > debt.remainingAmount) {
      throw ArgumentError('مبلغ الدفع يتجاوز المبلغ المتبقي');
    }
    await _repo.makePayment(
      debtId: debt.id,
      amount: amount,
      cycleId: cycleId,
    );
  }
}
