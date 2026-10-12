import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_history_entity.freezed.dart';
part 'savings_history_entity.g.dart';

enum SavingsTransactionType {
  deposit,
  withdrawal,
}

/// [initial]: savings entered at setup. [transfer]: manual move between
/// balance and savings. [other]: created by an expense, lending, goal, etc.,
/// and only changed from there.
enum SavingsRecordKind { initial, transfer, other }

@freezed
abstract class SavingsHistoryEntity with _$SavingsHistoryEntity {
  const factory SavingsHistoryEntity({
    required int id,
    required SavingsTransactionType type,
    required int amount,
    required String description,
    int? relatedCycleId,
    int? relatedExpenseId,
    int? relatedDebtPaymentId,
    int? relatedLendingId,
    required DateTime createdAt,
    @Default(SavingsRecordKind.other) SavingsRecordKind kind,
  }) = _SavingsHistoryEntity;

  factory SavingsHistoryEntity.fromJson(Map<String, dynamic> json) =>
      _$SavingsHistoryEntityFromJson(json);
}
