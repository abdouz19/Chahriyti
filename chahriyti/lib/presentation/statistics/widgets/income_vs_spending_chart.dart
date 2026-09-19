import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../application/use_cases/statistics/get_income_vs_spending_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class IncomeVsSpendingChart extends StatefulWidget {
  final List<IncomeVsSpendingPoint> points;

  const IncomeVsSpendingChart({super.key, required this.points});

  @override
  State<IncomeVsSpendingChart> createState() => _IncomeVsSpendingChartState();
}

class _IncomeVsSpendingChartState extends State<IncomeVsSpendingChart> {
  int _touchedGroupIndex = -1;
  int _touchedRodIndex = -1;

  String _monthName(int month) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('MMM', locale).format(DateTime(2024, month));
  }

  static const _incomeColor = Color(0xFF10B981);
  static final _spendingColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
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
          Text(context.l10n.incomeVsSpendingTitle, style: AppTypography.headlineSmall),
          const SizedBox(height: 12),
          // Legend
          Row(
            children: [
              _LegendDot(color: _incomeColor, label: context.l10n.incomeLabel),
              const SizedBox(width: 16),
              _LegendDot(color: _spendingColor, label: context.l10n.spendingLabel),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.points.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  context.l10n.insufficientDataForComparison,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            SizedBox(
              height: 220,
              child: BarChart(_buildChartData(context)),
            ),
        ],
      ),
    );
  }

  BarChartData _buildChartData(BuildContext context) {
    final pts = widget.points;
    final maxVal = pts
            .expand((p) => [p.income.toDouble(), p.spending.toDouble()])
            .reduce((a, b) => a > b ? a : b) *
        1.25;

    return BarChartData(
      maxY: maxVal,
      groupsSpace: 12,
      barTouchData: BarTouchData(
        touchCallback: (event, response) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.spot == null) {
              _touchedGroupIndex = -1;
              _touchedRodIndex = -1;
              return;
            }
            _touchedGroupIndex = response.spot!.touchedBarGroupIndex;
            _touchedRodIndex = response.spot!.touchedRodDataIndex;
          });
        },
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => AppColors.card,
          tooltipBorder: BorderSide(color: AppColors.border),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final pt = pts[groupIndex];
            final isIncome = rodIndex == 0;
            final amount = (isIncome ? pt.income : pt.spending);
            return BarTooltipItem(
              '${_monthName(pt.month.month)}\n',
              AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              children: [
                TextSpan(
                  text: '${isIncome ? context.l10n.incomeLabel : context.l10n.spendingLabel}: ',
                  style: AppTypography.bodySmall.copyWith(
                    color: isIncome ? _incomeColor : _spendingColor,
                  ),
                ),
                TextSpan(
                  text: '${_fmt(amount)} ${context.l10n.currencySymbol}',
                  style: AppTypography.labelMedium.copyWith(color: AppColors.textPrimary),
                ),
              ],
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (value, _) {
              final i = value.toInt();
              if (i < 0 || i >= pts.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _monthName(pts[i].month.month),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            getTitlesWidget: (value, _) {
              if (value == 0) return const SizedBox.shrink();
              return Text(
                _fmt(value.toInt()),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: AppColors.border, strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(pts.length, (i) {
        final pt = pts[i];
        return BarChartGroupData(
          x: i,
          groupVertically: false,
          barRods: [
            BarChartRodData(
              toY: pt.income.toDouble(),
              color: _touchedGroupIndex == i && _touchedRodIndex == 0
                  ? _incomeColor
                  : _incomeColor.withValues(alpha: 0.75),
              width: 14,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
            ),
            BarChartRodData(
              toY: pt.spending.toDouble(),
              color: _touchedGroupIndex == i && _touchedRodIndex == 1
                  ? _spendingColor
                  : _spendingColor.withValues(alpha: 0.75),
              width: 14,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
            ),
          ],
        );
      }),
    );
  }

  String _fmt(int amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}م';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)}k';
    return amount.toString();
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
