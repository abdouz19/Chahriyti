import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_income_breakdown_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class IncomeBreakdownChart extends StatefulWidget {
  final IncomeBreakdownResult breakdown;

  const IncomeBreakdownChart({super.key, required this.breakdown});

  @override
  State<IncomeBreakdownChart> createState() => _IncomeBreakdownChartState();
}

class _IncomeBreakdownChartState extends State<IncomeBreakdownChart> {
  int _touchedIndex = -1;

  static const List<Color> _palette = [
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFF59E0B),
    Color(0xFF06B6D4),
    Color(0xFFF43F5E),
    Color(0xFF6366F1),
    Color(0xFF14B8A6),
  ];

  Color _colorFor(int index) => _palette[index % _palette.length];

  @override
  Widget build(BuildContext context) {
    final amounts = widget.breakdown.amounts;
    final percentages = widget.breakdown.percentages;
    final keys = amounts.keys.toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up_rounded, size: 18, color: AppColors.positive),
              const SizedBox(width: 8),
              Text(context.l10n.incomeBreakdownTitle, style: AppTypography.headlineSmall),
            ],
          ),
          if (widget.breakdown.total > 0) ...[
            const SizedBox(height: 4),
            Text(
              context.l10n.totalAdditionalIncome(
                widget.breakdown.total.toDZDString(symbol: context.l10n.currencySymbol),
              ),
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: 20),
          if (keys.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  context.l10n.noAdditionalIncomeYet,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ),
            )
          else ...[
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = response.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sections: List.generate(keys.length, (i) {
                    final key = keys[i];
                    final pct = percentages[key]!;
                    final amount = amounts[key]!;
                    final isTouched = i == _touchedIndex;
                    final color = _colorFor(i);

                    return PieChartSectionData(
                      value: pct,
                      color: color,
                      radius: isTouched ? 65 : 55,
                      title: isTouched
                          ? amount.toDZDString(symbol: context.l10n.currencySymbol)
                          : (pct >= 5 ? '${pct.toStringAsFixed(0)}%' : ''),
                      titleStyle: TextStyle(
                        fontSize: isTouched ? 12 : 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    );
                  }),
                  centerSpaceRadius: 55,
                  sectionsSpace: 2,
                  startDegreeOffset: -90,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(keys, amounts, percentages),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend(
    List<String> keys,
    Map<String, int> amounts,
    Map<String, double> percentages,
  ) {
    return Column(
      children: List.generate(keys.length, (i) {
        final key = keys[i];
        final amount = amounts[key]!;
        final pct = percentages[key]!;
        final color = _colorFor(i);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  key,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                amount.toDZDString(symbol: context.l10n.currencySymbol),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.positive,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${pct.toStringAsFixed(0)}%',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }),
    );
  }
}
