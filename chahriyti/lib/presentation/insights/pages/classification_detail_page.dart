import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/classification_badge.dart';
import '../cubits/insights_cubit.dart';

class ClassificationDetailPage extends StatelessWidget {
  final int cycleId;

  const ClassificationDetailPage({
    required this.cycleId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InsightsCubit(
        calculateFinancialClassificationUseCase:
            Injection.calculateFinancialClassificationUseCase,
      )..loadClassification(cycleId),
      child: const _ClassificationDetailView(),
    );
  }
}

class _ClassificationDetailView extends StatelessWidget {
  const _ClassificationDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.classificationTitle,
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

          if (state is ClassificationLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClassificationBadge(
                    classification: state.classification,
                    savingsRate: state.savingsRate,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.classificationExplanationTitle,
                    style: AppTypography.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  _buildExplanation(context, state.classification),
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.classificationImprovementTitle,
                    style: AppTypography.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  _buildImprovement(context, state.classification),
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.classificationStatsTitle,
                    style: AppTypography.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  _buildStats(context, state),
                  const SizedBox(height: 32),
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

  Widget _buildExplanation(BuildContext context, classification) {
    final l = context.l10n;
    String explanation;
    switch (classification) {
      case 'legendarySaver':
        explanation = l.explanationLegendary;
        break;
      case 'smartSaver':
        explanation = l.explanationSmart;
        break;
      case 'balanced':
        explanation = l.explanationBalanced;
        break;
      case 'spendthrift':
        explanation = l.explanationSpendthrift;
        break;
      case 'danger':
        explanation = l.explanationDanger;
        break;
      case 'earlyBankruptcy':
        explanation = l.explanationEarlyBankruptcy;
        break;
      default:
        explanation = '';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        explanation,
        style: AppTypography.bodyMedium,
      ),
    );
  }

  Widget _buildImprovement(BuildContext context, classification) {
    final l = context.l10n;
    String? suggestion;
    List<String> tips = [];

    switch (classification) {
      case 'legendarySaver':
        suggestion = l.suggestionLegendary;
        tips = [l.tipInvestSurplus, l.tipHelpOthers, l.tipShareExperience];
        break;
      case 'smartSaver':
        suggestion = l.suggestionSmart;
        tips = [l.tipReduceOptional, l.tipFindExtraIncome, l.tipTrackWeekly];
        break;
      case 'balanced':
        suggestion = l.suggestionBalanced;
        tips = [l.tipWatchExcess, l.tipPlanEmergency, l.tipSetClearGoals];
        break;
      case 'spendthrift':
        suggestion = l.suggestionSpendthrift;
        tips = [l.tipListBeforeShopping, l.tipAvoidImpulse, l.tipSetDailyBudget];
        break;
      case 'danger':
        suggestion = l.suggestionDanger;
        tips = [l.tipStopUnnecessary, l.tipReviewDaily, l.tipSeekHelp];
        break;
      case 'earlyBankruptcy':
        suggestion = l.suggestionEarlyBankruptcy;
        tips = [l.tipEssentialOnly, l.tipFindExtraIncome2, l.tipRestructureBudget];
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion ?? '',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.positive,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context, ClassificationLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                context.l10n.savingsRateLabel,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${state.savingsRate.toStringAsFixed(1)}%',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
