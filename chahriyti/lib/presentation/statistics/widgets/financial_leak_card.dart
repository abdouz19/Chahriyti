import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/detect_financial_leaks_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class FinancialLeakCard extends StatelessWidget {
  final FinancialLeak leak;

  const FinancialLeakCard({
    super.key,
    required this.leak,
  });

  @override
  Widget build(BuildContext context) {
    final hasIncrease =
        leak.monthOverMonthChange != null && leak.monthOverMonthChange! > 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: subcategory name + icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: AppColors.warning,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leak.subcategory,
                      style: AppTypography.labelLarge,
                    ),
                    Text(
                      '${leak.transactionCount} عمليات',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              // Month-over-month change badge
              if (hasIncrease)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.negative.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        color: AppColors.negative,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${leak.monthOverMonthChange!.toStringAsFixed(0)}%',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.negative,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Total spent
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إجمالي الإنفاق',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              MoneyText(
                amount: Money(leak.totalSpent),
                style: AppTypography.labelMedium,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Potential savings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التوفير المحتمل',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              MoneyText(
                amount: Money(leak.potentialSavings),
                style: AppTypography.labelMedium,
                color: AppColors.positive,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
