import 'package:drift/drift.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../database/app_database.dart';
import '../database/daos/users_dao.dart';

class UserRepositoryImpl implements UserRepository {
  final UsersDao _dao;

  UserRepositoryImpl(this._dao);

  UserEntity _toEntity(UserRow row) => UserEntity(
        id: row.id,
        monthlySalary: row.monthlySalary,
        salaryDay: row.salaryDay,
        fullName: row.fullName,
        phoneNumber: row.phoneNumber,
        wilayaCode: row.wilayaCode,
        isActivated: row.isActivated,
        challengesEnabled: row.challengesEnabled,
        initialBalance: row.initialBalance,
        hasCompletedFinancialSetup: row.hasCompletedFinancialSetup,
        financialSetupStep: row.financialSetupStep,
        createdAt: row.createdAt,
      );

  @override
  Future<UserEntity?> getUser() async {
    final row = await _dao.getUser();
    return row != null ? _toEntity(row) : null;
  }

  @override
  Future<UserEntity> createUser({
    required int monthlySalary,
    required int salaryDay,
    required String fullName,
    required String phoneNumber,
    required int wilayaCode,
  }) async {
    await _dao.insertUser(
      UsersCompanion(
        monthlySalary: Value(monthlySalary),
        salaryDay: Value(salaryDay),
        fullName: Value(fullName),
        phoneNumber: Value(phoneNumber),
        wilayaCode: Value(wilayaCode),
        isActivated: const Value(false),
      ),
    );
    final row = await _dao.getUser();
    return _toEntity(row!);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    await _dao.updateUser(
      UserRow(
        id: user.id,
        monthlySalary: user.monthlySalary,
        salaryDay: user.salaryDay,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
        wilayaCode: user.wilayaCode,
        isActivated: user.isActivated,
        challengesEnabled: user.challengesEnabled,
        initialBalance: user.initialBalance,
        hasCompletedFinancialSetup: user.hasCompletedFinancialSetup,
        financialSetupStep: user.financialSetupStep,
        createdAt: user.createdAt,
      ),
    );
  }

  @override
  Future<bool> isActivated() async {
    final row = await _dao.getUser();
    return row?.isActivated ?? false;
  }

  @override
  Future<void> setActivated(bool activated) => _dao.setActivated(activated);

  @override
  Future<void> updateInitialBalance(int userId, int balance) =>
      _dao.updateInitialBalance(userId, balance);

  @override
  Future<void> updateFinancialSetupStep(int userId, int? step) =>
      _dao.updateFinancialSetupStep(userId, step);

  @override
  Future<void> completeFinancialSetup(int userId) =>
      _dao.completeFinancialSetup(userId);
}
