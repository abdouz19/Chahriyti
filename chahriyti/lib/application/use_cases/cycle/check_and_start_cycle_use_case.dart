import '../../../domain/entities/financial_cycle_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../domain/value_objects/cycle_dates.dart';
import '../savings/deposit_cycle_savings_use_case.dart';

/// New current cycle, plus what the cycles closed on the way left in savings.
class CycleStartResult {
  final FinancialCycleEntity cycle;
  final int savedFromClosedCycles;

  const CycleStartResult(this.cycle, this.savedFromClosedCycles);
}

class CheckAndStartCycleUseCase {
  final UserRepository _userRepo;
  final CycleRepository _cycleRepo;
  final DepositCycleSavingsUseCase _depositSavings;

  const CheckAndStartCycleUseCase(
    this._userRepo,
    this._cycleRepo,
    this._depositSavings,
  );

  /// Returns the new current [FinancialCycleEntity] if one was created
  /// (salary split needed), or null if the active cycle is still running.
  ///
  /// Months the app wasn't opened get their own cycle, each with its salary,
  /// closed right away so its leftover goes to savings.
  Future<CycleStartResult?> call() async {
    final user = await _userRepo.getUser();
    if (user == null) return null;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final salaryDay = user.salaryDay;

    final active = await _cycleRepo.getActiveCycle();
    var saved = 0;
    DateTime start;
    if (active != null) {
      // Still within the active cycle
      if (!today.isAfter(active.endDate)) return null;
      saved += await _closeCycle(active);
      start = CycleDates.dayAfter(active.endDate);
    } else {
      start = CycleDates.currentCycleStart(salaryDay, today);
    }

    while (true) {
      final cycle = await _cycleRepo.createCycle(
        startDate: start,
        endDate: CycleDates.cycleEnd(salaryDay, start),
        salaryAmount: user.monthlySalary,
      );
      if (!today.isAfter(cycle.endDate)) return CycleStartResult(cycle, saved);
      // A month that passed without opening the app
      saved += await _closeCycle(cycle);
      start = CycleDates.dayAfter(cycle.endDate);
    }
  }

  /// Returns the leftover moved to savings.
  Future<int> _closeCycle(FinancialCycleEntity cycle) async {
    final deposit = await _depositSavings(cycle.id);
    await _cycleRepo.closeCycle(cycle.id);
    return deposit?.amount ?? 0;
  }
}
