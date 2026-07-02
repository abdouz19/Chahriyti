import 'package:drift/drift.dart';

@DataClassName('DebtPaymentRow')
class DebtPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get debtId => integer()();
  IntColumn get cycleId => integer()();
  IntColumn get amount => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get fromSavings => boolean().withDefault(const Constant(false))();
  IntColumn get savingsAmount => integer().withDefault(const Constant(0))();
}
