import '../../../domain/entities/financial_cycle_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../savings/deposit_cycle_savings_use_case.dart';

class CheckAndStartCycleUseCase {
  final UserRepository _userRepo;
  final CycleRepository _cycleRepo;
  final DepositCycleSavingsUseCase _depositSavings;

  const CheckAndStartCycleUseCase(
    this._userRepo,
    this._cycleRepo,
    this._depositSavings,
  );

  /// Returns a new [FinancialCycleEntity] if a new cycle was created (salary split needed).
  /// Returns null if no action was required.
  Future<FinancialCycleEntity?> call() async {
    final user = await _userRepo.getUser();
    if (user == null) return null;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final salaryDay = user.salaryDay;

    // Clamp salary day to actual days in this month
    final effectiveDay = _clampToMonth(salaryDay, today.year, today.month);
    final thisSalaryDate = DateTime(today.year, today.month, effectiveDay);

    // Not yet salary day this month
    if (today.isBefore(thisSalaryDate)) return null;

    // Already have a cycle for this month
    final existing = await _cycleRepo.getCycleForMonth(today.year, today.month);
    if (existing != null) return null;

    // Close and archive the current active cycle
    final active = await _cycleRepo.getActiveCycle();
    if (active != null) {
      await _depositSavings(active.id);
      await _cycleRepo.closeCycle(active.id);
    }

    // Compute next cycle's end date (day before next salary day)
    final nextMonth = today.month == 12 ? 1 : today.month + 1;
    final nextYear = today.month == 12 ? today.year + 1 : today.year;
    final nextEffectiveDay = _clampToMonth(salaryDay, nextYear, nextMonth);
    final cycleEnd = DateTime(nextYear, nextMonth, nextEffectiveDay)
        .subtract(const Duration(days: 1));

    return _cycleRepo.createCycle(
      startDate: thisSalaryDate,
      endDate: cycleEnd,
      salaryAmount: user.monthlySalary,
    );
  }

  /// Returns [salaryDay] clamped to the last valid day of [year]/[month].
  static int _clampToMonth(int salaryDay, int year, int month) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return salaryDay > lastDay ? lastDay : salaryDay;
  }
}
