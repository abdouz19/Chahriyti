import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../application/use_cases/expense/add_expense_use_case.dart';
import '../../../application/use_cases/savings/get_savings_balance_use_case.dart';
import '../../../core/di/injection.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

abstract class ExpenseState {
  const ExpenseState();
}

class ExpenseCategorySelection extends ExpenseState {
  const ExpenseCategorySelection();
}

class ExpenseFormInput extends ExpenseState {
  final String category;
  final String subcategory;
  final int savingsBalance;
  final bool fromSavings;
  const ExpenseFormInput(
    this.category,
    this.subcategory, {
    this.savingsBalance = 0,
    this.fromSavings = false,
  });
}

class ExpenseSaving extends ExpenseState {
  const ExpenseSaving();
}

class ExpenseSaved extends ExpenseState {
  const ExpenseSaved();
}

class ExpenseError extends ExpenseState {
  final String message;
  const ExpenseError(this.message);
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

class ExpenseCubit extends Cubit<ExpenseState> {
  final AddExpenseUseCase _addExpense;
  final GetSavingsBalanceUseCase _getSavingsBalance;
  final int cycleId;
  int _savingsBalance = 0;
  bool _fromSavings = false;

  ExpenseCubit({
    required this.cycleId,
    required AddExpenseUseCase addExpense,
    required GetSavingsBalanceUseCase getSavingsBalance,
  })  : _addExpense = addExpense,
        _getSavingsBalance = getSavingsBalance,
        super(const ExpenseCategorySelection());

  Future<void> selectCategory(String category) async {
    debugPrint('📝 EXPENSE: Category selected: $category');
    _savingsBalance = await _getSavingsBalance();
    _fromSavings = false;
    emit(ExpenseFormInput(
      category,
      '',
      savingsBalance: _savingsBalance,
    ));
  }

  void setFromSavings(bool value) {
    final current = state;
    if (current is ExpenseFormInput) {
      _fromSavings = value;
      emit(ExpenseFormInput(
        current.category,
        current.subcategory,
        savingsBalance: _savingsBalance,
        fromSavings: value,
      ));
    }
  }

  /// Navigate back one step in the flow.
  void goBack() {
    final current = state;
    if (current is ExpenseFormInput) {
      emit(const ExpenseCategorySelection());
    } else if (current is ExpenseError) {
      emit(const ExpenseCategorySelection());
    }
  }

  Future<void> saveExpense({
    required String itemName,
    required int amount,
    String? notes,
    int savingsAmount = 0,
  }) async {
    final current = state;
    if (current is! ExpenseFormInput) {
      debugPrint('❌ EXPENSE: Invalid state for saving: $current');
      return;
    }

    debugPrint('💾 EXPENSE: Starting save...');
    debugPrint('   - Cycle ID: $cycleId');
    debugPrint('   - Category: ${current.category}');
    debugPrint('   - Subcategory: ${current.subcategory}');
    debugPrint('   - Item: $itemName');
    debugPrint('   - Amount: $amount');
    debugPrint('   - Notes: $notes');

    emit(const ExpenseSaving());
    try {
      await _addExpense(
        cycleId: cycleId,
        category: current.category,
        subcategory: current.subcategory,
        itemName: itemName,
        amount: amount,
        notes: notes,
        fromSavings: _fromSavings,
        savingsAmount: savingsAmount,
      );
      debugPrint('✅ EXPENSE: Saved successfully');
      emit(const ExpenseSaved());
    } on ArgumentError catch (e) {
      debugPrint('❌ EXPENSE: ArgumentError - ${e.message}');
      emit(ExpenseError(e.message.toString()));
    } catch (e) {
      debugPrint('❌ EXPENSE: Unexpected error - $e');
      emit(ExpenseError('حدث خطأ غير متوقع'));
    }
  }
}

// ---------------------------------------------------------------------------
// Helper for home page expense actions (not cubit state-based)
// ---------------------------------------------------------------------------

class HomeExpenseActions {
  static Future<String?> deleteExpense({
    required int expenseId,
    required int cycleId,
  }) async {
    try {
      await Injection.deleteExpenseUseCase(
          expenseId: expenseId, cycleId: cycleId);
      return null; // success
    } on ArgumentError catch (e) {
      return e.message.toString();
    } catch (e) {
      return 'حدث خطأ أثناء الحذف';
    }
  }
}
