import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../dashboard/get_dashboard_data_use_case.dart';

class SpendingTrendPoint {
  final int dayIndex; // 1-based from cycle start
  final double daily;
  final double cumulative;

  const SpendingTrendPoint({
    required this.dayIndex,
    required this.daily,
    required this.cumulative,
  });
}

class SpendingTrend {
  final List<SpendingTrendPoint> points;
  final double budget; // spendable (salary - split)
  final int totalDays;

  const SpendingTrend({
    required this.points,
    required this.budget,
    required this.totalDays,
  });
}

class GetSpendingTrendUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;
  final GetDashboardDataUseCase _getDashboardData;

  const GetSpendingTrendUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
    required GetDashboardDataUseCase getDashboardData,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository,
        _getDashboardData = getDashboardData;

  Future<SpendingTrend?> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return null;

    final expenses = await _expenseRepository.getExpenses(cycle.id);

    final start = DateTime(
        cycle.startDate.year, cycle.startDate.month, cycle.startDate.day);
    final end =
        DateTime(cycle.endDate.year, cycle.endDate.month, cycle.endDate.day);
    final now = DateTime.now();
    final today =
        DateTime(now.year, now.month, now.day);

    final totalDays = end.difference(start).inDays + 1;
    final daysPassed = (today.difference(start).inDays + 1).clamp(1, totalDays);

    // Group expenses by day index
    final dailyMap = <int, double>{};
    for (final expense in expenses.where((e) => !e.isSetupAdjustment)) {
      final expDay = DateTime(
          expense.createdAt.year, expense.createdAt.month, expense.createdAt.day);
      final dayIndex = expDay.difference(start).inDays + 1;
      if (dayIndex >= 1 && dayIndex <= totalDays) {
        // Balance part only, to compare with the balance-based budget line
        dailyMap[dayIndex] = (dailyMap[dayIndex] ?? 0) +
            (expense.amount - expense.savingsAmount);
      }
    }

    // Build cumulative points up to today
    final points = <SpendingTrendPoint>[];
    double cumulative = 0;
    for (int day = 1; day <= daysPassed; day++) {
      final daily = dailyMap[day] ?? 0;
      cumulative += daily;
      points.add(SpendingTrendPoint(
        dayIndex: day,
        daily: daily,
        cumulative: cumulative,
      ));
    }

    // Money available this cycle, same base as the home screen
    final data = await _getDashboardData();
    final budget = (data.totalExpenses + data.currentBalance).toDouble();

    return SpendingTrend(
      points: points,
      budget: budget,
      totalDays: totalDays,
    );
  }
}
