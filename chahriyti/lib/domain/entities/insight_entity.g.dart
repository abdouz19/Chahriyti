// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InsightEntity _$InsightEntityFromJson(Map<String, dynamic> json) =>
    _InsightEntity(
      id: (json['id'] as num).toInt(),
      cycleId: (json['cycleId'] as num).toInt(),
      type: $enumDecode(_$InsightTypeEnumMap, json['type']),
      category: json['category'] as String?,
      metric: json['metric'] as String,
      value: (json['value'] as num).toDouble(),
      suggestion: json['suggestion'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$InsightEntityToJson(_InsightEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cycleId': instance.cycleId,
      'type': _$InsightTypeEnumMap[instance.type]!,
      'category': instance.category,
      'metric': instance.metric,
      'value': instance.value,
      'suggestion': instance.suggestion,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

const _$InsightTypeEnumMap = {
  InsightType.leak: 'leak',
  InsightType.trend: 'trend',
  InsightType.classification: 'classification',
};
