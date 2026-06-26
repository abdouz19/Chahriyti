import 'package:drift/drift.dart';

@DataClassName('ExpenseRow')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cycleId => integer()();
  TextColumn get category => text()();
  TextColumn get subcategory => text()();
  TextColumn get itemName => text()();
  IntColumn get amount => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
