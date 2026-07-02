import '../../../domain/repositories/challenge_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

class ChallengeProgress {
  final int currentSpending; // in centimes
  final int targetAmount; // in centimes
  final int remainingBudget;
  final double percentageOfBudget;
  final bool isCompleted;

  ChallengeProgress({
    required this.currentSpending,
    required this.targetAmount,
    required this.remainingBudget,
    required this.percentageOfBudget,
    required this.isCompleted,
  });
}

class CalculateChallengeProgressUseCase {
  final ChallengeRepository _challengeRepository;
  final ExpenseRepository _expenseRepository;

  CalculateChallengeProgressUseCase(
    this._challengeRepository,
    this._expenseRepository,
  );

  Future<ChallengeProgress> call(int challengeId) async {
    final challenge = await _challengeRepository.getChallengeById(challengeId);
    if (challenge == null) {
      throw ArgumentError('Challenge not found');
    }

    // Get spending since challenge started
    final expenses = await _expenseRepository.getExpensesByDateRange(
      challenge.weekStart,
      challenge.weekStart.add(const Duration(days: 7)),
    );

    final currentSpending = expenses.fold<int>(0, (sum, exp) => sum + exp.amount);
    final targetAmount = challenge.targetAmount;
    final remainingBudget = targetAmount - currentSpending;
    final percentageOfBudget = targetAmount > 0
        ? (currentSpending / targetAmount.toDouble()) * 100
        : 0.0;

    return ChallengeProgress(
      currentSpending: currentSpending,
      targetAmount: targetAmount,
      remainingBudget: remainingBudget.clamp(0, targetAmount),
      percentageOfBudget: percentageOfBudget.clamp(0, 100),
      isCompleted: currentSpending <= targetAmount,
    );
  }
}
