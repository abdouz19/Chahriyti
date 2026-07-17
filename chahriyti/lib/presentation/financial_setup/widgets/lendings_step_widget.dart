import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/lending_entity.dart';
import 'lending_form_bottom_sheet.dart';
import 'setup_progress_bar.dart';

class LendingsStepWidget extends StatelessWidget {
  final List<LendingEntity> lendings;
  final Future<void> Function(String name, int amount) onAdd;
  final Future<void> Function(int id, String name, int amount) onEdit;
  final Future<void> Function(int id) onDelete;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const LendingsStepWidget({
    super.key,
    required this.lendings,
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
          const SetupProgressBar(currentStep: 5, totalSteps: 6),
          const SizedBox(height: 32),
          Text('من يدين لك بالمال؟', style: AppTypography.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'سلفات أعطيتها لأصدقاء أو عائلة.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: lendings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 48, color: AppColors.textSecondary),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد سلفات',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: lendings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final lending = lendings[index];
                      return Card(
                        child: ListTile(
                          title: Text(lending.borrowerName,
                              style: AppTypography.labelMedium),
                          trailing: Text(
                            '${lending.totalAmount} دج',
                            style: AppTypography.amountSmall.copyWith(
                              color: AppColors.positive,
                            ),
                          ),
                          onTap: () async {
                            final result = await LendingFormBottomSheet.show(
                              context,
                              initialName: lending.borrowerName,
                              initialAmount: lending.totalAmount,
                              onDelete: () => onDelete(lending.id),
                            );
                            if (result != null) {
                              await onEdit(
                                lending.id,
                                result.borrowerName,
                                result.totalAmount,
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
              label: Text(
                  lendings.isEmpty ? 'إضافة أول سلفة' : 'إضافة سلفة أخرى'),
              onPressed: () async {
                final result = await LendingFormBottomSheet.show(context);
                if (result != null) {
                  await onAdd(result.borrowerName, result.totalAmount);
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: lendings.isEmpty ? onSkip : null,
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
