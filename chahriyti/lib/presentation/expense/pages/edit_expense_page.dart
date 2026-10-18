import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/expense/edit_expense_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/expense_entity.dart';
import '../widgets/expense_form.dart';
import '../../shared/widgets/funding_source_sheet.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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
      emit(const EditExpenseError('expenseNotFound'));
    }
  }

  Future<void> saveExpense({
    required String itemName,
    required int amount,
    String? notes,
  }) async {
    final current = state;
    if (current is! EditExpenseReady) return;

    final original = current.expense;

    // Paid fully from savings: the whole change comes from / goes to savings
    if (original.fromSavings) {
      await _doSave(
        original.copyWith(
            itemName: itemName, amount: amount, notes: notes,
            savingsAmount: amount),
        originalSavingsAmount: original.savingsAmount,
      );
      return;
    }

    // Balance or split: keep the savings part (capped at the new amount);
    // any increase comes from the balance
    final newSavings = original.savingsAmount.clamp(0, amount);
    final oldBalancePart = original.amount - original.savingsAmount;
    final balancePartIncrease = (amount - newSavings) - oldBalancePart;

    if (balancePartIncrease > 0) {
      final balance = await _getAvailableBalance();
      if (balancePartIncrease > balance) {
        final savingsBalance = await Injection.getSavingsBalanceUseCase();
        // What this expense could use if re-funded from scratch
        final effectiveBalance = balance + oldBalancePart;
        final effectiveSavings = savingsBalance + original.savingsAmount;

        if (amount > effectiveBalance + effectiveSavings) {
          emit(EditExpenseError(
            'insufficientBalance:$balance:$savingsBalance',
          ));
          return;
        }

        emit(EditExpenseBalanceExceeded(
          originalExpense: original,
          pendingItemName: itemName,
          pendingAmount: amount,
          pendingNotes: notes,
          effectiveBalance: effectiveBalance,
          savingsBalance: effectiveSavings,
        ));
        return;
      }
    }

    await _doSave(
      original.copyWith(
          itemName: itemName, amount: amount, notes: notes,
          savingsAmount: newSavings),
      originalSavingsAmount: original.savingsAmount,
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
      emit(const EditExpenseError('unexpectedError'));
    }
  }

  Future<int> _getAvailableBalance() async =>
      // Shared formula: the active cycle balance, same as the dashboard
      (await Injection.getDashboardDataUseCase()).currentBalance;
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
        editExpense: Injection.editExpenseUseCase,
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
              content: Text(_localizeError(context, state.message)),
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
              context.l10n.editExpenseTitle,
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

  String _localizeError(BuildContext context, String message) {
    final l = context.l10n;
    if (message == 'expenseNotFound') return l.expenseNotFound;
    if (message == 'unexpectedError') return l.unexpectedError;
    if (message == 'insufficientSavings') return l.insufficientSavings;
    if (message == 'pastCycleExpense') return l.pastCycleExpenseLocked;
    if (message.startsWith('insufficientBalance:')) {
      final parts = message.split(':');
      final balance = int.tryParse(parts.elementAtOrNull(1) ?? '') ?? 0;
      final savings = int.tryParse(parts.elementAtOrNull(2) ?? '') ?? 0;
      return l.insufficientBalanceDetail(balance, savings);
    }
    return message;
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
                IconsaxPlusLinear.danger,
                size: 48,
                color: AppColors.negative,
              ),
              const SizedBox(height: 16),
              Text(
                _localizeError(context, state.message),
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
