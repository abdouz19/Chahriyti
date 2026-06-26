import '../../../domain/repositories/debt_repository.dart';

class DeleteDebtUseCase {
  final DebtRepository _repository;

  DeleteDebtUseCase(this._repository);

  Future<void> call(int debtId) async {
    if (debtId <= 0) {
      throw ArgumentError('Debt ID must be valid');
    }
    await _repository.deleteDebt(debtId);
  }
}
