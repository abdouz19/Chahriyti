import 'package:drift/drift.dart';

import '../../domain/entities/weekly_challenge_entity.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../database/app_database.dart';
import '../database/daos/challenges_dao.dart';

class ChallengeRepositoryImpl implements ChallengeRepository {
  final ChallengesDao _dao;

  ChallengeRepositoryImpl(this._dao);

  WeeklyChallengeEntity _toEntity(WeeklyChallengeRow row) =>
      WeeklyChallengeEntity(
        id: row.id,
        cycleId: row.cycleId,
        weekStart: row.weekStart,
        targetAmount: row.targetAmount,
        description: row.description,
        isCompleted: row.isCompleted,
        createdAt: row.createdAt,
      );

  @override
  Future<WeeklyChallengeEntity?> getChallengeById(int id) async {
    final row = await _dao.getChallengeById(id);
    return row != null ? _toEntity(row) : null;
  }

  @override
  Future<WeeklyChallengeEntity?> getActiveChallengeForWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    final row = await _dao.getActiveChallengeForWeek(weekStart, weekEnd);
    return row != null ? _toEntity(row) : null;
  }

  @override
  Future<List<WeeklyChallengeEntity>> getActiveChallenges() async {
    final rows = await _dao.getActiveChallenges();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<int> createChallenge({
    required DateTime weekStartDate,
    required int targetAmount,
    required String description,
  }) async {
    return _dao.insertChallenge(
      WeeklyChallengesCompanion(
        weekStart: Value(weekStartDate),
        targetAmount: Value(targetAmount),
        description: Value(description),
        isCompleted: const Value(false),
      ),
    );
  }

  @override
  Future<void> markCompleted(int id) async {
    return _dao.markChallengeCompleted(id);
  }

  @override
  Future<void> deleteChallenge(int id) async {
    return _dao.deleteChallenge(id);
  }
}
