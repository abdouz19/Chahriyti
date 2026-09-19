import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class OnboardingExclusivePage extends StatefulWidget {
  const OnboardingExclusivePage({super.key});

  @override
  State<OnboardingExclusivePage> createState() =>
      _OnboardingExclusivePageState();
}

class _OnboardingExclusivePageState extends State<OnboardingExclusivePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Skip button top right
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                  child: TextButton(
                    onPressed: () => context.go('/onboarding/value'),
                    child: Text(
                      'تخطي',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              // Icon
              Icon(
                Icons.star_rounded,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              // Heading
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'أنت الآن ضمن القلة',
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Three statements
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      'معظم الناس يؤجلون تنظيم أموالهم إلى الشهر القادم.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ثم إلى الشهر الذي بعده.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ثم تمر سنوات دون تغيير.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Highlighted closing
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    'تحميلك لهذا التطبيق يعني أنك قررت أن تبدأ اليوم.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
              // CTA button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/onboarding/value'),
                    child: const Text('متابعة'),
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
