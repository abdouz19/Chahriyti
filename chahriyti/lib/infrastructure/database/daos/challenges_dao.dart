import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/weekly_challenges_table.dart';

part 'challenges_dao.g.dart';

@DriftAccessor(tables: [WeeklyChallenges])
class ChallengesDao extends DatabaseAccessor<AppDatabase>
    with _$ChallengesDaoMixin {
  ChallengesDao(super.db);

  Future<int> insertChallenge(WeeklyChallengesCompanion challenge) =>
      into(weeklyChallenges).insert(challenge);

  Future<WeeklyChallengeRow?> getChallengeById(int id) =>
      (select(weeklyChallenges)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<WeeklyChallengeRow?> getActiveChallengeForWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    final list = await (select(weeklyChallenges)
          ..where((t) => t.isCompleted.equals(false)))
        .get();

    try {
      return list.firstWhere((row) =>
          row.weekStart.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          row.weekStart.isBefore(weekEnd.add(const Duration(days: 1))));
    } catch (e) {
      return null;
    }
  }

  Future<List<WeeklyChallengeRow>> getActiveChallenges() =>
      (select(weeklyChallenges)
            ..where((t) => t.isCompleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.weekStart)]))
          .get();

  Future<void> markChallengeCompleted(int id) =>
      (update(weeklyChallenges)..where((t) => t.id.equals(id)))
          .write(const WeeklyChallengesCompanion(isCompleted: Value(true)));

  Future<void> deleteChallenge(int id) =>
      (delete(weeklyChallenges)..where((t) => t.id.equals(id))).go();
}
