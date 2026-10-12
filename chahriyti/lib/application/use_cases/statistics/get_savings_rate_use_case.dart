import 'stats_amounts.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../../../domain/repositories/income_repository.dart';
import '../../../domain/entities/financial_cycle_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';

class SavingsRateResult {
  /// Put into savings this cycle: salary part set aside, income sent to
  /// savings and manual deposits, minus manual withdrawals.
  final int savedAmount;

  /// Salary + income earned this cycle (opening balance excluded).
  final int incomeBase;
  final double rate;          // savedAmount / incomeBase * 100
  final double? previousRate; // same for last closed cycle (null = no data)
  final double? rateDelta;    // rate - previousRate

  const SavingsRateResult({
    required this.savedAmount,
    required this.incomeBase,
    required this.rate,
    this.previousRate,
    this.rateDelta,
  });

  bool get hasComparison => previousRate != null;
  bool get isDeltaPositive => (rateDelta ?? 0) >= 0;

  static const empty = SavingsRateResult(
    savedAmount: 0,
    incomeBase: 0,
    rate: 0,
  );
}

class GetSavingsRateUseCase {
  final CycleRepository _cycleRepository;
  final IncomeRepository _incomeRepository;
  final SavingsRepository _savingsRepository;

  const GetSavingsRateUseCase({
    required CycleRepository cycleRepository,
    required IncomeRepository incomeRepository,
    required SavingsRepository savingsRepository,
  })  : _cycleRepository = cycleRepository,
        _incomeRepository = incomeRepository,
        _savingsRepository = savingsRepository;

  Future<SavingsRateResult> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return SavingsRateResult.empty;

    final current = await _forCycle(cycle);
    if (current.incomeBase <= 0) return SavingsRateResult.empty;

    // Compare against most recent closed cycle. End-of-cycle leftovers are
    // left out of both so the running cycle isn't penalised for not having one.
    final history = await _cycleRepository.getCycleHistory(limit: 6);
    final closed = history.where((c) => !c.isActive).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    if (closed.isEmpty) return current;

    final previous = await _forCycle(closed.first);
    if (previous.incomeBase <= 0) return current;

    return SavingsRateResult(
      savedAmount: current.savedAmount,
      incomeBase: current.incomeBase,
      rate: current.rate,
      previousRate: previous.rate,
      rateDelta: current.rate - previous.rate,
    );
  }

  Future<SavingsRateResult> _forCycle(FinancialCycleEntity cycle) async {
    final incomeBase = cycle.salaryAmount +
        await earnedIncome(_incomeRepository, cycle.id);
    final saved = cycle.salarySplitAmount +
        await earnedIncome(_incomeRepository, cycle.id, onlyToSavings: true) -
        await _savingsRepository.getNetTransfersToBalanceForCycle(cycle.id);
    return SavingsRateResult(
      savedAmount: saved,
      incomeBase: incomeBase,
      rate: incomeBase > 0 ? saved / incomeBase * 100 : 0,
    );
  }
}
