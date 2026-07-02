import '../../../domain/repositories/income_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../../../domain/entities/additional_income_entity.dart';

class AddIncomeUseCase {
  final IncomeRepository _repo;
  final SavingsRepository? _savingsRepository;

  const AddIncomeUseCase(this._repo, [this._savingsRepository]);

  Future<AdditionalIncomeEntity> call({
    required int cycleId,
    required String description,
    required int amount,
    bool toSavings = false,
  }) async {
    if (amount <= 0) throw ArgumentError('المبلغ يجب أن يكون أكبر من الصفر');
    if (description.trim().isEmpty) {
      throw ArgumentError('مصدر الدخل مطلوب');
    }
    final income = await _repo.addIncome(
      cycleId: cycleId,
      description: description.trim(),
      amount: amount,
      toSavings: toSavings,
    );
    if (toSavings && _savingsRepository != null) {
      await _savingsRepository.createDeposit(
        amount: amount,
        description: 'مدخول - ${description.trim()}',
        cycleId: cycleId,
      );
    }
    return income;
  }
}
