import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

enum LendingDeltaSource { balance, savings, forgotten }

class LendingDeltaAdjustmentSheet extends StatelessWidget {
  final int delta;
  final String title;
  final String description;

  /// true  → "from balance / from savings" labels + disable if insufficient
  /// false → "to balance / to savings" labels + always enabled
  final bool isIncrease;
  final int currentBalance;
  final int savingsBalance;

  const LendingDeltaAdjustmentSheet({
    super.key,
    required this.delta,
    required this.title,
    required this.description,
    required this.isIncrease,
    required this.currentBalance,
    required this.savingsBalance,
  });

  static String _fmt(int amount) =>
      NumberFormat('#,###', 'en_US').format(amount);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canAffordBalance = !isIncrease || currentBalance >= delta;
    final canAffordSavings = !isIncrease || savingsBalance >= delta;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.headlineSmall),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            LendingSheetOption(
              icon: Icons.account_balance_wallet_outlined,
              label:
                  isIncrease ? l10n.fromCurrentBalance : l10n.toCurrentBalance,
              subtitle: isIncrease
                  ? '${l10n.available}: ${_fmt(currentBalance)} ${l10n.currencySymbol}'
                  : '${l10n.currentBalance}: ${_fmt(currentBalance)} ${l10n.currencySymbol}',
              color: AppColors.primary,
              enabled: canAffordBalance,
              onTap: () => Navigator.pop(context, LendingDeltaSource.balance),
            ),
            const SizedBox(height: 12),
            LendingSheetOption(
              icon: Icons.savings_outlined,
              label: isIncrease ? l10n.fromSavings : l10n.toSavings,
              subtitle: isIncrease
                  ? '${l10n.available}: ${_fmt(savingsBalance)} ${l10n.currencySymbol}'
                  : '${l10n.savingsBalance}: ${_fmt(savingsBalance)} ${l10n.currencySymbol}',
              color: AppColors.positive,
              enabled: canAffordSavings,
              onTap: () => Navigator.pop(context, LendingDeltaSource.savings),
            ),
            const SizedBox(height: 12),
            LendingSheetOption(
              icon: Icons.history_outlined,
              label: l10n.forgottenAdjustment,
              color: AppColors.warning,
              onTap: () => Navigator.pop(context, LendingDeltaSource.forgotten),
            ),
          ],
        ),
      ),
    );
  }
}

class LendingSheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const LendingSheetOption({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.subtitle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = enabled ? color : AppColors.textSecondary;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: effectiveColor.withValues(alpha: enabled ? 0.08 : 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: effectiveColor.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, color: effectiveColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style:
                        AppTypography.labelLarge.copyWith(color: effectiveColor),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTypography.bodySmall.copyWith(
                        color: enabled
                            ? effectiveColor.withValues(alpha: 0.7)
                            : AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (enabled)
              Icon(Icons.arrow_forward_ios_rounded, color: effectiveColor, size: 14)
            else
              Icon(Icons.block_rounded, color: effectiveColor, size: 16),
          ],
        ),
      ),
    );
  }
}
