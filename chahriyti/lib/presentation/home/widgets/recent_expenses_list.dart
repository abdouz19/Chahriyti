import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/categories.dart';
import '../../../core/extensions/category_l10n_extension.dart';
import '../../../core/extensions/l10n_extension.dart';
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
      return EmptyStateWidget(
        illustrationPath: 'assets/illustrations/empty_expenses.svg',
        title: context.l10n.noExpenses,
        subtitle: context.l10n.startRecordingExpenses,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            context.l10n.recentExpenses,
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
                      context.l10n.viewAll,
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
                title: Text(context.l10n.edit),
                onTap: () {
                  Navigator.pop(context);
                  onEdit!(expense);
                },
              ),
            if (onDelete != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.negative),
                title: Text(context.l10n.delete, style: TextStyle(color: AppColors.negative)),
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

  bool get _isCustomCategory => expense.category.startsWith('custom_');

  @override
  Widget build(BuildContext context) {
    final category = _isCustomCategory ? null : _categoryFromString(expense.category);

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
              child: _isCustomCategory
                  ? const Icon(Icons.label_outline_rounded,
                      color: AppColors.primary, size: 20)
                  : Icon(
                      _categoryIcon(category!),
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
                    expense.itemName.isNotEmpty
                        ? expense.itemName
                        : (_isCustomCategory
                            ? 'فئة مخصصة'
                            : _categoryFromString(expense.category).localizedLabel(context)),
                    style: AppTypography.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _relativeDate(expense.createdAt, context),
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
      case ExpenseCategory.health:
        return Icons.local_hospital_rounded;
      case ExpenseCategory.transport:
        return Icons.directions_car_rounded;
      case ExpenseCategory.clothing:
        return Icons.checkroom_rounded;
      case ExpenseCategory.restaurants:
        return Icons.restaurant_rounded;
      case ExpenseCategory.education:
        return Icons.school_rounded;
      case ExpenseCategory.other:
        return Icons.more_horiz_rounded;
    }
  }

  static String _relativeDate(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final diff = now.difference(date);
    final l10n = context.l10n;

    if (diff.inMinutes < 1) return l10n.timeNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    if (diff.inDays == 1) return l10n.timeYesterday;
    if (diff.inDays < 7) return l10n.timeDaysAgo(diff.inDays);
    return l10n.timeWeeksAgo(diff.inDays ~/ 7);
  }
}
