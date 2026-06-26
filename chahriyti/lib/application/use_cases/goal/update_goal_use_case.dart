import '../../../domain/repositories/goal_repository.dart';

class UpdateGoalRequest {
  final int id;
  final String? name;
  final int? targetAmount; // in centimes
  final String? description;

  UpdateGoalRequest({
    required this.id,
    this.name,
    this.targetAmount,
    this.description,
  });
}

class UpdateGoalUseCase {
  final GoalRepository _repository;

  UpdateGoalUseCase(this._repository);

  Future<void> call(UpdateGoalRequest request) async {
    // Validate
    if (request.targetAmount != null && request.targetAmount! <= 0) {
      throw ArgumentError('Target amount must be greater than zero');
    }

    // Update via repository
    await _repository.updateGoal(
      id: request.id,
      name: request.name,
      targetAmount: request.targetAmount,
      description: request.description,
    );
  }
}
