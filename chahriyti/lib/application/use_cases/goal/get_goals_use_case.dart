import '../../../domain/entities/goal_entity.dart';
import '../../../domain/repositories/goal_repository.dart';

class GetGoalsUseCase {
  final GoalRepository _repository;

  GetGoalsUseCase(this._repository);

  Future<List<GoalEntity>> call({
    int limit = 20,
    int offset = 0,
  }) async {
    return _repository.getUserGoals(limit: limit, offset: offset);
  }

  /// Get incomplete goals only
  Future<List<GoalEntity>> getIncompleteGoals({
    int limit = 20,
    int offset = 0,
  }) async {
    final allGoals = await _repository.getUserGoals(limit: limit, offset: offset);
    return allGoals.where((goal) => !goal.isCompleted).toList();
  }
}
