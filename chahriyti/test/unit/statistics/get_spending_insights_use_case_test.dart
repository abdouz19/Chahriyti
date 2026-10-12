import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_spending_insights_use_case.dart';

import 'fakes.dart';

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeDashboard dashboard;
  late GetSpendingInsightsUseCase useCase;

  final today = DateTime.now();
  final midnight = DateTime(today.year, today.month, today.day);

  /// 30-day cycle on its 10th day.
  void cycleOnDay10() {
    final start = midnight.subtract(const Duration(days: 9));
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 80000,
      startDate: start,
      endDate: start.add(const Duration(days: 29)),
    );
  }

  setUp(() {
    cycleRepo = FakeCycleRepository();
    dashboard = FakeDashboard();
    useCase = GetSpendingInsightsUseCase(
      cycleRepository: cycleRepo,
      getDashboardData: dashboard,
    );
  });

  test('returns empty when no active cycle', () async {
    cycleRepo.activeCycle = null;
    expect(await useCase(), SpendingInsightsResult.empty);
  });

  test('returns empty when there is no money this cycle', () async {
    cycleOnDay10();
    expect((await useCase()).hasData, isFalse);
  });

  test('budget = spent + balance, remaining = home balance', () async {
    cycleOnDay10();
    dashboard
      ..expenses = 10000
      ..balance = 37000;
    final result = await useCase();
    expect(result.spendableBudget, 47000);
    expect(result.totalSpent, 10000);
    expect(result.remainingBudget, 37000);
    expect(result.daysElapsed, 10);
    // Today still counts, as on home
    expect(result.daysRemaining, 21);
    expect(result.dailyRemaining, closeTo(37000 / 21, 0.01));
  });

  test('last day of the cycle: today left, balance spendable today', () async {
    final start = midnight.subtract(const Duration(days: 29));
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 80000,
      startDate: start,
      endDate: start.add(const Duration(days: 29)),
    );
    dashboard
      ..expenses = 7300
      ..balance = 5700;
    final result = await useCase();
    expect(result.daysRemaining, 1);
    expect(result.dailyRemaining, closeTo(5700, 0.01));
    expect(result.projectedTotal, closeTo(7300, 0.01));
  });

  test('forecast extends the current pace', () async {
    cycleOnDay10();
    dashboard
      ..expenses = 10000
      ..balance = 37000;
    final result = await useCase();
    // 1000/day × 30 days
    expect(result.projectedTotal, closeTo(30000, 0.01));
    expect(result.projectedRatio, closeTo(30000 / 47000, 0.0001));
  });
}
