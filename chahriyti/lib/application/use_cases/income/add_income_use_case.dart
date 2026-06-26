import '../../../domain/repositories/income_repository.dart';
import '../../../domain/entities/additional_income_entity.dart';

class AddIncomeUseCase {
  final IncomeRepository _repo;

  const AddIncomeUseCase(this._repo);

  Future<AdditionalIncomeEntity> call({
    required int cycleId,
    required String description,
    required int amount,
  }) async {
    if (amount <= 0) throw ArgumentError('المبلغ يجب أن يكون أكبر من الصفر');
    if (description.trim().isEmpty) {
      throw ArgumentError('مصدر الدخل مطلوب');
    }
    return _repo.addIncome(
      cycleId: cycleId,
      description: description.trim(),
      amount: amount,
    );
  }
}
