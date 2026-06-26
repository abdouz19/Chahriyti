import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/financial_insights_table.dart';

part 'insights_dao.g.dart';

@DriftAccessor(tables: [FinancialInsights])
class InsightsDao extends DatabaseAccessor<AppDatabase> with _$InsightsDaoMixin {
  InsightsDao(super.db);

  Future<int> insertInsight(FinancialInsightsCompanion insight) =>
      into(financialInsights).insert(insight);

  Future<List<FinancialInsightRow>> getInsightsByCycle(int cycleId) =>
      (select(financialInsights)
            ..where((t) => t.cycleId.equals(cycleId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<FinancialInsightRow>> getValidInsights(
    int cycleId,
    DateTime now,
  ) =>
      (select(financialInsights)
            ..where((t) => t.cycleId.equals(cycleId))
            ..where((t) => t.expiresAt.isBiggerThanValue(now))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<FinancialInsightRow>> getLeakInsights(int cycleId) =>
      (select(financialInsights)
            ..where((t) => t.cycleId.equals(cycleId))
            ..where((t) => t.insightType.equals('leak'))
            ..orderBy([(t) => OrderingTerm.desc(t.value)]))
          .get();

  Future<List<FinancialInsightRow>> getTrendInsights(int cycleId) =>
      (select(financialInsights)
            ..where((t) => t.cycleId.equals(cycleId))
            ..where((t) => t.insightType.equals('trend'))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<FinancialInsightRow?> getClassificationInsight(int cycleId) =>
      (select(financialInsights)
            ..where((t) => t.cycleId.equals(cycleId))
            ..where((t) => t.insightType.equals('classification')))
          .getSingleOrNull();

  Future<void> deleteExpiredInsights(DateTime now) async {
    await (delete(financialInsights)
          ..where((t) => t.expiresAt.isSmallerThanValue(now)))
        .go();
  }
}
