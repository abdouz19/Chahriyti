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
    @Default(0) int salarySplitAmount,
    required bool isActive,
  }) = _FinancialCycleEntity;

  factory FinancialCycleEntity.fromJson(Map<String, dynamic> json) =>
      _$FinancialCycleEntityFromJson(json);

  int daysRemaining(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    // endDate = day before salary day, so +1 gives days until actual salary arrival
    final diff = end.difference(today).inDays + 1;
    return diff < 0 ? 0 : diff;
  }

  int daysElapsed(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final diff = today.difference(start).inDays;
    return diff < 0 ? 0 : diff;
  }
}
