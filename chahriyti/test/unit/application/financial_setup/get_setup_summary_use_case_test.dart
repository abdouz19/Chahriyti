import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/financial_setup/get_setup_summary_use_case.dart';
import 'package:chahriyti/domain/entities/debt_entity.dart';
import 'package:chahriyti/domain/entities/lending_collection_entity.dart';
import 'package:chahriyti/domain/entities/lending_entity.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/entities/user_entity.dart';
import 'package:chahriyti/domain/repositories/debt_repository.dart';
import 'package:chahriyti/domain/repositories/lending_repository.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';
import 'package:chahriyti/domain/repositories/user_repository.dart';

class FakeUserRepository implements UserRepository {
  UserEntity? _user;

  void setUser(UserEntity? user) => _user = user;

  @override
  Future<UserEntity?> getUser() async => _user;

  @override
  Future<UserEntity> createUser({
    required int monthlySalary,
    required int salaryDay,
    required String fullName,
    required String phoneNumber,
    required int wilayaCode,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> updateUser(UserEntity user) async {}

  @override
  Future<bool> isActivated() async => true;

  @override
  Future<void> setActivated(bool activated) async {}

  @override
  Future<void> updateInitialBalance(int userId, int balance) async {}

  @override
  Future<void> updateFinancialSetupStep(int userId, int? step) async {}

  @override
  Future<void> completeFinancialSetup(int userId) async {}
}

class FakeDebtRepository implements DebtRepository {
  List<DebtEntity> _activeDebts = [];

  void setActiveDebts(List<DebtEntity> debts) => _activeDebts = debts;

  @override
  Future<List<DebtEntity>> getActiveDebts({int? limit, int? offset}) async =>
      _activeDebts;

  @override
  Future<int> createDebt({
    required String creditorName,
    required int totalAmount,
    String? notes,
    int? cycleId,
    bool isSpent = true,
  }) async =>
      throw UnimplementedError();

  @override
  Future<DebtEntity> addDebt({
    required String creditorName,
    required int totalAmount,
    required int paidAmount,
  }) async =>
      throw UnimplementedError();

  @override
  Future<DebtEntity?> getDebtById(int id) async => throw UnimplementedError();

  @override
  Future<List<DebtEntity>> getUserDebts({int limit = 20, int offset = 0}) async => [];

  @override
  Future<List<DebtEntity>> getCompletedDebts({int? limit, int? offset}) async => [];

  @override
  Future<void> updateDebt({
    required int id,
    String? creditorName,
    int? totalAmount,
    String? notes,
    bool? isSpent,
  }) async {}

  @override
  Future<void> deleteDebt(int id) async {}

  @override
  Future<void> addPayment({
    required int debtId,
    required int amount,
    bool fromSavings = false,
    int savingsAmount = 0,
  }) async {}

  @override
  Future<void> markDebtCompleted(int id) async {}

  @override
  Future<void> makePayment({
    required int debtId,
    required int amount,
    required int cycleId,
    bool fromSavings = false,
  }) async {}

  @override
  Future<int> getTotalDebtPaymentsForCycle(int cycleId) async => 0;

  @override
  Future<int> getTotalDebtPaymentsFromSavingsForCycle(int cycleId) async => 0;

  @override
  Future<int> getTotalDebtsCreatedForCycle(int cycleId) async => 0;

  @override
  Future<List<int>> getSavingsPaymentIds(int debtId) async => [];

  @override
  Future<int> getTotalActiveRemainingAmount() async => 0;
}

class FakeLendingRepository implements LendingRepository {
  List<LendingEntity> _activeLendings = [];

  void setActiveLendings(List<LendingEntity> lendings) =>
      _activeLendings = lendings;

  @override
  Future<List<LendingEntity>> getActiveLendings(
          {int? limit, int? offset}) async =>
      _activeLendings;

  @override
  Future<LendingEntity> createLending({
    required String borrowerName,
    required int totalAmount,
    required bool fromSavings,
    int savingsAmount = 0,
    int? cycleId,
    String? notes,
  }) async =>
      throw UnimplementedError();

  @override
  Future<LendingEntity?> getLendingById(int id) async =>
      throw UnimplementedError();

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
  }) async {}

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
  Future<int> getTotalLendingsFromSavingsForCycle(int cycleId) async => 0;

  @override
  Future<int> getTotalCollectionsToBalanceForCycle(int cycleId) async => 0;

  @override
  Future<int> getTotalOutstandingLendingAmount() async => 0;
}

class FakeSavingsRepository implements SavingsRepository {
  int _balance = 0;

  void setBalance(int balance) => _balance = balance;

  @override
  Future<int> getSavingsBalance() async => _balance;

  @override
  Future<List<SavingsHistoryEntity>> getSavingsHistory(
          {int? limit, int? offset}) async =>
      [];

  @override
  Future<SavingsHistoryEntity> createDeposit({
    required int amount,
    required String description,
    required int cycleId,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> createInitialDeposit({required int amount}) async {}

  @override
  Future<SavingsHistoryEntity> createWithdrawal({
    required int amount,
    required String description,
    int? expenseId,
    int? debtPaymentId,
    int? lendingId,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteWithdrawalByExpenseId(int expenseId) async {}

  @override
  Future<void> deleteWithdrawalByDebtPaymentId(int debtPaymentId) async {}

  @override
  Future<void> deleteWithdrawalByLendingId(int lendingId) async {}

  @override
  Future<void> updateWithdrawalAmountByExpenseId(
          int expenseId, int newAmount) async {}

  @override
  Future<void> updateWithdrawalAmountByDebtPaymentId(
          int debtPaymentId, int newAmount) async {}
}

void main() {
  late FakeUserRepository userRepository;
  late FakeDebtRepository debtRepository;
  late FakeLendingRepository lendingRepository;
  late FakeSavingsRepository savingsRepository;
  late GetSetupSummaryUseCase useCase;

  setUp(() {
    userRepository = FakeUserRepository();
    debtRepository = FakeDebtRepository();
    lendingRepository = FakeLendingRepository();
    savingsRepository = FakeSavingsRepository();
    useCase = GetSetupSummaryUseCase(
      userRepository,
      debtRepository,
      lendingRepository,
      savingsRepository,
    );
  });

  test('returns correct summary with all data', () async {
    userRepository.setUser(UserEntity(
      id: 1,
      monthlySalary: 50000,
      salaryDay: 25,
      fullName: 'أحمد',
      phoneNumber: '0555555555',
      wilayaCode: 16,
      isActivated: true,
      challengesEnabled: false,
      initialBalance: 120000,
      createdAt: DateTime(2024, 1, 1),
    ));

    debtRepository.setActiveDebts([
      DebtEntity(
        id: 1,
        creditorName: 'محل الأجهزة',
        totalAmount: 30000,
        paidAmount: 5000,
        isFullyPaid: false,
        createdAt: DateTime(2024, 1, 1),
      ),
      DebtEntity(
        id: 2,
        creditorName: 'صديق',
        totalAmount: 10000,
        paidAmount: 0,
        isFullyPaid: false,
        createdAt: DateTime(2024, 1, 2),
      ),
    ]);

    lendingRepository.setActiveLendings([
      LendingEntity(
        id: 1,
        borrowerName: 'خالد',
        totalAmount: 5000,
        collectedAmount: 0,
        createdAt: DateTime(2024, 1, 1),
      ),
    ]);

    savingsRepository.setBalance(25000);

    final summary = await useCase.call();

    expect(summary.balance, 120000);
    expect(summary.savings, 25000);
    expect(summary.debts, hasLength(2));
    expect(summary.debts[0].creditorName, 'محل الأجهزة');
    expect(summary.debts[1].totalAmount, 10000);
    expect(summary.lendings, hasLength(1));
    expect(summary.lendings[0].borrowerName, 'خالد');
  });

  test('returns zeros and empty lists when no data', () async {
    userRepository.setUser(null);
    debtRepository.setActiveDebts([]);
    lendingRepository.setActiveLendings([]);
    savingsRepository.setBalance(0);

    final summary = await useCase.call();

    expect(summary.balance, 0);
    expect(summary.savings, 0);
    expect(summary.debts, isEmpty);
    expect(summary.lendings, isEmpty);
  });
}
