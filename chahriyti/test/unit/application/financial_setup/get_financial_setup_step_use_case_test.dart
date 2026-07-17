import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/financial_setup/get_financial_setup_step_use_case.dart';
import 'package:chahriyti/domain/entities/user_entity.dart';
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

void main() {
  late FakeUserRepository repository;
  late GetFinancialSetupStepUseCase useCase;

  setUp(() {
    repository = FakeUserRepository();
    useCase = GetFinancialSetupStepUseCase(repository);
  });

  test('returns null when no user exists', () async {
    repository.setUser(null);

    final step = await useCase.call();

    expect(step, isNull);
  });

  test('returns step value from user entity', () async {
    repository.setUser(UserEntity(
      id: 1,
      monthlySalary: 50000,
      salaryDay: 25,
      fullName: 'أحمد',
      phoneNumber: '0555555555',
      wilayaCode: 16,
      isActivated: true,
      challengesEnabled: false,
      financialSetupStep: 3,
      createdAt: DateTime(2024, 1, 1),
    ));

    final step = await useCase.call();

    expect(step, 3);
  });
}
