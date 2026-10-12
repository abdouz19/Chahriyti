import 'package:drift/drift.dart';

@DataClassName('LendingCollectionRow')
class LendingCollections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lendingId => integer()();
  IntColumn get amount => integer()();
  BoolColumn get toSavings => boolean().withDefault(const Constant(false))();
  // Cycle the money came back in; null for pre-v15 rows (falls back to lending's cycle)
  IntColumn get cycleId => integer().nullable()();
  // Signed balance correction from editing a lending's amount; not a real
  // collection (hidden from history, doesn't change collectedAmount)
  BoolColumn get isAdjustment => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
