import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/entities/expense_entity.dart';

class AddExpenseUseCase {
  final ExpenseRepository _repo;
  const AddExpenseUseCase(this._repo);

  Future<ExpenseEntity> call({
    required int cycleId,
    required String category,
    required String subcategory,
    required String itemName,
    required int amount,
    String? notes,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be positive');
    if (itemName.trim().isEmpty) throw ArgumentError('Item name required');
    return _repo.addExpense(
      cycleId: cycleId,
      category: category,
      subcategory: subcategory,
      itemName: itemName.trim(),
      amount: amount,
      notes: notes?.trim(),
    );
  }
}
