import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_past_cycles_use_case.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';

import 'fakes.dart';

class _Savings extends FakeSavingsRepository {
  final List<SavingsHistoryEntity> records;
  _Savings(this.records);

  @override
  Future<List<SavingsHistoryEntity>> getSavingsHistory(
          {int? limit, int? offset}) async =>
      records;
}

SavingsHistoryEntity _deposit(int cycleId, int amount, String description) =>
    SavingsHistoryEntity(
      id: amount,
      type: SavingsTransactionType.deposit,
      amount: amount,
      description: description,
      relatedCycleId: cycleId,
      createdAt: DateTime(2026, 10, 1),
    );

void main() {
  test('summarises closed cycles: income, all spending, saved at close',
      () async {
    final cycles = FakeCycleRepository()
      ..activeCycle = makeCycle(id: 3, startDate: DateTime(2026, 10, 1))
      ..history = [
        makeCycle(id: 3, startDate: DateTime(2026, 10, 1)),
        makeCycle(
            id: 2,
            isActive: false,
            salaryAmount: 80000,
            startDate: DateTime(2026, 9, 1)),
      ];
    final expenses = FakeExpenseRepository()
      ..setTotal(2, 50000)
      ..setFromSavings(2, 10000);
    final incomes = FakeIncomeRepository()
      ..setIncomes(2, [
        makeIncome(cycleId: 2, description: 'رصيد أولي', amount: 500000),
        makeIncome(id: 2, cycleId: 2, description: 'Bonus', amount: 5000),
      ]);
    final savings = _Savings([
      _deposit(2, 30000, 'ادخار نهاية الدورة'),
      _deposit(2, 4000, 'إيداع من الرصيد'), // a manual move, not a leftover
    ]);

    final result = await GetPastCyclesUseCase(
      cycleRepository: cycles,
      expenseRepository: expenses,
      incomeRepository: incomes,
      savingsRepository: savings,
    ).call();

    expect(result, hasLength(1));
    final september = result.single;
    expect(september.cycle.id, 2);
    expect(september.income, 85000); // salary + bonus, no opening balance
    expect(september.spending, 60000); // balance + savings part
    expect(september.saved, 30000);
  });
}
