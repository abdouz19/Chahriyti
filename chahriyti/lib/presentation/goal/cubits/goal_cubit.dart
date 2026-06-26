import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/goal/create_goal_use_case.dart';
import '../../../application/use_cases/goal/delete_goal_use_case.dart';
import '../../../application/use_cases/goal/get_goals_use_case.dart';
import '../../../application/use_cases/goal/update_goal_use_case.dart';
import '../../../core/constants/notification_messages.dart';
import '../../../infrastructure/services/notification_service.dart';
import 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  final CreateGoalUseCase _createGoalUseCase;
  final GetGoalsUseCase _getGoalsUseCase;
  final UpdateGoalUseCase _updateGoalUseCase;
  final DeleteGoalUseCase _deleteGoalUseCase;
  final NotificationService? _notificationService;

  GoalCubit(
    this._createGoalUseCase,
    this._getGoalsUseCase,
    this._updateGoalUseCase,
    this._deleteGoalUseCase, {
    NotificationService? notificationService,
  })  : _notificationService = notificationService,
        super(const GoalState.initial());

  Future<void> loadGoals({int limit = 20, int offset = 0}) async {
    emit(const GoalState.loading());
    try {
      final goals = await _getGoalsUseCase(limit: limit, offset: offset);
      emit(GoalState.goalsLoaded(
        goals,
        hasMore: goals.length == limit,
        offset: offset,
      ));
    } catch (e) {
      emit(GoalState.error('فشل تحميل الأهداف: ${e.toString()}'));
    }
  }

  Future<void> createGoal({
    required String name,
    required int targetAmount,
    String? description,
  }) async {
    emit(const GoalState.loading());
    try {
      final request = CreateGoalRequest(
        name: name,
        targetAmount: targetAmount,
        description: description,
      );
      final goalId = await _createGoalUseCase(request);
      emit(GoalState.goalCreated(goalId));

      // Send motivational notification
      _notificationService?.checkNotifications();

      // Reload goals
      await loadGoals();
    } catch (e) {
      emit(GoalState.error('فشل إنشاء الهدف: ${e.toString()}'));
    }
  }

  Future<void> updateGoal({
    required int id,
    String? name,
    int? targetAmount,
    String? description,
  }) async {
    emit(const GoalState.loading());
    try {
      final request = UpdateGoalRequest(
        id: id,
        name: name,
        targetAmount: targetAmount,
        description: description,
      );
      await _updateGoalUseCase(request);
      emit(const GoalState.goalUpdated());
      // Reload goals
      await loadGoals();
    } catch (e) {
      emit(GoalState.error('فشل تحديث الهدف: ${e.toString()}'));
    }
  }

  Future<void> deleteGoal(int id) async {
    emit(const GoalState.loading());
    try {
      await _deleteGoalUseCase(id);
      emit(const GoalState.goalDeleted());
      // Reload goals
      await loadGoals();
    } catch (e) {
      emit(GoalState.error('فشل حذف الهدف: ${e.toString()}'));
    }
  }

  Future<void> refresh() async {
    await loadGoals();
  }
}
