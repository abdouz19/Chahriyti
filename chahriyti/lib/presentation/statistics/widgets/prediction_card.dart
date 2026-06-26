import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_predictions_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class PredictionCard extends StatelessWidget {
  final PredictionResult prediction;

  const PredictionCard({
    super.key,
    required this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    final isSurplus = prediction.predictedEndBalance >= 0;
    final hasDepletion = prediction.depletionDate != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSurplus
              ? AppColors.positive.withValues(alpha: 0.3)
              : AppColors.negative.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSurplus ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                color: isSurplus ? AppColors.positive : AppColors.negative,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'التوقعات المالية',
                style: AppTypography.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Daily spending rate
          Row(
            children: [
              Text(
                'معدل الإنفاق اليومي: ',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              MoneyText(
                amount: Money.fromDZD(prediction.currentDailyRate),
                style: AppTypography.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Predicted end balance
          Row(
            children: [
              Text(
                'الرصيد المتوقع نهاية الدورة: ',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              MoneyText(
                amount: Money.fromDZD(prediction.predictedEndBalance),
                style: AppTypography.labelMedium,
                color: isSurplus ? AppColors.positive : AppColors.negative,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Status message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSurplus
                  ? AppColors.positive.withValues(alpha: 0.08)
                  : AppColors.negative.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  hasDepletion ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                  color: isSurplus ? AppColors.positive : AppColors.negative,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _statusMessage,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSurplus ? AppColors.positive : AppColors.negative,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _statusMessage {
    if (prediction.depletionDate != null) {
      final date = prediction.depletionDate!;
      final formatted = '${date.day}/${date.month}/${date.year}';
      return 'تحذير: قد ينفد رصيدك في $formatted';
    }

    final surplus = Money.fromDZD(prediction.predictedEndBalance);
    return 'مسارك ممتاز! ستتبقى لك ${surplus.formatDZD()}';
  }
}
