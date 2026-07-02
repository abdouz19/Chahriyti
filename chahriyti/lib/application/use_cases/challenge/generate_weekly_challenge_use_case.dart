import '../../../domain/repositories/challenge_repository.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

class GenerateWeeklyChallengeUseCase {
  final ChallengeRepository _challengeRepository;
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;

  GenerateWeeklyChallengeUseCase(
    this._challengeRepository,
    this._cycleRepository,
    this._expenseRepository,
  );

  Future<int?> call() async {
    // Get active cycle
    final activeCycle = await _cycleRepository.getActiveCycle();
    if (activeCycle == null) return null;

    // Get current week start (Monday)
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    // Check if challenge already exists for this week
    final existingChallenge = await _challengeRepository
        .getActiveChallengeForWeek(weekStart, weekEnd);
    if (existingChallenge != null) {
      return null; // Challenge already exists
    }

    // Get previous week's spending to calculate target
    final previousWeekStart = weekStart.subtract(const Duration(days: 7));
    final previousWeekEnd = weekStart;

    final previousExpenses =
        await _expenseRepository.getExpensesByDateRange(
      previousWeekStart,
      previousWeekEnd,
    );
    final previousWeekSpending = previousExpenses.fold<int>(
      0,
      (sum, expense) => sum + expense.amount,
    );

    // Challenge: spend 10% less than previous week, clamped between 500-1000 DZD
    final targetReduction = (previousWeekSpending * 0.1).toInt().clamp(500, 1000);
    final targetAmount = (previousWeekSpending - targetReduction).clamp(0, previousWeekSpending);

    // Create challenge
    final challengeId = await _challengeRepository.createChallenge(
      weekStartDate: weekStart,
      targetAmount: targetAmount,
      description:
          'حاول أن تصرف أقل من $previousWeekSpending دج في هذا الأسبوع',
    );

    return challengeId;
  }
}
