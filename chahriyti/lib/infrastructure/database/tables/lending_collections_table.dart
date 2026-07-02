import 'package:drift/drift.dart';

@DataClassName('LendingCollectionRow')
class LendingCollections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lendingId => integer()();
  IntColumn get amount => integer()();
  BoolColumn get toSavings => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
