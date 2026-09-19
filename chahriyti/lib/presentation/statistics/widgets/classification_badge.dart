import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ClassificationBadge extends StatelessWidget {
  final FinancialTier tier;

  const ClassificationBadge({super.key, required this.tier});

  @override
  Widget build(BuildContext context) {
    final color = _tierColor;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            // Left accent bar
            Container(width: 4, height: 52, color: color),
            const SizedBox(width: 12),
            // Emoji
            Text(tier.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            // Tier name
            Text(
              _tierLabel(context),
              style: AppTypography.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            // Separator
            Text(
              '·',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            // Description
            Expanded(
              child: Text(
                _tierDescription(context),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Color get _tierColor {
    switch (tier) {
      case FinancialTier.legendary:
        return const Color(0xFFD4A017);
      case FinancialTier.smart:
        return const Color(0xFF0D6E6E);
      case FinancialTier.balanced:
        return const Color(0xFF3B82F6);
      case FinancialTier.spender:
        return const Color(0xFFF59E0B);
      case FinancialTier.danger:
        return const Color(0xFFEF4444);
      case FinancialTier.earlyBankrupt:
        return const Color(0xFF991B1B);
    }
  }

  String _tierLabel(BuildContext context) {
    switch (tier) {
      case FinancialTier.legendary:
        return context.l10n.tierLegendary;
      case FinancialTier.smart:
        return context.l10n.tierSmart;
      case FinancialTier.balanced:
        return context.l10n.tierBalanced;
      case FinancialTier.spender:
        return context.l10n.tierSpender;
      case FinancialTier.danger:
        return context.l10n.tierDanger;
      case FinancialTier.earlyBankrupt:
        return context.l10n.tierEarlyBankrupt;
    }
  }

  String _tierDescription(BuildContext context) {
    switch (tier) {
      case FinancialTier.legendary:
        return context.l10n.tierLegendaryDesc;
      case FinancialTier.smart:
        return context.l10n.tierSmartDesc;
      case FinancialTier.balanced:
        return context.l10n.tierBalancedDesc;
      case FinancialTier.spender:
        return context.l10n.tierSpenderDesc;
      case FinancialTier.danger:
        return context.l10n.tierDangerDesc;
      case FinancialTier.earlyBankrupt:
        return context.l10n.tierEarlyBankruptDesc;
    }
  }
}
