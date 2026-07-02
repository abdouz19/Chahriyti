import 'package:drift/drift.dart';

@DataClassName('DebtRow')
class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get creditorName => text()();
  IntColumn get totalAmount => integer()();
  IntColumn get paidAmount => integer().withDefault(const Constant(0))();
  BoolColumn get isFullyPaid => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // nullable: old records pre-v10 have no cycleId
  IntColumn get cycleId => integer().nullable()();
}
