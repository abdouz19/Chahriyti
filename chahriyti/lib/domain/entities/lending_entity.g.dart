// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lending_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LendingEntity _$LendingEntityFromJson(Map<String, dynamic> json) =>
    _LendingEntity(
      id: (json['id'] as num).toInt(),
      borrowerName: json['borrowerName'] as String,
      totalAmount: (json['totalAmount'] as num).toInt(),
      collectedAmount: (json['collectedAmount'] as num?)?.toInt() ?? 0,
      isFullyCollected: json['isFullyCollected'] as bool? ?? false,
      fromSavings: json['fromSavings'] as bool? ?? false,
      savingsAmount: (json['savingsAmount'] as num?)?.toInt() ?? 0,
      cycleId: (json['cycleId'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$LendingEntityToJson(_LendingEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'borrowerName': instance.borrowerName,
      'totalAmount': instance.totalAmount,
      'collectedAmount': instance.collectedAmount,
      'isFullyCollected': instance.isFullyCollected,
      'fromSavings': instance.fromSavings,
      'savingsAmount': instance.savingsAmount,
      'cycleId': instance.cycleId,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
    };
