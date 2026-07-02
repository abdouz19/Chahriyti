import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/income_repository.dart';
import '../../../domain/repositories/debt_repository.dart';
import '../../../domain/repositories/lending_repository.dart';

class DashboardData {
  final int currentBalance;
  final int totalExpenses;
  final int totalDebtPayments;
  final int totalLendingsFromBalance;
  final int totalOutstandingLendings;
  final int totalIn;
  final int totalIncome;
  final int salaryAmount;
  final int daysRemaining;
  final int daysElapsed;
  final int dailyAverage;
  final int safeDaily;
  final double consumptionPercent;

  const DashboardData({
    required this.currentBalance,
    required this.totalExpenses,
    required this.totalDebtPayments,
    this.totalLendingsFromBalance = 0,
    this.totalOutstandingLendings = 0,
    required this.totalIn,
    required this.totalIncome,
    required this.salaryAmount,
    required this.daysRemaining,
    required this.daysElapsed,
    required this.dailyAverage,
    required this.safeDaily,
    required this.consumptionPercent,
  });

  int get totalOut => totalExpenses + totalDebtPayments + totalLendingsFromBalance;
}

class GetDashboardDataUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;
  final IncomeRepository _incomeRepository;
  final DebtRepository _debtRepository;
  final LendingRepository? _lendingRepository;

  const GetDashboardDataUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
    required IncomeRepository incomeRepository,
    required DebtRepository debtRepository,
    LendingRepository? lendingRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository,
        _incomeRepository = incomeRepository,
        _debtRepository = debtRepository,
        _lendingRepository = lendingRepository;

  Future<DashboardData> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) {
      return const DashboardData(
        currentBalance: 0,
        totalExpenses: 0,
        totalDebtPayments: 0,
        totalIn: 0,
        totalIncome: 0,
        salaryAmount: 0,
        daysRemaining: 0,
        daysElapsed: 0,
        dailyAverage: 0,
        safeDaily: 0,
        consumptionPercent: 0,
      );
    }

    final now = DateTime.now();

    final results = await Future.wait([
      _expenseRepository.getTotalExpenses(cycle.id),
      _incomeRepository.getTotalIncomeForCycle(cycle.id),
      _debtRepository.getTotalDebtPaymentsForCycle(cycle.id),
      _debtRepository.getTotalDebtsCreatedForCycle(cycle.id),
    ]);

    final totalExpenses = results[0];
    final totalIncome = results[1];
    final totalDebtPayments = results[2];
    final totalDebtsCreated = results[3];

    int totalLendingsFromBalance = 0;
    int totalOutstandingLendings = 0;
    int totalCollectionsToBalance = 0;
    if (_lendingRepository != null) {
      final lendingResults = await Future.wait([
        _lendingRepository.getTotalLendingsFromBalanceForCycle(cycle.id),
        _lendingRepository.getTotalOutstandingLendingAmount(),
        _lendingRepository.getTotalCollectionsToBalanceForCycle(cycle.id),
      ]);
      totalLendingsFromBalance = lendingResults[0];
      totalOutstandingLendings = lendingResults[1];
      totalCollectionsToBalance = lendingResults[2];
    }

    final salaryAmount = cycle.salaryAmount;
    final totalIn = salaryAmount - cycle.salarySplitAmount + totalIncome + totalDebtsCreated;
    final currentBalance = totalIn -
        totalExpenses -
        totalDebtPayments -
        totalLendingsFromBalance +
        totalCollectionsToBalance;

    final daysRemaining = cycle.daysRemaining(now);
    final daysElapsed = cycle.daysElapsed(now);

    final dailyAverage =
        daysElapsed > 0 ? (totalExpenses ~/ daysElapsed) : 0;
    final safeDaily =
        daysRemaining > 0 ? (currentBalance ~/ daysRemaining) : 0;

    final consumptionPercent =
        totalIn > 0 ? (totalExpenses / totalIn * 100).clamp(0.0, 100.0) : 0.0;

    return DashboardData(
      currentBalance: currentBalance,
      totalExpenses: totalExpenses,
      totalDebtPayments: totalDebtPayments,
      totalLendingsFromBalance: totalLendingsFromBalance,
      totalOutstandingLendings: totalOutstandingLendings,
      totalIn: totalIn,
      totalIncome: totalIncome,
      salaryAmount: salaryAmount,
      daysRemaining: daysRemaining,
      daysElapsed: daysElapsed,
      dailyAverage: dailyAverage,
      safeDaily: safeDaily,
      consumptionPercent: consumptionPercent,
    );
  }
}
