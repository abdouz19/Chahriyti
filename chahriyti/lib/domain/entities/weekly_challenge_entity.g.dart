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
  targetAmount: (json['targetAmount'] as num).toInt(),
  description: json['description'] as String,
  isCompleted: json['isCompleted'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$WeeklyChallengeEntityToJson(
  _WeeklyChallengeEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'cycleId': instance.cycleId,
  'weekStart': instance.weekStart.toIso8601String(),
  'targetAmount': instance.targetAmount,
  'description': instance.description,
  'isCompleted': instance.isCompleted,
  'createdAt': instance.createdAt.toIso8601String(),
};
