import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/savings_goal_entity.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class GoalProgressCard extends StatelessWidget {
  final List<SavingsGoalEntity> goals;
  final int savingsBalance;
  final VoidCallback? onViewAll;

  const GoalProgressCard({
    super.key,
    required this.goals,
    required this.savingsBalance,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...goals
            .take(3)
            .map((goal) => _GoalItem(goal: goal, savingsBalance: savingsBalance)),
        Divider(height: 16, color: AppColors.divider),
        GestureDetector(
          onTap: onViewAll,
          child: Center(
            child: Text(
              'عرض الكل',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GoalItem extends StatelessWidget {
  final SavingsGoalEntity goal;
  final int savingsBalance;

  const _GoalItem({required this.goal, required this.savingsBalance});

  @override
  Widget build(BuildContext context) {
    final saved = savingsBalance.clamp(0, goal.targetAmount);
    final percent = goal.targetAmount > 0
        ? (saved / goal.targetAmount * 100)
        : 0.0;
    final fraction = (percent / 100).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal.name,
                  style: AppTypography.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${percent.toStringAsFixed(0)}%',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: fraction,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: MoneyText(
              amount: Money(goal.targetAmount),
              style: AppTypography.bodySmall,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
