import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../dashboard/get_dashboard_data_use_case.dart';

class DepositFromBalanceUseCase {
  final SavingsRepository _savingsRepo;
  final CycleRepository _cycleRepo;
  final GetDashboardDataUseCase _getDashboardData;

  const DepositFromBalanceUseCase(
      this._savingsRepo, this._cycleRepo, this._getDashboardData);

  Future<void> call({required int amount}) async {
    if (amount <= 0) throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');

    final cycle = await _cycleRepo.getActiveCycle();
    if (cycle == null) throw StateError('لا توجد شهرية نشطة');

    // The balance must never go negative
    final balance = (await _getDashboardData()).currentBalance;
    if (amount > balance) {
      throw StateError('الرصيد الحالي غير كافٍ ($balance دج متاح)');
    }

    await _savingsRepo.createTransfer(
      toSavings: true,
      amount: amount,
      description: 'إيداع من الرصيد',
      cycleId: cycle.id,
    );
  }
}
