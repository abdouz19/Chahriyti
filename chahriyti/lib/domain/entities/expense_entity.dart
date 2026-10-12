import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/setup_adjustment.dart';

part 'expense_entity.freezed.dart';
part 'expense_entity.g.dart';

@freezed
abstract class ExpenseEntity with _$ExpenseEntity {
  const ExpenseEntity._();

  const factory ExpenseEntity({
    required int id,
    required int cycleId,
    required String category,
    required String subcategory,
    required String itemName,
    required int amount,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool fromSavings,
    @Default(0) int savingsAmount,
  }) = _ExpenseEntity;

  /// Money spent before the app, recorded at setup (not real spending).
  bool get isSetupAdjustment =>
      category == SetupAdjustment.expenseCategory &&
      itemName == SetupAdjustment.expenseItem;

  factory ExpenseEntity.fromJson(Map<String, dynamic> json) =>
      _$ExpenseEntityFromJson(json);
}
