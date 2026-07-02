import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_entity.freezed.dart';
part 'debt_entity.g.dart';

@freezed
abstract class DebtEntity with _$DebtEntity {
  const DebtEntity._();

  const factory DebtEntity({
    required int id,
    required String creditorName,
    required int totalAmount,
    required int paidAmount,
    required bool isFullyPaid,
    required DateTime createdAt,
    String? notes,
  }) = _DebtEntity;

  factory DebtEntity.fromJson(Map<String, dynamic> json) =>
      _$DebtEntityFromJson(json);

  int get remainingAmount => totalAmount - paidAmount;

  bool get isCompleted => isFullyPaid;
}
