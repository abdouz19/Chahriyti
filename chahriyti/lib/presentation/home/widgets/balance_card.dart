import 'package:flutter/material.dart';

import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class BalanceCard extends StatelessWidget {
  final int amount;
  final int cycleTotal;

  const BalanceCard({
    super.key,
    required this.amount,
    required this.cycleTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.positive.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.positive.withValues(alpha: 0.3),
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
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.positive,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'الرصيد الحالي',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.positive,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: 8),
            MoneyText(
              amount: Money(amount),
              style: AppTypography.amountLarge,
              color: AppColors.positive,
            ),
            if (cycleTotal > 0) ...[
              const SizedBox(height: 6),
              Text(
                'رصيد الدورة: ${cycleTotal.toDZDString()}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.positive.withValues(alpha: 0.65),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
