import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/additional_incomes_table.dart';
import 'tables/custom_categories_table.dart';
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
  CustomCategories,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 19;

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
          if (from < 11) {
            await m.addColumn(users, users.initialBalance);
            await m.addColumn(
                users, users.hasCompletedFinancialSetup);
            await m.addColumn(users, users.financialSetupStep);
            // Existing activated users skip the wizard
            await customStatement(
              'UPDATE users SET has_completed_financial_setup = 1 '
              'WHERE is_activated = 1',
            );
            // Recreate lendings table to make cycle_id nullable
            await customStatement(
                'ALTER TABLE lendings RENAME TO _lendings_old');
            await m.create(lendings);
            // Explicit columns: the new table follows the current schema,
            // which may have columns added after v11
            const v10Columns = 'id, borrower_name, total_amount, '
                'collected_amount, is_fully_collected, from_savings, '
                'savings_amount, cycle_id, notes, created_at';
            await customStatement(
                'INSERT INTO lendings ($v10Columns) '
                'SELECT $v10Columns FROM _lendings_old');
            await customStatement('DROP TABLE _lendings_old');
          }
          if (from < 12) {
            await m.addColumn(debts, debts.isSpent);
          }
          if (from < 13) {
            await m.create(customCategories);
          }
          if (from < 14) {
            // Recreate custom_categories with icon_code_point (int) replacing emoji (text)
            await customStatement('DROP TABLE IF EXISTS custom_categories');
            await m.create(customCategories);
          }
          if (from < 16) {
            // Guarded: the v11 rebuild of lendings already includes newer
            // columns, and dev builds may have run a partial v15
            await _addColumnIfMissing(m, lendings, lendings.isArchived);
            await _addColumnIfMissing(
                m, lendingCollections, lendingCollections.cycleId);
            await _addColumnIfMissing(
                m, lendingCollections, lendingCollections.isAdjustment);
            await _addColumnIfMissing(
                m, savingsGoals, savingsGoals.purchasedAmount);
            await _addColumnIfMissing(
                m, savingsGoals, savingsGoals.purchaseTransactionId);
          }
          if (from < 17) {
            await _addColumnIfMissing(m, savingsHistory, savingsHistory.kind);
            // Older transfers stay untagged: their effect already lives in
            // the cycle's salary split, so they must not be counted twice
            await customStatement(
              "UPDATE savings_history SET kind = 'initial' "
              "WHERE description = 'رصيد الادخار الأولي'",
            );
          }
          if (from < 18) {
            await _addColumnIfMissing(
                m, customCategories, customCategories.isArchived);
          }
          if (from < 19) {
            await _addColumnIfMissing(
                m, savingsHistory, savingsHistory.relatedIncomeId);
            // Link existing income deposits to their income: same name and
            // amount first, then same name alone (amount edited before the
            // link existed). Each income gets at most one deposit.
            for (final sameAmount in [true, false]) {
              await customStatement(
                "UPDATE savings_history SET related_income_id = ("
                "SELECT ai.id FROM additional_incomes ai "
                "WHERE ai.to_savings = 1 "
                "AND 'مدخول - ' || ai.description = savings_history.description "
                "${sameAmount ? 'AND ai.amount = savings_history.amount ' : ''}"
                "AND ai.id NOT IN (SELECT related_income_id FROM savings_history "
                "WHERE related_income_id IS NOT NULL) "
                "ORDER BY ai.id LIMIT 1) "
                "WHERE type = 'deposit' AND related_income_id IS NULL "
                "AND description LIKE 'مدخول - %'",
              );
            }
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA journal_mode=WAL;');
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );

  Future<void> _addColumnIfMissing(
    Migrator m,
    TableInfo table,
    GeneratedColumn column,
  ) async {
    final existing = await customSelect(
      'PRAGMA table_info(${table.actualTableName})',
    ).get();
    if (existing.any((row) => row.read<String>('name') == column.name)) return;
    await m.addColumn(table, column);
  }

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
      await delete(customCategories).go();
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
