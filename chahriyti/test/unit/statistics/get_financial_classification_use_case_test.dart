import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_financial_classification_use_case.dart';

import 'fakes.dart';

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeDashboard dashboard;
  late GetFinancialClassificationUseCase useCase;

  final today = DateTime.now();
  final midnight = DateTime(today.year, today.month, today.day);

  /// 30-day cycle on its [day]-th day.
  void cycleOnDay(int day) {
    final start = midnight.subtract(Duration(days: day - 1));
    cycleRepo.activeCycle = makeCycle(
      id: 1,
      salaryAmount: 80000,
      salarySplitAmount: 60000,
      startDate: start,
      endDate: start.add(const Duration(days: 29)),
    );
  }

  setUp(() {
    cycleRepo = FakeCycleRepository();
    dashboard = FakeDashboard();
    useCase = GetFinancialClassificationUseCase(
      cycleRepository: cycleRepo,
      getDashboardData: dashboard,
    );
  });

  test('returns null when no active cycle', () async {
    cycleRepo.activeCycle = null;
    expect(await useCase(), isNull);
  });

  // Day 15 of 30, spent 5000 of 30000 → pace 10000 → 67% left → legendary
  test('legendary when on pace to keep most of the money', () async {
    cycleOnDay(15);
    dashboard
      ..expenses = 5000
      ..balance = 25000;
    expect(await useCase(), FinancialTier.legendary);
  });

  // Day 15, spent 12750 of 30000 → pace 25500 → 15% left → balanced
  test('balanced when on pace to keep a little', () async {
    cycleOnDay(15);
    dashboard
      ..expenses = 12750
      ..balance = 17250;
    expect(await useCase(), FinancialTier.balanced);
  });

  // Day 15, spent 20000 of 30000 → pace 40000 → over budget → danger
  test('danger when on pace to overspend', () async {
    cycleOnDay(15);
    dashboard
      ..expenses = 20000
      ..balance = 10000;
    expect(await useCase(), FinancialTier.danger);
  });

  // Salary 80000 with 60000 set aside, 30000 spent: old formula said
  // legendary (62% of salary left); the real balance is gone.
  test('balance gone early is earlyBankrupt, whatever the salary', () async {
    cycleOnDay(5);
    dashboard
      ..expenses = 30000
      ..balance = 0;
    expect(await useCase(), FinancialTier.earlyBankrupt);
  });

  test('balance gone late is danger', () async {
    cycleOnDay(25);
    dashboard
      ..expenses = 30000
      ..balance = 0;
    expect(await useCase(), FinancialTier.danger);
  });
}
