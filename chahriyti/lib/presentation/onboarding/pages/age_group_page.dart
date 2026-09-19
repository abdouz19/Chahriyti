import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/onboarding_cubit.dart';
import '../widgets/onboarding_progress_dots.dart';
import '../widgets/selection_card.dart';

class AgeGroupPage extends StatefulWidget {
  const AgeGroupPage({super.key});

  @override
  State<AgeGroupPage> createState() => _AgeGroupPageState();
}

class _AgeGroupPageState extends State<AgeGroupPage>
    with SingleTickerProviderStateMixin {
  String? _selectedAge;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const _ageOptions = [
    'من 20 إلى 30 سنة',
    'من 31 إلى 40 سنة',
    'من 41 إلى 50 سنة',
    'أكثر من 50 سنة',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingFinancial) {
          context.go('/onboarding/financial');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const OnboardingProgressDots(currentStep: 2),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        Text(
                          'قليل يعرفون أين يذهب مالهم.',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'اليوم بدأت خطوة مختلفة.',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'في أي فئة عمرية تقع؟',
                            style: AppTypography.labelLarge,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(_ageOptions.length, (i) {
                          final option = _ageOptions[i];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: i < _ageOptions.length - 1 ? 8 : 0,
                            ),
                            child: SelectionCard(
                              label: option,
                              selected: _selectedAge == option,
                              isCheckbox: false,
                              onTap: () =>
                                  setState(() => _selectedAge = option),
                            ),
                          );
                        }),
                        const SizedBox(height: 24),
                      ],
                    ),
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
                        .submitAgeGroup(_selectedAge),
                    child: const Text('ابدأ الآن'),
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
