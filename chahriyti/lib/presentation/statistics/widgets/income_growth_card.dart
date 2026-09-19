import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_income_growth_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class IncomeGrowthCard extends StatelessWidget {
  final IncomeGrowthResult result;

  const IncomeGrowthCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final symbol = context.l10n.currencySymbol;
    final isEmpty = result.currentIncome == 0;
    final isPositive = result.growthPercent >= 0;
    final growthColor = isPositive ? AppColors.positive : AppColors.negative;
    final growthIcon =
        isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
    final pctText = isPositive
        ? '+${result.growthPercent.toStringAsFixed(1)}%'
        : '${result.growthPercent.toStringAsFixed(1)}%';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.positive.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.trending_up_rounded,
                color: AppColors.positive, size: 18),
          ),
          const SizedBox(height: 10),
          // Value
          Text(
            isEmpty
                ? '—'
                : result.currentIncome.toDZDString(symbol: symbol),
            style: AppTypography.amountSmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // Label
          Text(
            context.l10n.totalIncomeThisCycle,
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
            maxLines: 2,
          ),
          // Delta chip
          if (!isEmpty && result.hasComparison) ...[
            const SizedBox(height: 10),
            _DeltaChip(
              icon: growthIcon,
              text: pctText,
              color: growthColor,
            ),
          ],
        ],
      ),
    );
  }
}

class _DeltaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _DeltaChip(
      {required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
