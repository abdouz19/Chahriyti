import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../../../domain/entities/expense_entity.dart';
import '../savings/withdraw_savings_use_case.dart';

class AddExpenseUseCase {
  final ExpenseRepository _repo;
  final WithdrawSavingsUseCase? _withdrawSavings;
  final SavingsRepository? _savingsRepository;

  const AddExpenseUseCase(
    this._repo, [
    this._withdrawSavings,
    this._savingsRepository,
  ]);

  /// [savingsAmount]: portion of [amount] paid from savings.
  /// 0 = all from balance, amount = all from savings, in-between = split.
  Future<ExpenseEntity> call({
    required int cycleId,
    required String category,
    required String subcategory,
    required String itemName,
    required int amount,
    String? notes,
    bool fromSavings = false,
    int savingsAmount = 0,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be positive');
    if (itemName.trim().isEmpty) throw ArgumentError('Item name required');

    final effectiveSavingsAmount = fromSavings ? amount : savingsAmount.clamp(0, amount);

    if (effectiveSavingsAmount > 0 && _withdrawSavings != null) {
      final balance = await _savingsRepository!.getSavingsBalance();
      if (effectiveSavingsAmount > balance) {
        throw StateError('رصيد المدخرات غير كافي ($balance دج متاح)');
      }
    }

    final expense = await _repo.addExpense(
      cycleId: cycleId,
      category: category,
      subcategory: subcategory,
      itemName: itemName.trim(),
      amount: amount,
      notes: notes?.trim(),
      fromSavings: fromSavings,
      savingsAmount: effectiveSavingsAmount,
    );

    if (effectiveSavingsAmount > 0 && _withdrawSavings != null) {
      await _withdrawSavings.call(
        amount: effectiveSavingsAmount,
        description: '$category - $itemName',
        expenseId: expense.id,
      );
    }

    return expense;
  }
}
