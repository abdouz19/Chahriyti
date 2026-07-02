import 'package:drift/drift.dart';

@DataClassName('AdditionalIncomeRow')
class AdditionalIncomes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cycleId => integer()();
  TextColumn get description => text()();
  IntColumn get amount => integer()();
  BoolColumn get toSavings => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
