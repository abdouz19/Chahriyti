import '../../../domain/repositories/income_repository.dart';

class DeleteIncomeUseCase {
  final IncomeRepository _repository;

  DeleteIncomeUseCase(this._repository);

  Future<void> call(int id) async {
    await _repository.deleteIncome(id);
  }
}
