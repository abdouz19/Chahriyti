import 'package:drift/drift.dart';

@DataClassName('FinancialCycleRow')
class FinancialCycles extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get salaryAmount => integer()();
  IntColumn get salarySplitAmount =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
