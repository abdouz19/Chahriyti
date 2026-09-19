import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../application/use_cases/statistics/get_savings_balance_history_use_case.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SavingsBalanceHistoryChart extends StatelessWidget {
  final List<SavingsBalancePoint> points;

  const SavingsBalanceHistoryChart({super.key, required this.points});

  static const _lineColor = Color(0xFF10B981); // green — savings

  String _monthLabel(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('MMM', locale).format(date);
  }

  String _fmt(int amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}م';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)}k';
    return amount.toString();
  }

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
          Row(
            children: [
              Icon(Icons.show_chart_rounded, size: 18, color: _lineColor),
              const SizedBox(width: 8),
              Text(context.l10n.savingsHistoryTitle, style: AppTypography.headlineSmall),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.savingsHistorySubtitle,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          if (points.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  context.l10n.insufficientDataForComparison,
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: LineChart(_buildChartData(context)),
            ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(BuildContext context) {
    final symbol = context.l10n.currencySymbol;
    final maxBalance = points.map((p) => p.balance).reduce((a, b) => a > b ? a : b);
    final maxY = (maxBalance * 1.2).ceilToDouble();
    final safeMaxY = maxY <= 0 ? 1000.0 : maxY;

    final spots = List.generate(
      points.length,
      (i) => FlSpot(i.toDouble(), points[i].balance.toDouble()),
    );

    return LineChartData(
      minX: 0,
      maxX: (points.length - 1).toDouble(),
      minY: 0,
      maxY: safeMaxY,
      clipData: const FlClipData.all(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (value, _) {
              final i = value.toInt();
              if (i < 0 || i >= points.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _monthLabel(points[i].month, context),
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
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: _lineColor,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, pct, bar, index) {
              final isActive = points[index].isActive;
              return FlDotCirclePainter(
                radius: isActive ? 5 : 3,
                color: isActive ? _lineColor : AppColors.card,
                strokeWidth: 2,
                strokeColor: _lineColor,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _lineColor.withValues(alpha: 0.20),
                _lineColor.withValues(alpha: 0.01),
              ],
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppColors.card,
          tooltipBorder: BorderSide(color: AppColors.border),
          getTooltipItems: (spots) => spots.map((spot) {
            final i = spot.x.toInt();
            if (i < 0 || i >= points.length) return null;
            final pt = points[i];
            return LineTooltipItem(
              '${_monthLabel(pt.month, context)}\n',
              AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              children: [
                TextSpan(
                  text: '${_fmt(pt.balance)} $symbol',
                  style: AppTypography.labelMedium.copyWith(
                    color: _lineColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
