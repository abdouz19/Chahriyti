import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_cycle_entity.freezed.dart';
part 'financial_cycle_entity.g.dart';

@freezed
abstract class FinancialCycleEntity with _$FinancialCycleEntity {
  const FinancialCycleEntity._();

  const factory FinancialCycleEntity({
    required int id,
    required DateTime startDate,
    required DateTime endDate,
    required int salaryAmount,
    required bool isActive,
  }) = _FinancialCycleEntity;

  factory FinancialCycleEntity.fromJson(Map<String, dynamic> json) =>
      _$FinancialCycleEntityFromJson(json);

  int daysRemaining(DateTime now) {
    final diff = endDate.difference(now).inDays;
    return diff < 0 ? 0 : diff;
  }

  int daysElapsed(DateTime now) {
    final diff = now.difference(startDate).inDays;
    return diff < 0 ? 0 : diff;
  }
}
