import '../../../domain/repositories/goal_repository.dart';

class CreateGoalRequest {
  final String name;
  final int targetAmount; // in centimes
  final String? description;

  CreateGoalRequest({
    required this.name,
    required this.targetAmount,
    this.description,
  });
}

class CreateGoalUseCase {
  final GoalRepository _repository;

  CreateGoalUseCase(this._repository);

  Future<int> call(CreateGoalRequest request) async {
    // Validate
    if (request.name.isEmpty) {
      throw ArgumentError('Goal name cannot be empty');
    }
    if (request.targetAmount <= 0) {
      throw ArgumentError('Target amount must be greater than zero');
    }

    // Create goal via repository
    final goalId = await _repository.createGoal(
      name: request.name,
      targetAmount: request.targetAmount,
      description: request.description,
    );

    return goalId;
  }
}
