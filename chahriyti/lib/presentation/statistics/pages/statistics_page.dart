import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/statistics/get_category_breakdown_use_case.dart';
import '../../../application/use_cases/statistics/get_predictions_use_case.dart';
import '../../../application/use_cases/statistics/get_monthly_comparison_use_case.dart';
import '../../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../../application/use_cases/statistics/detect_financial_leaks_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../cubits/statistics_cubit.dart';
import '../widgets/category_breakdown_chart.dart';
import '../widgets/classification_badge.dart';
import '../widgets/financial_leak_card.dart';
import '../widgets/monthly_comparison_chart.dart';
import '../widgets/prediction_card.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatisticsCubit(
        getCategoryBreakdown: GetCategoryBreakdownUseCase(
          expenseRepository: Injection.expenseRepository,
        ),
        getPredictions: GetPredictionsUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
        ),
        getMonthlyComparison: GetMonthlyComparisonUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
        ),
        getFinancialClassification: GetFinancialClassificationUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
        ),
        detectFinancialLeaks: DetectFinancialLeaksUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
        ),
        cycleRepository: Injection.cycleRepository,
      )..loadStatistics(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'الإحصائيات',
            style: AppTypography.headlineSmall.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoading) {
              return _buildLoadingState();
            }

            if (state is StatisticsError) {
              return _buildErrorState(context, state.message);
            }

            if (state is StatisticsLoaded) {
              return _buildLoadedState(context, state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const LoadingShimmer(height: 160),
          const SizedBox(height: 16),
          const LoadingShimmer(height: 260),
          const SizedBox(height: 16),
          const LoadingShimmer(height: 140),
          const SizedBox(height: 16),
          const LoadingShimmer(height: 180),
          const SizedBox(height: 16),
          const LoadingShimmer(height: 240),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.negative,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  context.read<StatisticsCubit>().loadStatistics(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, StatisticsLoaded state) {
    return RefreshIndicator(
      onRefresh: () => context.read<StatisticsCubit>().refresh(),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Financial Classification Badge
            if (state.financialTier != null) ...[
              ClassificationBadge(tier: state.financialTier!),
              const SizedBox(height: 16),
            ],

            // Category Breakdown Chart
            CategoryBreakdownChart(breakdown: state.categoryBreakdown),
            const SizedBox(height: 16),

            // Financial Leaks (if any)
            if (state.financialLeaks.isNotEmpty) ...[
              Text(
                'تسريبات مالية',
                style: AppTypography.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'فئات تستهلك ميزانيتك بشكل ملحوظ',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: 12),
              ...state.financialLeaks.map(
                (leak) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FinancialLeakCard(leak: leak),
                ),
              ),
              const SizedBox(height: 6),
            ],

            // Prediction Card
            if (state.prediction != null) ...[
              PredictionCard(prediction: state.prediction!),
              const SizedBox(height: 16),
            ],

            // Monthly Comparison Chart
            MonthlyComparisonChart(comparisons: state.monthlyComparison),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
