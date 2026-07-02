import 'package:drift/drift.dart';

@DataClassName('LendingRow')
class Lendings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get borrowerName => text()();
  IntColumn get totalAmount => integer()();
  IntColumn get collectedAmount => integer().withDefault(const Constant(0))();
  BoolColumn get isFullyCollected =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get fromSavings => boolean().withDefault(const Constant(false))();
  IntColumn get savingsAmount => integer().withDefault(const Constant(0))();
  IntColumn get cycleId => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
