import '../../domain/entities/insight_entity.dart';
import '../database/app_database.dart';

class InsightMapper {
  static InsightEntity rowToEntity(FinancialInsightRow row) {
    return InsightEntity(
      id: row.id,
      cycleId: row.cycleId,
      type: _stringToInsightType(row.insightType),
      category: row.category,
      metric: row.metric,
      value: row.value,
      suggestion: row.suggestion,
      createdAt: row.createdAt,
      expiresAt: row.expiresAt,
    );
  }

  static InsightType _stringToInsightType(String typeStr) {
    switch (typeStr) {
      case 'leak':
        return InsightType.leak;
      case 'trend':
        return InsightType.trend;
      case 'classification':
        return InsightType.classification;
      default:
        return InsightType.leak;
    }
  }
}
