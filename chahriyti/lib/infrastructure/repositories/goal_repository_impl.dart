import 'package:drift/drift.dart';

import '../../domain/entities/savings_goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import '../database/app_database.dart';
import '../database/daos/goals_dao.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalsDao _dao;

  GoalRepositoryImpl(this._dao);

  SavingsGoalEntity _toEntity(SavingsGoalRow row) => SavingsGoalEntity(
        id: row.id,
        name: row.name,
        targetAmount: row.targetAmount,
        savedAmount: row.savedAmount,
        isAchieved: row.isAchieved,
        createdAt: row.createdAt,
      );

  @override
  Future<SavingsGoalEntity> createGoal({
    required String name,
    required int targetAmount,
  }) async {
    final id = await _dao.insertGoal(
      SavingsGoalsCompanion(
        name: Value(name),
        targetAmount: Value(targetAmount),
        savedAmount: const Value(0),
        isAchieved: const Value(false),
      ),
    );
    final rows = await _dao.getGoals();
    final row = rows.firstWhere((r) => r.id == id);
    return _toEntity(row);
  }

  @override
  Future<void> contribute({
    required int goalId,
    required int amount,
    required int cycleId,
  }) =>
      _dao.insertContribution(
        goalId: goalId,
        cycleId: cycleId,
        amount: amount,
      );

  @override
  Future<List<SavingsGoalEntity>> getGoals() async {
    final rows = await _dao.getGoals();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<SavingsGoalEntity>> getActiveGoals() async {
    final rows = await _dao.getActiveGoals();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<int> getTotalContributionsForCycle(int cycleId) =>
      _dao.getTotalContributionsForCycle(cycleId);
}
