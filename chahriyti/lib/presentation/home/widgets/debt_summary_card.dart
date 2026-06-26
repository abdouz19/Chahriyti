import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class DebtSummaryCard extends StatelessWidget {
  final List<DebtEntity> debts;

  const DebtSummaryCard({super.key, required this.debts});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.negative,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'الديون',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.negative,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (debts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'لا توجد ديون مسجلة',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              ...debts.take(3).map((debt) => _DebtItem(debt: debt)),
          ],
        ),
      ),
    );
  }
}

class _DebtItem extends StatelessWidget {
  final DebtEntity debt;

  const _DebtItem({required this.debt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              debt.creditorName,
              style: AppTypography.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MoneyText(
            amount: Money.fromDZD(debt.remainingAmount),
            style: AppTypography.amountSmall,
            color: AppColors.negative,
          ),
        ],
      ),
    );
  }
}
