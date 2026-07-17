import '../../../domain/repositories/debt_repository.dart';

class DeleteInitialDebtUseCase {
  final DebtRepository _debtRepository;

  DeleteInitialDebtUseCase(this._debtRepository);

  Future<void> call(int id) => _debtRepository.deleteDebt(id);
}
