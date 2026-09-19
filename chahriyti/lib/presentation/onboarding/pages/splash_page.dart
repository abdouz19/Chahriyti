import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _bodyOpacity;
  late final Animation<double> _boldOpacity;
  late final Animation<double> _buttonOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.55, curve: Curves.easeOut),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.55, curve: Curves.easeIn),
      ),
    );

    _bodyOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.7, curve: Curves.easeIn),
      ),
    );

    _boldOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.8, curve: Curves.easeIn),
      ),
    );

    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              FadeTransition(
                opacity: _logoOpacity,
                child: Image.asset(
                  'assets/icons/CHAHRIYTI 512.png',
                  width: 110,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              SlideTransition(
                position: _titleSlide,
                child: FadeTransition(
                  opacity: _titleOpacity,
                  child: Text(
                    'أهلاً بك في شهريتي',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColors.primary,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _bodyOpacity,
                child: Text(
                  'أغلب الناس يعرفون كم يقبضون... لكن القليل فقط يعرفون أين يذهب مالهم.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.8,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FadeTransition(
                opacity: _boldOpacity,
                child: Text(
                  'اليوم بدأت خطوة مختلفة.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              FadeTransition(
                opacity: _buttonOpacity,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/onboarding/exclusive'),
                    child: const Text('ابدأ الآن'),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
