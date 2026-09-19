import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/income_repository.dart';

class IncomeVsSpendingPoint {
  final DateTime month;
  final int income;   // salary + additional incomes
  final int spending; // total expenses from balance

  const IncomeVsSpendingPoint({
    required this.month,
    required this.income,
    required this.spending,
  });

  int get surplus => income - spending;
}

class GetIncomeVsSpendingUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;
  final IncomeRepository _incomeRepository;

  const GetIncomeVsSpendingUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
    required IncomeRepository incomeRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository,
        _incomeRepository = incomeRepository;

  Future<List<IncomeVsSpendingPoint>> call() async {
    final history = await _cycleRepository.getCycleHistory(limit: 6);
    final closedCycles = history.where((c) => !c.isActive).toList();
    if (closedCycles.isEmpty) return [];

    final points = <IncomeVsSpendingPoint>[];
    for (final cycle in closedCycles) {
      final spending = await _expenseRepository.getTotalExpenses(cycle.id);
      final additionalIncome = await _incomeRepository.getTotalIncomeForCycle(cycle.id);
      final income = cycle.salaryAmount + additionalIncome;
      points.add(IncomeVsSpendingPoint(
        month: cycle.startDate,
        income: income,
        spending: spending,
      ));
    }

    points.sort((a, b) => a.month.compareTo(b.month));
    return points;
  }
}
