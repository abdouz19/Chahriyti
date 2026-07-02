import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/categories.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/expense_cubit.dart';
import '../widgets/category_grid.dart';
import '../widgets/expense_form.dart';
import '../../shared/widgets/payment_source_toggle.dart';
import '../../shared/widgets/funding_source_sheet.dart';

class AddExpensePage extends StatelessWidget {
  final int cycleId;

  const AddExpensePage({super.key, required this.cycleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseCubit(
        cycleId: cycleId,
        addExpense: Injection.addExpenseUseCase,
        getSavingsBalance: Injection.getSavingsBalanceUseCase,
      ),
      child: const _AddExpenseView(),
    );
  }
}

class _AddExpenseView extends StatelessWidget {
  const _AddExpenseView();

  String _titleForState(ExpenseState state) {
    if (state is ExpenseFormInput) return 'تفاصيل المصروف';
    return 'صرف';
  }

  bool _canGoBack(ExpenseState state) => state is ExpenseFormInput;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseCubit, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseSaved) {
          Navigator.of(context).pop(true);
        } else if (state is ExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.negative,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ExpenseCubit>();
        return Scaffold(
          appBar: AppBar(
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                _titleForState(state),
                key: ValueKey(_titleForState(state)),
                style: AppTypography.headlineSmall,
              ),
            ),
            leading: _canGoBack(state)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: cubit.goBack,
                  )
                : const CloseButton(),
          ),
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _buildBody(context, state, cubit),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ExpenseState state,
    ExpenseCubit cubit,
  ) {
    if (state is ExpenseCategorySelection) {
      return _CategoryStep(
        key: const ValueKey('category'),
        onCategorySelected: (cat) => cubit.selectCategory(cat.name),
      );
    }

    if (state is ExpenseFormInput) {
      return _FormStep(
        key: const ValueKey('form'),
        isSaving: false,
        savingsBalance: state.savingsBalance,
        fromSavings: state.fromSavings,
        onFromSavingsChanged: cubit.setFromSavings,
        onSave: ({required String itemName, required int amount, String? notes, int savingsAmount = 0}) {
          cubit.saveExpense(
            itemName: itemName,
            amount: amount,
            notes: notes,
            savingsAmount: savingsAmount,
          );
        },
      );
    }

    if (state is ExpenseSaving) {
      return _FormStep(
        key: const ValueKey('form-saving'),
        isSaving: true,
        onSave: ({required String itemName, required int amount, String? notes, int savingsAmount = 0}) {},
      );
    }

    // ExpenseSaved / ExpenseError are handled via listener
    return const SizedBox.shrink();
  }
}

// ---------------------------------------------------------------------------
// Step widgets
// ---------------------------------------------------------------------------

class _CategoryStep extends StatelessWidget {
  final ValueChanged<ExpenseCategory> onCategorySelected;

  const _CategoryStep({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'اختر نوع المصروف',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          CategoryGrid(onCategorySelected: onCategorySelected),
        ],
      ),
    );
  }
}

class _FormStep extends StatelessWidget {
  final bool isSaving;
  final int savingsBalance;
  final bool fromSavings;
  final ValueChanged<bool>? onFromSavingsChanged;
  final void Function({
    required String itemName,
    required int amount,
    String? notes,
    int savingsAmount,
  }) onSave;

  const _FormStep({
    super.key,
    required this.isSaving,
    required this.onSave,
    this.savingsBalance = 0,
    this.fromSavings = false,
    this.onFromSavingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (savingsBalance > 0 && onFromSavingsChanged != null) ...[
            FutureBuilder<int>(
              future: Injection.cycleRepository.getActiveCycle().then(
                    (cycle) => cycle != null
                        ? _getCurrentBalance(cycle.id)
                        : 0,
                  ),
              initialData: 0,
              builder: (ctx, snapshot) {
                return PaymentSourceToggle(
                  currentBalance: snapshot.data ?? 0,
                  savingsBalance: savingsBalance,
                  fromSavings: fromSavings,
                  onChanged: onFromSavingsChanged!,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
          ExpenseForm(
            isSaving: isSaving,
            onSave: ({required String itemName, required int amount, String? notes}) async {
              await _handleSave(
                context: context,
                itemName: itemName,
                amount: amount,
                notes: notes,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave({
    required BuildContext context,
    required String itemName,
    required int amount,
    String? notes,
  }) async {
    // All-from-savings toggle selected
    if (fromSavings) {
      if (amount > savingsBalance) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('رصيد المدخرات غير كافٍ')),
          );
        }
        return;
      }
      onSave(itemName: itemName, amount: amount, notes: notes, savingsAmount: 0);
      return;
    }

    // Get current spendable balance
    final cycle = await Injection.cycleRepository.getActiveCycle();
    final balance = cycle != null ? await _getCurrentBalance(cycle.id) : 0;

    if (amount > balance + savingsBalance) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرصيد والمدخرات غير كافية')),
        );
      }
      return;
    }

    if (amount > balance) {
      if (!context.mounted) return;
      final result = await showFundingSourceSheet(
        context,
        amount: amount,
        availableBalance: balance,
        availableSavings: savingsBalance,
      );
      if (result == null || !context.mounted) return;
      onSave(itemName: itemName, amount: amount, notes: notes, savingsAmount: result.savingsAmount);
      return;
    }

    // Balance is sufficient
    onSave(itemName: itemName, amount: amount, notes: notes, savingsAmount: 0);
  }

  Future<int> _getCurrentBalance(int cycleId) async {
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
