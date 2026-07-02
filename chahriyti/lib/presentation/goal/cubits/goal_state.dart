import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/goal_entity.dart';

part 'goal_state.freezed.dart';

@freezed
class GoalState with _$GoalState {
  const factory GoalState.initial() = GoalInitial;

  const factory GoalState.loading() = GoalLoading;

  const factory GoalState.goalsLoaded(
    List<GoalEntity> goals, {
    @Default(false) bool hasMore,
    @Default(0) int offset,
    @Default(false) bool isCompletedTab,
  }) = GoalsLoaded;

  const factory GoalState.goalLoaded(GoalEntity goal) = GoalLoaded;

  const factory GoalState.goalCreated(int goalId) = GoalCreated;

  const factory GoalState.goalUpdated() = GoalUpdated;

  const factory GoalState.goalDeleted() = GoalDeleted;

  const factory GoalState.error(String message) = GoalError;
}
