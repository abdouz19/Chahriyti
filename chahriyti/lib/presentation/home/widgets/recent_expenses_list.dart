import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/categories.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/expense_entity.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/money_text.dart';

class RecentExpensesList extends StatelessWidget {
  final List<ExpenseEntity> expenses;
  final void Function(ExpenseEntity expense)? onEditExpense;
  final void Function(ExpenseEntity expense)? onDeleteExpense;

  const RecentExpensesList({
    super.key,
    required this.expenses,
    this.onEditExpense,
    this.onDeleteExpense,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const EmptyStateWidget(
        illustrationPath: 'assets/illustrations/empty_expenses.svg',
        title: 'لا توجد مصاريف',
        subtitle: 'ابدأ بتسجيل مصاريفك اليومية',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'آخر المصاريف',
            style: AppTypography.labelMedium,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.border),
          ),
          elevation: 0,
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenses.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: AppColors.divider,
                  indent: 56,
                ),
                itemBuilder: (context, index) {
                  return _ExpenseRow(
                    expense: expenses[index],
                    onEdit: onEditExpense,
                    onDelete: onDeleteExpense,
                  );
                },
              ),
              Divider(height: 1, color: AppColors.divider),
              InkWell(
                onTap: () => context.push('/history'),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      'عرض الكل',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  final ExpenseEntity expense;
  final void Function(ExpenseEntity expense)? onEdit;
  final void Function(ExpenseEntity expense)? onDelete;

  const _ExpenseRow({
    required this.expense,
    this.onEdit,
    this.onDelete,
  });

  void _showActionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('تعديل'),
                onTap: () {
                  Navigator.pop(context);
                  onEdit!(expense);
                },
              ),
            if (onDelete != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.negative),
                title: Text('حذف', style: TextStyle(color: AppColors.negative)),
                onTap: () {
                  Navigator.pop(context);
                  onDelete!(expense);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = _categoryFromString(expense.category);

    return GestureDetector(
      onLongPress: (onEdit != null || onDelete != null)
          ? () => _showActionsSheet(context)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _categoryIcon(category),
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
                    style: AppTypography.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _relativeDate(expense.createdAt),
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            MoneyText(
              amount: Money(expense.amount),
              style: AppTypography.amountSmall,
              color: AppColors.negative,
            ),
          ],
        ),
      ),
    );
  }

  static ExpenseCategory _categoryFromString(String category) {
    return ExpenseCategory.values.firstWhere(
      (c) => c.name == category,
      orElse: () => ExpenseCategory.other,
    );
  }

  static IconData _categoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.essentials:
        return Icons.shopping_basket_rounded;
      case ExpenseCategory.homeFamily:
        return Icons.home_rounded;
      case ExpenseCategory.luxuries:
        return Icons.diamond_rounded;
      case ExpenseCategory.other:
        return Icons.more_horiz_rounded;
    }
  }

  static String _relativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    const lfm = '\u202A'; // Left-to-Right embedding
    const pdf = '\u202C'; // Pop Directional Formatting

    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ $lfm${diff.inMinutes}$pdf دقيقة';
    if (diff.inHours < 24) return 'منذ $lfm${diff.inHours}$pdf ساعة';
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ $lfm${diff.inDays}$pdf أيام';
    return 'منذ $lfm${diff.inDays ~/ 7}$pdf أسبوع';
  }
}
