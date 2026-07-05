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

  Future<void> call(ExpenseEntity expense) async {
    if (expense.amount <= 0) throw ArgumentError('Amount must be positive');

    final cycle = await _cycleRepo.getActiveCycle();
    if (cycle == null || cycle.id != expense.cycleId || !cycle.isActive) {
      throw StateError('Cannot edit expense: cycle is not active');
    }

    // Update savings withdrawal amount if this was a savings-funded expense
    if (expense.fromSavings) {
      await _savingsRepo?.updateWithdrawalAmountByExpenseId(
        expense.id,
        expense.amount,
      );
    }

    await _expenseRepo.editExpense(
      expense.copyWith(itemName: expense.itemName.trim()),
    );
  }
}
