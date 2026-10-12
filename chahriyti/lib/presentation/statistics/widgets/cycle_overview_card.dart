import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../../application/use_cases/statistics/get_spending_insights_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/statistics_cubit.dart';
import 'classification_badge.dart';
import 'stat_widgets.dart';

/// Top of the statistics screen: how this cycle is going at a glance.
class CycleOverviewCard extends StatelessWidget {
  final FinancialTier? tier;
  final SpendingInsightsResult insights;
  final FirstCycleNote? firstCycleNote;

  const CycleOverviewCard({
    super.key,
    required this.tier,
    required this.insights,
    this.firstCycleNote,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;
    final accent = tier != null ? tierColor(tier!) : AppColors.primary;
    final available = insights.spendableBudget;
    final spentShare = available > 0
        ? (insights.totalSpent / available).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: statCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tier
          if (tier != null)
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(tier!.emoji, style: const TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tierLabel(context, tier!),
                        style: AppTypography.labelLarge.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        tierDescription(context, tier!),
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (insights.hasData) ...[
            if (tier != null) const SizedBox(height: 20),
            // Remaining (main figure)
            Text(l10n.statRemainingThisCycle, style: AppTypography.labelSmall),
            const SizedBox(height: 4),
            Text(
              insights.remainingBudget.toDZDString(symbol: symbol),
              style: AppTypography.amountLarge.copyWith(
                color: insights.remainingBudget < 0
                    ? AppColors.negative
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: spentShare,
                minHeight: 10,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.statSpentOfAvailable(
                insights.totalSpent.toDZDString(symbol: symbol),
                available.toDZDString(symbol: symbol),
              ),
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
            if (firstCycleNote != null) ...[
              const SizedBox(height: 10),
              _FirstCycleNoteBox(note: firstCycleNote!),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(height: 1, color: AppColors.divider),
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _Figure(
                      label: l10n.dailyBudgetTitle,
                      value: insights.dailyRemaining
                          .toInt()
                          .toDZDString(symbol: symbol),
                    ),
                  ),
                  const VerticalDivider(width: 24, color: AppColors.divider),
                  Expanded(
                    child: _Figure(
                      label: l10n.daysRemainingLabel,
                      value: '${insights.daysRemaining}',
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

class _Figure extends StatelessWidget {
  final String label;
  final String value;

  const _Figure({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelSmall),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.amountSmall),
      ],
    );
  }
}

/// First cycle only: why the base is the opening balance, not the salary.
class _FirstCycleNoteBox extends StatelessWidget {
  final FirstCycleNote note;

  const _FirstCycleNoteBox({required this.note});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;
    final locale = Localizations.localeOf(context).languageCode;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.statFirstCycleNote(
                note.openingBalance.toDZDString(symbol: symbol),
                DateFormat('d MMMM', locale).format(note.salaryFrom),
                note.salary.toDZDString(symbol: symbol),
              ),
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
