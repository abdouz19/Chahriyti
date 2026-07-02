import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/goal/create_goal_use_case.dart';
import '../../../application/use_cases/goal/delete_goal_use_case.dart';
import '../../../application/use_cases/goal/get_goals_use_case.dart';
import '../../../application/use_cases/goal/update_goal_use_case.dart';
import '../../../application/use_cases/savings/withdraw_savings_use_case.dart';
import '../../../domain/repositories/goal_repository.dart';
import '../../../infrastructure/services/notification_service.dart';
import 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  final CreateGoalUseCase _createGoalUseCase;
  final GetGoalsUseCase _getGoalsUseCase;
  final UpdateGoalUseCase _updateGoalUseCase;
  final DeleteGoalUseCase _deleteGoalUseCase;
  final WithdrawSavingsUseCase? _withdrawSavingsUseCase;
  final GoalRepository? _goalRepository;
  final NotificationService? _notificationService;

  static const _pageSize = 10;
  bool _isLoadingMore = false;

  GoalCubit(
    this._createGoalUseCase,
    this._getGoalsUseCase,
    this._updateGoalUseCase,
    this._deleteGoalUseCase, {
    WithdrawSavingsUseCase? withdrawSavingsUseCase,
    GoalRepository? goalRepository,
    NotificationService? notificationService,
  })  : _withdrawSavingsUseCase = withdrawSavingsUseCase,
        _goalRepository = goalRepository,
        _notificationService = notificationService,
        super(const GoalState.initial());

  Future<void> loadGoals() async {
    emit(const GoalState.loading());
    try {
      final goals = await _getGoalsUseCase.getActiveGoals(
        limit: _pageSize,
        offset: 0,
      );
      emit(GoalState.goalsLoaded(
        goals,
        hasMore: goals.length == _pageSize,
        offset: _pageSize,
      ));
    } catch (e) {
      emit(GoalState.error('فشل تحميل الأهداف: ${e.toString()}'));
    }
  }

  Future<void> loadCompletedGoals() async {
    emit(const GoalState.loading());
    try {
      final goals = await _getGoalsUseCase.getCompletedGoals(
        limit: _pageSize,
        offset: 0,
      );
      emit(GoalState.goalsLoaded(
        goals,
        isCompletedTab: true,
        hasMore: goals.length == _pageSize,
        offset: _pageSize,
      ));
    } catch (e) {
      emit(GoalState.error('فشل تحميل الأهداف: ${e.toString()}'));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! GoalsLoaded || !currentState.hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    try {
      final newGoals = currentState.isCompletedTab
          ? await _getGoalsUseCase.getCompletedGoals(
              limit: _pageSize,
              offset: currentState.offset,
            )
          : await _getGoalsUseCase.getActiveGoals(
              limit: _pageSize,
              offset: currentState.offset,
            );
      emit(GoalState.goalsLoaded(
        [...currentState.goals, ...newGoals],
        hasMore: newGoals.length == _pageSize,
        offset: currentState.offset + _pageSize,
        isCompletedTab: currentState.isCompletedTab,
      ));
    } catch (_) {}
    _isLoadingMore = false;
  }

  Future<void> loadGoalById(int goalId) async {
    emit(const GoalState.loading());
    try {
      final allGoals = await _getGoalsUseCase();
      final goal = allGoals.firstWhere(
        (g) => g.id == goalId,
        orElse: () => throw Exception('الهدف غير موجود'),
      );
      emit(GoalState.goalLoaded(goal));
    } catch (e) {
      emit(GoalState.error('فشل تحميل تفاصيل الهدف: ${e.toString()}'));
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

  Future<void> purchaseGoal({
    required int goalId,
    required int amount,
    required String goalName,
  }) async {
    emit(const GoalState.loading());
    try {
      await _withdrawSavingsUseCase!(
        amount: amount,
        description: 'شراء هدف - $goalName',
      );
      await _goalRepository!.markGoalCompleted(goalId);
      emit(const GoalState.goalUpdated());
    } catch (e) {
      emit(GoalState.error('فشل عملية الشراء: ${e.toString()}'));
    }
  }

  Future<void> refresh() async {
    await loadGoals();
  }
}
