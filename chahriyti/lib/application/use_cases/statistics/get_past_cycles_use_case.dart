import '../../../domain/entities/financial_cycle_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/income_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import 'stats_amounts.dart';

/// What one finished monthly cycle came to.
class PastCycleSummary {
  final FinancialCycleEntity cycle;

  /// Salary + income earned (opening balance excluded).
  final int income;

  /// Everything spent, from the balance or savings.
  final int spending;

  /// Left over at the end, moved to savings when the cycle closed.
  final int saved;

  const PastCycleSummary({
    required this.cycle,
    required this.income,
    required this.spending,
    required this.saved,
  });
}

/// Closed cycles, newest first, a page at a time.
class GetPastCyclesUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;
  final IncomeRepository _incomeRepository;
  final SavingsRepository _savingsRepository;

  const GetPastCyclesUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
    required IncomeRepository incomeRepository,
    required SavingsRepository savingsRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository,
        _incomeRepository = incomeRepository,
        _savingsRepository = savingsRepository;

  // Description the end-of-cycle saving is stored with
  static const _cycleEndDescription = 'ادخار نهاية الدورة';

  Future<List<PastCycleSummary>> call({int limit = 10, int offset = 0}) async {
    // Newest first; the running cycle is the newest, so skip it
    final hasActive = await _cycleRepository.getActiveCycle() != null;
    final cycles = (await _cycleRepository.getCycleHistory(
      limit: limit,
      offset: offset + (hasActive ? 1 : 0),
    ))
        .where((c) => !c.isActive)
        .toList();
    if (cycles.isEmpty) return [];

    // Leftovers saved at each cycle's close, by cycle
    final history = await _savingsRepository.getSavingsHistory(limit: 5000);
    final savedByCycle = <int, int>{};
    for (final h in history) {
      if (h.description == _cycleEndDescription && h.relatedCycleId != null) {
        savedByCycle[h.relatedCycleId!] =
            (savedByCycle[h.relatedCycleId!] ?? 0) + h.amount;
      }
    }

    return [
      for (final cycle in cycles)
        PastCycleSummary(
          cycle: cycle,
          income: cycle.salaryAmount +
              await earnedIncome(_incomeRepository, cycle.id),
          spending: await totalSpending(_expenseRepository, cycle.id),
          saved: savedByCycle[cycle.id] ?? 0,
        ),
    ];
  }
}
