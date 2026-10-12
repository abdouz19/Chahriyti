import 'package:flutter/widgets.dart';

import '../../../core/constants/categories.dart';
import '../../../core/extensions/category_l10n_extension.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../domain/entities/savings_history_entity.dart';

/// Savings records store their description as text written when created
/// (Arabic templates, or `categoryKey - item` for expenses). This turns
/// the known templates into the user's language; anything else (a description
/// the user typed) is shown as is.
String localizedSavingsDescription(
    BuildContext context, SavingsHistoryEntity record) {
  final l = context.l10n;
  final text = record.description;

  if (record.relatedExpenseId != null) {
    final sep = text.indexOf(' - ');
    final key = sep >= 0 ? text.substring(0, sep) : text;
    final item = sep >= 0 ? text.substring(sep + 3).trim() : '';
    final category = key.startsWith('custom_')
        ? l.customCategory
        : ExpenseCategory.values
                .where((c) => c.name == key)
                .firstOrNull
                ?.localizedLabel(context) ??
            key;
    return item.isEmpty ? category : '$category - $item';
  }

  final exact = <String, String>{
    'رصيد الادخار الأولي': l.savDescInitial,
    'رصيد أولي': l.savDescInitial,
    'إيداع من الرصيد': l.savDescDepositFromBalance,
    'سحب للرصيد': l.savDescWithdrawToBalance,
    'ادخار نهاية الدورة': l.savDescCycleEnd,
    'تقسيم الراتب': l.savDescSalarySplit,
  };
  final fixed = exact[text];
  if (fixed != null) return fixed;

  // Longer prefixes first: "إلغاء شراء هدف" contains "شراء هدف"
  final withName = <String, String Function(String)>{
    'إلغاء شراء هدف - ': l.savDescGoalPurchaseUndo,
    'شراء هدف - ': l.savDescGoalPurchase,
    'تحصيل سلفة - ': l.savDescLendingCollection,
    'تعديل سلفة - ': l.savDescLendingEdit,
    'سلفة - ': l.savDescLending,
    'سداد دين - ': l.savDescDebtPayment,
    'مدخول - ': l.savDescIncome,
  };
  for (final entry in withName.entries) {
    if (text.startsWith(entry.key)) {
      return entry.value(text.substring(entry.key.length));
    }
  }
  return text;
}
