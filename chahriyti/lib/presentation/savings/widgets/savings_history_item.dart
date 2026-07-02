import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/savings_history_entity.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class SavingsHistoryItem extends StatelessWidget {
  final SavingsHistoryEntity record;

  const SavingsHistoryItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final isDeposit = record.type == SavingsTransactionType.deposit;
    final color = isDeposit ? AppColors.positive : AppColors.negative;
    final icon = isDeposit
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.description,
                  style: AppTypography.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(record.createdAt),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          MoneyText(
            amount: Money(record.amount),
            style: AppTypography.labelLarge,
            color: color,
            showSign: true,
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const arabicMonths = [
      'جانفي', 'فيفري', 'مارس', 'أفريل', 'ماي', 'جوان',
      'جويلية', 'أوت', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return '${date.day} ${arabicMonths[date.month - 1]} ${date.year}';
  }
}
