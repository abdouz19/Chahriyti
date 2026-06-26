import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/expense/add_expense_use_case.dart';
import '../../../core/constants/categories.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/expense_cubit.dart';
import '../widgets/category_grid.dart';
import '../widgets/expense_form.dart';
import '../widgets/subcategory_chips.dart';

class AddExpensePage extends StatelessWidget {
  final int cycleId;

  const AddExpensePage({super.key, required this.cycleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseCubit(
        cycleId: cycleId,
        addExpense: AddExpenseUseCase(Injection.expenseRepository),
      ),
      child: const _AddExpenseView(),
    );
  }
}

class _AddExpenseView extends StatelessWidget {
  const _AddExpenseView();

  String _titleForState(ExpenseState state) {
    if (state is ExpenseSubcategorySelection) {
      // Show the Arabic label of the chosen category
      final cat = ExpenseCategory.values.firstWhere(
        (c) => c.name == state.category,
        orElse: () => ExpenseCategory.other,
      );
      return cat.arabicLabel;
    }
    if (state is ExpenseFormInput) return 'تفاصيل المصروف';
    return 'صرف';
  }

  bool _canGoBack(ExpenseState state) =>
      state is ExpenseSubcategorySelection || state is ExpenseFormInput;

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

    if (state is ExpenseSubcategorySelection) {
      final cat = ExpenseCategory.values.firstWhere(
        (c) => c.name == state.category,
        orElse: () => ExpenseCategory.other,
      );
      return _SubcategoryStep(
        key: ValueKey('subcategory-${state.category}'),
        category: cat,
        onSubcategorySelected: (sub) => cubit.selectSubcategory(sub.name),
      );
    }

    if (state is ExpenseFormInput) {
      return _FormStep(
        key: ValueKey('form-${state.subcategory}'),
        isSaving: false,
        onSave: ({required String itemName, required int amount, String? notes}) {
          cubit.saveExpense(
            itemName: itemName,
            amount: amount,
            notes: notes,
          );
        },
      );
    }

    if (state is ExpenseSaving) {
      return _FormStep(
        key: const ValueKey('form-saving'),
        isSaving: true,
        onSave: ({required String itemName, required int amount, String? notes}) {},
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

class _SubcategoryStep extends StatelessWidget {
  final ExpenseCategory category;
  final ValueChanged<ExpenseSubcategory> onSubcategorySelected;

  const _SubcategoryStep({
    super.key,
    required this.category,
    required this.onSubcategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'اختر التصنيف الفرعي',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),
          SubcategoryChips(
            category: category,
            onSubcategorySelected: onSubcategorySelected,
          ),
        ],
      ),
    );
  }
}

class _FormStep extends StatelessWidget {
  final bool isSaving;
  final void Function({
    required String itemName,
    required int amount,
    String? notes,
  }) onSave;

  const _FormStep({
    super.key,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ExpenseForm(
        isSaving: isSaving,
        onSave: onSave,
      ),
    );
  }
}
