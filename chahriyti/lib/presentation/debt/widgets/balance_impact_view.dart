import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Explains how an action changes the current balance:
/// "X will be added/deducted", the calculation, and a block message when the
/// balance can't cover a deduction.
class BalanceImpactView extends StatelessWidget {
  /// Signed change to the current balance.
  final int delta;

  /// Null while loading; the calculation line is hidden until then.
  final int? currentBalance;

  /// Shown instead of the impact when set (e.g. debt from a previous cycle).
  final String? notice;

  /// Extra advice under the impact.
  final String? hint;

  /// Describes savings instead of the current balance.
  final bool isSavings;

  const BalanceImpactView({
    required this.delta,
    this.currentBalance,
    this.notice,
    this.hint,
    this.isSavings = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;
    final balance = currentBalance;
    final secondary =
        AppTypography.bodySmall.copyWith(color: AppColors.textSecondary);

    if (notice != null) return Text(notice!, style: secondary);
    if (delta == 0) {
      return Text(isSavings ? l10n.savingsImpactNone : l10n.debtImpactNone,
          style: secondary);
    }

    final color = delta > 0 ? AppColors.positive : AppColors.negative;
    final amount = delta.abs().toDZDString(symbol: symbol);
    final newBalance = balance != null ? balance + delta : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isSavings
              ? (delta > 0
                  ? l10n.savingsImpactAdd(amount)
                  : l10n.savingsImpactDeduct(amount))
              : (delta > 0
                  ? l10n.debtImpactAdd(amount)
                  : l10n.debtImpactDeduct(amount)),
          style: AppTypography.labelLarge.copyWith(color: color),
        ),
        if (balance != null && newBalance != null) ...[
          const SizedBox(height: 8),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              '${balance.toFormattedNumber()} ${delta > 0 ? '+' : '−'} '
              '${delta.abs().toFormattedNumber()} = '
              '${newBalance.toDZDString(symbol: symbol)}',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: newBalance < 0 ? AppColors.negative : AppColors.textPrimary,
              ),
            ),
          ),
        ],
        if (balance != null && newBalance != null && newBalance < 0) ...[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.block_rounded,
                  size: 16, color: AppColors.negative),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isSavings
                      ? l10n.savingsImpactInsufficient(
                          balance.toDZDString(symbol: symbol), amount)
                      : l10n.debtImpactInsufficientBalance(
                          balance.toDZDString(symbol: symbol),
                          amount,
                        ),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.negative,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (hint != null) ...[
          const SizedBox(height: 8),
          Text(hint!, style: secondary),
        ],
      ],
    );
  }
}
