import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/repositories/savings_repository.dart';

class AddLendingCollectionUseCase {
  final LendingRepository _repository;
  final SavingsRepository? _savingsRepository;

  const AddLendingCollectionUseCase(this._repository, [this._savingsRepository]);

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

    await _repository.addCollection(
      lendingId: lendingId,
      amount: amount,
      toSavings: toSavings,
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
