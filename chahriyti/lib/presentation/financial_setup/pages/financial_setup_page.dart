import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../cubits/financial_setup_cubit.dart';
import '../cubits/financial_setup_state.dart';
import '../widgets/balance_step_widget.dart';
import '../widgets/debts_step_widget.dart';
import '../widgets/lendings_step_widget.dart';
import '../widgets/savings_step_widget.dart';
import '../widgets/summary_step_widget.dart';
import '../widgets/welcome_step_widget.dart';

class FinancialSetupPage extends StatelessWidget {
  const FinancialSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FinancialSetupCubit, FinancialSetupState>(
      listener: (context, state) {
        if (state is FinancialSetupCompleted) {
          context.go('/onboarding/salary');
        } else if (state is FinancialSetupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.negative,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<FinancialSetupCubit>();
        final showBack = state is! FinancialSetupWelcome &&
            state is! FinancialSetupLoading;

        return Scaffold(
          appBar: showBack
              ? AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: cubit.goBack,
                  ),
                )
              : null,
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildStep(context, state, cubit),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(
    BuildContext context,
    FinancialSetupState state,
    FinancialSetupCubit cubit,
  ) {
    return switch (state) {
      FinancialSetupWelcome() => WelcomeStepWidget(
          key: const ValueKey('welcome'),
          onStart: cubit.beginSetup,
        ),
      FinancialSetupBalance(:final currentBalance) => BalanceStepWidget(
          key: const ValueKey('balance'),
          initialValue: currentBalance,
          onNext: cubit.setBalance,
          onBack: cubit.goBack,
        ),
      FinancialSetupSavings(:final currentSavings) => SavingsStepWidget(
          key: const ValueKey('savings'),
          initialValue: currentSavings,
          onNext: cubit.setSavings,
          onSkip: cubit.skipSavings,
          onBack: cubit.goBack,
        ),
      FinancialSetupDebts(:final debts) => DebtsStepWidget(
          key: const ValueKey('debts'),
          debts: debts,
          onAdd: (name, amount, isSpent) => cubit.addDebt(
              creditorName: name, totalAmount: amount, isSpent: isSpent),
          onEdit: (id, name, amount, isSpent) => cubit.editDebt(
              id: id,
              creditorName: name,
              totalAmount: amount,
              isSpent: isSpent),
          onDelete: cubit.deleteDebt,
          onNext: cubit.nextFromDebts,
          onSkip: cubit.nextFromDebts,
          onBack: cubit.goBack,
        ),
      FinancialSetupLendings(:final lendings) => LendingsStepWidget(
          key: const ValueKey('lendings'),
          lendings: lendings,
          onAdd: (name, amount) =>
              cubit.addLending(borrowerName: name, totalAmount: amount),
          onEdit: (id, name, amount) => cubit.editLending(
              id: id, borrowerName: name, totalAmount: amount),
          onDelete: cubit.deleteLending,
          onNext: cubit.nextFromLendings,
          onSkip: cubit.nextFromLendings,
          onBack: cubit.goBack,
        ),
      FinancialSetupSummary(
        :final balance,
        :final savings,
        :final debts,
        :final lendings,
      ) =>
        SummaryStepWidget(
          key: const ValueKey('summary'),
          balance: balance,
          savings: savings,
          debts: debts,
          lendings: lendings,
          onEditStep: cubit.editFromSummary,
          onConfirm: cubit.confirm,
          onBack: cubit.goBack,
        ),
      FinancialSetupLoading() => const Center(
          key: ValueKey('loading'),
          child: CircularProgressIndicator(),
        ),
      FinancialSetupCompleted() => const SizedBox.shrink(
          key: ValueKey('completed'),
        ),
      FinancialSetupError() => const SizedBox.shrink(
          key: ValueKey('error'),
        ),
    };
  }
}
