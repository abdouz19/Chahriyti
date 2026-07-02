import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/weekly_challenge_entity.dart';
import '../cubits/challenge_cubit.dart';

class ChallengeDetailPage extends StatelessWidget {
  final int challengeId;

  const ChallengeDetailPage({
    required this.challengeId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChallengeCubit(
        Injection.generateWeeklyChallengeUseCase,
        challengeRepository: Injection.challengeRepository,
        notificationService: Injection.notificationService,
      )..loadChallengeById(challengeId),
      child: const _ChallengeDetailView(),
    );
  }
}

class _ChallengeDetailView extends StatelessWidget {
  const _ChallengeDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تفاصيل التحدي',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: BlocBuilder<ChallengeCubit, ChallengeState>(
        builder: (context, state) {
          if (state is ChallengeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ChallengeDetailLoaded) {
            final challenge = state.challenge as WeeklyChallengeEntity;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Challenge description
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'وصف التحدي',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          challenge.description,
                          style: AppTypography.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Target amount
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'المبلغ المستهدف',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'دج ${challenge.targetAmount}',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Week information
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'بداية الأسبوع',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${challenge.weekStart.day}/${challenge.weekStart.month}/${challenge.weekStart.year}',
                                style: AppTypography.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: challenge.isCompleted
                                ? AppColors.positive.withValues(alpha: 0.1)
                                : AppColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: challenge.isCompleted
                                  ? AppColors.positive.withValues(alpha: 0.3)
                                  : AppColors.warning.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'الحالة',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                challenge.isCompleted ? 'مكتمل' : 'قيد التقدم',
                                style: AppTypography.labelLarge.copyWith(
                                  color: challenge.isCompleted
                                      ? AppColors.positive
                                      : AppColors.warning,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Status badge
                  if (!challenge.isCompleted)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 32,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'حاول تحقيق هذا الهدف هذا الأسبوع!',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.positive.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.positive.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.celebration_rounded,
                            size: 32,
                            color: AppColors.positive,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'رائع! لقد أكملت هذا التحدي 🎉',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.positive,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }

          if (state is ChallengeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: AppColors.negative,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
