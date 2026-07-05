import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_category_breakdown_use_case.dart';
import '../../../core/constants/categories.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CategoryBreakdownChart extends StatefulWidget {
  final CategoryBreakdownResult breakdown;

  const CategoryBreakdownChart({super.key, required this.breakdown});

  @override
  State<CategoryBreakdownChart> createState() => _CategoryBreakdownChartState();
}

class _CategoryBreakdownChartState extends State<CategoryBreakdownChart> {
  int _touchedIndex = -1;

  static const Map<String, Color> _categoryColors = {
    'essentials':  Color(0xFF3B82F6),
    'homeFamily':  Color(0xFF8B5CF6),
    'luxuries':    Color(0xFFF59E0B),
    'health':      Color(0xFF10B981),
    'transport':   Color(0xFF06B6D4),
    'clothing':    Color(0xFFF43F5E),
    'restaurants': Color(0xFFFF7849),
    'education':   Color(0xFF6366F1),
    'other':       Color(0xFF94A3B8),
  };

  Color _colorFor(String key) =>
      _categoryColors[key] ?? const Color(0xFF94A3B8);

  String _arabicLabel(String key) {
    for (final c in ExpenseCategory.values) {
      if (c.name == key) return c.arabicLabel;
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    final percentages = widget.breakdown.percentages;
    final amounts = widget.breakdown.amounts;
    final keys = percentages.keys.toList();

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
          Text('توزيع المصاريف', style: AppTypography.headlineSmall),
          const SizedBox(height: 20),
          if (percentages.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'لا توجد مصاريف بعد',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
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
                        _touchedIndex =
                            response.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sections: List.generate(keys.length, (i) {
                    final key = keys[i];
                    final pct = percentages[key]!;
                    final amount = amounts[key] ?? 0;
                    final isTouched = i == _touchedIndex;
                    final color = _colorFor(key);

                    return PieChartSectionData(
                      value: pct,
                      color: color,
                      radius: isTouched ? 65 : 55,
                      title: isTouched
                          ? amount.toDZDString()
                          : (pct >= 5
                              ? '${pct.toStringAsFixed(0)}%'
                              : ''),
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
            _buildLegend(keys),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend(List<String> keys) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: keys.map((key) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _colorFor(key),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              _arabicLabel(key),
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textPrimary),
            ),
          ],
        );
      }).toList(),
    );
  }
}
