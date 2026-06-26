import 'package:drift/drift.dart';

@DataClassName('SavingsGoalRow')
class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get targetAmount => integer()();
  IntColumn get savedAmount => integer().withDefault(const Constant(0))();
  BoolColumn get isAchieved => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
