import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/categories.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CategoryBreakdownChart extends StatelessWidget {
  final Map<String, double> breakdown;

  static const Map<String, Color> _categoryColors = {
    'essentials': Color(0xFF3B82F6),
    'homeFamily': Color(0xFF8B5CF6),
    'luxuries': Color(0xFFF59E0B),
    'other': Color(0xFF6B7280),
  };

  const CategoryBreakdownChart({
    super.key,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    if (breakdown.isEmpty) {
      return _buildEmptyState();
    }

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
            'توزيع المصاريف',
            style: AppTypography.headlineSmall,
          ),
          const SizedBox(height: 20),
          Center(
            child: RepaintBoundary(
              child: SizedBox(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter: _DonutChartPainter(
                    data: _buildChartData(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            'توزيع المصاريف',
            style: AppTypography.headlineSmall,
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد مصاريف بعد',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<_ChartSegment> _buildChartData() {
    return breakdown.entries.map((entry) {
      final color = _categoryColors[entry.key] ?? const Color(0xFF6B7280);
      final label = _getArabicLabel(entry.key);
      return _ChartSegment(
        category: entry.key,
        percentage: entry.value,
        color: color,
        label: label,
      );
    }).toList();
  }

  Widget _buildLegend() {
    final segments = _buildChartData();
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: segments.map((segment) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: segment.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${segment.label} ${segment.percentage.toStringAsFixed(1)}%',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _getArabicLabel(String categoryKey) {
    for (final category in ExpenseCategory.values) {
      if (category.name == categoryKey) {
        return category.arabicLabel;
      }
    }
    return categoryKey;
  }
}

class _ChartSegment {
  final String category;
  final double percentage;
  final Color color;
  final String label;

  const _ChartSegment({
    required this.category,
    required this.percentage,
    required this.color,
    required this.label,
  });
}

class _DonutChartPainter extends CustomPainter {
  final List<_ChartSegment> data;

  _DonutChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.35;
    final drawRadius = radius - strokeWidth / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Start from top (-90 degrees)
    var startAngle = -math.pi / 2;

    for (final segment in data) {
      final sweepAngle = (segment.percentage / 100) * 2 * math.pi;

      paint.color = segment.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: drawRadius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      // Draw percentage label at the midpoint of the arc
      if (segment.percentage >= 5) {
        final midAngle = startAngle + sweepAngle / 2;
        final labelRadius = radius + 2;
        final labelX = center.dx + labelRadius * math.cos(midAngle);
        final labelY = center.dy + labelRadius * math.sin(midAngle);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '${segment.percentage.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(
            labelX - textPainter.width / 2,
            labelY - textPainter.height / 2,
          ),
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
