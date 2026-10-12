import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/repositories/savings_repository.dart';

class AddLendingCollectionUseCase {
  final LendingRepository _repository;
  final SavingsRepository? _savingsRepository;
  final CycleRepository? _cycleRepository;

  const AddLendingCollectionUseCase(
    this._repository, [
    this._savingsRepository,
    this._cycleRepository,
  ]);

  Future<void> call({
    required int lendingId,
    required int amount,
    bool toSavings = false,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');
    }

    final lending = await _repository.getLendingById(lendingId);
    if (lending == null) {
      throw ArgumentError('السلفة غير موجودة');
    }

    if (amount > lending.remainingAmount) {
      throw ArgumentError(
        'مبلغ التحصيل ($amount) يتجاوز المبلغ المتبقي (${lending.remainingAmount})',
      );
    }

    // Money comes back in the current cycle, whatever cycle it was lent in
    final cycle = await _cycleRepository?.getActiveCycle();

    await _repository.addCollection(
      lendingId: lendingId,
      amount: amount,
      toSavings: toSavings,
      cycleId: cycle?.id,
    );

    // If collection goes to savings, create a savings deposit
    if (toSavings && _savingsRepository != null) {
      await _savingsRepository.createDeposit(
        amount: amount,
        description: 'تحصيل سلفة - ${lending.borrowerName}',
        cycleId: lending.cycleId ?? 0,
      );
    }
  }
}
