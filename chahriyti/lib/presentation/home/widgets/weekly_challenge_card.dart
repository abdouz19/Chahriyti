import 'package:flutter/material.dart';

import '../../../application/use_cases/challenge/generate_weekly_challenge_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

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
                    color: AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.warning,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'تحدي الأسبوع ${data.weekNumber}',
                  style: AppTypography.labelLarge,
                ),
                const Spacer(),
                if (data.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.positive.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'مكتمل',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.positive,
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
            if (data.previousWeekSpending > 0) ...[
              const SizedBox(height: 12),
              RepaintBoundary(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: data.progressPercent / 100,
                    minHeight: 6,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      data.isCompleted ? AppColors.positive : AppColors.warning,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${data.progressPercent.toStringAsFixed(0)}% من الهدف',
                style: AppTypography.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
