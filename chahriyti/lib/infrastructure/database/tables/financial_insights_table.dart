import 'package:drift/drift.dart';

@DataClassName('FinancialInsightRow')
class FinancialInsights extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cycleId => integer()();
  TextColumn get insightType => text()(); // 'leak', 'trend', 'classification'
  TextColumn get category => text().nullable()();
  TextColumn get metric => text()();
  RealColumn get value => real()();
  TextColumn get suggestion => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime()();
}
