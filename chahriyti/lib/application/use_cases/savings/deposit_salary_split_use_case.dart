import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/savings_repository.dart';

class DepositSalarySplitUseCase {
  final CycleRepository _cycleRepository;
  final SavingsRepository _savingsRepository;

  const DepositSalarySplitUseCase({
    required CycleRepository cycleRepository,
    required SavingsRepository savingsRepository,
  })  : _cycleRepository = cycleRepository,
        _savingsRepository = savingsRepository;

  /// Creates a savings deposit from a salary split and updates the cycle's
  /// salarySplitAmount. Returns the created deposit, or null if amount is 0.
  Future<void> call({required int cycleId, required int amount}) async {
    if (amount <= 0) return;

    final cycle = await _cycleRepository.getCycleById(cycleId);
    if (cycle == null) {
      throw StateError('Cycle not found: $cycleId');
    }

    if (amount > cycle.salaryAmount) {
      throw ArgumentError(
        'Split amount ($amount) exceeds salary (${cycle.salaryAmount})',
      );
    }

    await _savingsRepository.createDeposit(
      amount: amount,
      description: 'تقسيم الراتب',
      cycleId: cycleId,
    );

    await _cycleRepository.updateCycleSalarySplit(cycleId, amount);
  }
}
