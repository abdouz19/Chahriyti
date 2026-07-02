import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/lending_entity.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';

class LendingSummaryCard extends StatelessWidget {
  final List<LendingEntity> lendings;
  final VoidCallback? onViewAll;

  const LendingSummaryCard({super.key, required this.lendings, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...lendings.take(3).map((lending) => _LendingItem(lending: lending)),
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

class _LendingItem extends StatelessWidget {
  final LendingEntity lending;

  const _LendingItem({required this.lending});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              lending.borrowerName,
              style: AppTypography.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MoneyText(
            amount: Money(lending.remainingAmount),
            style: AppTypography.amountSmall,
            color: AppColors.negative,
          ),
        ],
      ),
    );
  }
}
