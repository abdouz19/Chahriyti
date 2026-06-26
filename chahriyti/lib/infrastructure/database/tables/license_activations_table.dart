import 'package:drift/drift.dart';

@DataClassName('LicenseActivationRow')
class LicenseActivations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceId => text()();
  TextColumn get licenseKey => text().nullable()();
  TextColumn get expiryDate => text().nullable()();
  DateTimeColumn get activatedAt => dateTime().nullable()();
}
