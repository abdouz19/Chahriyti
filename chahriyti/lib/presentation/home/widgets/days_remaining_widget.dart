import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class DaysRemainingWidget extends StatelessWidget {
  final int daysRemaining;

  const DaysRemainingWidget({super.key, required this.daysRemaining});

  @override
  Widget build(BuildContext context) {
    final isSalaryDay = daysRemaining == 0;

    return Card(
      color: isSalaryDay
          ? AppColors.positive.withValues(alpha: 0.08)
          : AppColors.primary.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSalaryDay
              ? AppColors.positive.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSalaryDay
                      ? Icons.celebration_rounded
                      : Icons.calendar_today_rounded,
                  color: isSalaryDay ? AppColors.positive : AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  isSalaryDay ? 'يوم الراتب!' : 'الأيام المتبقية',
                  style: AppTypography.labelSmall.copyWith(
                    color:
                        isSalaryDay ? AppColors.positive : AppColors.primary,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isSalaryDay)
              Text(
                'يوم الراتب!',
                style: AppTypography.amountLarge.copyWith(
                  color: AppColors.positive,
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$daysRemaining',
                    style: AppTypography.amountLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'يوم',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
