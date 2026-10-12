import '../../../domain/repositories/goal_repository.dart';
import '../savings/withdraw_savings_use_case.dart';

class PurchaseGoalUseCase {
  final GoalRepository _goalRepository;
  final WithdrawSavingsUseCase _withdrawSavings;

  const PurchaseGoalUseCase(this._goalRepository, this._withdrawSavings);

  /// Takes the actual [price] out of savings and marks the goal bought,
  /// remembering the withdrawal so the purchase can be undone.
  Future<void> call({
    required int goalId,
    required String goalName,
    required int price,
  }) async {
    final withdrawal = await _withdrawSavings(
      amount: price,
      description: 'شراء هدف - $goalName',
    );
    await _goalRepository.markGoalPurchased(
      id: goalId,
      amount: price,
      transactionId: withdrawal.id,
    );
  }
}
