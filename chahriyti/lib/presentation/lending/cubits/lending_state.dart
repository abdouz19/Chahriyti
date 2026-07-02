import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/lending_collection_entity.dart';
import '../../../domain/entities/lending_entity.dart';

part 'lending_state.freezed.dart';

@freezed
sealed class LendingState with _$LendingState {
  const factory LendingState.initial() = LendingInitial;
  const factory LendingState.loading() = LendingLoading;
  const factory LendingState.lendingsLoaded(
    List<LendingEntity> lendings, {
    @Default(false) bool hasMore,
    @Default(0) int offset,
    @Default(false) bool isCollectedTab,
  }) = LendingsLoaded;
  const factory LendingState.lendingLoaded(
    LendingEntity lending,
    List<LendingCollectionEntity> collections,
  ) = LendingLoaded;
  const factory LendingState.lendingCreated(LendingEntity lending) =
      LendingCreated;
  const factory LendingState.lendingDeleted() = LendingDeleted;
  const factory LendingState.collectionAdded() = CollectionAdded;
  const factory LendingState.error(String message) = LendingError;
}
