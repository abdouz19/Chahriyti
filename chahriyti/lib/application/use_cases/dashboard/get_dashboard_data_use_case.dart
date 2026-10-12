import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/income_repository.dart';
import '../../../domain/repositories/debt_repository.dart';
import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import 'cycle_balance.dart';

class DashboardData {
  final int currentBalance;
  final int totalExpenses;
  final int totalExpensesFromSavings;
  final int totalDebtPayments;
  final int totalDebtPaymentsFromSavings;
  final int totalLendingsFromBalance;
  final int totalLendingsFromSavings;
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
    this.totalExpensesFromSavings = 0,
    required this.totalDebtPayments,
    this.totalDebtPaymentsFromSavings = 0,
    this.totalLendingsFromBalance = 0,
    this.totalLendingsFromSavings = 0,
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
  final SavingsRepository? _savingsRepository;

  const GetDashboardDataUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
    required IncomeRepository incomeRepository,
    required DebtRepository debtRepository,
    LendingRepository? lendingRepository,
    SavingsRepository? savingsRepository,
  })  : _savingsRepository = savingsRepository,
        _cycleRepository = cycleRepository,
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
      _expenseRepository.getTotalExpensesFromSavingsForCycle(cycle.id),
      _incomeRepository.getTotalIncomeForCycle(cycle.id),
      _debtRepository.getTotalDebtPaymentsForCycle(cycle.id),
      _debtRepository.getTotalDebtPaymentsFromSavingsForCycle(cycle.id),
      _debtRepository.getTotalDebtsCreatedForCycle(cycle.id),
      _expenseRepository.getSetupAdjustmentForCycle(cycle.id),
    ]);

    // Money spent before the app counts in the balance, not as spending
    final setupAdjustment = results[6];
    final expensesForBalance = results[0];
    final totalExpenses = expensesForBalance - setupAdjustment;
    final totalExpensesFromSavings = results[1];
    final totalIncome = results[2];
    final totalDebtPayments = results[3];
    final totalDebtPaymentsFromSavings = results[4];
    final totalDebtsCreated = results[5];

    int totalLendingsFromBalance = 0;
    int totalLendingsFromSavings = 0;
    int totalOutstandingLendings = 0;
    int totalCollectionsToBalance = 0;
    if (_lendingRepository != null) {
      final lendingResults = await Future.wait([
        _lendingRepository.getTotalLendingsFromBalanceForCycle(cycle.id),
        _lendingRepository.getTotalLendingsFromSavingsForCycle(cycle.id),
        _lendingRepository.getTotalOutstandingLendingAmount(),
        _lendingRepository.getTotalCollectionsToBalanceForCycle(cycle.id),
      ]);
      totalLendingsFromBalance = lendingResults[0];
      totalLendingsFromSavings = lendingResults[1];
      totalOutstandingLendings = lendingResults[2];
      totalCollectionsToBalance = lendingResults[3];
    }

    final salaryAmount = cycle.salaryAmount;
    final totalIn = salaryAmount - cycle.salarySplitAmount + totalIncome + totalDebtsCreated;
    final netTransfersToBalance =
        await _savingsRepository?.getNetTransfersToBalanceForCycle(cycle.id) ??
            0;
    final currentBalance = cycleBalance(
      cycle: cycle,
      income: totalIncome,
      debtsCreated: totalDebtsCreated,
      expenses: expensesForBalance,
      debtPayments: totalDebtPayments,
      lendingsFromBalance: totalLendingsFromBalance,
      collectionsToBalance: totalCollectionsToBalance,
      netTransfersToBalance: netTransfersToBalance,
    );

    final daysRemaining = cycle.daysRemaining(now);
    final daysElapsed = cycle.daysElapsed(now);

    final dailyAverage =
        daysElapsed > 0 ? (totalExpenses ~/ daysElapsed) : 0;
    final safeDaily =
        daysRemaining > 0 ? (currentBalance ~/ daysRemaining) : 0;

    // Share of the money available this cycle already spent:
    // spent ÷ (spent + what's left). Lendings, debt payments and setup money
    // are already reflected in the balance, so they don't skew it.
    final available = totalExpenses + currentBalance;
    final consumptionPercent = available > 0
        ? (totalExpenses / available * 100).clamp(0.0, 100.0)
        : (totalExpenses > 0 ? 100.0 : 0.0);

    return DashboardData(
      currentBalance: currentBalance,
      totalExpenses: totalExpenses,
      totalExpensesFromSavings: totalExpensesFromSavings,
      totalDebtPayments: totalDebtPayments,
      totalDebtPaymentsFromSavings: totalDebtPaymentsFromSavings,
      totalLendingsFromBalance: totalLendingsFromBalance,
      totalLendingsFromSavings: totalLendingsFromSavings,
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
