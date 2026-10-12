import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/dashboard/get_dashboard_data_use_case.dart';
import 'package:chahriyti/application/use_cases/statistics/stats_amounts.dart';
import 'package:chahriyti/domain/repositories/debt_repository.dart';

import 'fakes.dart';

class _NoDebts extends Fake implements DebtRepository {
  @override
  Future<int> getTotalDebtPaymentsForCycle(int cycleId) async => 0;
  @override
  Future<int> getTotalDebtPaymentsFromSavingsForCycle(int cycleId) async => 0;
  @override
  Future<int> getTotalDebtsCreatedForCycle(int cycleId) async => 0;
}

void main() {
  // Salary 80,000; the user said they had 13,000 left at setup, recorded as
  // 67,000 spent before the app. Then 2,000 of real spending.
  late FakeExpenseRepository expenses;
  late GetDashboardDataUseCase dashboard;

  setUp(() {
    final cycles = FakeCycleRepository()
      ..activeCycle = makeCycle(
        id: 1,
        salaryAmount: 80000,
        startDate: DateTime.now().subtract(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 25)),
      );
    expenses = FakeExpenseRepository()
      ..setTotal(1, 69000)
      ..setSetupAdjustment(1, 67000);
    dashboard = GetDashboardDataUseCase(
      cycleRepository: cycles,
      expenseRepository: expenses,
      incomeRepository: FakeIncomeRepository(),
      debtRepository: _NoDebts(),
    );
  });

  test('balance counts money spent before the app', () async {
    expect((await dashboard()).currentBalance, 11000);
  });

  test('spending and consumption ignore it', () async {
    final data = await dashboard();
    expect(data.totalExpenses, 2000);
    // 2,000 of the 13,000 available since setup
    expect(data.consumptionPercent, closeTo(2000 / 13000 * 100, 0.01));
  });

  test('statistics spending ignores it too', () async {
    expect(await totalSpending(expenses, 1), 2000);
  });
}
