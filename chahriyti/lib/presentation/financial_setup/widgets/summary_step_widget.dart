import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../../domain/entities/lending_entity.dart';
import 'setup_progress_bar.dart';

class SummaryStepWidget extends StatelessWidget {
  final int balance;
  final int savings;
  final List<DebtEntity> debts;
  final List<LendingEntity> lendings;
  final ValueChanged<int> onEditStep;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  const SummaryStepWidget({
    super.key,
    required this.balance,
    required this.savings,
    required this.debts,
    required this.lendings,
    required this.onEditStep,
    required this.onConfirm,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SetupProgressBar(currentStep: 6, totalSteps: 6),
          const SizedBox(height: 24),
          Text('ملخص وضعك المالي', style: AppTypography.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'تحقق من البيانات قبل التأكيد.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _SummaryCard(
                  icon: Icons.account_balance_wallet,
                  label: 'الرصيد',
                  value: '$balance دج',
                  valueColor: AppColors.primary,
                  onEdit: () => onEditStep(1),
                ),
                const SizedBox(height: 8),
                _SummaryCard(
                  icon: Icons.savings,
                  label: 'المدخرات',
                  value: '$savings دج',
                  valueColor: AppColors.positive,
                  onEdit: () => onEditStep(2),
                ),
                const SizedBox(height: 8),
                _SummaryListCard(
                  icon: Icons.trending_down,
                  label: 'الديون',
                  items: debts
                      .map((d) =>
                          '${d.creditorName}: ${d.totalAmount} دج${d.isSpent ? '' : ' (في الرصيد)'}')
                      .toList(),
                  emptyText: 'لا توجد ديون',
                  valueColor: AppColors.negative,
                  onEdit: () => onEditStep(3),
                ),
                const SizedBox(height: 8),
                _SummaryListCard(
                  icon: Icons.trending_up,
                  label: 'السلفات',
                  items: lendings
                      .map((l) => '${l.borrowerName}: ${l.totalAmount} دج')
                      .toList(),
                  emptyText: 'لا توجد سلفات',
                  valueColor: AppColors.positive,
                  onEdit: () => onEditStep(4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              child: const Text('تأكيد وبدء الاستخدام'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final VoidCallback onEdit;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: valueColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.labelSmall),
                  Text(
                    value,
                    style: AppTypography.amountSmall.copyWith(
                      color: valueColor,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryListCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> items;
  final String emptyText;
  final Color valueColor;
  final VoidCallback onEdit;

  const _SummaryListCard({
    required this.icon,
    required this.label,
    required this.items,
    required this.emptyText,
    required this.valueColor,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: valueColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label, style: AppTypography.labelMedium),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: onEdit,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 36),
                child: Text(
                  emptyText,
                  style: AppTypography.bodySmall,
                ),
              )
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(right: 36, bottom: 4),
                  child: Text(item, style: AppTypography.bodyMedium),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
