import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_spending_insights_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import 'stat_widgets.dart';

/// Spending at the current pace by the end of the cycle.
class MonthForecastCard extends StatelessWidget {
  final SpendingInsightsResult result;

  const MonthForecastCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;

    if (!result.hasData) {
      return StatKpiCard(
        icon: Icons.insights_rounded,
        color: AppColors.primary,
        label: l10n.monthForecastTitle,
        value: '—',
      );
    }

    final (Color color, IconData icon, String status) = result.isOverBudget
        ? (AppColors.negative, Icons.warning_amber_rounded, l10n.overBudgetLabel)
        : result.isNearBudget
            ? (AppColors.warning, Icons.info_outline_rounded, l10n.nearBudgetLabel)
            : (
                AppColors.positive,
                Icons.check_circle_outline_rounded,
                l10n.underBudgetLabel
              );

    return StatKpiCard(
      icon: Icons.insights_rounded,
      color: color,
      label: l10n.monthForecastTitle,
      value: result.projectedTotal.toInt().toDZDString(symbol: symbol),
      valueColor: color,
      caption:
          '${l10n.forecastFromLabel} ${result.spendableBudget.toDZDString(symbol: symbol)}',
      chip: StatChip(icon: icon, text: status, color: color),
    );
  }
}

/// Average spent per day so far this cycle.
class DailyAverageCard extends StatelessWidget {
  final SpendingInsightsResult result;

  const DailyAverageCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final average = result.hasData && result.daysElapsed > 0
        ? (result.totalSpent / result.daysElapsed).round()
        : null;
    return StatKpiCard(
      icon: Icons.show_chart_rounded,
      color: AppColors.warning,
      label: l10n.dailyAverageLabel,
      value: average == null ? '—' : average.toDZDString(symbol: l10n.currencySymbol),
      caption: result.hasData ? l10n.perDayLabel : null,
    );
  }
}
