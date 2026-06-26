import 'package:drift/drift.dart';

import '../../domain/entities/insight_entity.dart';
import '../../domain/repositories/insight_repository.dart';
import '../database/app_database.dart';
import '../database/daos/insights_dao.dart';
import '../mappers/insight_mapper.dart';

class InsightRepositoryImpl implements InsightRepository {
  final InsightsDao _dao;
  final AppDatabase _db;

  InsightRepositoryImpl(this._dao, this._db);

  @override
  Future<List<InsightEntity>> getInsightsByCycle(int cycleId) async {
    final rows = await _dao.getInsightsByCycle(cycleId);
    return rows.map(InsightMapper.rowToEntity).toList();
  }

  @override
  Future<List<InsightEntity>> getValidInsights(int cycleId) async {
    final rows = await _dao.getValidInsights(cycleId, DateTime.now());
    return rows.map(InsightMapper.rowToEntity).toList();
  }

  @override
  Future<List<InsightEntity>> getLeakInsights(int cycleId) async {
    final rows = await _dao.getLeakInsights(cycleId);
    return rows.map(InsightMapper.rowToEntity).toList();
  }

  @override
  Future<List<InsightEntity>> getTrendInsights(int cycleId) async {
    final rows = await _dao.getTrendInsights(cycleId);
    return rows.map(InsightMapper.rowToEntity).toList();
  }

  @override
  Future<InsightEntity?> getClassificationInsight(int cycleId) async {
    final row = await _dao.getClassificationInsight(cycleId);
    return row != null ? InsightMapper.rowToEntity(row) : null;
  }

  @override
  Future<int> saveInsight(InsightEntity insight) async {
    return await _dao.insertInsight(
      FinancialInsightsCompanion(
        cycleId: Value(insight.cycleId),
        insightType: Value(_insightTypeToString(insight.type)),
        category: Value(insight.category),
        metric: Value(insight.metric),
        value: Value(insight.value),
        suggestion: Value(insight.suggestion),
        createdAt: Value(insight.createdAt),
        expiresAt: Value(insight.expiresAt),
      ),
    );
  }

  @override
  Future<void> deleteExpiredInsights() async {
    await _dao.deleteExpiredInsights(DateTime.now());
  }

  String _insightTypeToString(InsightType type) {
    return type.toString().split('.').last;
  }
}
