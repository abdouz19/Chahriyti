import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/lending_entity.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class LendingCard extends StatelessWidget {
  final LendingEntity lending;
  final VoidCallback? onTap;

  const LendingCard({
    required this.lending,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = lending.remainingAmount;
    final percentageCollected = lending.totalAmount > 0
        ? (lending.collectedAmount / lending.totalAmount.toDouble()) * 100
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: borrower name + completion badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lending.borrowerName,
                        style: AppTypography.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (lending.notes != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            lending.notes!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                if (lending.isFullyCollected)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.positive.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'تم التحصيل',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.positive,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Amounts row: total / remaining
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المبلغ الكلي',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    MoneyText(
                      amount: Money(lending.totalAmount),
                      style: AppTypography.amountSmall,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'المبلغ المتبقي',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    MoneyText(
                      amount: Money(remaining.clamp(0, lending.totalAmount)),
                      style: AppTypography.amountSmall,
                      color:
                          remaining > 0 ? AppColors.warning : AppColors.positive,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentageCollected / 100,
                minHeight: 8,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  remaining > 0 ? AppColors.warning : AppColors.positive,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${percentageCollected.toStringAsFixed(1)}% محصّل',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
