import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/onboarding_cubit.dart';
import '../widgets/onboarding_progress_dots.dart';
import '../widgets/selection_card.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final Set<String> _selected = {};

  static const _goals = [
    'معرفة رصيدي الحقيقي في أي لحظة',
    'تسجيل مصاريفي بسهولة',
    'معرفة أين يذهب راتبي',
    'التخطيط لأهدافي المالية خطوة بخطوة',
    'متابعة ديوني والتزاماتي دون نسيان',
    'تحديد سقف يومي آمن للمصاريف',
    'بناء مدخراتي بشكل تدريجي ومنظم',
    'تسجيل مصادر دخلي الإضافية',
    'متابعة إحصائياتي المالية بوضوح',
    'اتخاذ قرارات مالية مبنية على أرقامي الحقيقية',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCelebration) {
          context.go('/onboarding/welcome');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const OnboardingProgressDots(currentStep: 4),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'لماذا تريد استعمال شهريتي؟',
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اختر كل ما ينطبق عليك',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      ...List.generate(_goals.length, (i) {
                        final goal = _goals[i];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: i < _goals.length - 1 ? 8 : 0,
                          ),
                          child: SelectionCard(
                            label: goal,
                            selected: _selected.contains(goal),
                            isCheckbox: true,
                            onTap: () {
                              setState(() {
                                if (_selected.contains(goal)) {
                                  _selected.remove(goal);
                                } else {
                                  _selected.add(goal);
                                }
                              });
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Bottom CTA
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context
                        .read<OnboardingCubit>()
                        .submitGoals(_selected.toList()),
                    child: const Text('التالي'),
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
