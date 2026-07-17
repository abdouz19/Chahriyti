import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/financial_setup/set_initial_savings_use_case.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/entities/user_entity.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';
import 'package:chahriyti/domain/repositories/user_repository.dart';

class FakeUserRepository implements UserRepository {
  UserEntity? _user;
  int? lastStepUserId;
  int? lastStepValue;

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
  Future<void> updateFinancialSetupStep(int userId, int? step) async {
    lastStepUserId = userId;
    lastStepValue = step;
  }

  @override
  Future<void> completeFinancialSetup(int userId) async {}
}

class FakeSavingsRepository implements SavingsRepository {
  bool initialDepositCreated = false;
  int? lastDepositAmount;

  @override
  Future<int> getSavingsBalance() async => 0;

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
  Future<void> createInitialDeposit({required int amount}) async {
    initialDepositCreated = true;
    lastDepositAmount = amount;
  }

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
  late FakeSavingsRepository savingsRepository;
  late SetInitialSavingsUseCase useCase;

  setUp(() {
    userRepository = FakeUserRepository();
    savingsRepository = FakeSavingsRepository();
    useCase = SetInitialSavingsUseCase(userRepository, savingsRepository);
  });

  test('creates deposit when amount > 0', () async {
    userRepository.setUser(UserEntity(
      id: 3,
      monthlySalary: 50000,
      salaryDay: 25,
      fullName: 'أحمد',
      phoneNumber: '0555555555',
      wilayaCode: 16,
      isActivated: true,
      challengesEnabled: false,
      createdAt: DateTime(2024, 1, 1),
    ));

    await useCase.call(amount: 10000);

    expect(savingsRepository.initialDepositCreated, isTrue);
    expect(savingsRepository.lastDepositAmount, 10000);
    expect(userRepository.lastStepUserId, 3);
    expect(userRepository.lastStepValue, 3);
  });

  test('skips deposit when amount is 0', () async {
    userRepository.setUser(UserEntity(
      id: 3,
      monthlySalary: 50000,
      salaryDay: 25,
      fullName: 'أحمد',
      phoneNumber: '0555555555',
      wilayaCode: 16,
      isActivated: true,
      challengesEnabled: false,
      createdAt: DateTime(2024, 1, 1),
    ));

    await useCase.call(amount: 0);

    expect(savingsRepository.initialDepositCreated, isFalse);
    expect(savingsRepository.lastDepositAmount, isNull);
    // Step should still advance to 3
    expect(userRepository.lastStepUserId, 3);
    expect(userRepository.lastStepValue, 3);
  });
}
