// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'additional_income_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdditionalIncomeEntity _$AdditionalIncomeEntityFromJson(
  Map<String, dynamic> json,
) => _AdditionalIncomeEntity(
  id: (json['id'] as num).toInt(),
  cycleId: (json['cycleId'] as num).toInt(),
  description: json['description'] as String,
  amount: (json['amount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AdditionalIncomeEntityToJson(
  _AdditionalIncomeEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'cycleId': instance.cycleId,
  'description': instance.description,
  'amount': instance.amount,
  'createdAt': instance.createdAt.toIso8601String(),
};
