import 'package:freezed_annotation/freezed_annotation.dart';

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

  factory ExpenseEntity.fromJson(Map<String, dynamic> json) =>
      _$ExpenseEntityFromJson(json);
}
