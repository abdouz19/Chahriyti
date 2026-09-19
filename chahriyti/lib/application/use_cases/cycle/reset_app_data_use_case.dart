import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../infrastructure/database/app_database.dart';

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

    await _db.resetFinancialData();

    // Create a fresh cycle so the financial setup has a cycle to operate on
    // and the auto-cycle gate in the router does not fire after setup.
    final now = DateTime.now();
    final salaryDay = user.salaryDay;
    final thisMonthLastDay = DateTime(now.year, now.month + 1, 0).day;
    final effectiveDay = salaryDay > thisMonthLastDay ? thisMonthLastDay : salaryDay;
    final startDate = DateTime(now.year, now.month, effectiveDay);
    final cycleStart = startDate.isAfter(now)
        ? DateTime(now.year, now.month - 1, effectiveDay)
        : startDate;
    final nextMonth = cycleStart.month == 12 ? 1 : cycleStart.month + 1;
    final nextYear = cycleStart.month == 12 ? cycleStart.year + 1 : cycleStart.year;
    final nextMonthLastDay = DateTime(nextYear, nextMonth + 1, 0).day;
    final nextEffectiveDay = salaryDay > nextMonthLastDay ? nextMonthLastDay : salaryDay;
    final cycleEnd = DateTime(nextYear, nextMonth, nextEffectiveDay)
        .subtract(const Duration(days: 1));

    await _cycleRepo.createCycle(
      startDate: cycleStart,
      endDate: cycleEnd,
      salaryAmount: user.monthlySalary,
    );

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
