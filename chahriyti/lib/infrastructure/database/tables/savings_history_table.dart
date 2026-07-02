import 'package:drift/drift.dart';

@DataClassName('SavingsHistoryRow')
class SavingsHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'deposit' or 'withdrawal'
  IntColumn get amount => integer()();
  TextColumn get description => text()();
  IntColumn get relatedCycleId => integer().nullable()();
  IntColumn get relatedExpenseId => integer().nullable()();
  IntColumn get relatedDebtPaymentId => integer().nullable()();
  IntColumn get relatedLendingId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
