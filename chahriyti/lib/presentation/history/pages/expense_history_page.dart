import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/expense_entity.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/money_text.dart';
import '../cubits/history_cubit.dart';

class ExpenseHistoryPage extends StatelessWidget {
  const ExpenseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryCubit(
        expenseRepository: Injection.expenseRepository,
        cycleRepository: Injection.cycleRepository,
      )..loadExpenses(),
      child: const _ExpenseHistoryView(),
    );
  }
}

class _ExpenseHistoryView extends StatelessWidget {
  const _ExpenseHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'سجل المصاريف',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: BlocConsumer<HistoryCubit, HistoryState>(
        listener: (context, state) {
          if (state is HistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.negative,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is HistoryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.negative,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: AppTypography.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<HistoryCubit>().loadExpenses(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          final expenses = _getExpenses(state);
          final hasMore = _getHasMore(state);
          final activeCycleId = _getActiveCycleId(state);
          final isLoadingMore = state is HistoryLoadingMore;

          if (expenses.isEmpty) {
            return const EmptyStateWidget(
              illustrationPath: 'assets/illustrations/empty_history.svg',
              title: 'لا توجد مصاريف مسجلة',
              subtitle: 'ستظهر هنا المصاريف التي تسجلها',
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => context.read<HistoryCubit>().loadExpenses(),
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (!isLoadingMore &&
                    hasMore &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200) {
                  context.read<HistoryCubit>().loadMore();
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: expenses.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= expenses.length) {
                    return _buildLoadMoreIndicator(isLoadingMore);
                  }

                  final expense = expenses[index];
                  final canDelete = activeCycleId != null &&
                      expense.cycleId == activeCycleId;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ExpenseRow(
                      expense: expense,
                      canDelete: canDelete,
                      onTap: () async {
                        await context.push('/expense/edit', extra: expense);
                        if (context.mounted) {
                          context.read<HistoryCubit>().loadExpenses();
                        }
                      },
                      onDelete: () =>
                          _onDelete(context, expense),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  List<ExpenseEntity> _getExpenses(HistoryState state) {
    if (state is HistoryLoaded) return state.expenses;
    if (state is HistoryLoadingMore) return state.currentExpenses;
    return [];
  }

  bool _getHasMore(HistoryState state) {
    if (state is HistoryLoaded) return state.hasMore;
    if (state is HistoryLoadingMore) return true;
    return false;
  }

  int? _getActiveCycleId(HistoryState state) {
    if (state is HistoryLoaded) return state.activeCycleId;
    if (state is HistoryLoadingMore) return state.activeCycleId;
    return null;
  }

  Widget _buildLoadMoreIndicator(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              )
            : Text(
                'تحميل المزيد',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
      ),
    );
  }

  Future<void> _onDelete(
    BuildContext context,
    ExpenseEntity expense,
  ) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'حذف المصروف',
      message: 'هل تريد حذف "${expense.itemName}"؟',
      confirmLabel: 'حذف',
      cancelLabel: 'إلغاء',
      confirmColor: AppColors.negative,
    );

    if (confirmed && context.mounted) {
      context.read<HistoryCubit>().deleteExpense(expense.id);
    }
  }
}

class _ExpenseRow extends StatelessWidget {
  final ExpenseEntity expense;
  final bool canDelete;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ExpenseRow({
    required this.expense,
    required this.canDelete,
    required this.onTap,
    required this.onDelete,
  });

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'essentials':
        return Icons.shopping_basket_rounded;
      case 'homeFamily':
        return Icons.home_rounded;
      case 'luxuries':
        return Icons.diamond_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  String _formatDateArabicMonth(DateTime date) {
    final arabicMonths = [
      'جانفي',
      'فيفري',
      'مارس',
      'أفريل',
      'ماي',
      'جوان',
      'جويلية',
      'أوت',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    final day = date.day;
    final month = arabicMonths[date.month - 1];
    final year = date.year;
    return '$day $month $year';
  }

  @override
  Widget build(BuildContext context) {

    Widget card = GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _categoryIcon(expense.category),
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.itemName,
                    style: AppTypography.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDateArabicMonth(expense.createdAt),
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            MoneyText(
              amount: Money.fromDZD(expense.amount),
              style: AppTypography.amountSmall,
              color: AppColors.negative,
            ),
          ],
        ),
      ),
    );

    if (canDelete) {
      return Dismissible(
        key: ValueKey(expense.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: AppColors.negative,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
          ),
        ),
        confirmDismiss: (_) async {
          onDelete();
          return false;
        },
        child: card,
      );
    }

    return card;
  }
}
