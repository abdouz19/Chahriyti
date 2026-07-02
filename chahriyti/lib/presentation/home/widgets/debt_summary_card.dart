import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class DebtSummaryCard extends StatelessWidget {
  final List<DebtEntity> debts;
  final VoidCallback? onViewAll;

  const DebtSummaryCard({super.key, required this.debts, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...debts.take(3).map((debt) => _DebtItem(debt: debt)),
        Divider(height: 16, color: AppColors.divider),
        GestureDetector(
          onTap: onViewAll,
          child: Center(
            child: Text(
              'عرض الكل',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
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
            amount: Money(debt.remainingAmount),
            style: AppTypography.amountSmall,
            color: AppColors.negative,
          ),
        ],
      ),
    );
  }
}
