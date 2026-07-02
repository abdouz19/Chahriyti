import '../../../domain/repositories/income_repository.dart';

class UpdateIncomeUseCase {
  final IncomeRepository _repository;

  UpdateIncomeUseCase(this._repository);

  Future<void> call({required int id, required String description}) async {
    if (description.trim().isEmpty) {
      throw ArgumentError('مصدر الدخل لا يمكن أن يكون فارغاً');
    }
    await _repository.updateIncome(id: id, description: description.trim());
  }
}
