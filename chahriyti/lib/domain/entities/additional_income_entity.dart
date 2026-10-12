import 'package:freezed_annotation/freezed_annotation.dart';

part 'additional_income_entity.freezed.dart';
part 'additional_income_entity.g.dart';

@freezed
abstract class AdditionalIncomeEntity with _$AdditionalIncomeEntity {
  const AdditionalIncomeEntity._();

  const factory AdditionalIncomeEntity({
    required int id,
    required int cycleId,
    required String description,
    required int amount,
    required DateTime createdAt,
    @Default(false) bool toSavings,
  }) = _AdditionalIncomeEntity;

  /// Opening balance entered at setup, stored as an income.
  bool get isInitialBalance =>
      description == 'رصيد أولي' || description == 'رصيد اولي';

  factory AdditionalIncomeEntity.fromJson(Map<String, dynamic> json) =>
      _$AdditionalIncomeEntityFromJson(json);
}
