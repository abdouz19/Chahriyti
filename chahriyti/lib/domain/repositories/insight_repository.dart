import '../entities/insight_entity.dart';

abstract class InsightRepository {
  Future<List<InsightEntity>> getInsightsByCycle(int cycleId);

  Future<List<InsightEntity>> getValidInsights(int cycleId);

  Future<List<InsightEntity>> getLeakInsights(int cycleId);

  Future<List<InsightEntity>> getTrendInsights(int cycleId);

  Future<InsightEntity?> getClassificationInsight(int cycleId);

  Future<int> saveInsight(InsightEntity insight);

  Future<void> deleteExpiredInsights();
}
