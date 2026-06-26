import '../../../domain/entities/challenge_entity.dart';
import '../../../domain/repositories/challenge_repository.dart';

class GetActiveChallengeUseCase {
  final ChallengeRepository _repository;

  GetActiveChallengeUseCase(this._repository);

  /// Get current week's active challenge if it exists
  Future<ChallengeEntity?> call() async {
    final now = DateTime.now();
    // Get week start (Monday)
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    return _repository.getActiveChallengeForWeek(weekStart, weekEnd);
  }

  /// Get all active (non-completed) challenges
  Future<List<ChallengeEntity>> getAll() async {
    return _repository.getActiveChallenges();
  }
}
