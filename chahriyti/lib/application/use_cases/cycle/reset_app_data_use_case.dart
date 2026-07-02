import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../infrastructure/database/app_database.dart';

class ResetAppDataUseCase {
  final AppDatabase _db;
  final UserRepository _userRepo;
  final CycleRepository _cycleRepo;

  const ResetAppDataUseCase(this._db, this._userRepo, this._cycleRepo);

  /// Clears all financial data and creates a fresh cycle.
  /// Preserves the user's salary and salary day.
  Future<void> call() async {
    final user = await _userRepo.getUser();
    if (user == null) throw StateError('لم يتم العثور على بيانات المستخدم');

    await _db.resetFinancialData();

    final now = DateTime.now();
    final salaryDay = user.salaryDay;
    final thisMonthLastDay = DateTime(now.year, now.month + 1, 0).day;
    final effectiveDay =
        salaryDay > thisMonthLastDay ? thisMonthLastDay : salaryDay;
    final startDate = DateTime(now.year, now.month, effectiveDay);
    final cycleStart =
        startDate.isAfter(now) ? DateTime(now.year, now.month - 1, effectiveDay) : startDate;
    final nextMonth = cycleStart.month == 12 ? 1 : cycleStart.month + 1;
    final nextYear = cycleStart.month == 12 ? cycleStart.year + 1 : cycleStart.year;
    final nextMonthLastDay = DateTime(nextYear, nextMonth + 1, 0).day;
    final nextEffectiveDay = salaryDay > nextMonthLastDay ? nextMonthLastDay : salaryDay;
    final cycleEnd =
        DateTime(nextYear, nextMonth, nextEffectiveDay)
            .subtract(const Duration(days: 1));

    await _cycleRepo.createCycle(
      startDate: cycleStart,
      endDate: cycleEnd,
      salaryAmount: user.monthlySalary,
    );
  }
}
