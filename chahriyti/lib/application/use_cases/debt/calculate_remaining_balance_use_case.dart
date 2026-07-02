import '../../../domain/repositories/debt_repository.dart';

class RemainingBalance {
  final int amount; // in centimes
  final double percentagePaid;
  final bool isFullyPaid;

  RemainingBalance({
    required this.amount,
    required this.percentagePaid,
    required this.isFullyPaid,
  });
}

class CalculateRemainingBalanceUseCase {
  final DebtRepository _repository;

  CalculateRemainingBalanceUseCase(this._repository);

  Future<RemainingBalance> call(int debtId) async {
    final debt = await _repository.getDebtById(debtId);
    if (debt == null) {
      throw ArgumentError('Debt not found');
    }

    // Calculate remaining
    final remaining = debt.totalAmount - debt.paidAmount;
    final percentagePaid = debt.totalAmount > 0
        ? (debt.paidAmount / debt.totalAmount.toDouble()) * 100
        : 0.0;

    return RemainingBalance(
      amount: remaining.clamp(0, debt.totalAmount),
      percentagePaid: percentagePaid.clamp(0, 100),
      isFullyPaid: remaining <= 0,
    );
  }
}
