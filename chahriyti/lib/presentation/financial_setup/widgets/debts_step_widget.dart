import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
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
          const SetupProgressBar(currentStep: 4, totalSteps: 7),
          const SizedBox(height: 32),
          Text(context.l10n.debtsStepTitle, style: AppTypography.headlineMedium),
          const SizedBox(height: 8),
          Text(
            context.l10n.debtsStepDesc,
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
                          context.l10n.noDebts,
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
                            '${debt.totalAmount} ${context.l10n.currencySymbol}',
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
              label: Text(debts.isEmpty ? context.l10n.addFirstDebt : context.l10n.addAnotherDebt),
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
                  child: Text(context.l10n.skip),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onNext,
                  child: Text(context.l10n.next),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
