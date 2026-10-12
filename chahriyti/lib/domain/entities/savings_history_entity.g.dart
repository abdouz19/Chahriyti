// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_history_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingsHistoryEntity _$SavingsHistoryEntityFromJson(
  Map<String, dynamic> json,
) => _SavingsHistoryEntity(
  id: (json['id'] as num).toInt(),
  type: $enumDecode(_$SavingsTransactionTypeEnumMap, json['type']),
  amount: (json['amount'] as num).toInt(),
  description: json['description'] as String,
  relatedCycleId: (json['relatedCycleId'] as num?)?.toInt(),
  relatedExpenseId: (json['relatedExpenseId'] as num?)?.toInt(),
  relatedDebtPaymentId: (json['relatedDebtPaymentId'] as num?)?.toInt(),
  relatedLendingId: (json['relatedLendingId'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  kind:
      $enumDecodeNullable(_$SavingsRecordKindEnumMap, json['kind']) ??
      SavingsRecordKind.other,
);

Map<String, dynamic> _$SavingsHistoryEntityToJson(
  _SavingsHistoryEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$SavingsTransactionTypeEnumMap[instance.type]!,
  'amount': instance.amount,
  'description': instance.description,
  'relatedCycleId': instance.relatedCycleId,
  'relatedExpenseId': instance.relatedExpenseId,
  'relatedDebtPaymentId': instance.relatedDebtPaymentId,
  'relatedLendingId': instance.relatedLendingId,
  'createdAt': instance.createdAt.toIso8601String(),
  'kind': _$SavingsRecordKindEnumMap[instance.kind]!,
};

const _$SavingsTransactionTypeEnumMap = {
  SavingsTransactionType.deposit: 'deposit',
  SavingsTransactionType.withdrawal: 'withdrawal',
};

const _$SavingsRecordKindEnumMap = {
  SavingsRecordKind.initial: 'initial',
  SavingsRecordKind.transfer: 'transfer',
  SavingsRecordKind.other: 'other',
};
