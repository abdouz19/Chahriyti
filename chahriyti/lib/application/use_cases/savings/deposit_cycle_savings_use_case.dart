import '../../../domain/entities/savings_history_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/debt_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/income_repository.dart';
import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../dashboard/cycle_balance.dart';

class DepositCycleSavingsUseCase {
  final CycleRepository cycleRepository;
  final ExpenseRepository expenseRepository;
  final IncomeRepository incomeRepository;
  final DebtRepository debtRepository;
  final SavingsRepository savingsRepository;
  final LendingRepository? lendingRepository;

  const DepositCycleSavingsUseCase({
    required this.cycleRepository,
    required this.expenseRepository,
    required this.incomeRepository,
    required this.debtRepository,
    required this.savingsRepository,
    this.lendingRepository,
  });

  /// Calculates remaining balance for a cycle and creates a savings deposit
  /// if the balance is positive. Returns null if no deposit was created.
  Future<SavingsHistoryEntity?> call(int cycleId) async {
    final cycle = await cycleRepository.getCycleById(cycleId);
    if (cycle == null) return null;

    final totalIncome = await incomeRepository.getTotalIncomeForCycle(cycleId);
    final totalExpenses = await expenseRepository.getTotalExpenses(cycleId);
    final totalDebtPayments =
        await debtRepository.getTotalDebtPaymentsForCycle(cycleId);
    final totalDebtsCreated =
        await debtRepository.getTotalDebtsCreatedForCycle(cycleId);
    final totalLendings = lendingRepository != null
        ? await lendingRepository!.getTotalLendingsFromBalanceForCycle(cycleId)
        : 0;
    final totalCollections = lendingRepository != null
        ? await lendingRepository!.getTotalCollectionsToBalanceForCycle(cycleId)
        : 0;
    final netTransfers =
        await savingsRepository.getNetTransfersToBalanceForCycle(cycleId);

    // Same balance the dashboard shows, so the leftover saved matches it
    final remainingBalance = cycleBalance(
      cycle: cycle,
      income: totalIncome,
      debtsCreated: totalDebtsCreated,
      expenses: totalExpenses,
      debtPayments: totalDebtPayments,
      lendingsFromBalance: totalLendings,
      collectionsToBalance: totalCollections,
      netTransfersToBalance: netTransfers,
    );

    if (remainingBalance <= 0) return null;

    return savingsRepository.createDeposit(
      amount: remainingBalance,
      description: 'ادخار نهاية الدورة',
      cycleId: cycleId,
    );
  }
}
