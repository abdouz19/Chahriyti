import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getUser();

  Future<UserEntity> createUser({
    required int monthlySalary,
    required int salaryDay,
    required String fullName,
    required String phoneNumber,
    required int wilayaCode,
  });

  Future<void> updateUser(UserEntity user);

  Future<bool> isActivated();

  Future<void> setActivated(bool activated);

  Future<void> updateInitialBalance(int userId, int balance);

  Future<void> updateFinancialSetupStep(int userId, int? step);

  Future<void> completeFinancialSetup(int userId);
}
