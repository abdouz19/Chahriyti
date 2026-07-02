// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lendings_dao.dart';

// ignore_for_file: type=lint
mixin _$LendingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $LendingsTable get lendings => attachedDatabase.lendings;
  $LendingCollectionsTable get lendingCollections =>
      attachedDatabase.lendingCollections;
  LendingsDaoManager get managers => LendingsDaoManager(this);
}

class LendingsDaoManager {
  final _$LendingsDaoMixin _db;
  LendingsDaoManager(this._db);
  $$LendingsTableTableManager get lendings =>
      $$LendingsTableTableManager(_db.attachedDatabase, _db.lendings);
  $$LendingCollectionsTableTableManager get lendingCollections =>
      $$LendingCollectionsTableTableManager(
        _db.attachedDatabase,
        _db.lendingCollections,
      );
}
