import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/savings_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository _expenseRepo;
  final CycleRepository _cycleRepo;
  final SavingsRepository? _savingsRepo;

  const DeleteExpenseUseCase(
    this._expenseRepo,
    this._cycleRepo, [
    this._savingsRepo,
  ]);

  Future<void> call({required int expenseId, required int cycleId}) async {
    final cycle = await _cycleRepo.getActiveCycle();
    if (cycle == null || cycle.id != cycleId || !cycle.isActive) {
      throw StateError('Cannot delete expense: cycle is not active');
    }

    // Reverse savings withdrawal if this was a savings-funded expense
    await _savingsRepo?.deleteWithdrawalByExpenseId(expenseId);

    await _expenseRepo.deleteExpense(expenseId);
  }
}
