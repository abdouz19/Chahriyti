import 'package:drift/drift.dart';

@DataClassName('WeeklyChallengeRow')
class WeeklyChallenges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cycleId => integer()();
  DateTimeColumn get weekStart => dateTime()();
  IntColumn get targetReduction => integer()();
  IntColumn get previousWeekSpending => integer()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
