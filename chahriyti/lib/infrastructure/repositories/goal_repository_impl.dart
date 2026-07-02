import 'package:drift/drift.dart';

import '../../domain/entities/goal_entity.dart';
import '../../domain/entities/savings_goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import '../database/app_database.dart';
import '../database/daos/goals_dao.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalsDao _dao;

  GoalRepositoryImpl(this._dao);

  SavingsGoalEntity _toSavingsEntity(SavingsGoalRow row) => SavingsGoalEntity(
        id: row.id,
        name: row.name,
        targetAmount: row.targetAmount,
        savedAmount: row.savedAmount,
        isAchieved: row.isAchieved,
        createdAt: row.createdAt,
      );

  GoalEntity _toEntity(SavingsGoalRow row) => GoalEntity(
        id: row.id,
        name: row.name,
        targetAmount: row.targetAmount,
        savedAmount: row.savedAmount,
        description: null,
        createdAt: row.createdAt,
        completedAt: row.isAchieved ? row.createdAt : null,
      );

  @override
  Future<int> createGoal({
    required String name,
    required int targetAmount,
    String? description,
  }) async {
    return _dao.insertGoal(
      SavingsGoalsCompanion(
        name: Value(name),
        targetAmount: Value(targetAmount),
        savedAmount: const Value(0),
        isAchieved: const Value(false),
      ),
    );
  }

  @override
  Future<GoalEntity?> getGoalById(int id) async {
    final rows = await _dao.getGoals();
    try {
      final row = rows.firstWhere((r) => r.id == id);
      return _toEntity(row);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<GoalEntity>> getUserGoals({
    int limit = 20,
    int offset = 0,
  }) async {
    final rows = await _dao.getGoals();
    // Simple pagination in memory
    final paginated =
        rows.skip(offset).take(limit);
    return paginated.map(_toEntity).toList();
  }

  @override
  Future<void> updateGoal({
    required int id,
    String? name,
    int? targetAmount,
    String? description,
  }) async {
    await _dao.updateGoal(
      id: id,
      name: name,
      targetAmount: targetAmount,
    );
  }

  @override
  Future<void> deleteGoal(int id) async {
    await _dao.deleteGoal(id);
  }

  @override
  Future<List<GoalEntity>> getActiveGoalsPaginated({int? limit, int? offset}) async {
    final rows = await _dao.getActiveGoals(limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<GoalEntity>> getCompletedGoals({int? limit, int? offset}) async {
    final rows = await _dao.getCompletedGoals(limit: limit, offset: offset);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<void> markGoalCompleted(int id) async {
    await _dao.markGoalAchieved(id);
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

  // Legacy methods for backward compatibility
  Future<List<SavingsGoalEntity>> getGoals() async {
    final rows = await _dao.getGoals();
    return rows.map(_toSavingsEntity).toList();
  }

  Future<List<SavingsGoalEntity>> getActiveGoalsLegacy() async {
    final rows = await _dao.getActiveGoals();
    return rows.map(_toSavingsEntity).toList();
  }

  @override
  Future<List<SavingsGoalEntity>> getActiveGoals() async {
    final rows = await _dao.getActiveGoals();
    return rows.map(_toSavingsEntity).toList();
  }

  Future<int> getTotalContributionsForCycle(int cycleId) =>
      _dao.getTotalContributionsForCycle(cycleId);
}
