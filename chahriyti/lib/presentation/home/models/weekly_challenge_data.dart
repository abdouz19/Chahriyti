import '../../../domain/entities/weekly_challenge_entity.dart';

class WeeklyChallengeData {
  final int weekNumber;
  final String description;
  final int targetAmount;
  final bool isCompleted;

  WeeklyChallengeData({
    required this.weekNumber,
    required this.description,
    required this.targetAmount,
    required this.isCompleted,
  });

  factory WeeklyChallengeData.fromEntity(WeeklyChallengeEntity entity) {
    // Calculate week number from weekStart date
    final now = DateTime.now();
    final weekDiff = now.difference(entity.weekStart).inDays ~/ 7;
    final weekNumber = weekDiff.abs() + 1;

    return WeeklyChallengeData(
      weekNumber: weekNumber,
      description: entity.description,
      targetAmount: entity.targetAmount,
      isCompleted: entity.isCompleted,
    );
  }
}
