import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ValuePropositionPage extends StatefulWidget {
  const ValuePropositionPage({super.key});

  @override
  State<ValuePropositionPage> createState() => _ValuePropositionPageState();
}

class _ValuePropositionPageState extends State<ValuePropositionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _benefits = [
    'ستعرف رصيدك الحقيقي في أي لحظة',
    'ستسجل مصاريفك بسهولة ودون تعقيد',
    'ستكتشف أين يذهب راتبك فعليًا',
    'ستراقب تقدم أهدافك المالية خطوة بخطوة',
    'ستتابع ديونك وسلفك دون نسيان',
    'ستحدد سقفًا يوميًا آمنًا للمصاريف',
    'ستبني مدخراتك بشكل تدريجي ومنظم',
    'ستسجل مصادر دخلك الإضافية',
    'ستتابع إحصائياتك المالية بوضوح',
    'ستتخذ قرارات مالية مبنية على أرقام حقيقية لا على التخمين',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                children: [
                  // Title
                  Text(
                    'من الآن فصاعدًا...',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Benefits list with staggered animation
                  ...List.generate(_benefits.length, (index) {
                    final delay = index / (_benefits.length + 2);
                    final end = delay + (2 / (_benefits.length + 2));
                    final animation = CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        delay.clamp(0.0, 1.0),
                        end.clamp(0.0, 1.0),
                        curve: Curves.easeOut,
                      ),
                    );
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.15, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: _BenefitItem(text: _benefits[index]),
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  // Motivational quote
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Text(
                        '"الأرقام التي لا تُقاس لا يمكن تحسينها."',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          height: 1.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/onboarding/cta'),
                  child: const Text('متابعة'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final String text;

  const _BenefitItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.positive.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 18,
              color: AppColors.positive,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: AppTypography.bodyLarge.copyWith(
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
