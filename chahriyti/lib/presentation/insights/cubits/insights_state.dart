import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../application/use_cases/insights/calculate_financial_classification_use_case.dart';
import '../../../application/use_cases/insights/detect_financial_leaks_use_case.dart';
import '../../../application/use_cases/insights/generate_spending_trends_use_case.dart';

part 'insights_state.freezed.dart';

@freezed
abstract class InsightsState with _$InsightsState {
  const factory InsightsState.initial() = _Initial;

  const factory InsightsState.loading() = _Loading;

  const factory InsightsState.loaded({
    required FinancialClassification classification,
    required double savingsRate,
    required List<LeakInsight> leaks,
    required List<SpendingTrend> trends,
  }) = _Loaded;

  const factory InsightsState.error(String message) = _Error;
}
