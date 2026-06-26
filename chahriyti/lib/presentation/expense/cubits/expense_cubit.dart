import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../application/use_cases/expense/add_expense_use_case.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

abstract class ExpenseState {
  const ExpenseState();
}

class ExpenseCategorySelection extends ExpenseState {
  const ExpenseCategorySelection();
}

class ExpenseSubcategorySelection extends ExpenseState {
  final String category;
  const ExpenseSubcategorySelection(this.category);
}

class ExpenseFormInput extends ExpenseState {
  final String category;
  final String subcategory;
  const ExpenseFormInput(this.category, this.subcategory);
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
  final int cycleId;

  ExpenseCubit({
    required this.cycleId,
    required AddExpenseUseCase addExpense,
  })  : _addExpense = addExpense,
        super(const ExpenseCategorySelection());

  void selectCategory(String category) {
    debugPrint('📝 EXPENSE: Category selected: $category');
    emit(ExpenseSubcategorySelection(category));
  }

  void selectSubcategory(String subcategory) {
    final current = state;
    if (current is ExpenseSubcategorySelection) {
      debugPrint('📝 EXPENSE: Subcategory selected: $subcategory');
      emit(ExpenseFormInput(current.category, subcategory));
    }
  }

  /// Navigate back one step in the flow.
  void goBack() {
    final current = state;
    if (current is ExpenseSubcategorySelection) {
      emit(const ExpenseCategorySelection());
    } else if (current is ExpenseFormInput) {
      emit(ExpenseSubcategorySelection(current.category));
    } else if (current is ExpenseError) {
      // Try to go back to category selection on error
      emit(const ExpenseCategorySelection());
    }
  }

  Future<void> saveExpense({
    required String itemName,
    required int amount,
    String? notes,
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
