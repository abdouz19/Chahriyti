// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_dao.dart';

// ignore_for_file: type=lint
mixin _$SavingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SavingsHistoryTable get savingsHistory => attachedDatabase.savingsHistory;
  SavingsDaoManager get managers => SavingsDaoManager(this);
}

class SavingsDaoManager {
  final _$SavingsDaoMixin _db;
  SavingsDaoManager(this._db);
  $$SavingsHistoryTableTableManager get savingsHistory =>
      $$SavingsHistoryTableTableManager(
        _db.attachedDatabase,
        _db.savingsHistory,
      );
}
