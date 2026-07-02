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

  Future<List<GoalEntity>> getActiveGoals({
    int? limit,
    int? offset,
  }) async {
    return _repository.getActiveGoalsPaginated(limit: limit, offset: offset);
  }

  Future<List<GoalEntity>> getCompletedGoals({
    int? limit,
    int? offset,
  }) async {
    return _repository.getCompletedGoals(limit: limit, offset: offset);
  }
}
