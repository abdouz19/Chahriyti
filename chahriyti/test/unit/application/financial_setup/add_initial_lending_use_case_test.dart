import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/financial_setup/add_initial_lending_use_case.dart';
import 'package:chahriyti/domain/entities/financial_cycle_entity.dart';
import 'package:chahriyti/domain/entities/lending_entity.dart';
import 'package:chahriyti/domain/entities/lending_collection_entity.dart';
import 'package:chahriyti/domain/repositories/cycle_repository.dart';
import 'package:chahriyti/domain/repositories/lending_repository.dart';

class FakeLendingRepository implements LendingRepository {
  String? lastBorrowerName;
  int? lastTotalAmount;
  bool? lastFromSavings;
  int? lastCycleId;

  @override
  Future<LendingEntity> createLending({
    required String borrowerName,
    required int totalAmount,
    required bool fromSavings,
    int savingsAmount = 0,
    int? cycleId,
    String? notes,
  }) async {
    lastBorrowerName = borrowerName;
    lastTotalAmount = totalAmount;
    lastFromSavings = fromSavings;
    lastCycleId = cycleId;
    return LendingEntity(
      id: 1,
      borrowerName: borrowerName,
      totalAmount: totalAmount,
      fromSavings: fromSavings,
      createdAt: DateTime(2024, 1, 1),
    );
  }

  @override
  Future<LendingEntity?> getLendingById(int id) async =>
      throw UnimplementedError();

  @override
  Future<List<LendingEntity>> getActiveLendings({int? limit, int? offset}) async =>
      throw UnimplementedError();

  @override
  Future<List<LendingEntity>> getCollectedLendings({int? limit, int? offset}) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteLending(int id) async => throw UnimplementedError();

  @override
  Future<void> updateLending({
    required int id,
    String? borrowerName,
    String? notes,
    int? totalAmount,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> addCollection({
    required int lendingId,
    required int amount,
    bool toSavings = false,
  }) async =>
      throw UnimplementedError();

  @override
  Future<List<LendingCollectionEntity>> getCollectionsForLending(int lendingId) async =>
      throw UnimplementedError();

  @override
  Future<int> getTotalLendingsFromBalanceForCycle(int cycleId) async =>
      throw UnimplementedError();

  @override
  Future<int> getTotalLendingsFromSavingsForCycle(int cycleId) async =>
      throw UnimplementedError();

  @override
  Future<int> getTotalCollectionsToBalanceForCycle(int cycleId) async =>
      throw UnimplementedError();

  @override
  Future<int> getTotalOutstandingLendingAmount() async =>
      throw UnimplementedError();
}

class FakeCycleRepository implements CycleRepository {
  final FinancialCycleEntity? activeCycle;

  FakeCycleRepository({this.activeCycle});

  @override
  Future<FinancialCycleEntity?> getActiveCycle() async => activeCycle;

  @override
  Future<FinancialCycleEntity> createCycle({
    required DateTime startDate,
    required DateTime endDate,
    required int salaryAmount,
    int salarySplitAmount = 0,
  }) async =>
      throw UnimplementedError();

  @override
  Future<FinancialCycleEntity?> getCycleById(int id) async => null;

  @override
  Future<FinancialCycleEntity?> getPreviousCycle(int cycleId) async => null;

  @override
  Future<void> closeCycle(int id) async {}

  @override
  Future<void> updateCycleSalary(int cycleId, int salaryAmount) async {}

  @override
  Future<void> updateCycleSalarySplit(int cycleId, int salarySplitAmount) async {}

  @override
  Future<void> updateCycleSalaryDay(int cycleId, int salaryDay) async {}

  @override
  Future<List<FinancialCycleEntity>> getCycleHistory({
    int limit = 6,
    int offset = 0,
  }) async =>
      [];

  @override
  Future<FinancialCycleEntity?> getCycleForMonth(int year, int month) async => null;
}

FinancialCycleEntity _cycle() => FinancialCycleEntity(
      id: 1,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
      salaryAmount: 80000,
      salarySplitAmount: 0,
      isActive: true,
    );

void main() {
  late FakeLendingRepository repository;
  late FakeCycleRepository cycleRepository;
  late AddInitialLendingUseCase useCase;

  setUp(() {
    repository = FakeLendingRepository();
    cycleRepository = FakeCycleRepository(activeCycle: _cycle());
    useCase = AddInitialLendingUseCase(repository, cycleRepository);
  });

  test('creates lending with correct borrowerName and totalAmount', () async {
    final result = await useCase.call(
      borrowerName: 'محمد',
      totalAmount: 25000,
    );

    expect(repository.lastBorrowerName, 'محمد');
    expect(repository.lastTotalAmount, 25000);
    expect(repository.lastFromSavings, false);
    expect(result.borrowerName, 'محمد');
    expect(result.totalAmount, 25000);
  });

  test('passes active cycle id to lending', () async {
    await useCase.call(borrowerName: 'علي', totalAmount: 10000);
    expect(repository.lastCycleId, 1);
  });

  test('passes null cycleId when no active cycle', () async {
    final noCyclRepo = FakeCycleRepository(activeCycle: null);
    final useCaseNoCycle = AddInitialLendingUseCase(repository, noCyclRepo);
    await useCaseNoCycle.call(borrowerName: 'علي', totalAmount: 10000);
    expect(repository.lastCycleId, isNull);
  });

  test('throws ArgumentError for empty name', () {
    expect(
      () => useCase.call(borrowerName: '', totalAmount: 10000),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('throws ArgumentError for whitespace-only name', () {
    expect(
      () => useCase.call(borrowerName: '   ', totalAmount: 10000),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('throws ArgumentError for amount <= 0', () {
    expect(
      () => useCase.call(borrowerName: 'علي', totalAmount: 0),
      throwsA(isA<ArgumentError>()),
    );

    expect(
      () => useCase.call(borrowerName: 'علي', totalAmount: -500),
      throwsA(isA<ArgumentError>()),
    );
  });
}
