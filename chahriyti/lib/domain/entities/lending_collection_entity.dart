import 'package:freezed_annotation/freezed_annotation.dart';

part 'lending_collection_entity.freezed.dart';
part 'lending_collection_entity.g.dart';

@freezed
abstract class LendingCollectionEntity with _$LendingCollectionEntity {
  const factory LendingCollectionEntity({
    required int id,
    required int lendingId,
    required int amount,
    @Default(false) bool toSavings,
    required DateTime createdAt,
  }) = _LendingCollectionEntity;

  factory LendingCollectionEntity.fromJson(Map<String, dynamic> json) =>
      _$LendingCollectionEntityFromJson(json);
}
