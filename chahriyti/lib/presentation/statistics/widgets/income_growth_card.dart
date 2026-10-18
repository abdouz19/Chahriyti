import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_income_growth_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import 'stat_widgets.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class IncomeGrowthCard extends StatelessWidget {
  final IncomeGrowthResult result;

  const IncomeGrowthCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isEmpty = result.currentIncome == 0;
    final isPositive = result.growthPercent >= 0;
    final color = isPositive ? AppColors.positive : AppColors.negative;

    return StatKpiCard(
      icon: IconsaxPlusLinear.trend_up,
      color: AppColors.positive,
      label: context.l10n.totalIncomeThisCycle,
      value: isEmpty
          ? '—'
          : result.currentIncome.toDZDString(symbol: context.l10n.currencySymbol),
      chip: !isEmpty && result.hasComparison
          ? StatChip(
              icon: isPositive
                  ? IconsaxPlusLinear.arrow_up
                  : IconsaxPlusLinear.arrow_down,
              text:
                  '${isPositive ? '+' : ''}${result.growthPercent.toStringAsFixed(1)}%',
              color: color,
            )
          : null,
    );
  }
}
