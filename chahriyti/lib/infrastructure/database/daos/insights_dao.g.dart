// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights_dao.dart';

// ignore_for_file: type=lint
mixin _$InsightsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FinancialInsightsTable get financialInsights =>
      attachedDatabase.financialInsights;
  InsightsDaoManager get managers => InsightsDaoManager(this);
}

class InsightsDaoManager {
  final _$InsightsDaoMixin _db;
  InsightsDaoManager(this._db);
  $$FinancialInsightsTableTableManager get financialInsights =>
      $$FinancialInsightsTableTableManager(
        _db.attachedDatabase,
        _db.financialInsights,
      );
}
