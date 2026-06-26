import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_monthly_comparison_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';

class MonthlyComparisonChart extends StatelessWidget {
  final List<MonthlyComparison> comparisons;

  const MonthlyComparisonChart({
    super.key,
    required this.comparisons,
  });

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
          Text(
            'مقارنة الأشهر',
            style: AppTypography.headlineSmall,
          ),
          const SizedBox(height: 20),
          if (comparisons.length < 2)
            _buildEmptyState()
          else
            _buildChart(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'بيانات غير كافية للمقارنة',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    return RepaintBoundary(
      child: SizedBox(
        height: 200,
        child: CustomPaint(
          size: const Size(double.infinity, 200),
          painter: _BarChartPainter(
            comparisons: comparisons,
          ),
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<MonthlyComparison> comparisons;

  static const List<String> _arabicMonths = [
    'جانفي',
    'فيفري',
    'مارس',
    'أفريل',
    'ماي',
    'جوان',
    'جويلية',
    'أوت',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  _BarChartPainter({required this.comparisons});

  @override
  void paint(Canvas canvas, Size size) {
    if (comparisons.isEmpty) return;

    final maxSpending = comparisons
        .map((c) => c.totalSpending)
        .reduce((a, b) => math.max(a, b));

    if (maxSpending == 0) return;

    const bottomPadding = 40.0;
    const topPadding = 20.0;
    final chartHeight = size.height - bottomPadding - topPadding;
    final barCount = comparisons.length;
    final barWidth = (size.width / barCount) * 0.5;
    final spacing = (size.width - barWidth * barCount) / (barCount + 1);

    final barPaint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < barCount; i++) {
      final comparison = comparisons[i];
      final barHeight =
          (comparison.totalSpending / maxSpending) * chartHeight;

      final x = spacing + i * (barWidth + spacing);
      final y = topPadding + chartHeight - barHeight;

      // Bar gradient effect via solid color
      barPaint.color = AppColors.primary;

      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(6),
      );
      canvas.drawRRect(barRect, barPaint);

      // Amount label above bar
      final amount = Money(comparison.totalSpending);
      final amountText = TextPainter(
        text: TextSpan(
          text: amount.formatDZD(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout();

      amountText.paint(
        canvas,
        Offset(
          x + barWidth / 2 - amountText.width / 2,
          y - amountText.height - 4,
        ),
      );

      // Month label below bar
      final monthIndex = comparison.month.month - 1;
      final monthLabel = _arabicMonths[monthIndex];
      final textPainter = TextPainter(
        text: TextSpan(
          text: monthLabel,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          x + barWidth / 2 - textPainter.width / 2,
          size.height - bottomPadding + 8,
        ),
      );
    }

    // Draw baseline
    final baselinePaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, topPadding + chartHeight),
      Offset(size.width, topPadding + chartHeight),
      baselinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.comparisons != comparisons;
  }
}
