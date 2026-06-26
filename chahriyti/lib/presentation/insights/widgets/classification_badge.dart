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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getColor().withOpacity(0.1),
            _getColor().withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getColor().withOpacity(0.3),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _getColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                _getIcon(),
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Classification Name
          Text(
            classification.name,
            style: AppTypography.headlineSmall.copyWith(
              color: _getColor(),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Savings Rate
          Text(
            '${savingsRate.toStringAsFixed(1)}% معدل الادخار',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            classification.description,
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Suggestion
          Container(
            decoration: BoxDecoration(
              color: _getColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Text(
              classification.suggestion,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (classification) {
      case FinancialClassification.legendarySaver:
        return Colors.green;
      case FinancialClassification.smartSaver:
        return Colors.blue;
      case FinancialClassification.balanced:
        return Colors.orange;
      case FinancialClassification.spendthrift:
        return Colors.amber;
      case FinancialClassification.danger:
        return Colors.red;
      case FinancialClassification.earlyBankruptcy:
        return Colors.redAccent;
    }
  }

  String _getIcon() {
    switch (classification) {
      case FinancialClassification.legendarySaver:
        return '🌟';
      case FinancialClassification.smartSaver:
        return '💡';
      case FinancialClassification.balanced:
        return '⚖️';
      case FinancialClassification.spendthrift:
        return '💸';
      case FinancialClassification.danger:
        return '⚠️';
      case FinancialClassification.earlyBankruptcy:
        return '🚨';
    }
  }
}
