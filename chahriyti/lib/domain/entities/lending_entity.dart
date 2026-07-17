import 'package:freezed_annotation/freezed_annotation.dart';

part 'lending_entity.freezed.dart';
part 'lending_entity.g.dart';

@freezed
abstract class LendingEntity with _$LendingEntity {
  const LendingEntity._();

  const factory LendingEntity({
    required int id,
    required String borrowerName,
    required int totalAmount,
    @Default(0) int collectedAmount,
    @Default(false) bool isFullyCollected,
    @Default(false) bool fromSavings,
    @Default(0) int savingsAmount,
    int? cycleId,
    String? notes,
    required DateTime createdAt,
  }) = _LendingEntity;

  factory LendingEntity.fromJson(Map<String, dynamic> json) =>
      _$LendingEntityFromJson(json);

  int get remainingAmount => totalAmount - collectedAmount;
}
