import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/dashboard/get_dashboard_data_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/financial_cycle_entity.dart';
import '../cubits/debt_cubit.dart';
import '../cubits/debt_state.dart';
import '../widgets/balance_impact_view.dart';
import '../../shared/widgets/payment_source_toggle.dart';
import '../../shared/widgets/funding_source_sheet.dart';
import '../../shared/widgets/amount_progress_card.dart';
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
    return BlocConsumer<DebtCubit, DebtState>(
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
      builder: (context, state) {
        final canDelete = state is DebtLoaded ? state.debt.paidAmount == 0 : true;
        return Scaffold(
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
                icon: Icon(
                  Icons.delete_outline,
                  color: canDelete ? AppColors.negative : AppColors.textSecondary,
                ),
                tooltip: context.l10n.delete,
                onPressed: canDelete ? () => _showDeleteConfirmation(context) : null,
              ),
            ],
          ),
          body: Builder(builder: (context) {
            if (state is DebtLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is DebtLoaded) {
              final debt = state.debt;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AmountProgressCard(
                      personLabel: context.l10n.creditorName,
                      personName: debt.creditorName,
                      totalAmount: debt.totalAmount,
                      progressLabel: context.l10n.paidAmount,
                      progressAmount: debt.paidAmount,
                      remainingAmount: debt.remainingAmount,
                      isCompleted: debt.isCompleted,
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
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
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
          }),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final cubit = context.read<DebtCubit>();
    final currentState = cubit.state;
    if (currentState is! DebtLoaded) return;
    final debt = currentState.debt;

    // Deleting a non-spent debt of the active cycle takes its amount back out
    // of the balance (delete is only allowed before any payment).
    final results = await Future.wait([
      Injection.cycleRepository.getActiveCycle(),
      Injection.getDashboardDataUseCase(),
    ]);
    final activeCycleId = (results[0] as FinancialCycleEntity?)?.id;
    final balance = (results[1] as DashboardData).currentBalance;
    final delta = !debt.isSpent &&
            activeCycleId != null &&
            debt.cycleId == activeCycleId
        ? -debt.totalAmount
        : 0;
    final blocked = balance + delta < 0;

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.deleteDebtTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.deleteDebtBody),
            const SizedBox(height: 12),
            BalanceImpactView(delta: delta, currentBalance: balance),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: blocked
                ? null
                : () {
                    Navigator.pop(dialogContext);
                    cubit.deleteDebt(debt.id);
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
    final debtCubit = context.read<DebtCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => FutureBuilder<int>(
        future: debtCubit.getSavingsBalance(),
        initialData: 0,
        builder: (_, snapshot) {
          final savingsBalance = snapshot.data ?? 0;
          return _PaymentDialog(
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

  Future<int> _getCurrentBalance() async =>
      // Shared formula: the active cycle balance, same as the dashboard
      (await Injection.getDashboardDataUseCase()).currentBalance;
}

class _PaymentDialog extends StatefulWidget {
  final int savingsBalance;
  final int maxAmount;
  final void Function(int amount, bool fromSavings) onSubmit;
  final VoidCallback onCancel;

  const _PaymentDialog({
    required this.savingsBalance,
    required this.maxAmount,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  late final TextEditingController _amountController;
  late final Future<int> _balanceFuture;
  bool _fromSavings = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _balanceFuture = _getCurrentBalance();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.addPayment),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
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
              future: _balanceFuture,
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
            final amount = int.tryParse(_amountController.text);
            if (amount == null || amount <= 0) {
              setState(() => _errorText = l10n.enterValidAmount);
              return;
            }
            if (amount > widget.maxAmount) {
              setState(() => _errorText = l10n.amountExceedsRemaining(
                  widget.maxAmount.toFormattedNumber()));
              return;
            }
            widget.onSubmit(amount, _fromSavings);
          },
          child: Text(l10n.add),
        ),
      ],
    );
  }

  Future<int> _getCurrentBalance() async =>
      // Shared formula: the active cycle balance, same as the dashboard
      (await Injection.getDashboardDataUseCase()).currentBalance;
}
