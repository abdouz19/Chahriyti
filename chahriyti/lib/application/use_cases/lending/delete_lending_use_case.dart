import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/value_objects/lending_money_place.dart';
import 'add_lending_collection_use_case.dart';

class DeleteLendingUseCase {
  final LendingRepository _repository;
  final AddLendingCollectionUseCase _addCollection;

  const DeleteLendingUseCase(this._repository, this._addCollection);

  /// Archives the lending instead of erasing it, so the money that already
  /// moved (the lending itself, past collections) stays counted. The remaining
  /// amount is recorded as a final collection to [remainingTo]; untracked
  /// records nothing, so that money stays lost.
  Future<void> call(
    int lendingId, {
    LendingMoneyPlace remainingTo = LendingMoneyPlace.untracked,
  }) async {
    final lending = await _repository.getLendingById(lendingId);
    if (lending == null) throw ArgumentError('السلفة غير موجودة');

    final remaining = lending.remainingAmount;
    if (remaining > 0 &&
        remainingTo != LendingMoneyPlace.untracked) {
      await _addCollection(
        lendingId: lendingId,
        amount: remaining,
        toSavings: remainingTo == LendingMoneyPlace.savings,
      );
    }

    await _repository.archiveLending(lendingId);
  }
}
