import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/debt_entity.dart';
import 'debt_form_bottom_sheet.dart';
import 'setup_progress_bar.dart';

class DebtsStepWidget extends StatelessWidget {
  final List<DebtEntity> debts;
  final Future<void> Function(String name, int amount, bool isSpent) onAdd;
  final Future<void> Function(int id, String name, int amount, bool isSpent) onEdit;
  final Future<void> Function(int id) onDelete;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const DebtsStepWidget({
    super.key,
    required this.debts,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onNext,
    required this.onSkip,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SetupProgressBar(currentStep: 4, totalSteps: 6),
          const SizedBox(height: 32),
          Text('لمن أنت مدين؟', style: AppTypography.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'ديون بنكية، قروض شخصية، أو أي مبلغ تدين به.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: debts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 48, color: AppColors.textSecondary),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد ديون',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: debts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final debt = debts[index];
                      return Card(
                        child: ListTile(
                          title: Text(debt.creditorName,
                              style: AppTypography.labelMedium),
                          trailing: Text(
                            '${debt.totalAmount} دج',
                            style: AppTypography.amountSmall.copyWith(
                              color: AppColors.negative,
                            ),
                          ),
                          onTap: () async {
                            final result = await DebtFormBottomSheet.show(
                              context,
                              initialName: debt.creditorName,
                              initialAmount: debt.totalAmount,
                              initialIsSpent: debt.isSpent,
                              onDelete: () => onDelete(debt.id),
                            );
                            if (result != null) {
                              await onEdit(
                                debt.id,
                                result.creditorName,
                                result.totalAmount,
                                result.isSpent,
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(debts.isEmpty ? 'إضافة أول دَيْن' : 'إضافة دَيْن آخر'),
              onPressed: () async {
                final result = await DebtFormBottomSheet.show(context);
                if (result != null) {
                  await onAdd(
                      result.creditorName, result.totalAmount, result.isSpent);
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: debts.isEmpty ? onSkip : null,
                  child: const Text('تخطي'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onNext,
                  child: const Text('التالي'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
