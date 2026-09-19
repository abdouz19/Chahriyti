import 'package:drift/drift.dart';

@DataClassName('CustomCategoryRow')
class CustomCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get iconCodePoint => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
