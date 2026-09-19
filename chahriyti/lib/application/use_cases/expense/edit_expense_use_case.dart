import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../../../domain/entities/expense_entity.dart';

class EditExpenseUseCase {
  final ExpenseRepository _expenseRepo;
  final CycleRepository _cycleRepo;
  final SavingsRepository? _savingsRepo;

  const EditExpenseUseCase(
    this._expenseRepo,
    this._cycleRepo, [
    this._savingsRepo,
  ]);

  /// [originalSavingsAmount]: the savings amount before this edit (to compute delta).
  Future<void> call(
    ExpenseEntity expense, {
    int originalSavingsAmount = 0,
  }) async {
    if (expense.amount <= 0) throw ArgumentError('Amount must be positive');

    final cycle = await _cycleRepo.getActiveCycle();
    if (cycle == null || cycle.id != expense.cycleId || !cycle.isActive) {
      throw StateError('Cannot edit expense: cycle is not active');
    }

    final newSavings = expense.savingsAmount;

    if (newSavings > 0 && originalSavingsAmount == 0) {
      // No prior savings record — create one
      await _savingsRepo?.createWithdrawal(
        amount: newSavings,
        description: '${expense.category} - ${expense.itemName.trim()}',
        expenseId: expense.id,
      );
    } else if (newSavings == 0 && originalSavingsAmount > 0) {
      // Savings removed — delete record (money returns to savings balance)
      await _savingsRepo?.deleteWithdrawalByExpenseId(expense.id);
    } else if (newSavings > 0 && originalSavingsAmount > 0) {
      // Changed savings portion — update record
      await _savingsRepo?.updateWithdrawalAmountByExpenseId(expense.id, newSavings);
    }

    await _expenseRepo.editExpense(
      expense.copyWith(itemName: expense.itemName.trim()),
    );
  }
}
