import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/goal_entity.dart';
import '../../shared/widgets/amount_progress_card.dart';
import '../cubits/goal_cubit.dart';
import '../cubits/goal_state.dart';
import 'add_goal_page.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class GoalDetailPage extends StatelessWidget {
  final int goalId;

  const GoalDetailPage({
    required this.goalId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoalCubit(
        Injection.createGoalUseCase,
        Injection.getGoalsUseCase,
        Injection.updateGoalUseCase,
        Injection.deleteGoalUseCase,
        purchaseGoalUseCase: Injection.purchaseGoalUseCase,
        undoGoalPurchaseUseCase: Injection.undoGoalPurchaseUseCase,
        notificationService: Injection.notificationService,
      )..loadGoalById(goalId),
      child: _GoalDetailView(goalId: goalId),
    );
  }
}

class _GoalDetailView extends StatefulWidget {
  final int goalId;

  const _GoalDetailView({required this.goalId});

  @override
  State<_GoalDetailView> createState() => _GoalDetailViewState();
}

class _GoalDetailViewState extends State<_GoalDetailView> {
  int _savingsBalance = 0;
  bool _hasOtherActiveGoals = false;

  @override
  void initState() {
    super.initState();
    _loadSavingsBalance();
    _loadOtherGoals();
  }

  // Goals all draw on the same savings; warn when others compete for it
  Future<void> _loadOtherGoals() async {
    final active = await Injection.getGoalsUseCase.getActiveGoals(limit: 2);
    if (mounted) {
      setState(() => _hasOtherActiveGoals =
          active.any((g) => g.id != widget.goalId));
    }
  }

  Future<void> _loadSavingsBalance() async {
    final balance = await Injection.getSavingsBalanceUseCase();
    if (mounted) {
      setState(() => _savingsBalance = balance);
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    final cubit = context.read<GoalCubit>();
    final currentState = cubit.state;
    if (currentState is! GoalLoaded) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.deleteGoalTitle),
        content: Text(context.l10n.deleteGoalBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.deleteGoal(currentState.goal.id);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.goalDetails,
          style: AppTypography.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.edit_2),
            tooltip: context.l10n.edit,
            onPressed: () async {
              final cubit = context.read<GoalCubit>();
              final currentState = cubit.state;
              if (currentState is GoalLoaded) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddGoalPage(initialGoal: currentState.goal),
                  ),
                );
                cubit.loadGoalById(widget.goalId);
              }
            },
          ),
          IconButton(
            icon: Icon(IconsaxPlusLinear.trash, color: AppColors.negative),
            tooltip: context.l10n.delete,
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: BlocListener<GoalCubit, GoalState>(
        listener: (context, state) {
          if (state is GoalUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.purchaseSuccess),
                backgroundColor: AppColors.positive,
              ),
            );
            Navigator.pop(context);
          }
          if (state is GoalDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.goalDeletedMsg),
                backgroundColor: AppColors.positive,
              ),
            );
            Navigator.pop(context);
          }
          if (state is GoalError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.negative,
              ),
            );
          }
        },
        child: BlocBuilder<GoalCubit, GoalState>(
          builder: (context, state) {
            if (state is GoalLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is GoalLoaded) {
              final goal = state.goal;
              final saved = _savingsBalance.clamp(0, goal.targetAmount);
              final percentageSaved = goal.targetAmount > 0
                  ? (saved / goal.targetAmount * 100)
                  : 0.0;
              final remaining =
                  (goal.targetAmount - saved).clamp(0, goal.targetAmount);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AmountProgressCard(
                      personLabel: context.l10n.goalName,
                      personName: goal.name,
                      totalAmount: goal.targetAmount,
                      totalLabel: context.l10n.targetAmount,
                      progressLabel: context.l10n.amountSaved,
                      progressAmount: goal.isCompleted ? goal.targetAmount : saved,
                      remainingAmount: goal.isCompleted ? 0 : remaining,
                      isCompleted: goal.isCompleted,
                      footer: !goal.isCompleted && _hasOtherActiveGoals
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(IconsaxPlusLinear.info_circle,
                                    size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    context.l10n.goalsShareSavingsNote,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),

                    // Buy button — visible when savings cover the target
                    if (!goal.isCompleted && percentageSaved >= 100) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showPurchaseConfirmation(context, goal),
                          icon: const Icon(IconsaxPlusBold.shopping_cart,
                              size: 24),
                          label: Text(
                            context.l10n.purchase,
                            style: AppTypography.labelLarge
                                .copyWith(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.positive,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],

                    // Purchased: what was paid, and a way back
                    if (goal.isCompleted) ...[
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.positive.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.positive.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              IconsaxPlusBold.tick_circle,
                              color: AppColors.positive,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                goal.purchasedAmount != null
                                    ? context.l10n.purchasedFor(
                                        goal.purchasedAmount!.toDZDString(
                                            symbol:
                                                context.l10n.currencySymbol))
                                    : context.l10n.purchased,
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.positive,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton.icon(
                          onPressed: () =>
                              _showUndoPurchaseConfirmation(context, goal),
                          icon: const Icon(IconsaxPlusLinear.undo, size: 18),
                          label: Text(context.l10n.undoPurchase),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }

            if (state is GoalError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IconsaxPlusLinear.danger,
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

  Future<void> _showPurchaseConfirmation(
      BuildContext context, GoalEntity goal) async {
    final cubit = context.read<GoalCubit>();
    final price = await showDialog<int>(
      context: context,
      builder: (_) => _PurchaseDialog(
        goalName: goal.name,
        initialPrice: goal.targetAmount,
        savingsBalance: _savingsBalance,
      ),
    );
    if (price == null) return;
    cubit.purchaseGoal(goalId: goal.id, price: price, goalName: goal.name);
  }

  void _showUndoPurchaseConfirmation(BuildContext context, GoalEntity goal) {
    final cubit = context.read<GoalCubit>();
    final l10n = context.l10n;
    final refund = (goal.purchasedAmount ?? goal.targetAmount)
        .toDZDString(symbol: l10n.currencySymbol);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.undoPurchase, style: AppTypography.headlineSmall),
        content: Text(
          l10n.undoPurchaseBody(refund),
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final error = await cubit.undoPurchase(goal);
              await _loadSavingsBalance();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error ?? l10n.purchaseUndone),
                  backgroundColor:
                      error == null ? AppColors.positive : AppColors.negative,
                ),
              );
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}

/// Asks for the price actually paid; pops with it, or null when cancelled.
/// Owns its controller so it outlives the dialog's closing animation.
class _PurchaseDialog extends StatefulWidget {
  final String goalName;
  final int initialPrice;
  final int savingsBalance;

  const _PurchaseDialog({
    required this.goalName,
    required this.initialPrice,
    required this.savingsBalance,
  });

  @override
  State<_PurchaseDialog> createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<_PurchaseDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialPrice.toString());
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = context.l10n;
    final price = int.tryParse(_controller.text);
    if (price == null || price <= 0) {
      setState(() => _errorText = l10n.enterValidAmount);
      return;
    }
    if (price > widget.savingsBalance) {
      setState(() => _errorText = l10n.amountExceedsAvailable);
      return;
    }
    Navigator.pop(context, price);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(l10n.confirmPurchaseTitle, style: AppTypography.headlineSmall),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.purchasePriceQuestion(widget.goalName),
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            onChanged: (_) {
              if (_errorText != null) setState(() => _errorText = null);
            },
            decoration: InputDecoration(
              suffixText: l10n.currencySymbol,
              errorText: _errorText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.purchaseDeductNote} ${l10n.availableBalance}: '
            '${widget.savingsBalance.toDZDString(symbol: l10n.currencySymbol)}',
            style:
                AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: AppTypography.labelLarge
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.positive,
            foregroundColor: Colors.white,
          ),
          child: Text(
            l10n.purchase,
            style: AppTypography.labelLarge.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
