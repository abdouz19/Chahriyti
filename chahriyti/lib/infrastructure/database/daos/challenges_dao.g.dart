// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenges_dao.dart';

// ignore_for_file: type=lint
mixin _$ChallengesDaoMixin on DatabaseAccessor<AppDatabase> {
  $WeeklyChallengesTable get weeklyChallenges =>
      attachedDatabase.weeklyChallenges;
  ChallengesDaoManager get managers => ChallengesDaoManager(this);
}

class ChallengesDaoManager {
  final _$ChallengesDaoMixin _db;
  ChallengesDaoManager(this._db);
  $$WeeklyChallengesTableTableManager get weeklyChallenges =>
      $$WeeklyChallengesTableTableManager(
        _db.attachedDatabase,
        _db.weeklyChallenges,
      );
}
