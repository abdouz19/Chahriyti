import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../../../domain/value_objects/lending_money_place.dart';

class UpdateLendingRequest {
  final int id;
  final String? borrowerName;
  final String? notes;
  final int? totalAmount;

  /// Where the amount difference comes from (increase) or goes to (decrease).
  /// Null leaves money untouched beyond what the balance formula derives.
  final LendingMoneyPlace? deltaPlace;

  UpdateLendingRequest({
    required this.id,
    this.borrowerName,
    this.notes,
    this.totalAmount,
    this.deltaPlace,
  });
}

class UpdateLendingUseCase {
  final LendingRepository _repository;
  final CycleRepository? _cycleRepository;
  final SavingsRepository? _savingsRepository;

  UpdateLendingUseCase(
    this._repository, [
    this._cycleRepository,
    this._savingsRepository,
  ]);

  Future<void> call(UpdateLendingRequest request) async {
    if (request.totalAmount != null && request.totalAmount! <= 0) {
      throw ArgumentError('المبلغ يجب أن يكون أكبر من الصفر');
    }

    final place = request.deltaPlace;
    final lending = place != null && request.totalAmount != null
        ? await _repository.getLendingById(request.id)
        : null;
    final delta =
        lending != null ? request.totalAmount! - lending.totalAmount : 0;

    // Savings must cover an increase taken from it
    if (delta > 0 && place == LendingMoneyPlace.savings) {
      final savings = await _savingsRepository!.getSavingsBalance();
      if (delta > savings) {
        throw StateError('رصيد المدخرات غير كافٍ ($savings دج متاح)');
      }
    }

    await _repository.updateLending(
      id: request.id,
      borrowerName: request.borrowerName,
      notes: request.notes,
      totalAmount: request.totalAmount,
    );

    if (lending == null || delta == 0) return;

    // A bigger lending is money out (-delta); a smaller one is money back.
    final cycle = await _cycleRepository!.getActiveCycle();

    // Editing totalAmount already shifts the balance by -delta, but only for a
    // balance-funded lending of the active cycle. Correct the balance so it
    // ends up exactly where the user said the difference went.
    final derived =
        !lending.fromSavings && lending.cycleId == cycle?.id ? -delta : 0;
    final wanted = place == LendingMoneyPlace.balance ? -delta : 0;
    final correction = wanted - derived;
    if (correction != 0 && cycle != null) {
      await _repository.addBalanceAdjustment(
        lendingId: lending.id,
        amount: correction,
        cycleId: cycle.id,
      );
    }

    if (place == LendingMoneyPlace.savings) {
      final description = 'تعديل سلفة - ${lending.borrowerName}';
      if (delta > 0) {
        await _savingsRepository!.createWithdrawal(
          amount: delta,
          description: description,
          lendingId: lending.id,
        );
      } else {
        await _savingsRepository!.createDeposit(
          amount: -delta,
          description: description,
          cycleId: cycle?.id ?? lending.cycleId ?? 0,
        );
      }
    }
  }
}
