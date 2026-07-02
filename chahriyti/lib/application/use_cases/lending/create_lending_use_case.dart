import '../../../domain/entities/lending_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../savings/withdraw_savings_use_case.dart';

class CreateLendingUseCase {
  final LendingRepository _lendingRepository;
  final CycleRepository _cycleRepository;
  final WithdrawSavingsUseCase? _withdrawSavings;
  final SavingsRepository? _savingsRepository;

  CreateLendingUseCase(
    this._lendingRepository,
    this._cycleRepository, [
    this._withdrawSavings,
    this._savingsRepository,
  ]);

  Future<LendingEntity> call({
    required String borrowerName,
    required int amount,
    bool fromSavings = false,
    int savingsAmount = 0,
    String? notes,
  }) async {
    if (borrowerName.trim().isEmpty) throw ArgumentError('اسم المقترض مطلوب');
    if (amount <= 0) throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');

    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) throw StateError('لا توجد دورة مالية نشطة');

    final effectiveSavingsAmount = fromSavings ? amount : savingsAmount.clamp(0, amount);

    if (effectiveSavingsAmount > 0 && _savingsRepository != null) {
      final savingsBalance = await _savingsRepository.getSavingsBalance();
      if (effectiveSavingsAmount > savingsBalance) {
        throw StateError('رصيد المدخرات غير كافي');
      }
    }

    final lending = await _lendingRepository.createLending(
      borrowerName: borrowerName.trim(),
      totalAmount: amount,
      fromSavings: fromSavings,
      savingsAmount: effectiveSavingsAmount,
      cycleId: cycle.id,
      notes: notes?.trim(),
    );

    if (effectiveSavingsAmount > 0 && _withdrawSavings != null) {
      await _withdrawSavings.call(
        amount: effectiveSavingsAmount,
        description: 'سلفة - $borrowerName',
        lendingId: lending.id,
      );
    }

    return lending;
  }
}
