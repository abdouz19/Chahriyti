import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class DailyAverageWidget extends StatelessWidget {
  final int dailyAverage;

  const DailyAverageWidget({super.key, required this.dailyAverage});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.border,
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
                  Icons.show_chart_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'المعدل اليومي',
                  style: AppTypography.labelSmall,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: 8),
            MoneyText(
              amount: Money.fromDZD(dailyAverage),
              style: AppTypography.amountLarge,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
