import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../infrastructure/database/app_database.dart';
import '../../../domain/value_objects/cycle_dates.dart';

class ResetAppDataUseCase {
  final AppDatabase _db;
  final UserRepository _userRepo;
  final CycleRepository _cycleRepo;

  const ResetAppDataUseCase(this._db, this._userRepo, this._cycleRepo);

  /// Partial reset: deletes all financial transactions and history, then
  /// resets the user's financial-setup flags so the setup wizard re-runs.
  /// Preserves: salary amount, salary day, name, phone, activation status.
  /// Creates a fresh cycle so the setup wizard has a cycle to operate on.
  Future<void> call() async {
    final user = await _userRepo.getUser();
    if (user == null) throw StateError('لم يتم العثور على بيانات المستخدم');

    // All or nothing: a reset cut half-way (app killed) would leave the user
    // on an empty home with setup already marked done.
    await _db.transaction(() async {
      await _db.resetFinancialData();

      // Fresh cycle so the financial setup has a cycle to operate on and the
      // auto-cycle gate in the router does not fire after setup.
      final salaryDay = user.salaryDay;
      final cycleStart = CycleDates.currentCycleStart(salaryDay, DateTime.now());
      await _cycleRepo.createCycle(
        startDate: cycleStart,
        endDate: CycleDates.cycleEnd(salaryDay, cycleStart),
        salaryAmount: user.monthlySalary,
      );

      // Keeps salary, salary day, name and activation (the licence was
      // already bought); only re-runs the financial setup.
      await _userRepo.updateUser(
        user.copyWith(
          hasCompletedFinancialSetup: false,
          initialBalance: null,
          financialSetupStep: null,
        ),
      );
    });
  }
}
