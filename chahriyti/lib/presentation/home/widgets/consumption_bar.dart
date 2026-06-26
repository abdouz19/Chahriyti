import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ConsumptionBar extends StatelessWidget {
  final double consumptionPercent;

  const ConsumptionBar({super.key, required this.consumptionPercent});

  Color get _barColor {
    if (consumptionPercent < 50) return AppColors.consumptionLow;
    if (consumptionPercent <= 75) return AppColors.consumptionMid;
    return AppColors.consumptionHigh;
  }

  @override
  Widget build(BuildContext context) {
    final clampedPercent = consumptionPercent.clamp(0.0, 100.0);
    final fraction = clampedPercent / 100.0;

    return RepaintBoundary(
      child: Card(
        color: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'نسبة الاستهلاك',
                    style: AppTypography.labelSmall,
                  ),
                  Text(
                    '${clampedPercent.toStringAsFixed(0)}%',
                    style: AppTypography.labelMedium.copyWith(
                      color: _barColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 12,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: FractionallySizedBox(
                          widthFactor: fraction,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _barColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
