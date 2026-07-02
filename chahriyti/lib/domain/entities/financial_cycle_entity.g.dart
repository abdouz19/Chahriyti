// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_cycle_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinancialCycleEntity _$FinancialCycleEntityFromJson(
  Map<String, dynamic> json,
) => _FinancialCycleEntity(
  id: (json['id'] as num).toInt(),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  salaryAmount: (json['salaryAmount'] as num).toInt(),
  salarySplitAmount: (json['salarySplitAmount'] as num?)?.toInt() ?? 0,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$FinancialCycleEntityToJson(
  _FinancialCycleEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'salaryAmount': instance.salaryAmount,
  'salarySplitAmount': instance.salarySplitAmount,
  'isActive': instance.isActive,
};
