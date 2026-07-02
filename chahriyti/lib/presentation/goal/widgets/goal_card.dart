import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/goal_entity.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';
import 'progress_bar.dart';

class GoalCard extends StatelessWidget {
  final GoalEntity goal;
  final int savingsBalance;
  final VoidCallback? onTap;

  const GoalCard({
    required this.goal,
    this.savingsBalance = 0,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: AppTypography.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (goal.description != null)
                        Text(
                          goal.description!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (goal.isCompleted)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.positive.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'مكتمل',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.positive,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الهدف:',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                MoneyText(
                  amount: Money(goal.targetAmount.toInt()),
                  style: AppTypography.amountSmall,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            GoalProgressBar(
              targetAmount: goal.targetAmount,
              progressPercent: goal.targetAmount > 0
                  ? (savingsBalance.clamp(0, goal.targetAmount) /
                          goal.targetAmount *
                          100)
                  : 0,
            ),
          ],
        ),
      ),
    );
  }
}
