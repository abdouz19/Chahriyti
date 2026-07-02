// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lending_collection_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LendingCollectionEntity _$LendingCollectionEntityFromJson(
  Map<String, dynamic> json,
) => _LendingCollectionEntity(
  id: (json['id'] as num).toInt(),
  lendingId: (json['lendingId'] as num).toInt(),
  amount: (json['amount'] as num).toInt(),
  toSavings: json['toSavings'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$LendingCollectionEntityToJson(
  _LendingCollectionEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'lendingId': instance.lendingId,
  'amount': instance.amount,
  'toSavings': instance.toSavings,
  'createdAt': instance.createdAt.toIso8601String(),
};
