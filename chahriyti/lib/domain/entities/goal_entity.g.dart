// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoalEntity _$GoalEntityFromJson(Map<String, dynamic> json) => _GoalEntity(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  targetAmount: (json['targetAmount'] as num).toInt(),
  description: json['description'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$GoalEntityToJson(_GoalEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'targetAmount': instance.targetAmount,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
