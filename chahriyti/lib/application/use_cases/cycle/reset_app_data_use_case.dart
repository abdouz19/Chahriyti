import '../../../domain/repositories/user_repository.dart';
import '../../../infrastructure/database/app_database.dart';

class ResetAppDataUseCase {
  final AppDatabase _db;
  final UserRepository _userRepo;

  const ResetAppDataUseCase(this._db, this._userRepo);

  /// Partial reset: deletes all financial transactions and history, then
  /// resets the user's financial-setup flags so the setup wizard re-runs.
  /// Preserves: salary amount, salary day, name, phone, activation status.
  Future<void> call() async {
    final user = await _userRepo.getUser();
    if (user == null) throw StateError('لم يتم العثور على بيانات المستخدم');

    await _db.resetFinancialData();

    // Reset financial-setup flags — router will redirect to /financial-setup.
    await _userRepo.updateUser(
      user.copyWith(
        hasCompletedFinancialSetup: false,
        initialBalance: null,
        financialSetupStep: null,
      ),
    );
  }
}
