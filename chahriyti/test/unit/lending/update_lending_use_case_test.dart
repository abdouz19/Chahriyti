import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/lending/update_lending_use_case.dart';
import 'package:chahriyti/domain/entities/financial_cycle_entity.dart';
import 'package:chahriyti/domain/entities/lending_collection_entity.dart';
import 'package:chahriyti/domain/entities/lending_entity.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/repositories/cycle_repository.dart';
import 'package:chahriyti/domain/repositories/lending_repository.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';
import 'package:chahriyti/domain/value_objects/lending_money_place.dart';

class FakeLendingRepository implements LendingRepository {
  int? lastUpdatedId;
  String? lastUpdatedBorrowerName;
  String? lastUpdatedNotes;
  int? lastUpdatedTotalAmount;
  LendingEntity? lending;
  final adjustments = <int>[];

  @override
  Future<LendingEntity> createLending({
    required String borrowerName,
    required int totalAmount,
    required bool fromSavings,
    int? cycleId,
    String? notes,
    int savingsAmount = 0,
  }) async =>
      throw UnimplementedError();

  @override
  Future<LendingEntity?> getLendingById(int id) async => lending;

  @override
  Future<void> addBalanceAdjustment({
    required int lendingId,
    required int amount,
    required int cycleId,
  }) async =>
      adjustments.add(amount);

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
  Future<void> archiveLending(int id) async {}

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
    int? cycleId,
  }) async {}

  @override
  Future<List<LendingCollectionEntity>> getCollectionsForLending(
          int lendingId) async =>
      [];

  @override
  Future<int> getTotalLendingsFromBalanceForCycle(int cycleId) async => 0;

  @override
  Future<int> getTotalLendingsFromSavingsForCycle(int cycleId) async => 0;

  @override
  Future<int> getTotalCollectionsToBalanceForCycle(int cycleId) async => 0;

  @override
  Future<int> getTotalOutstandingLendingAmount() async => 0;
}

class FakeCycleRepository extends Fake implements CycleRepository {
  @override
  Future<FinancialCycleEntity?> getActiveCycle() async => FinancialCycleEntity(
        id: 2,
        startDate: DateTime(2026, 10, 1),
        endDate: DateTime(2026, 10, 31),
        salaryAmount: 100000,
        isActive: true,
      );
}

class FakeSavingsRepository extends Fake implements SavingsRepository {
  int balance = 50000;
  int net = 0; // deposits - withdrawals made by the use case

  SavingsHistoryEntity _entry(int amount, String description) =>
      SavingsHistoryEntity(
        id: 1,
        type: SavingsTransactionType.values.first,
        amount: amount,
        description: description,
        createdAt: DateTime(2026, 10, 6),
      );

  @override
  Future<int> getSavingsBalance() async => balance;

  @override
  Future<SavingsHistoryEntity> createDeposit({
    required int amount,
    required String description,
    required int cycleId,
  }) async {
    net += amount;
    return _entry(amount, description);
  }

  @override
  Future<SavingsHistoryEntity> createWithdrawal({
    required int amount,
    required String description,
    int? expenseId,
    int? debtPaymentId,
    int? lendingId,
  }) async {
    net -= amount;
    return _entry(amount, description);
  }
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

  group('amount difference ends up where the user chose', () {
    late FakeSavingsRepository savings;
    const activeCycleId = 2;

    LendingEntity lending({bool fromSavings = false, int cycleId = activeCycleId}) =>
        LendingEntity(
          id: 7,
          borrowerName: 'Progix',
          totalAmount: 80000,
          fromSavings: fromSavings,
          savingsAmount: fromSavings ? 80000 : 0,
          cycleId: cycleId,
          createdAt: DateTime(2026, 10, 4),
        );

    setUp(() {
      savings = FakeSavingsRepository();
      useCase = UpdateLendingUseCase(
          repository, FakeCycleRepository(), savings);
    });

    /// Net change to the current balance: what the balance formula derives
    /// from the new totalAmount plus the adjustments the use case recorded.
    int balanceChange(LendingEntity l, int newAmount) {
      final derived = !l.fromSavings && l.cycleId == activeCycleId
          ? -(newAmount - l.totalAmount)
          : 0;
      return derived + repository.adjustments.fold(0, (a, b) => a + b);
    }

    Future<void> edit(LendingEntity l, int newAmount, LendingMoneyPlace place) {
      repository.lending = l;
      return useCase(UpdateLendingRequest(
        id: l.id,
        totalAmount: newAmount,
        deltaPlace: place,
      ));
    }

    test('increase from balance deducts the balance', () async {
      final l = lending();
      await edit(l, 83000, LendingMoneyPlace.balance);
      expect(balanceChange(l, 83000), -3000);
      expect(savings.net, 0);
    });

    test('increase from savings leaves balance and withdraws savings', () async {
      final l = lending();
      await edit(l, 83000, LendingMoneyPlace.savings);
      expect(balanceChange(l, 83000), 0);
      expect(savings.net, -3000);
    });

    test('untracked increase moves no money', () async {
      final l = lending();
      await edit(l, 83000, LendingMoneyPlace.untracked);
      expect(balanceChange(l, 83000), 0);
      expect(savings.net, 0);
    });

    test('decrease to balance on a savings lending adds to balance', () async {
      final l = lending(fromSavings: true);
      await edit(l, 77000, LendingMoneyPlace.balance);
      expect(balanceChange(l, 77000), 3000);
      expect(savings.net, 0);
    });

    test('decrease to savings leaves balance and deposits savings', () async {
      final l = lending();
      await edit(l, 77000, LendingMoneyPlace.savings);
      expect(balanceChange(l, 77000), 0);
      expect(savings.net, 3000);
    });

    test('untracked decrease moves no money', () async {
      final l = lending();
      await edit(l, 77000, LendingMoneyPlace.untracked);
      expect(balanceChange(l, 77000), 0);
      expect(savings.net, 0);
    });

    test('old-cycle lending still changes the current balance', () async {
      final l = lending(cycleId: 1);
      await edit(l, 83000, LendingMoneyPlace.balance);
      expect(balanceChange(l, 83000), -3000);
    });

    test('increase from savings beyond savings balance throws', () async {
      savings.balance = 1000;
      repository.lending = lending();
      await expectLater(
        useCase(UpdateLendingRequest(
          id: 7,
          totalAmount: 83000,
          deltaPlace: LendingMoneyPlace.savings,
        )),
        throwsA(isA<StateError>()),
      );
      expect(repository.lastUpdatedTotalAmount, isNull);
    });
  });
}
