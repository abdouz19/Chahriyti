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
import 'tables/savings_history_table.dart';
import 'tables/lending_collections_table.dart';
import 'tables/lendings_table.dart';
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
  SavingsHistory,
  Lendings,
  LendingCollections,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1 && to == 2) {
            await m.create(financialInsights);
          }
          if (from == 2 && to == 3) {
            await m.addColumn(users, users.challengesEnabled);
            await m.addColumn(debts, debts.notes);
            await m.create(weeklyChallenges);
          }
          if (from < 4) {
            await m.create(savingsHistory);
            await m.addColumn(expenses, expenses.fromSavings);
            await m.addColumn(debtPayments, debtPayments.fromSavings);
          }
          if (from < 5) {
            await m.addColumn(
                financialCycles, financialCycles.salarySplitAmount);
          }
          if (from < 6) {
            await m.create(lendings);
            await m.create(lendingCollections);
            await m.addColumn(
                savingsHistory, savingsHistory.relatedLendingId);
          }
          if (from == 6) {
            await m.addColumn(
                lendingCollections, lendingCollections.toSavings);
          }
          if (from < 8) {
            await m.addColumn(
                additionalIncomes, additionalIncomes.toSavings);
          }
          if (from < 9) {
            await m.addColumn(expenses, expenses.savingsAmount);
            await m.addColumn(debtPayments, debtPayments.savingsAmount);
            await m.addColumn(lendings, lendings.savingsAmount);
          }
          if (from < 10) {
            await m.addColumn(debts, debts.cycleId);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA journal_mode=WAL;');
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );

  /// Deletes all financial data, keeping users and license_activations intact.
  Future<void> resetFinancialData() async {
    await transaction(() async {
      await delete(lendingCollections).go();
      await delete(lendings).go();
      await delete(savingsContributions).go();
      await delete(savingsGoals).go();
      await delete(savingsHistory).go();
      await delete(debtPayments).go();
      await delete(debts).go();
      await delete(expenses).go();
      await delete(additionalIncomes).go();
      await delete(financialInsights).go();
      await delete(weeklyChallenges).go();
      await delete(financialCycles).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/chahriyti.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}
