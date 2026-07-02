import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/savings_repository.dart';

class DepositFromBalanceUseCase {
  final SavingsRepository _savingsRepo;
  final CycleRepository _cycleRepo;

  const DepositFromBalanceUseCase(this._savingsRepo, this._cycleRepo);

  Future<void> call({required int amount}) async {
    if (amount <= 0) throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');

    final cycle = await _cycleRepo.getActiveCycle();
    if (cycle == null) throw StateError('لا توجد دورة مالية نشطة');

    await _savingsRepo.createDeposit(
      amount: amount,
      description: 'إيداع من الرصيد',
      cycleId: cycle.id,
    );

    // Increase salarySplitAmount so the balance formula reflects the transfer
    await _cycleRepo.updateCycleSalarySplit(
      cycle.id,
      cycle.salarySplitAmount + amount,
    );
  }
}
