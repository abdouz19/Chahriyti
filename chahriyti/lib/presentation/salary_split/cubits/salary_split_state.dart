import 'package:freezed_annotation/freezed_annotation.dart';

part 'salary_split_state.freezed.dart';

@freezed
sealed class SalarySplitState with _$SalarySplitState {
  const factory SalarySplitState.initial({
    required int salaryAmount,
  }) = SalarySplitInitial;

  const factory SalarySplitState.editing({
    required int salaryAmount,
    required int allocationAmount,
    required int remainingBalance,
  }) = SalarySplitEditing;

  const factory SalarySplitState.confirming() = SalarySplitConfirming;

  const factory SalarySplitState.complete() = SalarySplitComplete;

  const factory SalarySplitState.error(String message) = SalarySplitError;
}
