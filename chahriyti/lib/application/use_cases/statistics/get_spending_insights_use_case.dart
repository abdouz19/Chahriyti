import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

class SpendingInsightsResult {
  final bool hasData;
  final int spendableBudget;   // salaryAmount - salarySplitAmount
  final int totalSpent;
  final int remainingBudget;   // can be negative (over budget)
  final double dailyRemaining; // remainingBudget / daysRemaining (can be negative)
  final int daysRemaining;
  final int daysElapsed;
  final int totalDays;
  final double projectedTotal; // totalSpent + (dailyRate * daysRemaining)
  final double projectedRatio; // projectedTotal / spendableBudget

  const SpendingInsightsResult({
    required this.hasData,
    required this.spendableBudget,
    required this.totalSpent,
    required this.remainingBudget,
    required this.dailyRemaining,
    required this.daysRemaining,
    required this.daysElapsed,
    required this.totalDays,
    required this.projectedTotal,
    required this.projectedRatio,
  });

  bool get isOverBudget => projectedRatio > 1.0;
  bool get isNearBudget => projectedRatio >= 0.9 && projectedRatio <= 1.0;
  bool get isDailyNegative => dailyRemaining < 0;

  static const empty = SpendingInsightsResult(
    hasData: false,
    spendableBudget: 0,
    totalSpent: 0,
    remainingBudget: 0,
    dailyRemaining: 0.0,
    daysRemaining: 0,
    daysElapsed: 0,
    totalDays: 0,
    projectedTotal: 0.0,
    projectedRatio: 0.0,
  );
}

class GetSpendingInsightsUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;

  const GetSpendingInsightsUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository;

  Future<SpendingInsightsResult> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return SpendingInsightsResult.empty;

    final spendable = cycle.salaryAmount - cycle.salarySplitAmount;
    if (spendable <= 0) return SpendingInsightsResult.empty;

    final now = DateTime.now();
    final start = DateTime(
        cycle.startDate.year, cycle.startDate.month, cycle.startDate.day);
    final end = DateTime(
        cycle.endDate.year, cycle.endDate.month, cycle.endDate.day);
    final today = DateTime(now.year, now.month, now.day);

    final totalDays = end.difference(start).inDays + 1;
    final daysElapsed =
        (today.difference(start).inDays + 1).clamp(1, totalDays);
    final daysRemaining = (totalDays - daysElapsed).clamp(0, totalDays);

    final spent = await _expenseRepository.getTotalExpenses(cycle.id);
    final remaining = spendable - spent;

    final dailyRemaining =
        daysRemaining > 0 ? remaining / daysRemaining : 0.0;

    // Forecast: current daily rate × remaining days + already spent
    final dailyRate = spent / daysElapsed;
    final projected = spent + dailyRate * daysRemaining;
    final ratio = projected / spendable;

    return SpendingInsightsResult(
      hasData: true,
      spendableBudget: spendable,
      totalSpent: spent,
      remainingBudget: remaining,
      dailyRemaining: dailyRemaining,
      daysRemaining: daysRemaining,
      daysElapsed: daysElapsed,
      totalDays: totalDays,
      projectedTotal: projected,
      projectedRatio: ratio,
    );
  }
}
