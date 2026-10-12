import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/savings_repository.dart';

class WithdrawToBalanceUseCase {
  final SavingsRepository _savingsRepo;
  final CycleRepository _cycleRepo;

  const WithdrawToBalanceUseCase(this._savingsRepo, this._cycleRepo);

  Future<void> call({required int amount}) async {
    if (amount <= 0) throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');

    final cycle = await _cycleRepo.getActiveCycle();
    if (cycle == null) throw StateError('لا توجد شهرية نشطة');

    final savingsBalance = await _savingsRepo.getSavingsBalance();
    if (amount > savingsBalance) {
      throw StateError('رصيد المدخرات غير كافٍ ($savingsBalance دج متاح)');
    }

    // Recorded as its own transfer (not via the salary split), so the
    // balance always gets the full amount
    await _savingsRepo.createTransfer(
      toSavings: false,
      amount: amount,
      description: 'سحب للرصيد',
      cycleId: cycle.id,
    );
  }
}
