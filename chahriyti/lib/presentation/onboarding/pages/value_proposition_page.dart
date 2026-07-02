import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
    'تتبع مصاريفك اليومية بسهولة',
    'معرفة رصيدك المتبقي في أي لحظة',
    'حساب المبلغ الآمن للصرف يومياً',
    'إحصائيات ذكية لعاداتك المالية',
    'تحديات أسبوعية لتوفير أكثر',
    'إدارة ديونك وأهدافك الادخارية',
    'تنبيهات ذكية قبل نفاد الرصيد',
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
      appBar: AppBar(
        title: const Text('مزايا شهريتي'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 8),
                  // Lottie animation
                  Center(
                    child: Lottie.asset(
                      'assets/animations/features.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Text(
                    'ماذا ستستفيد من شهريتي؟',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.primary,
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
                        '"المال الذي لا تديره، يديرك"',
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
                  onPressed: () => context.go('/onboarding/salary'),
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
