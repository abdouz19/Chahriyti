// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_goal_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingsGoalEntity _$SavingsGoalEntityFromJson(Map<String, dynamic> json) =>
    _SavingsGoalEntity(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toInt(),
      savedAmount: (json['savedAmount'] as num).toInt(),
      isAchieved: json['isAchieved'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SavingsGoalEntityToJson(_SavingsGoalEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'targetAmount': instance.targetAmount,
      'savedAmount': instance.savedAmount,
      'isAchieved': instance.isAchieved,
      'createdAt': instance.createdAt.toIso8601String(),
    };
