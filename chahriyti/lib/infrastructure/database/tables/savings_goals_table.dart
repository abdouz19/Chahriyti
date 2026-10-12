import 'package:drift/drift.dart';

@DataClassName('SavingsGoalRow')
class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get targetAmount => integer()();
  IntColumn get savedAmount => integer().withDefault(const Constant(0))();
  BoolColumn get isAchieved => boolean().withDefault(const Constant(false))();
  // Set when bought: the price paid and the savings withdrawal it created,
  // so the purchase can be undone exactly
  IntColumn get purchasedAmount => integer().nullable()();
  IntColumn get purchaseTransactionId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
