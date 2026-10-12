import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../../domain/value_objects/lending_money_place.dart';
import '../../shared/widgets/amount_progress_card.dart';
import '../../shared/widgets/money_text.dart';
import '../cubits/lending_cubit.dart';
import '../cubits/lending_state.dart';
import '../widgets/delta_adjustment_sheet.dart';
import 'add_lending_page.dart';

class LendingDetailPage extends StatelessWidget {
  final int lendingId;

  const LendingDetailPage({
    required this.lendingId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LendingCubit(
        Injection.createLendingUseCase,
        Injection.getLendingsUseCase,
        Injection.addLendingCollectionUseCase,
        Injection.deleteLendingUseCase,
        Injection.getSavingsBalanceUseCase,
        Injection.updateLendingUseCase,
      )..loadLendingById(lendingId),
      child: _LendingDetailView(lendingId: lendingId),
    );
  }
}

class _LendingDetailView extends StatelessWidget {
  final int lendingId;

  const _LendingDetailView({required this.lendingId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LendingCubit, LendingState>(
      listener: (context, state) {
        state.whenOrNull(
          lendingDeleted: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.lendingDeletedMsg),
                backgroundColor: AppColors.positive,
              ),
            );
            context.pop();
          },
          collectionAdded: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.collectionAddedMsg),
                backgroundColor: AppColors.positive,
              ),
            );
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.negative,
              ),
            );
            context.read<LendingCubit>().loadLendingById(lendingId);
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.lendingDetails,
            style: AppTypography.headlineSmall,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: context.l10n.edit,
              onPressed: () async {
                final currentState = context.read<LendingCubit>().state;
                if (currentState is LendingLoaded) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddLendingPage(
                        cycleId: currentState.lending.cycleId ?? 0,
                        initialLending: currentState.lending,
                      ),
                    ),
                  );
                  if (context.mounted) {
                    context.read<LendingCubit>().loadLendingById(lendingId);
                  }
                }
              },
            ),
            IconButton(
              onPressed: () => _handleDelete(context),
              icon: Icon(
                Icons.delete_outline,
                color: AppColors.negative,
              ),
              tooltip: context.l10n.deleteLendingTitle,
            ),
          ],
        ),
        body: BlocBuilder<LendingCubit, LendingState>(
          builder: (context, state) {
            if (state is LendingLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            return state.maybeWhen(
              lendingLoaded: (lending, collections) {
                final locale = Localizations.localeOf(context).languageCode;
                final dateFormat = DateFormat('yyyy/MM/dd', locale);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AmountProgressCard(
                        personLabel: context.l10n.borrowerName,
                        personName: lending.borrowerName,
                        totalAmount: lending.totalAmount,
                        progressLabel: context.l10n.collectedAmount,
                        progressAmount: lending.collectedAmount,
                        remainingAmount: lending.remainingAmount,
                        isCompleted: lending.isFullyCollected,
                        footer: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text(
                              dateFormat
                                  .format(lending.createdAt)
                                  .toLatinDigits(),
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              lending.isUntracked
                                  ? Icons.history_rounded
                                  : lending.fromSavings
                                      ? Icons.savings_rounded
                                      : Icons.account_balance_wallet_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              lending.isUntracked
                                  ? context.l10n.forgottenAdjustment
                                  : lending.fromSavings
                                      ? context.l10n.fromSavings
                                      : context.l10n.fromBalance,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Notes
                      if (lending.notes != null &&
                          lending.notes!.isNotEmpty) ...[
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
                            lending.notes!,
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Add collection button
                      if (!lending.isFullyCollected)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showAddCollectionDialog(
                              context,
                              lending.remainingAmount,
                            ),
                            icon: const Icon(Icons.add),
                            label: Text(context.l10n.addCollection),
                          ),
                        ),

                      // Collection history
                      if (collections.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          context.l10n.collectionHistory,
                          style: AppTypography.labelLarge,
                        ),
                        const SizedBox(height: 12),
                        ...collections.map((collection) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: 18,
                                      color: AppColors.positive,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dateFormat
                                              .format(collection.createdAt)
                                              .toLatinDigits(),
                                          style:
                                              AppTypography.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              collection.toSavings
                                                  ? Icons.savings_rounded
                                                  : Icons
                                                      .account_balance_wallet_rounded,
                                              size: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              collection.toSavings
                                                  ? context.l10n.toSavings
                                                  : context.l10n.toBalance,
                                              style: AppTypography.bodySmall
                                                  .copyWith(
                                                color: AppColors.textSecondary,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                MoneyText(
                                  amount: Money(collection.amount),
                                  style: AppTypography.labelLarge,
                                  color: AppColors.positive,
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
              error: (message) => Center(
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
                        message,
                        style: AppTypography.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final currentState = context.read<LendingCubit>().state;
    if (currentState is! LendingLoaded) return;

    final lending = currentState.lending;
    final cubit = context.read<LendingCubit>();

    // Fully collected → simple confirm dialog, no routing needed
    if (lending.remainingAmount == 0) {
      _showSimpleDeleteConfirmation(context, cubit);
      return;
    }

    // Fetch balances for display
    final currentBalance = await _currentBalance();
    final savingsBalance = await Injection.getSavingsBalanceUseCase();

    if (!context.mounted) return;
    final l10n = context.l10n;
    final source = await showModalBottomSheet<LendingMoneyPlace>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LendingDeltaAdjustmentSheet(
        delta: lending.remainingAmount,
        isIncrease: false,
        title: l10n.lendingDeleteWhereTitle,
        description: l10n.lendingDeleteWhereDesc(lending.remainingAmount),
        currentBalance: currentBalance,
        savingsBalance: savingsBalance,
      ),
    );
    if (source == null || !context.mounted) return;

    cubit.deleteLending(lendingId, remainingTo: source);
  }

  void _showSimpleDeleteConfirmation(BuildContext context, LendingCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.deleteLendingTitle),
        content: Text(context.l10n.deleteLendingBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.deleteLending(lendingId);
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

  // Balance of the active cycle — collected money always lands there,
  // even for a lending made in an older cycle.
  Future<int> _currentBalance() async =>
      (await Injection.getDashboardDataUseCase()).currentBalance;

  Future<void> _showAddCollectionDialog(BuildContext context, int maxAmount) async {
    final cubit = context.read<LendingCubit>();

    final currentBalance = await _currentBalance();
    final savingsBalance = await Injection.getSavingsBalanceUseCase();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => _CollectionDialog(
        maxAmount: maxAmount,
        currentBalance: currentBalance,
        savingsBalance: savingsBalance,
        onSubmit: (amount, toSavings) {
          Navigator.pop(dialogContext);
          cubit.addCollection(
            lendingId: lendingId,
            amount: amount,
            toSavings: toSavings,
          );
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }
}

class _CollectionDialog extends StatefulWidget {
  final int maxAmount;
  final int currentBalance;
  final int savingsBalance;
  final void Function(int amount, bool toSavings) onSubmit;
  final VoidCallback onCancel;

  const _CollectionDialog({
    required this.maxAmount,
    required this.currentBalance,
    required this.savingsBalance,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<_CollectionDialog> createState() => _CollectionDialogState();
}

class _CollectionDialogState extends State<_CollectionDialog> {
  late final TextEditingController _amountController;
  bool _toSavings = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final l10n = context.l10n;
    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() => _errorText = l10n.enterValidAmount);
      return;
    }
    if (amount > widget.maxAmount) {
      setState(() => _errorText = l10n.amountExceedsRemaining(widget.maxAmount.toDZDString(symbol: l10n.currencySymbol)));
      return;
    }
    widget.onSubmit(amount, _toSavings);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.addCollection),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.remainingAmountLabel(widget.maxAmount.toDZDString(symbol: l10n.currencySymbol)),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) {
              if (_errorText != null) setState(() => _errorText = null);
            },
            decoration: InputDecoration(
              hintText: l10n.collectedAmountHint,
              suffixText: l10n.currencySymbol,
              errorText: _errorText,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.addAmountTo,
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _toSavings = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: !_toSavings
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !_toSavings
                            ? AppColors.primary
                            : AppColors.border,
                        width: !_toSavings ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          color: !_toSavings
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.balance,
                          style: AppTypography.labelSmall.copyWith(
                            color: !_toSavings
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: !_toSavings
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${NumberFormat('#,###', 'en_US').format(widget.currentBalance)} ${l10n.currencySymbol}',
                          style: AppTypography.bodySmall.copyWith(
                            color: !_toSavings
                                ? AppColors.primary.withValues(alpha: 0.75)
                                : AppColors.textSecondary.withValues(alpha: 0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _toSavings = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _toSavings
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _toSavings
                            ? AppColors.primary
                            : AppColors.border,
                        width: _toSavings ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.savings_rounded,
                          color: _toSavings
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.savings,
                          style: AppTypography.labelSmall.copyWith(
                            color: _toSavings
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: _toSavings
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${NumberFormat('#,###', 'en_US').format(widget.savingsBalance)} ${l10n.currencySymbol}',
                          style: AppTypography.bodySmall.copyWith(
                            color: _toSavings
                                ? AppColors.primary.withValues(alpha: 0.75)
                                : AppColors.textSecondary.withValues(alpha: 0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: Text(l10n.register),
        ),
      ],
    );
  }
}
