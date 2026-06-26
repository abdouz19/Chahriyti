// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycles_dao.dart';

// ignore_for_file: type=lint
mixin _$CyclesDaoMixin on DatabaseAccessor<AppDatabase> {
  $FinancialCyclesTable get financialCycles => attachedDatabase.financialCycles;
  CyclesDaoManager get managers => CyclesDaoManager(this);
}

class CyclesDaoManager {
  final _$CyclesDaoMixin _db;
  CyclesDaoManager(this._db);
  $$FinancialCyclesTableTableManager get financialCycles =>
      $$FinancialCyclesTableTableManager(
        _db.attachedDatabase,
        _db.financialCycles,
      );
}
