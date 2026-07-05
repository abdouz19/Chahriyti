import '../../../domain/entities/lending_collection_entity.dart';
import '../../../domain/entities/lending_entity.dart';
import '../../../domain/repositories/lending_repository.dart';

class GetLendingsUseCase {
  final LendingRepository _repository;

  const GetLendingsUseCase(this._repository);

  Future<List<LendingEntity>> getActiveLendings({int? limit, int? offset}) =>
      _repository.getActiveLendings(limit: limit, offset: offset);

  Future<List<LendingEntity>> getCollectedLendings({int? limit, int? offset}) =>
      _repository.getCollectedLendings(limit: limit, offset: offset);

  Future<LendingEntity?> getLendingById(int id) =>
      _repository.getLendingById(id);

  Future<List<LendingCollectionEntity>> getCollectionsForLending(
          int lendingId) =>
      _repository.getCollectionsForLending(lendingId);

  Future<int> getTotalOutstandingLendingAmount() =>
      _repository.getTotalOutstandingLendingAmount();
}
