import 'package:drift/drift.dart';

@DataClassName('WeeklyChallengeRow')
class WeeklyChallenges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cycleId => integer()();
  DateTimeColumn get weekStart => dateTime()();
  IntColumn get targetAmount => integer()();
  TextColumn get description => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
