// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_challenge_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeeklyChallengeEntity _$WeeklyChallengeEntityFromJson(
  Map<String, dynamic> json,
) => _WeeklyChallengeEntity(
  id: (json['id'] as num).toInt(),
  cycleId: (json['cycleId'] as num).toInt(),
  weekStart: DateTime.parse(json['weekStart'] as String),
  targetReduction: (json['targetReduction'] as num).toInt(),
  previousWeekSpending: (json['previousWeekSpending'] as num).toInt(),
  isCompleted: json['isCompleted'] as bool,
);

Map<String, dynamic> _$WeeklyChallengeEntityToJson(
  _WeeklyChallengeEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'cycleId': instance.cycleId,
  'weekStart': instance.weekStart.toIso8601String(),
  'targetReduction': instance.targetReduction,
  'previousWeekSpending': instance.previousWeekSpending,
  'isCompleted': instance.isCompleted,
};
