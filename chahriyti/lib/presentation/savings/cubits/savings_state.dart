import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/savings_history_entity.dart';

part 'savings_state.freezed.dart';

@freezed
sealed class SavingsState with _$SavingsState {
  const factory SavingsState.loading() = SavingsLoading;
  const factory SavingsState.loaded({
    required int balance,
    required List<SavingsHistoryEntity> history,
    @Default(false) bool hasMore,
    @Default(0) int offset,
  }) = SavingsLoaded;
  const factory SavingsState.error(String message) = SavingsError;
}
