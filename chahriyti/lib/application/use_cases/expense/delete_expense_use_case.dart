import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository _expenseRepo;
  final CycleRepository _cycleRepo;

  const DeleteExpenseUseCase(this._expenseRepo, this._cycleRepo);

  Future<void> call({required int expenseId, required int cycleId}) async {
    final cycle = await _cycleRepo.getActiveCycle();
    if (cycle == null || cycle.id != cycleId || !cycle.isActive) {
      throw StateError('Cannot delete expense: cycle is not active');
    }
    await _expenseRepo.deleteExpense(expenseId);
  }
}
