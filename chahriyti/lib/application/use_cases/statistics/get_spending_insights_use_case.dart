import '../../../domain/repositories/cycle_repository.dart';
import '../dashboard/get_dashboard_data_use_case.dart';

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
  final GetDashboardDataUseCase _getDashboardData;

  const GetSpendingInsightsUseCase({
    required CycleRepository cycleRepository,
    required GetDashboardDataUseCase getDashboardData,
  })  : _cycleRepository = cycleRepository,
        _getDashboardData = getDashboardData;

  /// Budget = money available this cycle = spent from the balance + what's
  /// left in it (same base as the home screen); remaining = home balance.
  Future<SpendingInsightsResult> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return SpendingInsightsResult.empty;

    final data = await _getDashboardData();
    final spent = data.totalExpenses;
    final available = spent + data.currentBalance;
    if (available <= 0) return SpendingInsightsResult.empty;

    final now = DateTime.now();
    final start = DateTime(
        cycle.startDate.year, cycle.startDate.month, cycle.startDate.day);
    final end = DateTime(
        cycle.endDate.year, cycle.endDate.month, cycle.endDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final totalDays = end.difference(start).inDays + 1;
    final daysElapsed =
        (today.difference(start).inDays + 1).clamp(1, totalDays);
    // Days still to live on the money, today included (same as home): on
    // the last day the balance is still there to spend
    final daysRemaining =
        (end.difference(today).inDays + 1).clamp(0, totalDays);

    final remaining = data.currentBalance;
    final dailyRemaining =
        daysRemaining > 0 ? remaining / daysRemaining : 0.0;

    // Forecast: current daily rate × the days after today + already spent
    final dailyRate = spent / daysElapsed;
    final projected = spent + dailyRate * (daysRemaining - 1).clamp(0, totalDays);

    return SpendingInsightsResult(
      hasData: true,
      spendableBudget: available,
      totalSpent: spent,
      remainingBudget: remaining,
      dailyRemaining: dailyRemaining,
      daysRemaining: daysRemaining,
      daysElapsed: daysElapsed,
      totalDays: totalDays,
      projectedTotal: projected,
      projectedRatio: projected / available,
    );
  }
}
