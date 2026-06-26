// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incomes_dao.dart';

// ignore_for_file: type=lint
mixin _$IncomesDaoMixin on DatabaseAccessor<AppDatabase> {
  $AdditionalIncomesTable get additionalIncomes =>
      attachedDatabase.additionalIncomes;
  IncomesDaoManager get managers => IncomesDaoManager(this);
}

class IncomesDaoManager {
  final _$IncomesDaoMixin _db;
  IncomesDaoManager(this._db);
  $$AdditionalIncomesTableTableManager get additionalIncomes =>
      $$AdditionalIncomesTableTableManager(
        _db.attachedDatabase,
        _db.additionalIncomes,
      );
}
