import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/entities/expense_entity.dart';

class EditExpenseUseCase {
  final ExpenseRepository _expenseRepo;
  final CycleRepository _cycleRepo;

  const EditExpenseUseCase(this._expenseRepo, this._cycleRepo);

  Future<void> call(ExpenseEntity expense) async {
    if (expense.amount <= 0) throw ArgumentError('Amount must be positive');
    if (expense.itemName.trim().isEmpty) {
      throw ArgumentError('Item name required');
    }

    final cycle = await _cycleRepo.getActiveCycle();
    if (cycle == null || cycle.id != expense.cycleId || !cycle.isActive) {
      throw StateError('Cannot edit expense: cycle is not active');
    }

    await _expenseRepo.editExpense(
      expense.copyWith(itemName: expense.itemName.trim()),
    );
  }
}
