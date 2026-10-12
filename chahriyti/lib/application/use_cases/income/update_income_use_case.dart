import '../../../domain/entities/additional_income_entity.dart';
import '../../../domain/repositories/income_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../dashboard/get_dashboard_data_use_case.dart';
import 'income_change_check.dart';

class UpdateIncomeUseCase {
  final IncomeRepository _repository;
  final SavingsRepository _savingsRepo;
  final GetDashboardDataUseCase _getDashboardData;

  UpdateIncomeUseCase(
      this._repository, this._savingsRepo, this._getDashboardData);

  /// Changes the income and moves the difference in its destination.
  Future<void> call({
    required AdditionalIncomeEntity income,
    required String description,
    required int amount,
  }) async {
    if (description.trim().isEmpty) {
      throw ArgumentError('مصدر الدخل لا يمكن أن يكون فارغاً');
    }
    if (amount <= 0) throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');

    await checkIncomeChangeAffordable(income, amount - income.amount,
        savingsRepo: _savingsRepo, getDashboardData: _getDashboardData);
    if (income.toSavings && amount != income.amount) {
      await _savingsRepo.updateDepositAmountByIncomeId(income.id, amount);
    }
    await _repository.updateIncome(
        id: income.id, description: description.trim(), amount: amount);
  }
}
