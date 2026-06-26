import 'package:flutter/material.dart';

import '../../../application/use_cases/insights/calculate_financial_classification_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ClassificationBadge extends StatelessWidget {
  final FinancialClassification classification;
  final double savingsRate;

  const ClassificationBadge({
    required this.classification,
    required this.savingsRate,
    super.key,
  });

  IconData _getIcon() {
    switch (classification) {
      case FinancialClassification.legendarySaver:
        return Icons.star_rounded;
      case FinancialClassification.smartSaver:
        return Icons.lightbulb_rounded;
      case FinancialClassification.balanced:
        return Icons.balance_rounded;
      case FinancialClassification.spendthrift:
        return Icons.local_offer_rounded;
      case FinancialClassification.danger:
        return Icons.warning_rounded;
      case FinancialClassification.earlyBankruptcy:
        return Icons.dangerous_rounded;
    }
  }

  Color _getColor() {
    switch (classification) {
      case FinancialClassification.legendarySaver:
        return const Color(0xFF6366F1); // Indigo
      case FinancialClassification.smartSaver:
        return const Color(0xFF10B981); // Emerald
      case FinancialClassification.balanced:
        return const Color(0xFF3B82F6); // Blue
      case FinancialClassification.spendthrift:
        return const Color(0xFFF59E0B); // Amber
      case FinancialClassification.danger:
        return const Color(0xFFF97316); // Orange
      case FinancialClassification.earlyBankruptcy:
        return const Color(0xFFEF4444); // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIcon(),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classification.name,
                      style: AppTypography.headlineSmall.copyWith(
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'معدل الادخار: ${savingsRate.toStringAsFixed(1)}%',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              classification.suggestion,
              style: AppTypography.bodySmall.copyWith(
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
