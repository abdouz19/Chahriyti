// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => _UserEntity(
  id: (json['id'] as num).toInt(),
  monthlySalary: (json['monthlySalary'] as num).toInt(),
  salaryDay: (json['salaryDay'] as num).toInt(),
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  wilayaCode: (json['wilayaCode'] as num).toInt(),
  isActivated: json['isActivated'] as bool,
  challengesEnabled: json['challengesEnabled'] as bool,
  initialBalance: (json['initialBalance'] as num?)?.toInt(),
  hasCompletedFinancialSetup:
      json['hasCompletedFinancialSetup'] as bool? ?? false,
  financialSetupStep: (json['financialSetupStep'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserEntityToJson(_UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'monthlySalary': instance.monthlySalary,
      'salaryDay': instance.salaryDay,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'wilayaCode': instance.wilayaCode,
      'isActivated': instance.isActivated,
      'challengesEnabled': instance.challengesEnabled,
      'initialBalance': instance.initialBalance,
      'hasCompletedFinancialSetup': instance.hasCompletedFinancialSetup,
      'financialSetupStep': instance.financialSetupStep,
      'createdAt': instance.createdAt.toIso8601String(),
    };
