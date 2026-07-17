import '../../../domain/repositories/lending_repository.dart';

class DeleteInitialLendingUseCase {
  final LendingRepository _lendingRepository;

  DeleteInitialLendingUseCase(this._lendingRepository);

  Future<void> call(int id) => _lendingRepository.deleteLending(id);
}
