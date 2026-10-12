import 'package:drift/drift.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../database/app_database.dart';
import '../database/daos/users_dao.dart';

class UserRepositoryImpl implements UserRepository {
  final UsersDao _dao;

  /// The single user, kept in memory: the router reads it on every keyboard
  /// animation frame. Every write below goes through this class and drops it.
  Future<UserEntity?>? _cached;

  UserRepositoryImpl(this._dao);

  void _invalidate() => _cached = null;

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
  Future<UserEntity?> getUser() => _cached ??= () async {
        final row = await _dao.getUser();
        return row != null ? _toEntity(row) : null;
      }();

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
    _invalidate();
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
    _invalidate();
  }

  @override
  Future<bool> isActivated() async =>
      (await getUser())?.isActivated ?? false;

  @override
  Future<void> setActivated(bool activated) async {
    await _dao.setActivated(activated);
    _invalidate();
  }

  @override
  Future<void> updateInitialBalance(int userId, int balance) async {
    await _dao.updateInitialBalance(userId, balance);
    _invalidate();
  }

  @override
  Future<void> updateFinancialSetupStep(int userId, int? step) async {
    await _dao.updateFinancialSetupStep(userId, step);
    _invalidate();
  }

  @override
  Future<void> completeFinancialSetup(int userId) async {
    await _dao.completeFinancialSetup(userId);
    _invalidate();
  }
}
