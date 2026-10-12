import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_category_breakdown_use_case.dart';
import '../../../application/use_cases/statistics/get_past_cycles_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../statistics/widgets/category_breakdown_chart.dart';
import '../../statistics/widgets/stat_widgets.dart';
import 'cycle_history_page.dart';

/// Statistics of one finished monthly cycle.
class PastCycleDetailPage extends StatefulWidget {
  final PastCycleSummary summary;

  const PastCycleDetailPage({super.key, required this.summary});

  @override
  State<PastCycleDetailPage> createState() => _PastCycleDetailPageState();
}

class _PastCycleDetailPageState extends State<PastCycleDetailPage> {
  late final Future<CategoryBreakdownResult> _breakdown =
      Injection.getCategoryBreakdownUseCase(widget.summary.cycle);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;
    final s = widget.summary;
    final savedRate = s.income > 0 ? s.saved / s.income * 100 : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(pastCycleTitle(context, s.cycle.startDate),
            style: AppTypography.headlineSmall),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: statCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pastCycleRange(context, s.cycle.startDate, s.cycle.endDate),
                  style: AppTypography.labelSmall,
                ),
                const SizedBox(height: 14),
                Text(l10n.pastCycleSaved, style: AppTypography.labelSmall),
                Text(
                  s.saved.toDZDString(symbol: symbol),
                  style: AppTypography.amountLarge
                      .copyWith(color: AppColors.positive),
                ),
                Text(
                  l10n.pastCycleSavedShare(savedRate.toStringAsFixed(0)),
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(height: 1, color: AppColors.divider),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _Line(
                          label: l10n.pastCycleIncome,
                          value: s.income.toDZDString(symbol: symbol)),
                    ),
                    Expanded(
                      child: _Line(
                        label: l10n.pastCycleSpent,
                        value: s.spending.toDZDString(symbol: symbol),
                        color: AppColors.negative,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<CategoryBreakdownResult>(
            future: _breakdown,
            builder: (context, snap) => snap.hasData
                ? CategoryBreakdownChart(breakdown: snap.data!)
                : const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary)),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _Line({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelSmall),
        const SizedBox(height: 2),
        Text(value,
            style: AppTypography.amountSmall
                .copyWith(color: color ?? AppColors.textPrimary)),
      ],
    );
  }
}
