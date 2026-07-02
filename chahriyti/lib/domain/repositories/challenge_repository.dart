import '../entities/weekly_challenge_entity.dart';

abstract class ChallengeRepository {
  Future<WeeklyChallengeEntity?> getChallengeById(int id);

  Future<WeeklyChallengeEntity?> getActiveChallengeForWeek(
    DateTime weekStart,
    DateTime weekEnd,
  );

  Future<List<WeeklyChallengeEntity>> getActiveChallenges();

  Future<int> createChallenge({
    required DateTime weekStartDate,
    required int targetAmount,
    required String description,
  });

  Future<void> markCompleted(int id);

  Future<void> deleteChallenge(int id);
}
