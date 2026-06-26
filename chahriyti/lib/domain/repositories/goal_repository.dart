import '../entities/goal_entity.dart';

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
}
