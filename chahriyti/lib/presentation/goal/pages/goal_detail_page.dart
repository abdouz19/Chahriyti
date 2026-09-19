import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/goal_cubit.dart';
import '../cubits/goal_state.dart';
import 'add_goal_page.dart';

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
        withdrawSavingsUseCase: Injection.withdrawSavingsUseCase,
        goalRepository: Injection.goalRepository,
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

  @override
  void initState() {
    super.initState();
    _loadSavingsBalance();
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
            icon: const Icon(Icons.edit_outlined),
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
            icon: Icon(Icons.delete_outline, color: AppColors.negative),
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
                    // Goal name
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
                            context.l10n.goalName,
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            goal.name,
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
                                  context.l10n.targetAmount,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${goal.targetAmount} ${context.l10n.currencySymbol}',
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
                                color:
                                    AppColors.positive.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  context.l10n.amountSaved,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$saved ${context.l10n.currencySymbol}',
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
                              '${percentageSaved.toStringAsFixed(0)}%',
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
                            value: percentageSaved / 100,
                            minHeight: 8,
                            backgroundColor: AppColors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              percentageSaved == 100
                                  ? AppColors.positive
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Remaining amount
                    if (!goal.isCompleted)
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
                              '$remaining ${context.l10n.currencySymbol}',
                              style: AppTypography.headlineSmall.copyWith(
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Buy button — visible when savings cover the target
                    if (!goal.isCompleted && percentageSaved >= 100) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () => _showPurchaseConfirmation(
                            context,
                            goal.id,
                            goal.targetAmount,
                            goal.name,
                          ),
                          icon: const Icon(Icons.shopping_cart_rounded,
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

                    // Completed badge
                    if (goal.isCompleted) ...[
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.positive.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.positive.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.positive,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.l10n.purchased,
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.positive,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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

  void _showPurchaseConfirmation(
    BuildContext context,
    int goalId,
    int targetAmount,
    String goalName,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          context.l10n.confirmPurchaseTitle,
          style: AppTypography.headlineSmall,
          textAlign: TextAlign.center,
        ),
        content: Text(
          context.l10n.confirmPurchaseBody(goalName, targetAmount),
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.l10n.cancel,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<GoalCubit>().purchaseGoal(
                    goalId: goalId,
                    amount: targetAmount,
                    goalName: goalName,
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.positive,
              foregroundColor: Colors.white,
            ),
            child: Text(
              context.l10n.purchase,
              style: AppTypography.labelLarge.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
