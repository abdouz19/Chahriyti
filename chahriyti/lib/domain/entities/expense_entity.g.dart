// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseEntity _$ExpenseEntityFromJson(Map<String, dynamic> json) =>
    _ExpenseEntity(
      id: (json['id'] as num).toInt(),
      cycleId: (json['cycleId'] as num).toInt(),
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      itemName: json['itemName'] as String,
      amount: (json['amount'] as num).toInt(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      fromSavings: json['fromSavings'] as bool? ?? false,
      savingsAmount: (json['savingsAmount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ExpenseEntityToJson(_ExpenseEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cycleId': instance.cycleId,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'itemName': instance.itemName,
      'amount': instance.amount,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'fromSavings': instance.fromSavings,
      'savingsAmount': instance.savingsAmount,
    };
