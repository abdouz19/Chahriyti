import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/income_repository.dart';

/// Shared amounts for statistics, so every card counts the same way.

/// Everything spent in a cycle, whether paid from the balance or savings
/// (money spent before the app, recorded at setup, is not spending).
Future<int> totalSpending(ExpenseRepository expenses, int cycleId) async =>
    await expenses.getTotalExpenses(cycleId) +
    await expenses.getTotalExpensesFromSavingsForCycle(cycleId) -
    await expenses.getSetupAdjustmentForCycle(cycleId);

/// Additional income earned in a cycle, wherever it went. The opening
/// balance from setup is money the user already had, not income.
Future<int> earnedIncome(IncomeRepository incomes, int cycleId,
        {bool onlyToSavings = false}) async =>
    (await incomes.getIncomesForCycle(cycleId))
        .where((i) => !i.isInitialBalance && (!onlyToSavings || i.toSavings))
        .fold<int>(0, (sum, i) => sum + i.amount);
