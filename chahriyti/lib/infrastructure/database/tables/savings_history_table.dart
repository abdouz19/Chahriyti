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
  IntColumn get relatedIncomeId => integer().nullable()();
  // 'initial' (setup savings) or 'transfer' (manual move with the balance,
  // counted in that cycle's balance). Null: created by another feature.
  TextColumn get kind => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
