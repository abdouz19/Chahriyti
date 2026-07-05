import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_spending_trend_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SpendingTrendChart extends StatelessWidget {
  final SpendingTrend trend;

  const SpendingTrendChart({super.key, required this.trend});

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
          Text('مسار الإنفاق', style: AppTypography.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'الإنفاق التراكمي مقارنة بالميزانية',
            style:
                AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          if (trend.points.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'لا توجد بيانات بعد',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: LineChart(_buildChartData()),
            ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  LineChartData _buildChartData() {
    final budget = trend.budget;
    final totalDays = trend.totalDays.toDouble();
    final maxY = (budget * 1.1).ceilToDouble();

    final actualSpots = trend.points
        .map((p) => FlSpot(p.dayIndex.toDouble(), p.cumulative))
        .toList();

    // Budget ceiling: flat line from day 1 to last day of cycle
    final budgetSpots = [
      FlSpot(1, budget),
      FlSpot(totalDays, budget),
    ];

    final lastCumulative =
        trend.points.isNotEmpty ? trend.points.last.cumulative : 0.0;
    final isOverBudget = lastCumulative > budget;
    final actualColor =
        isOverBudget ? AppColors.negative : AppColors.primary;

    return LineChartData(
      minX: 1,
      maxX: totalDays,
      minY: 0,
      maxY: maxY,
      clipData: const FlClipData.all(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: budget / 4,
        getDrawingHorizontalLine: (_) => FlLine(
          color: AppColors.border,
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            interval: budget / 4,
            getTitlesWidget: (value, _) {
              if (value == 0) return const SizedBox.shrink();
              final k = (value / 1000).toStringAsFixed(0);
              return Text(
                '${k}k',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary, fontSize: 10),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: (totalDays / 4).ceilToDouble(),
            getTitlesWidget: (value, _) {
              return Text(
                'ي${value.toInt()}',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary, fontSize: 10),
              );
            },
          ),
        ),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineBarsData: [
        // Actual cumulative spending
        LineChartBarData(
          spots: actualSpots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: actualColor,
          barWidth: 3,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: actualColor.withValues(alpha: 0.08),
          ),
        ),
        // Budget ceiling
        LineChartBarData(
          spots: budgetSpots,
          isCurved: false,
          color: AppColors.negative.withValues(alpha: 0.5),
          barWidth: 1.5,
          dashArray: [8, 4],
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppColors.card,
          getTooltipItems: (spots) {
            return spots.map((spot) {
              if (spot.barIndex == 1) return null; // skip budget line tooltip
              final amount = spot.y.toInt();
              return LineTooltipItem(
                'يوم ${spot.x.toInt()}\n${_formatAmount(amount)} دج',
                AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}م';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}k';
    }
    return amount.toString();
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _legendDot(AppColors.primary),
        const SizedBox(width: 6),
        Text('الإنفاق الفعلي',
            style:
                AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
        const SizedBox(width: 20),
        _legendLine(AppColors.negative.withValues(alpha: 0.5)),
        const SizedBox(width: 6),
        Text('سقف الميزانية',
            style:
                AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _legendDot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  Widget _legendLine(Color color) => Container(
        width: 20,
        height: 2,
        color: color,
      );
}
