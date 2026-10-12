import '../../../domain/entities/goal_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/goal_repository.dart';
import '../../../domain/repositories/savings_repository.dart';

class UndoGoalPurchaseUseCase {
  final GoalRepository _goalRepository;
  final SavingsRepository _savingsRepository;
  final CycleRepository _cycleRepository;

  const UndoGoalPurchaseUseCase(
    this._goalRepository,
    this._savingsRepository,
    this._cycleRepository,
  );

  /// Gives the purchase money back to savings and reopens the goal.
  Future<void> call(GoalEntity goal) async {
    final transactionId = goal.purchaseTransactionId;
    if (transactionId != null) {
      // Remove the original withdrawal: savings history reads as if the
      // purchase never happened
      await _savingsRepository.deleteTransaction(transactionId);
    } else {
      // Bought before purchases were tracked: the target was withdrawn
      final cycle = await _cycleRepository.getActiveCycle();
      await _savingsRepository.createDeposit(
        amount: goal.purchasedAmount ?? goal.targetAmount,
        description: 'إلغاء شراء هدف - ${goal.name}',
        cycleId: cycle?.id ?? 0,
      );
    }
    await _goalRepository.undoGoalPurchase(goal.id);
  }
}
