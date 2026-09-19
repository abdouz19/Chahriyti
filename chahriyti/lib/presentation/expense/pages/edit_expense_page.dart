import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/expense/edit_expense_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/expense_entity.dart';
import '../widgets/expense_form.dart';
import '../../shared/widgets/funding_source_sheet.dart';

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

/// Emitted when the new amount exceeds available balance.
/// Body keeps showing the form; listener shows funding sheet.
class EditExpenseBalanceExceeded extends EditExpenseState {
  final ExpenseEntity originalExpense;
  final String pendingItemName;
  final int pendingAmount;
  final String? pendingNotes;
  /// currentBalance + originalExpense.amount — effective max from balance.
  final int effectiveBalance;
  final int savingsBalance;

  const EditExpenseBalanceExceeded({
    required this.originalExpense,
    required this.pendingItemName,
    required this.pendingAmount,
    this.pendingNotes,
    required this.effectiveBalance,
    required this.savingsBalance,
  });
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

    final delta = amount - current.expense.amount;

    if (delta > 0) {
      final balance = await _getAvailableBalance();
      if (delta > balance) {
        final savingsBalance = await Injection.getSavingsBalanceUseCase();
        final effectiveBalance = balance + current.expense.amount;

        if (amount > effectiveBalance + savingsBalance) {
          emit(EditExpenseError(
            'رصيدك الحالي $balance دج والمدخرات $savingsBalance دج — لا يكفي لإتمام هذا المبلغ',
          ));
          return;
        }

        emit(EditExpenseBalanceExceeded(
          originalExpense: current.expense,
          pendingItemName: itemName,
          pendingAmount: amount,
          pendingNotes: notes,
          effectiveBalance: effectiveBalance,
          savingsBalance: savingsBalance,
        ));
        return;
      }
    }

    await _doSave(
      current.expense.copyWith(itemName: itemName, amount: amount, notes: notes),
      originalSavingsAmount: current.expense.savingsAmount,
    );
  }

  /// Called after user selects funding split from the sheet.
  Future<void> saveWithFunding(int savingsAmount) async {
    final current = state;
    if (current is! EditExpenseBalanceExceeded) return;

    final updated = current.originalExpense.copyWith(
      itemName: current.pendingItemName,
      amount: current.pendingAmount,
      notes: current.pendingNotes,
      savingsAmount: savingsAmount,
      fromSavings: savingsAmount >= current.pendingAmount,
    );

    await _doSave(
      updated,
      originalSavingsAmount: current.originalExpense.savingsAmount,
    );
  }

  void resetToReady() {
    final current = state;
    if (current is EditExpenseBalanceExceeded) {
      emit(EditExpenseReady(current.originalExpense));
    }
  }

  Future<void> _doSave(
    ExpenseEntity updated, {
    required int originalSavingsAmount,
  }) async {
    emit(EditExpenseSaving(updated));
    try {
      await _editExpense(updated, originalSavingsAmount: originalSavingsAmount);
      emit(const EditExpenseSaved());
    } on ArgumentError catch (e) {
      emit(EditExpenseError(e.message.toString()));
    } on StateError catch (e) {
      emit(EditExpenseError(e.message));
    } catch (_) {
      emit(const EditExpenseError('حدث خطأ غير متوقع'));
    }
  }

  Future<int> _getAvailableBalance() async {
    final totalExpenses =
        await Injection.expenseRepository.getTotalExpenses(cycleId);
    final totalIncome =
        await Injection.incomeRepository.getTotalIncomeForCycle(cycleId);
    final totalDebtPayments =
        await Injection.debtRepository.getTotalDebtPaymentsForCycle(cycleId);
    final totalDebtsCreated =
        await Injection.debtRepository.getTotalDebtsCreatedForCycle(cycleId);
    final totalLendings =
        await Injection.lendingRepository.getTotalLendingsFromBalanceForCycle(cycleId);
    final totalCollections =
        await Injection.lendingRepository.getTotalCollectionsToBalanceForCycle(cycleId);
    final cycle = await Injection.cycleRepository.getCycleById(cycleId);
    if (cycle == null) return 0;
    return cycle.salaryAmount -
        cycle.salarySplitAmount +
        totalIncome +
        totalDebtsCreated -
        totalExpenses -
        totalDebtPayments -
        totalLendings +
        totalCollections;
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
      listener: (context, state) async {
        if (state is EditExpenseSaved) {
          Navigator.of(context).pop(true);
        } else if (state is EditExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.negative,
            ),
          );
        } else if (state is EditExpenseBalanceExceeded) {
          final cubit = context.read<EditExpenseCubit>();
          final result = await showFundingSourceSheet(
            context,
            amount: state.pendingAmount,
            availableBalance: state.effectiveBalance,
            availableSavings: state.savingsBalance,
          );
          if (!context.mounted) return;
          if (result == null) {
            cubit.resetToReady();
          } else {
            cubit.saveWithFunding(result.savingsAmount);
          }
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

    if (state is EditExpenseReady ||
        state is EditExpenseSaving ||
        state is EditExpenseBalanceExceeded) {
      final expense = state is EditExpenseReady
          ? state.expense
          : state is EditExpenseSaving
              ? state.expense
              : (state as EditExpenseBalanceExceeded).originalExpense;
      final isSaving = state is EditExpenseSaving;
      final cubit = context.read<EditExpenseCubit>();

      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ExpenseForm(
          initialItemName: expense.itemName,
          initialAmount: expense.amount,
          initialNotes: expense.notes,
          isSaving: isSaving,
          category: expense.category,
          onSave: ({
            required String itemName,
            required int amount,
            String? notes,
          }) async {
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
