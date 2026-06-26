import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/classification_badge.dart';
import '../cubits/insights_cubit.dart';
import '../widgets/leak_card.dart';
import '../widgets/trend_card.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InsightsCubit(
        calculateFinancialClassificationUseCase:
            Injection.calculateFinancialClassificationUseCase,
      )..loadInsights(),
      child: const _InsightsView(),
    );
  }
}

class _InsightsView extends StatelessWidget {
  const _InsightsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'البصائر المالية',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: BlocBuilder<InsightsCubit, InsightsState>(
        builder: (context, state) {
          if (state is InsightsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is InsightsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Classification section
                  ClassificationBadge(
                    classification: state.classification,
                    savingsRate: state.savingsRate,
                  ),
                  const SizedBox(height: 24),
                  // Leaks section
                  if (state.leaks.isNotEmpty) ...[
                    Text(
                      'التسربات المالية',
                      style: AppTypography.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    ...state.leaks.map(
                      (leak) => LeakCard(leak: leak),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Trends section
                  if (state.trends.isNotEmpty) ...[
                    Text(
                      'الاتجاهات الشهرية',
                      style: AppTypography.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    ...state.trends.map(
                      (trend) => TrendCard(trend: trend),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Empty state
                  if (state.leaks.isEmpty && state.trends.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.insights_rounded,
                              size: 64,
                              color: AppColors.primary.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد بصائر حالياً',
                              style: AppTypography.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'سيتم عرض التسربات والاتجاهات عند توفر بيانات كافية',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          if (state is InsightsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
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
