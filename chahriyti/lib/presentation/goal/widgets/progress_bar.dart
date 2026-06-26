import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class GoalProgressBar extends StatelessWidget {
  final int targetAmount; // in centimes
  final double progressPercent;
  final double height;
  final Color backgroundColor;
  final Color progressColor;

  const GoalProgressBar({
    required this.targetAmount,
    this.progressPercent = 0,
    this.height = 8,
    this.backgroundColor = AppColors.border,
    this.progressColor = AppColors.primary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progressPercent / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RepaintBoundary(
          child: ClipRoundedRect(
            child: LinearProgressIndicator(
              value: percent,
              minHeight: height,
              backgroundColor: backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${progressPercent.toStringAsFixed(1)}%',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class ClipRoundedRect extends StatelessWidget {
  final Widget child;

  const ClipRoundedRect({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: child,
    );
  }
}
