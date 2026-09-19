import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/debt_cubit.dart';
import '../cubits/debt_state.dart';
import '../../shared/widgets/payment_source_toggle.dart';
import '../../shared/widgets/funding_source_sheet.dart';
import 'add_debt_page.dart';

class DebtDetailPage extends StatelessWidget {
  final int debtId;

  const DebtDetailPage({
    required this.debtId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DebtCubit(
        Injection.createDebtUseCase,
        Injection.getDebtsUseCase,
        Injection.updateDebtUseCase,
        Injection.deleteDebtUseCase,
        Injection.addPaymentUseCase,
        Injection.getSavingsBalanceUseCase,
        notificationService: Injection.notificationService,
      )..loadDebtById(debtId),
      child: _DebtDetailView(debtId: debtId),
    );
  }
}

class _DebtDetailView extends StatelessWidget {
  final int debtId;

  const _DebtDetailView({required this.debtId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DebtCubit, DebtState>(
      listener: (context, state) {
        if (state is DebtDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.debtDeletedMsg),
              backgroundColor: AppColors.positive,
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.debtDetails,
            style: AppTypography.headlineSmall,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: context.l10n.edit,
              onPressed: () async {
                final cubit = context.read<DebtCubit>();
                final currentState = cubit.state;
                if (currentState is DebtLoaded) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddDebtPage(initialDebt: currentState.debt),
                    ),
                  );
                  cubit.loadDebtById(debtId);
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: AppColors.negative),
              tooltip: context.l10n.delete,
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ],
        ),
        body: BlocBuilder<DebtCubit, DebtState>(
          builder: (context, state) {
            if (state is DebtLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is DebtLoaded) {
              final debt = state.debt;
              final percentagePaid = debt.totalAmount > 0
                  ? (debt.paidAmount / debt.totalAmount * 100).clamp(0, 100)
                  : 0.0;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Creditor name
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.creditorName,
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            debt.creditorName,
                            style: AppTypography.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Amount info
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  context.l10n.totalAmount,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${debt.totalAmount} ${context.l10n.currencySymbol}',
                                  style: AppTypography.labelLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.positive.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.positive.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  context.l10n.paidAmount,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${debt.paidAmount} ${context.l10n.currencySymbol}',
                                  style: AppTypography.labelLarge.copyWith(
                                    color: AppColors.positive,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.l10n.progress,
                              style: AppTypography.labelLarge,
                            ),
                            Text(
                              '${percentagePaid.toStringAsFixed(0)}%',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentagePaid / 100,
                            minHeight: 8,
                            backgroundColor: AppColors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              percentagePaid == 100
                                  ? AppColors.positive
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Remaining amount
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            context.l10n.remainingAmount,
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${debt.remainingAmount} ${context.l10n.currencySymbol}',
                            style: AppTypography.headlineSmall.copyWith(
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Notes
                    if (debt.notes != null && debt.notes!.isNotEmpty) ...[
                      Text(
                        context.l10n.notes,
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          debt.notes!,
                          style: AppTypography.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Add payment button
                    if (!debt.isCompleted)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showAddPaymentDialog(context, debt.id, debt.remainingAmount);
                          },
                          icon: const Icon(Icons.add),
                          label: Text(context.l10n.addPayment),
                        ),
                      ),
                  ],
                ),
              );
            }

            if (state is DebtError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 64,
                        color: AppColors.negative,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: AppTypography.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final cubit = context.read<DebtCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.deleteDebtTitle),
        content: Text(context.l10n.deleteDebtBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              final currentState = cubit.state;
              if (currentState is DebtLoaded) {
                cubit.deleteDebt(currentState.debt.id);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negative,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context, int debtId, int remainingAmount) {
    final amountController = TextEditingController();
    final debtCubit = context.read<DebtCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => FutureBuilder<int>(
        future: debtCubit.getSavingsBalance(),
        initialData: 0,
        builder: (_, snapshot) {
          final savingsBalance = snapshot.data ?? 0;
          return _PaymentDialog(
            amountController: amountController,
            savingsBalance: savingsBalance,
            maxAmount: remainingAmount,
            onSubmit: (amount, fromSavings) async {
              Navigator.pop(dialogContext);
              if (!fromSavings) {
                // Get current balance to check if split is needed
                final balance = await _getCurrentBalance();
                if (amount > balance + savingsBalance) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.insufficientFunds),
                        backgroundColor: AppColors.negative,
                      ),
                    );
                  }
                  return;
                }
                if (amount > balance && context.mounted) {
                  final result = await showFundingSourceSheet(
                    context,
                    amount: amount,
                    availableBalance: balance,
                    availableSavings: savingsBalance,
                  );
                  if (result == null || !context.mounted) return;
                  final error = await debtCubit.addPayment(
                    debtId: debtId,
                    amount: amount,
                    fromSavings: false,
                    savingsAmount: result.savingsAmount,
                  );
                  if (error != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        backgroundColor: AppColors.negative,
                      ),
                    );
                  }
                  return;
                }
              }
              final error = await debtCubit.addPayment(
                debtId: debtId,
                amount: amount,
                fromSavings: fromSavings,
              );
              if (error != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: AppColors.negative,
                  ),
                );
              }
            },
            onCancel: () => Navigator.pop(dialogContext),
          );
        },
      ),
    );
  }

  Future<int> _getCurrentBalance() async {
    final cycle = await Injection.cycleRepository.getActiveCycle();
    if (cycle == null) return 0;
    final totalExpenses =
        await Injection.expenseRepository.getTotalExpenses(cycle.id);
    final totalIncome =
        await Injection.incomeRepository.getTotalIncomeForCycle(cycle.id);
    final totalDebtPayments =
        await Injection.debtRepository.getTotalDebtPaymentsForCycle(cycle.id);
    final totalDebtsCreated =
        await Injection.debtRepository.getTotalDebtsCreatedForCycle(cycle.id);
    final totalLendings =
        await Injection.lendingRepository.getTotalLendingsFromBalanceForCycle(cycle.id);
    final totalCollections =
        await Injection.lendingRepository.getTotalCollectionsToBalanceForCycle(cycle.id);
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

class _PaymentDialog extends StatefulWidget {
  final TextEditingController amountController;
  final int savingsBalance;
  final int maxAmount;
  final void Function(int amount, bool fromSavings) onSubmit;
  final VoidCallback onCancel;

  const _PaymentDialog({
    required this.amountController,
    required this.savingsBalance,
    required this.maxAmount,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  bool _fromSavings = false;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.addPayment),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.amountController,
            keyboardType: TextInputType.number,
            onChanged: (_) {
              if (_errorText != null) setState(() => _errorText = null);
            },
            decoration: InputDecoration(
              hintText: l10n.amountInDZD,
              suffixText: l10n.currencySymbol,
              errorText: _errorText,
            ),
          ),
          if (widget.savingsBalance > 0) ...[
            const SizedBox(height: 16),
            FutureBuilder<int>(
              future: _getCurrentBalance(),
              initialData: 0,
              builder: (context, snapshot) {
                return PaymentSourceToggle(
                  currentBalance: snapshot.data ?? 0,
                  savingsBalance: widget.savingsBalance,
                  fromSavings: _fromSavings,
                  onChanged: (value) => setState(() => _fromSavings = value),
                );
              },
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = int.tryParse(widget.amountController.text);
            if (amount == null || amount <= 0) {
              setState(() => _errorText = l10n.enterValidAmount);
              return;
            }
            if (amount > widget.maxAmount) {
              setState(() => _errorText = l10n.amountExceedsRemaining('${widget.maxAmount}'));
              return;
            }
            widget.onSubmit(amount, _fromSavings);
          },
          child: Text(l10n.add),
        ),
      ],
    );
  }

  Future<int> _getCurrentBalance() async {
    final cycle = await Injection.cycleRepository.getActiveCycle();
    if (cycle == null) return 0;
    final totalExpenses =
        await Injection.expenseRepository.getTotalExpenses(cycle.id);
    final totalIncome =
        await Injection.incomeRepository.getTotalIncomeForCycle(cycle.id);
    final totalDebtPayments =
        await Injection.debtRepository.getTotalDebtPaymentsForCycle(cycle.id);
    final totalDebtsCreated =
        await Injection.debtRepository.getTotalDebtsCreatedForCycle(cycle.id);
    final totalLendings =
        await Injection.lendingRepository.getTotalLendingsFromBalanceForCycle(cycle.id);
    final totalCollections =
        await Injection.lendingRepository.getTotalCollectionsToBalanceForCycle(cycle.id);
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
