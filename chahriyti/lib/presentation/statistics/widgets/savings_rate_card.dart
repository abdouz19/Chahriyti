import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_savings_rate_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import 'stat_widgets.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class SavingsRateCard extends StatelessWidget {
  final SavingsRateResult result;

  const SavingsRateCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isEmpty = result.incomeBase == 0;
    final up = result.isDeltaPositive;

    return StatKpiCard(
      icon: IconsaxPlusBold.strongbox,
      color: AppColors.primary,
      label: context.l10n.savingsRateLabel,
      value: isEmpty ? '—' : '${result.rate.toStringAsFixed(1)}%',
      caption: isEmpty
          ? null
          : result.savedAmount.toDZDString(symbol: context.l10n.currencySymbol),
      chip: !isEmpty && result.rateDelta != null
          ? StatChip(
              icon: up ? IconsaxPlusLinear.arrow_up : IconsaxPlusLinear.arrow_down,
              text: '${up ? '+' : ''}${result.rateDelta!.toStringAsFixed(1)}%',
              color: up ? AppColors.positive : AppColors.negative,
            )
          : null,
    );
  }
}
