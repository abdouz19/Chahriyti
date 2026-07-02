import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';
import '../cubits/lending_cubit.dart';
import '../cubits/lending_state.dart';
import 'add_lending_page.dart';

class LendingDetailPage extends StatelessWidget {
  final int lendingId;

  const LendingDetailPage({
    required this.lendingId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LendingCubit(
        Injection.createLendingUseCase,
        Injection.getLendingsUseCase,
        Injection.addLendingCollectionUseCase,
        Injection.deleteLendingUseCase,
        Injection.getSavingsBalanceUseCase,
        Injection.updateLendingUseCase,
      )..loadLendingById(lendingId),
      child: _LendingDetailView(lendingId: lendingId),
    );
  }
}

class _LendingDetailView extends StatelessWidget {
  final int lendingId;

  const _LendingDetailView({required this.lendingId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LendingCubit, LendingState>(
      listener: (context, state) {
        state.whenOrNull(
          lendingDeleted: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حذف السلفة'),
                backgroundColor: AppColors.positive,
              ),
            );
            context.pop();
          },
          collectionAdded: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تسجيل التحصيل بنجاح'),
                backgroundColor: AppColors.positive,
              ),
            );
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.negative,
              ),
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'تفاصيل السلفة',
            style: AppTypography.headlineSmall,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'تعديل',
              onPressed: () async {
                final currentState = context.read<LendingCubit>().state;
                if (currentState is LendingLoaded) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddLendingPage(
                        cycleId: currentState.lending.cycleId,
                        initialLending: currentState.lending,
                      ),
                    ),
                  );
                  if (context.mounted) {
                    context.read<LendingCubit>().loadLendingById(lendingId);
                  }
                }
              },
            ),
            IconButton(
              onPressed: () => _showDeleteConfirmation(context),
              icon: Icon(
                Icons.delete_outline,
                color: AppColors.negative,
              ),
              tooltip: 'حذف السلفة',
            ),
          ],
        ),
        body: BlocBuilder<LendingCubit, LendingState>(
          builder: (context, state) {
            if (state is LendingLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            return state.maybeWhen(
              lendingLoaded: (lending, collections) {
                final percentageCollected = lending.totalAmount > 0
                    ? (lending.collectedAmount /
                            lending.totalAmount.toDouble()) *
                        100
                    : 0.0;
                final dateFormat = DateFormat('yyyy/MM/dd', 'ar');

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Borrower name card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اسم المقترض',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              lending.borrowerName,
                              style: AppTypography.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Amount info row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'المبلغ الإجمالي',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  MoneyText(
                                    amount: Money(lending.totalAmount),
                                    style: AppTypography.labelLarge,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.positive.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.positive
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'المبلغ المحصّل',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  MoneyText(
                                    amount: Money(lending.collectedAmount),
                                    style: AppTypography.labelLarge,
                                    color: AppColors.positive,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Progress bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'التقدم',
                                style: AppTypography.labelLarge,
                              ),
                              Text(
                                '${percentageCollected.toStringAsFixed(0)}%',
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentageCollected / 100,
                              minHeight: 8,
                              backgroundColor: AppColors.border,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                percentageCollected >= 100
                                    ? AppColors.positive
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Remaining amount
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'المبلغ المتبقي',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            MoneyText(
                              amount: Money(lending.remainingAmount),
                              style: AppTypography.headlineSmall,
                              color: lending.remainingAmount > 0
                                  ? AppColors.warning
                                  : AppColors.positive,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Date + source info
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(
                            dateFormat.format(lending.createdAt),
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            lending.fromSavings
                                ? Icons.savings_rounded
                                : Icons.account_balance_wallet_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            lending.fromSavings
                                ? 'من المدخرات'
                                : 'من الرصيد',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Notes
                      if (lending.notes != null &&
                          lending.notes!.isNotEmpty) ...[
                        Text(
                          'ملاحظات',
                          style: AppTypography.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            lending.notes!,
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Add collection button
                      if (!lending.isFullyCollected)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showAddCollectionDialog(
                              context,
                              lending.remainingAmount,
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('تسجيل تحصيل'),
                          ),
                        ),

                      // Collection history
                      if (collections.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          'سجل التحصيلات',
                          style: AppTypography.labelLarge,
                        ),
                        const SizedBox(height: 12),
                        ...collections.map((collection) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: 18,
                                      color: AppColors.positive,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dateFormat
                                              .format(collection.createdAt),
                                          style:
                                              AppTypography.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              collection.toSavings
                                                  ? Icons.savings_rounded
                                                  : Icons
                                                      .account_balance_wallet_rounded,
                                              size: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              collection.toSavings
                                                  ? 'إلى المدخرات'
                                                  : 'إلى الرصيد',
                                              style: AppTypography.bodySmall
                                                  .copyWith(
                                                color: AppColors.textSecondary,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                MoneyText(
                                  amount: Money(collection.amount),
                                  style: AppTypography.labelLarge,
                                  color: AppColors.positive,
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
              error: (message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 64,
                        color: AppColors.negative,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: AppTypography.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final cubit = context.read<LendingCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف السلفة'),
        content: const Text(
          'سيتم حذف السلفة وجميع الاسترجاعات المرتبطة بها. هل تريد المتابعة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.deleteLending(lendingId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negative,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showAddCollectionDialog(BuildContext context, int maxAmount) {
    final amountController = TextEditingController();
    final cubit = context.read<LendingCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => _CollectionDialog(
        maxAmount: maxAmount,
        amountController: amountController,
        onSubmit: (amount, toSavings) {
          Navigator.pop(dialogContext);
          cubit.addCollection(
            lendingId: lendingId,
            amount: amount,
            toSavings: toSavings,
          );
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }
}

class _CollectionDialog extends StatefulWidget {
  final int maxAmount;
  final TextEditingController amountController;
  final void Function(int amount, bool toSavings) onSubmit;
  final VoidCallback onCancel;

  const _CollectionDialog({
    required this.maxAmount,
    required this.amountController,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<_CollectionDialog> createState() => _CollectionDialogState();
}

class _CollectionDialogState extends State<_CollectionDialog> {
  bool _toSavings = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تسجيل تحصيل'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المبلغ المتبقي: ${widget.maxAmount.toDZDString()}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: widget.amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'المبلغ المحصّل',
              suffixText: 'دج',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'إضافة المبلغ إلى',
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _toSavings = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: !_toSavings
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !_toSavings
                            ? AppColors.primary
                            : AppColors.border,
                        width: !_toSavings ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          color: !_toSavings
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'الرصيد',
                          style: AppTypography.labelSmall.copyWith(
                            color: !_toSavings
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: !_toSavings
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _toSavings = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _toSavings
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _toSavings
                            ? AppColors.primary
                            : AppColors.border,
                        width: _toSavings ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.savings_rounded,
                          color: _toSavings
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'المدخرات',
                          style: AppTypography.labelSmall.copyWith(
                            color: _toSavings
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: _toSavings
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = int.tryParse(widget.amountController.text);
            if (amount != null && amount > 0) {
              widget.onSubmit(amount, _toSavings);
            }
          },
          child: const Text('تسجيل'),
        ),
      ],
    );
  }
}
