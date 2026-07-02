import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/savings_repository.dart';

class WithdrawToBalanceUseCase {
  final SavingsRepository _savingsRepo;
  final CycleRepository _cycleRepo;

  const WithdrawToBalanceUseCase(this._savingsRepo, this._cycleRepo);

  Future<void> call({required int amount}) async {
    if (amount <= 0) throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');

    final cycle = await _cycleRepo.getActiveCycle();
    if (cycle == null) throw StateError('لا توجد دورة مالية نشطة');

    final savingsBalance = await _savingsRepo.getSavingsBalance();
    if (amount > savingsBalance) {
      throw StateError('رصيد المدخرات غير كافٍ ($savingsBalance دج متاح)');
    }

    await _savingsRepo.createWithdrawal(
      amount: amount,
      description: 'سحب للرصيد',
    );

    // Decrease salarySplitAmount so balance formula reflects the transfer
    final newSplit = (cycle.salarySplitAmount - amount).clamp(0, cycle.salaryAmount);
    await _cycleRepo.updateCycleSalarySplit(cycle.id, newSplit);
  }
}
