import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/financial_setup/set_initial_balance_use_case.dart';
import 'package:chahriyti/domain/entities/user_entity.dart';
import 'package:chahriyti/domain/repositories/user_repository.dart';

class FakeUserRepository implements UserRepository {
  UserEntity? _user;
  int? lastBalanceUserId;
  int? lastBalanceValue;
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
  Future<void> updateInitialBalance(int userId, int balance) async {
    lastBalanceUserId = userId;
    lastBalanceValue = balance;
  }

  @override
  Future<void> updateFinancialSetupStep(int userId, int? step) async {
    lastStepUserId = userId;
    lastStepValue = step;
  }

  @override
  Future<void> completeFinancialSetup(int userId) async {}
}

void main() {
  late FakeUserRepository repository;
  late SetInitialBalanceUseCase useCase;

  setUp(() {
    repository = FakeUserRepository();
    useCase = SetInitialBalanceUseCase(repository);
  });

  test('saves balance and updates step to 2', () async {
    repository.setUser(UserEntity(
      id: 5,
      monthlySalary: 50000,
      salaryDay: 25,
      fullName: 'أحمد',
      phoneNumber: '0555555555',
      wilayaCode: 16,
      isActivated: true,
      challengesEnabled: false,
      createdAt: DateTime(2024, 1, 1),
    ));

    await useCase.call(balance: 75000);

    expect(repository.lastBalanceUserId, 5);
    expect(repository.lastBalanceValue, 75000);
    expect(repository.lastStepUserId, 5);
    expect(repository.lastStepValue, 2);
  });

  test('throws ArgumentError for negative amount', () async {
    repository.setUser(UserEntity(
      id: 1,
      monthlySalary: 50000,
      salaryDay: 25,
      fullName: 'أحمد',
      phoneNumber: '0555555555',
      wilayaCode: 16,
      isActivated: true,
      challengesEnabled: false,
      createdAt: DateTime(2024, 1, 1),
    ));

    expect(
      () => useCase.call(balance: -500),
      throwsA(isA<ArgumentError>()),
    );
  });
}
