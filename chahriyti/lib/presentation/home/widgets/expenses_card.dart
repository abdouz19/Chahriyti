import 'package:flutter/material.dart';

import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class ExpensesCard extends StatelessWidget {
  final int expenses;
  final int savingsAmount;

  const ExpensesCard({
    super.key,
    required this.expenses,
    this.savingsAmount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.negative.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.negative.withValues(alpha: 0.3),
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
                  Icons.trending_down_rounded,
                  color: AppColors.negative,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'المصاريف',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.negative,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: 8),
            MoneyText(
              amount: Money(expenses),
              style: AppTypography.amountLarge,
              color: AppColors.negative,
            ),
            if (savingsAmount > 0) ...[
              const SizedBox(height: 6),
              Text(
                'من المدخرات هذه الدورة: ${savingsAmount.toDZDString()}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.negative.withValues(alpha: 0.65),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
