import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theme/app_colors.dart';

class OnboardingPageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    this.pageCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSmoothIndicator(
      activeIndex: currentPage,
      count: pageCount,
      effect: const WormEffect(
        dotWidth: 8,
        dotHeight: 8,
        spacing: 8,
        activeDotColor: AppColors.primary,
        dotColor: AppColors.border,
      ),
    );
  }
}
