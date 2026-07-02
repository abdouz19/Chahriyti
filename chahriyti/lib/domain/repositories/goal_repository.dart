import '../entities/goal_entity.dart';
import '../entities/savings_goal_entity.dart';

abstract class GoalRepository {
  Future<GoalEntity?> getGoalById(int id);

  Future<List<GoalEntity>> getUserGoals({
    int limit = 20,
    int offset = 0,
  });

  Future<int> createGoal({
    required String name,
    required int targetAmount,
    String? description,
  });

  Future<void> updateGoal({
    required int id,
    String? name,
    int? targetAmount,
    String? description,
  });

  Future<void> deleteGoal(int id);

  Future<void> markGoalCompleted(int id);

  Future<void> contribute({
    required int goalId,
    required int amount,
    required int cycleId,
  });

  Future<List<GoalEntity>> getActiveGoalsPaginated({int? limit, int? offset});

  Future<List<GoalEntity>> getCompletedGoals({int? limit, int? offset});

  // Legacy methods for backward compatibility with dashboard
  Future<List<SavingsGoalEntity>> getActiveGoals();
}
