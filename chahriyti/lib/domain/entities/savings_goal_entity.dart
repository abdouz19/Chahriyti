import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_goal_entity.freezed.dart';
part 'savings_goal_entity.g.dart';

@freezed
abstract class SavingsGoalEntity with _$SavingsGoalEntity {
  const SavingsGoalEntity._();

  const factory SavingsGoalEntity({
    required int id,
    required String name,
    required int targetAmount,
    required int savedAmount,
    required bool isAchieved,
    required DateTime createdAt,
  }) = _SavingsGoalEntity;

  factory SavingsGoalEntity.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalEntityFromJson(json);

  double get progressPercentage =>
      targetAmount > 0 ? (savedAmount / targetAmount * 100).clamp(0, 100) : 0;

  int get remainingAmount => targetAmount - savedAmount;
}
