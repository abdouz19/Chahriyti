import 'package:flutter/material.dart';

import '../../../application/use_cases/insights/generate_spending_trends_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/money_text.dart';
import '../../../domain/value_objects/money.dart';

class TrendCard extends StatelessWidget {
  final SpendingTrend trend;
  final VoidCallback? onTap;

  const TrendCard({
    required this.trend,
    this.onTap,
    super.key,
  });

  IconData _getCategoryIcon() {
    final category = trend.category.toLowerCase();
    if (category.contains('قهوة') || category.contains('مشروبات')) {
      return Icons.local_cafe_rounded;
    } else if (category.contains('طعام') || category.contains('مطعم')) {
      return Icons.restaurant_rounded;
    } else if (category.contains('تسوق') || category.contains('ملابس')) {
      return Icons.shopping_bag_rounded;
    } else if (category.contains('مواصلات')) {
      return Icons.directions_car_rounded;
    } else if (category.contains('ترفيه')) {
      return Icons.movie_rounded;
    } else if (category.contains('صحة')) {
      return Icons.local_hospital_rounded;
    } else if (category.contains('تعليم')) {
      return Icons.school_rounded;
    } else if (category.contains('سكن')) {
      return Icons.home_rounded;
    } else {
      return Icons.label_rounded;
    }
  }

  Color _getTrendColor() {
    return trend.isIncreasing ? AppColors.warning : AppColors.positive;
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
          border: Border.all(
            color: _getTrendColor().withValues(alpha: 0.3),
          ),
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
                    color: _getTrendColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(),
                    color: _getTrendColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trend.category,
                        style: AppTypography.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            trend.isIncreasing
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            color: _getTrendColor(),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${trend.percentageChange.toStringAsFixed(1)}%',
                            style: AppTypography.bodySmall.copyWith(
                              color: _getTrendColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 12),
            // Amount comparison
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الشهر الماضي',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    MoneyText(
                      amount: Money(trend.previousAmount),
                      style: AppTypography.labelLarge,
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'هذا الشهر',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    MoneyText(
                      amount: Money(trend.currentAmount),
                      style: AppTypography.labelLarge,
                      color: _getTrendColor(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Suggestion
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getTrendColor().withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                trend.suggestion,
                style: AppTypography.bodySmall.copyWith(
                  color: _getTrendColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
