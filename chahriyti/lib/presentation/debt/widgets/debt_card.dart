import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class DebtCard extends StatelessWidget {
  final DebtEntity debt;
  final VoidCallback? onTap;

  const DebtCard({
    required this.debt,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate remaining balance and progress
    final totalPaid = debt.payments.fold<int>(0, (sum, p) => sum + p.amount);
    final remaining = debt.totalAmount - totalPaid;
    final percentagePaid = debt.totalAmount > 0
        ? (totalPaid / debt.totalAmount.toDouble()) * 100
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
            // Header: creditor name + completion badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        debt.creditorName,
                        style: AppTypography.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (debt.notes != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            debt.notes!,
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
                if (debt.isCompleted)
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

            // Amounts row: total / paid
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
                      amount: Money(debt.totalAmount.toInt()),
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
                      amount: Money(remaining.clamp(0, debt.totalAmount).toInt()),
                      style: AppTypography.amountSmall,
                      color: remaining > 0 ? AppColors.warning : AppColors.positive,
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
                value: percentagePaid / 100,
                minHeight: 8,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  remaining > 0 ? AppColors.warning : AppColors.positive,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${percentagePaid.toStringAsFixed(1)}% مدفوع',
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
