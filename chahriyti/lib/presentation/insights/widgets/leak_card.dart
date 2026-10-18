import 'package:flutter/material.dart';

import '../../../application/use_cases/insights/detect_financial_leaks_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/money_text.dart';
import '../../../domain/value_objects/money.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class LeakCard extends StatelessWidget {
  final LeakInsight leak;
  final VoidCallback? onTap;

  const LeakCard({
    required this.leak,
    this.onTap,
    super.key,
  });

  IconData _getCategoryIcon() {
    final category = leak.category.toLowerCase();
    if (category.contains('قهوة') || category.contains('مشروبات')) {
      return IconsaxPlusBold.coffee;
    } else if (category.contains('طعام') || category.contains('مطعم')) {
      return IconsaxPlusBold.reserve;
    } else if (category.contains('تسوق') || category.contains('ملابس')) {
      return IconsaxPlusBold.shopping_bag;
    } else if (category.contains('مواصلات')) {
      return IconsaxPlusBold.car;
    } else if (category.contains('ترفيه')) {
      return IconsaxPlusBold.video_play;
    } else if (category.contains('صحة')) {
      return IconsaxPlusBold.hospital;
    } else if (category.contains('تعليم')) {
      return IconsaxPlusBold.teacher;
    } else if (category.contains('سكن')) {
      return IconsaxPlusBold.home_2;
    } else {
      return IconsaxPlusBold.tag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and category
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(),
                    color: AppColors.warning,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leak.category,
                        style: AppTypography.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.transactions(leak.transactionCount),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MoneyText(
                      amount: Money(leak.totalAmount),
                      style: AppTypography.labelLarge,
                      color: AppColors.warning,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${leak.percentageOfTotal.toStringAsFixed(1)}%',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 12),
            // Savings opportunity
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.positive.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    IconsaxPlusLinear.trend_down,
                    color: AppColors.positive,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.canSave,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  MoneyText(
                    amount: Money(leak.potentialSavings),
                    style: AppTypography.labelLarge,
                    color: AppColors.positive,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Suggestion
            Text(
              leak.suggestion,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
