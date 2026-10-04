import '../../../domain/repositories/income_repository.dart';

class UpdateIncomeUseCase {
  final IncomeRepository _repository;

  UpdateIncomeUseCase(this._repository);

  Future<void> call({required int id, required String description, required int amount}) async {
    if (description.trim().isEmpty) {
      throw ArgumentError('مصدر الدخل لا يمكن أن يكون فارغاً');
    }
    if (amount <= 0) throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');
    await _repository.updateIncome(id: id, description: description.trim(), amount: amount);
  }
}
