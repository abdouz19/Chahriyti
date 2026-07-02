import 'package:flutter/material.dart';

import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class BalancePreviewCard extends StatelessWidget {
  final int salaryAmount;
  final int allocationAmount;
  final int remainingBalance;

  const BalancePreviewCard({
    super.key,
    required this.salaryAmount,
    required this.allocationAmount,
    required this.remainingBalance,
  });

  @override
  Widget build(BuildContext context) {
    final isFullAllocation = remainingBalance == 0 && allocationAmount > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Total salary
          _Row(
            label: 'الراتب الكلي',
            amount: salaryAmount,
            color: AppColors.textPrimary,
          ),
          const Divider(height: 24),
          // Savings allocation
          _Row(
            label: 'المبلغ للادخار',
            amount: allocationAmount,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          // Remaining balance
          _Row(
            label: 'الرصيد المتبقي',
            amount: remainingBalance,
            color: isFullAllocation ? AppColors.negative : AppColors.positive,
            isBold: true,
          ),
          if (isFullAllocation) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'رصيدك الحالي سيكون 0 دج',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final int amount;
  final Color color;
  final bool isBold;

  const _Row({
    required this.label,
    required this.amount,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTypography.labelMedium
              : AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
        ),
        Text(
          amount.toDZDString(),
          style: (isBold ? AppTypography.amountMedium : AppTypography.amountSmall)
              .copyWith(color: color),
        ),
      ],
    );
  }
}
