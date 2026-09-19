import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_spending_insights_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class DailyBudgetCard extends StatelessWidget {
  final SpendingInsightsResult result;

  const DailyBudgetCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final symbol = context.l10n.currencySymbol;

    if (!result.hasData) {
      return _EmptyKpiCard(
        icon: Icons.today_rounded,
        label: context.l10n.dailyBudgetTitle,
        iconColor: AppColors.primary,
      );
    }

    final daily = result.dailyRemaining;
    final isNegative = daily < 0;
    final valueColor = isNegative ? AppColors.negative : AppColors.positive;
    final formattedDaily = daily.abs().toInt().toDZDString(symbol: symbol);

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
              color: valueColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.today_rounded, color: valueColor, size: 18),
          ),
          const SizedBox(height: 10),
          // Daily amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (isNegative)
                Text(
                  '−',
                  style: AppTypography.amountSmall.copyWith(
                    color: valueColor,
                    fontSize: 13,
                  ),
                ),
              Flexible(
                child: Text(
                  formattedDaily,
                  style: AppTypography.amountSmall.copyWith(
                    color: valueColor,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            context.l10n.perDayLabel,
            style: AppTypography.bodySmall.copyWith(
              color: valueColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          // Label
          Text(
            context.l10n.dailyBudgetTitle,
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 8),
          // Days remaining pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              '${result.daysRemaining} ${context.l10n.daysRemainingLabel}',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Month-End Forecast ────────────────────────────────────────────────────

class MonthForecastCard extends StatelessWidget {
  final SpendingInsightsResult result;

  const MonthForecastCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final symbol = context.l10n.currencySymbol;

    if (!result.hasData) {
      return _EmptyKpiCard(
        icon: Icons.insights_rounded,
        label: context.l10n.monthForecastTitle,
        iconColor: AppColors.primary,
      );
    }

    final projected = result.projectedTotal.toInt();
    final budget = result.spendableBudget;

    final Color statusColor;
    final IconData statusIcon;
    final String statusLabel;

    if (result.isOverBudget) {
      statusColor = AppColors.negative;
      statusIcon = Icons.warning_amber_rounded;
      statusLabel = context.l10n.overBudgetLabel;
    } else if (result.isNearBudget) {
      statusColor = AppColors.warning;
      statusIcon = Icons.info_outline_rounded;
      statusLabel = context.l10n.nearBudgetLabel;
    } else {
      statusColor = AppColors.positive;
      statusIcon = Icons.check_circle_outline_rounded;
      statusLabel = context.l10n.underBudgetLabel;
    }

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
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.insights_rounded, color: statusColor, size: 18),
          ),
          const SizedBox(height: 10),
          // Projected amount
          Text(
            projected.toDZDString(symbol: symbol),
            style: AppTypography.amountSmall.copyWith(
              color: statusColor,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            '${context.l10n.forecastFromLabel} ${budget.toDZDString(symbol: symbol)}',
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            context.l10n.monthForecastTitle,
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 8),
          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, size: 10, color: statusColor),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    statusLabel,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared empty state ────────────────────────────────────────────────────

class _EmptyKpiCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _EmptyKpiCard(
      {required this.icon, required this.label, required this.iconColor});

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            '—',
            style: AppTypography.amountSmall
                .copyWith(color: AppColors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
