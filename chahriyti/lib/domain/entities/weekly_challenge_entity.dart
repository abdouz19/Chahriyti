import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_challenge_entity.freezed.dart';
part 'weekly_challenge_entity.g.dart';

@freezed
abstract class WeeklyChallengeEntity with _$WeeklyChallengeEntity {
  const WeeklyChallengeEntity._();

  const factory WeeklyChallengeEntity({
    required int id,
    required int cycleId,
    required DateTime weekStart,
    required int targetReduction,
    required int previousWeekSpending,
    required bool isCompleted,
  }) = _WeeklyChallengeEntity;

  factory WeeklyChallengeEntity.fromJson(Map<String, dynamic> json) =>
      _$WeeklyChallengeEntityFromJson(json);
}
