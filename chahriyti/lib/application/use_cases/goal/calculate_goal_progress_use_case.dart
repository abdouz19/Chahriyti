import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/income_repository.dart';

class GoalProgress {
  final double savedAmount; // in centimes
  final double progressPercent;
  final bool isCompleted;

  GoalProgress({
    required this.savedAmount,
    required this.progressPercent,
    required this.isCompleted,
  });
}

class CalculateGoalProgressUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;
  final IncomeRepository _incomeRepository;

  CalculateGoalProgressUseCase(
    this._cycleRepository,
    this._expenseRepository,
    this._incomeRepository,
  );

  Future<GoalProgress> call(int goalTargetAmount) async {
    // Get active cycle
    final activeCycle = await _cycleRepository.getActiveCycle();
    if (activeCycle == null) {
      return GoalProgress(
        savedAmount: 0,
        progressPercent: 0,
        isCompleted: false,
      );
    }

    // Get total income in cycle
    final incomes = await _incomeRepository.getIncomesByDateRange(
      activeCycle.startDate,
      activeCycle.endDate,
    );
    final totalIncome = incomes.fold<int>(0, (sum, income) => sum + income.amount);

    // Get total expenses in cycle
    final expenses = await _expenseRepository.getExpensesByDateRange(
      activeCycle.startDate,
      activeCycle.endDate,
    );
    final totalExpenses = expenses.fold<int>(0, (sum, exp) => sum + exp.amount);

    // Calculate savings (income - expenses)
    final savedAmount = totalIncome - totalExpenses;
    final progressPercent = totalIncome > 0
        ? (savedAmount / goalTargetAmount.toDouble()) * 100
        : 0.0;

    return GoalProgress(
      savedAmount: savedAmount.toDouble(),
      progressPercent: progressPercent.clamp(0, 9999), // Allow >100%
      isCompleted: savedAmount >= goalTargetAmount,
    );
  }
}
