import '../../../domain/entities/additional_income_entity.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../dashboard/get_dashboard_data_use_case.dart';

/// Checks that changing an income by [delta] (negative = less money) keeps
/// its destination (balance or savings) from going negative.
Future<void> checkIncomeChangeAffordable(
  AdditionalIncomeEntity income,
  int delta, {
  required SavingsRepository savingsRepo,
  required GetDashboardDataUseCase getDashboardData,
}) async {
  if (delta >= 0) return;
  if (income.toSavings) {
    final savings = await savingsRepo.getSavingsBalance();
    if (savings + delta < 0) {
      throw StateError('رصيد المدخرات غير كافٍ ($savings دج متاح)');
    }
  } else {
    final balance = (await getDashboardData()).currentBalance;
    if (balance + delta < 0) {
      throw StateError('الرصيد الحالي غير كافٍ ($balance دج متاح)');
    }
  }
}
