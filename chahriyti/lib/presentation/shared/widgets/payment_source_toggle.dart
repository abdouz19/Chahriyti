import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import 'money_text.dart';

class PaymentSourceToggle extends StatelessWidget {
  final int currentBalance;
  final int savingsBalance;
  final bool fromSavings;
  final ValueChanged<bool> onChanged;

  const PaymentSourceToggle({
    super.key,
    required this.currentBalance,
    required this.savingsBalance,
    required this.fromSavings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (savingsBalance <= 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ادفع من',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _SourceOption(
                label: 'الرصيد الحالي',
                amount: currentBalance,
                isSelected: !fromSavings,
                onTap: () => onChanged(false),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SourceOption(
                label: 'المدخرات',
                amount: savingsBalance,
                isSelected: fromSavings,
                onTap: () => onChanged(true),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SourceOption extends StatelessWidget {
  final String label;
  final int amount;
  final bool isSelected;
  final VoidCallback onTap;

  const _SourceOption({
    required this.label,
    required this.amount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            MoneyText(
              amount: Money(amount),
              style: AppTypography.bodySmall,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
