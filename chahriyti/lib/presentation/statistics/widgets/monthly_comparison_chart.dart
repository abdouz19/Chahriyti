import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_monthly_comparison_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class MonthlyComparisonChart extends StatefulWidget {
  final List<MonthlyComparison> comparisons;

  const MonthlyComparisonChart({super.key, required this.comparisons});

  @override
  State<MonthlyComparisonChart> createState() => _MonthlyComparisonChartState();
}

class _MonthlyComparisonChartState extends State<MonthlyComparisonChart> {
  int _touchedIndex = -1;

  static const _arabicMonths = [
    'جانفي', 'فيفري', 'مارس', 'أفريل', 'ماي', 'جوان',
    'جويلية', 'أوت', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

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
          Text('مقارنة الأشهر', style: AppTypography.headlineSmall),
          const SizedBox(height: 20),
          if (widget.comparisons.length < 2)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'بيانات غير كافية للمقارنة',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            SizedBox(
              height: 220,
              child: BarChart(_buildChartData()),
            ),
        ],
      ),
    );
  }

  BarChartData _buildChartData() {
    final comps = widget.comparisons;
    final maxY = comps
            .map((c) => c.totalSpending.toDouble())
            .reduce((a, b) => a > b ? a : b) *
        1.25;

    return BarChartData(
      maxY: maxY,
      barTouchData: BarTouchData(
        touchCallback: (event, response) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.spot == null) {
              _touchedIndex = -1;
              return;
            }
            _touchedIndex = response.spot!.touchedBarGroupIndex;
          });
        },
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => AppColors.card,
          tooltipBorder: BorderSide(color: AppColors.border),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final amount = rod.toY.toInt();
            final month = comps[groupIndex].month;
            return BarTooltipItem(
              '${_arabicMonths[month.month - 1]}\n',
              AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              children: [
                TextSpan(
                  text: '${_formatAmount(amount)} دج',
                  style: AppTypography.labelMedium
                      .copyWith(color: AppColors.textPrimary),
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
              if (i < 0 || i >= comps.length) return const SizedBox.shrink();
              final month = comps[i].month;
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _arabicMonths[month.month - 1],
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
                _formatAmount(value.toInt()),
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
      barGroups: List.generate(comps.length, (i) {
        final isTouched = i == _touchedIndex;
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: comps[i].totalSpending.toDouble(),
              color: isTouched
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.7),
              width: 22,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ],
        );
      }),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}م';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)}k';
    return amount.toString();
  }
}
