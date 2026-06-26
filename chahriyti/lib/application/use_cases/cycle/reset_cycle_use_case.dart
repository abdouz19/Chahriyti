import '../../../domain/entities/financial_cycle_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';

class ResetCycleUseCase {
  final CycleRepository _repo;

  const ResetCycleUseCase(this._repo);

  /// Closes the current active cycle and creates a new one from today
  /// with the same salary amount. Returns the new cycle.
  Future<FinancialCycleEntity> call() async {
    final currentCycle = await _repo.getActiveCycle();
    if (currentCycle == null) {
      throw StateError('لا توجد دورة مالية نشطة');
    }

    // Close current cycle
    await _repo.closeCycle(currentCycle.id);

    // Create a new cycle from today with the same salary
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month + 1, now.day);

    return _repo.createCycle(
      startDate: now,
      endDate: endDate,
      salaryAmount: currentCycle.salaryAmount,
    );
  }
}
