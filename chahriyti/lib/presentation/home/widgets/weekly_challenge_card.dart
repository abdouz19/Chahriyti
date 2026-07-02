import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/weekly_challenge_data.dart';

class WeeklyChallengeCard extends StatelessWidget {
  final WeeklyChallengeData? challenge;

  const WeeklyChallengeCard({super.key, this.challenge});

  @override
  Widget build(BuildContext context) {
    if (challenge == null) {
      return const SizedBox.shrink();
    }

    final data = challenge!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: data.isCompleted
                        ? AppColors.positive.withValues(alpha: 0.12)
                        : AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    data.isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.emoji_events_rounded,
                    color: data.isCompleted ? AppColors.positive : AppColors.warning,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'تحدي الأسبوع ${data.weekNumber}',
                  style: AppTypography.labelLarge,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: data.isCompleted
                        ? AppColors.positive.withValues(alpha: 0.12)
                        : AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data.isCompleted ? 'مكتمل' : 'قيد التقدم',
                    style: AppTypography.labelSmall.copyWith(
                      color: data.isCompleted
                          ? AppColors.positive
                          : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data.description,
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المبلغ المستهدف',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'دج ${data.targetAmount}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
