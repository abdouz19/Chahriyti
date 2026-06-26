import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/expense/edit_expense_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/expense_entity.dart';
import '../widgets/expense_form.dart';

// ---------------------------------------------------------------------------
// Edit-specific states
// ---------------------------------------------------------------------------

abstract class EditExpenseState {
  const EditExpenseState();
}

class EditExpenseLoading extends EditExpenseState {
  const EditExpenseLoading();
}

class EditExpenseReady extends EditExpenseState {
  final ExpenseEntity expense;
  const EditExpenseReady(this.expense);
}

class EditExpenseSaving extends EditExpenseState {
  final ExpenseEntity expense;
  const EditExpenseSaving(this.expense);
}

class EditExpenseSaved extends EditExpenseState {
  const EditExpenseSaved();
}

class EditExpenseError extends EditExpenseState {
  final String message;
  const EditExpenseError(this.message);
}

// ---------------------------------------------------------------------------
// Edit cubit
// ---------------------------------------------------------------------------

class EditExpenseCubit extends Cubit<EditExpenseState> {
  final EditExpenseUseCase _editExpense;
  final int expenseId;
  final int cycleId;

  EditExpenseCubit({
    required this.expenseId,
    required this.cycleId,
    required EditExpenseUseCase editExpense,
  })  : _editExpense = editExpense,
        super(const EditExpenseLoading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final expenses = await Injection.expenseRepository
          .getExpenses(cycleId);
      final expense = expenses.firstWhere(
        (e) => e.id == expenseId,
        orElse: () => throw StateError('Expense not found'),
      );
      emit(EditExpenseReady(expense));
    } catch (e) {
      emit(const EditExpenseError('لم يتم العثور على المصروف'));
    }
  }

  Future<void> saveExpense({
    required String itemName,
    required int amount,
    String? notes,
  }) async {
    final current = state;
    if (current is! EditExpenseReady) return;

    final updated = current.expense.copyWith(
      itemName: itemName,
      amount: amount,
      notes: notes,
    );

    emit(EditExpenseSaving(updated));
    try {
      await _editExpense(updated);
      emit(const EditExpenseSaved());
    } on ArgumentError catch (e) {
      emit(EditExpenseError(e.message.toString()));
    } on StateError catch (e) {
      emit(EditExpenseError(e.message));
    } catch (_) {
      emit(const EditExpenseError('حدث خطأ غير متوقع'));
    }
  }
}

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class EditExpensePage extends StatelessWidget {
  final int expenseId;
  final int cycleId;

  const EditExpensePage({
    super.key,
    required this.expenseId,
    required this.cycleId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditExpenseCubit(
        expenseId: expenseId,
        cycleId: cycleId,
        editExpense: EditExpenseUseCase(
          Injection.expenseRepository,
          Injection.cycleRepository,
        ),
      ),
      child: const _EditExpenseView(),
    );
  }
}

class _EditExpenseView extends StatelessWidget {
  const _EditExpenseView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditExpenseCubit, EditExpenseState>(
      listener: (context, state) {
        if (state is EditExpenseSaved) {
          Navigator.of(context).pop(true);
        } else if (state is EditExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.negative,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'تعديل المصروف',
              style: AppTypography.headlineSmall,
            ),
            leading: const CloseButton(),
          ),
          body: SafeArea(
            child: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, EditExpenseState state) {
    if (state is EditExpenseLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (state is EditExpenseError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.negative,
              ),
              const SizedBox(height: 16),
              Text(
                state.message,
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      );
    }

    if (state is EditExpenseReady || state is EditExpenseSaving) {
      final expense = state is EditExpenseReady
          ? state.expense
          : (state as EditExpenseSaving).expense;
      final isSaving = state is EditExpenseSaving;
      final cubit = context.read<EditExpenseCubit>();

      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ExpenseForm(
          initialItemName: expense.itemName,
          initialAmount: expense.amount,
          initialNotes: expense.notes,
          isSaving: isSaving,
          onSave: ({
            required String itemName,
            required int amount,
            String? notes,
          }) {
            cubit.saveExpense(
              itemName: itemName,
              amount: amount,
              notes: notes,
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
