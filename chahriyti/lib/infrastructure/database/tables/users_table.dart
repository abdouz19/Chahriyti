import 'package:drift/drift.dart';

@DataClassName('UserRow')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get monthlySalary => integer()();
  IntColumn get salaryDay => integer()();
  TextColumn get fullName => text().withDefault(const Constant(''))();
  TextColumn get phoneNumber => text().withDefault(const Constant(''))();
  IntColumn get wilayaCode => integer().withDefault(const Constant(0))();
  BoolColumn get isActivated => boolean().withDefault(const Constant(false))();
  BoolColumn get challengesEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get initialBalance => integer().nullable()();
  BoolColumn get hasCompletedFinancialSetup => boolean().withDefault(const Constant(false))();
  IntColumn get financialSetupStep => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
