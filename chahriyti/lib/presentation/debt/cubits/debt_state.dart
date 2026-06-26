import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/debt_entity.dart';

part 'debt_state.freezed.dart';

@freezed
class DebtState with _$DebtState {
  const factory DebtState.initial() = DebtInitial;

  const factory DebtState.loading() = DebtLoading;

  const factory DebtState.debtsLoaded(
    List<DebtEntity> debts, {
    @Default(false) bool hasMore,
    @Default(0) int offset,
  }) = DebtsLoaded;

  const factory DebtState.debtCreated(int debtId) = DebtCreated;

  const factory DebtState.debtUpdated() = DebtUpdated;

  const factory DebtState.debtDeleted() = DebtDeleted;

  const factory DebtState.paymentAdded() = PaymentAdded;

  const factory DebtState.error(String message) = DebtError;
}
