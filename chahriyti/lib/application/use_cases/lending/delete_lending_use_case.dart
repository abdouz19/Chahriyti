import '../../../domain/repositories/lending_repository.dart';

class DeleteLendingUseCase {
  final LendingRepository _repository;

  const DeleteLendingUseCase(this._repository);

  Future<void> call(int lendingId) async {
    await _repository.deleteLending(lendingId);
  }
}
