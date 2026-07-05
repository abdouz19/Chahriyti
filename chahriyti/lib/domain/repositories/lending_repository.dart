import '../entities/lending_entity.dart';
import '../entities/lending_collection_entity.dart';

abstract class LendingRepository {
  Future<LendingEntity> createLending({
    required String borrowerName,
    required int totalAmount,
    required bool fromSavings,
    int savingsAmount = 0,
    required int cycleId,
    String? notes,
  });

  Future<LendingEntity?> getLendingById(int id);

  Future<List<LendingEntity>> getActiveLendings({int? limit, int? offset});

  Future<List<LendingEntity>> getCollectedLendings({int? limit, int? offset});

  Future<void> deleteLending(int id);

  Future<void> updateLending({
    required int id,
    String? borrowerName,
    String? notes,
    int? totalAmount,
  });

  Future<void> addCollection({
    required int lendingId,
    required int amount,
    bool toSavings = false,
  });

  Future<List<LendingCollectionEntity>> getCollectionsForLending(int lendingId);

  Future<int> getTotalLendingsFromBalanceForCycle(int cycleId);

  Future<int> getTotalLendingsFromSavingsForCycle(int cycleId);

  Future<int> getTotalCollectionsToBalanceForCycle(int cycleId);

  Future<int> getTotalOutstandingLendingAmount();
}
