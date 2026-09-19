import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_savings_rate_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SavingsRateCard extends StatelessWidget {
  final SavingsRateResult result;

  const SavingsRateCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final symbol = context.l10n.currencySymbol;
    final isEmpty = result.salaryAmount == 0;
    final deltaColor =
        result.isDeltaPositive ? AppColors.positive : AppColors.negative;
    final deltaIcon = result.isDeltaPositive
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;
    final deltaText = result.rateDelta != null
        ? '${result.isDeltaPositive ? '+' : ''}${result.rateDelta!.toStringAsFixed(1)}%'
        : null;

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
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.savings_rounded, color: AppColors.primary, size: 18),
          ),
          const SizedBox(height: 10),
          // Rate value
          Text(
            isEmpty ? '—' : '${result.rate.toStringAsFixed(1)}%',
            style: AppTypography.amountSmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          // Split amount
          Text(
            isEmpty
                ? context.l10n.savingsRateLabel
                : result.salarySplitAmount.toDZDString(symbol: symbol),
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            context.l10n.savingsRateLabel,
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
          ),
          // Delta chip
          if (!isEmpty && result.hasComparison && deltaText != null) ...[
            const SizedBox(height: 10),
            _DeltaChip(
              icon: deltaIcon,
              text: deltaText,
              color: deltaColor,
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
