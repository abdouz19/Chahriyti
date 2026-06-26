import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_entity.freezed.dart';
part 'goal_entity.g.dart';

@freezed
abstract class GoalEntity with _$GoalEntity {
  const GoalEntity._();

  const factory GoalEntity({
    required int id,
    required String name,
    required int targetAmount, // in centimes
    String? description,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _GoalEntity;

  bool get isCompleted => completedAt != null;

  factory GoalEntity.fromJson(Map<String, dynamic> json) =>
      _$GoalEntityFromJson(json);
}
