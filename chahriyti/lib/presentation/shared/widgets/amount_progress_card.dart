import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Summary card for a debt or lending: person, remaining amount, progress,
/// and total vs. paid/collected.
class AmountProgressCard extends StatelessWidget {
  final String personLabel;
  final String personName;
  final int totalAmount;
  final String? totalLabel;
  final String progressLabel;
  final int progressAmount;
  final int remainingAmount;
  final bool isCompleted;
  final Widget? footer;

  const AmountProgressCard({
    required this.personLabel,
    required this.personName,
    required this.totalAmount,
    this.totalLabel,
    required this.progressLabel,
    required this.progressAmount,
    required this.remainingAmount,
    required this.isCompleted,
    this.footer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;
    final accent = isCompleted ? AppColors.positive : AppColors.primary;
    final initial =
        personName.trim().isNotEmpty ? personName.trim()[0].toUpperCase() : '?';
    final percent = totalAmount > 0
        ? (progressAmount / totalAmount * 100).clamp(0.0, 100.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Person
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  initial,
                  style: AppTypography.amountSmall
                      .copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(personLabel, style: AppTypography.labelSmall),
                    Text(
                      personName,
                      style: AppTypography.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.positive.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.completed,
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.positive),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Remaining (main figure)
          Text(l10n.remainingAmount, style: AppTypography.labelSmall),
          const SizedBox(height: 4),
          Text(
            remainingAmount.toDZDString(symbol: symbol),
            style: AppTypography.amountLarge.copyWith(
              color: isCompleted ? AppColors.positive : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Progress
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 10,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.progress, style: AppTypography.labelSmall),
              Text(
                '${percent.toStringAsFixed(0)}%',
                style: AppTypography.labelSmall.copyWith(color: accent),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: AppColors.divider),
          ),

          // Total / paid
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _Stat(
                    label: totalLabel ?? l10n.totalAmount,
                    value: totalAmount.toDZDString(symbol: symbol),
                  ),
                ),
                const VerticalDivider(width: 24, color: AppColors.divider),
                Expanded(
                  child: _Stat(
                    label: progressLabel,
                    value: progressAmount.toDZDString(symbol: symbol),
                    valueColor: AppColors.positive,
                  ),
                ),
              ],
            ),
          ),
          if (footer != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: AppColors.divider),
            ),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Stat({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelSmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.amountSmall.copyWith(
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
