import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/lending/update_lending_use_case.dart';
import 'package:chahriyti/domain/entities/lending_collection_entity.dart';
import 'package:chahriyti/domain/entities/lending_entity.dart';
import 'package:chahriyti/domain/repositories/lending_repository.dart';

class FakeLendingRepository implements LendingRepository {
  int? lastUpdatedId;
  String? lastUpdatedBorrowerName;
  String? lastUpdatedNotes;
  int? lastUpdatedTotalAmount;

  @override
  Future<LendingEntity> createLending({
    required String borrowerName,
    required int totalAmount,
    required bool fromSavings,
    required int cycleId,
    String? notes,
    int savingsAmount = 0,
  }) async =>
      throw UnimplementedError();

  @override
  Future<LendingEntity?> getLendingById(int id) async =>
      throw UnimplementedError();

  @override
  Future<List<LendingEntity>> getActiveLendings(
          {int? limit, int? offset}) async =>
      [];

  @override
  Future<List<LendingEntity>> getCollectedLendings(
          {int? limit, int? offset}) async =>
      [];

  @override
  Future<void> deleteLending(int id) async {}

  @override
  Future<void> updateLending({
    required int id,
    String? borrowerName,
    String? notes,
    int? totalAmount,
  }) async {
    lastUpdatedId = id;
    lastUpdatedBorrowerName = borrowerName;
    lastUpdatedNotes = notes;
    lastUpdatedTotalAmount = totalAmount;
  }

  @override
  Future<void> addCollection({
    required int lendingId,
    required int amount,
    bool toSavings = false,
  }) async {}

  @override
  Future<List<LendingCollectionEntity>> getCollectionsForLending(
          int lendingId) async =>
      [];

  @override
  Future<int> getTotalLendingsFromBalanceForCycle(int cycleId) async => 0;

  @override
  Future<int> getTotalCollectionsToBalanceForCycle(int cycleId) async => 0;

  @override
  Future<int> getTotalOutstandingLendingAmount() async => 0;
}

void main() {
  late FakeLendingRepository repository;
  late UpdateLendingUseCase useCase;

  setUp(() {
    repository = FakeLendingRepository();
    useCase = UpdateLendingUseCase(repository);
  });

  test('valid update with borrowerName passes', () async {
    final request = UpdateLendingRequest(
      id: 1,
      borrowerName: 'أحمد',
    );

    await useCase.call(request);

    expect(repository.lastUpdatedId, 1);
    expect(repository.lastUpdatedBorrowerName, 'أحمد');
  });

  test('totalAmount <= 0 throws ArgumentError', () async {
    final request = UpdateLendingRequest(
      id: 1,
      totalAmount: 0,
    );

    expect(
      () => useCase.call(request),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('negative totalAmount throws ArgumentError', () async {
    final request = UpdateLendingRequest(
      id: 1,
      totalAmount: -500,
    );

    expect(
      () => useCase.call(request),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('delegates to repository correctly', () async {
    final request = UpdateLendingRequest(
      id: 42,
      borrowerName: 'خالد',
      notes: 'ملاحظة تجريبية',
      totalAmount: 1000,
    );

    await useCase.call(request);

    expect(repository.lastUpdatedId, 42);
    expect(repository.lastUpdatedBorrowerName, 'خالد');
    expect(repository.lastUpdatedNotes, 'ملاحظة تجريبية');
    expect(repository.lastUpdatedTotalAmount, 1000);
  });
}
