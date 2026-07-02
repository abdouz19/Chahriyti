// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtEntity _$DebtEntityFromJson(Map<String, dynamic> json) => _DebtEntity(
  id: (json['id'] as num).toInt(),
  creditorName: json['creditorName'] as String,
  totalAmount: (json['totalAmount'] as num).toInt(),
  paidAmount: (json['paidAmount'] as num).toInt(),
  isFullyPaid: json['isFullyPaid'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$DebtEntityToJson(_DebtEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creditorName': instance.creditorName,
      'totalAmount': instance.totalAmount,
      'paidAmount': instance.paidAmount,
      'isFullyPaid': instance.isFullyPaid,
      'createdAt': instance.createdAt.toIso8601String(),
      'notes': instance.notes,
    };
