import '../../../domain/entities/additional_income_entity.dart';
import '../../../domain/repositories/income_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../dashboard/get_dashboard_data_use_case.dart';
import 'income_change_check.dart';

class DeleteIncomeUseCase {
  final IncomeRepository _repository;
  final SavingsRepository _savingsRepo;
  final GetDashboardDataUseCase _getDashboardData;

  DeleteIncomeUseCase(
      this._repository, this._savingsRepo, this._getDashboardData);

  /// Removes the income and the money it brought, from the balance or from
  /// savings. Refused when that place can't give the money back.
  Future<void> call(AdditionalIncomeEntity income) async {
    await checkIncomeChangeAffordable(income, -income.amount,
        savingsRepo: _savingsRepo, getDashboardData: _getDashboardData);
    if (income.toSavings) {
      await _savingsRepo.deleteDepositByIncomeId(income.id);
    }
    await _repository.deleteIncome(income.id);
  }
}
