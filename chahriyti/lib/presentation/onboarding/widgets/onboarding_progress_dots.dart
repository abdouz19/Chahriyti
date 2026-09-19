import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class OnboardingProgressDots extends StatelessWidget {
  final int currentStep; // 1-4
  const OnboardingProgressDots({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index < currentStep;
        return Padding(
          padding: EdgeInsets.only(right: index < 3 ? 8.0 : 0.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.primary : Colors.transparent,
              border: isActive
                  ? null
                  : Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
            ),
          ),
        );
      }),
    );
  }
}
