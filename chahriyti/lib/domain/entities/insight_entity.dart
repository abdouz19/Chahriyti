import 'package:freezed_annotation/freezed_annotation.dart';

part 'insight_entity.freezed.dart';
part 'insight_entity.g.dart';

enum InsightType { leak, trend, classification }

@freezed
abstract class InsightEntity with _$InsightEntity {
  const InsightEntity._();

  const factory InsightEntity({
    required int id,
    required int cycleId,
    required InsightType type,
    String? category,
    required String metric,
    required double value,
    required String suggestion,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _InsightEntity;

  factory InsightEntity.fromJson(Map<String, dynamic> json) =>
      _$InsightEntityFromJson(json);
}
