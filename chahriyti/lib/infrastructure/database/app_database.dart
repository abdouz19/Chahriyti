import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/additional_incomes_table.dart';
import 'tables/debt_payments_table.dart';
import 'tables/debts_table.dart';
import 'tables/expenses_table.dart';
import 'tables/financial_cycles_table.dart';
import 'tables/financial_insights_table.dart';
import 'tables/license_activations_table.dart';
import 'tables/savings_contributions_table.dart';
import 'tables/savings_goals_table.dart';
import 'tables/users_table.dart';
import 'tables/weekly_challenges_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Users,
  FinancialCycles,
  Expenses,
  AdditionalIncomes,
  Debts,
  DebtPayments,
  SavingsGoals,
  SavingsContributions,
  WeeklyChallenges,
  FinancialInsights,
  LicenseActivations,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1 && to == 2) {
            // Create the new FinancialInsights table for existing users
            await m.create(financialInsights);
          }
        },
        beforeOpen: (details) async {
          // Enable WAL mode for better concurrent read performance
          await customStatement('PRAGMA journal_mode=WAL;');
          // Enable foreign keys
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/chahriyti.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}
