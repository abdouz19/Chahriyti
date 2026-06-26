import '../../../domain/repositories/goal_repository.dart';

class DeleteGoalUseCase {
  final GoalRepository _repository;

  DeleteGoalUseCase(this._repository);

  Future<void> call(int goalId) async {
    if (goalId <= 0) {
      throw ArgumentError('Goal ID must be valid');
    }
    await _repository.deleteGoal(goalId);
  }
}
