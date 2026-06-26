import '../../../domain/repositories/goal_repository.dart';

class ContributeToGoalUseCase {
  final GoalRepository _repo;

  const ContributeToGoalUseCase(this._repo);

  Future<void> call({
    required int goalId,
    required int amount,
    required int cycleId,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('مبلغ المساهمة يجب أن يكون أكبر من الصفر');
    }
    await _repo.contribute(
      goalId: goalId,
      amount: amount,
      cycleId: cycleId,
    );
  }
}
