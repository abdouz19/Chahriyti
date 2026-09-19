import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/income_repository.dart';

class IncomeBreakdownResult {
  final Map<String, int> amounts;      // description → DZD
  final Map<String, double> percentages; // description → %
  final int total;

  const IncomeBreakdownResult({
    required this.amounts,
    required this.percentages,
    required this.total,
  });

  static const empty = IncomeBreakdownResult(
    amounts: {},
    percentages: {},
    total: 0,
  );
}

class GetIncomeBreakdownUseCase {
  final CycleRepository _cycleRepository;
  final IncomeRepository _incomeRepository;

  const GetIncomeBreakdownUseCase({
    required CycleRepository cycleRepository,
    required IncomeRepository incomeRepository,
  })  : _cycleRepository = cycleRepository,
        _incomeRepository = incomeRepository;

  Future<IncomeBreakdownResult> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return IncomeBreakdownResult.empty;

    final incomes = await _incomeRepository.getIncomesForCycle(cycle.id);
    if (incomes.isEmpty) return IncomeBreakdownResult.empty;

    // Group by description, sum amounts (exclude system entries)
    const excluded = {'رصيد أولي', 'رصيد اولي'};
    final amounts = <String, int>{};
    for (final income in incomes) {
      final key = income.description.trim();
      if (key.isEmpty || excluded.contains(key)) continue;
      amounts[key] = (amounts[key] ?? 0) + income.amount;
    }

    if (amounts.isEmpty) return IncomeBreakdownResult.empty;

    // Sort by amount descending
    final sorted = Map.fromEntries(
      amounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );

    final total = sorted.values.fold<int>(0, (s, v) => s + v);
    final percentages = sorted.map(
      (k, v) => MapEntry(k, (v / total) * 100),
    );

    return IncomeBreakdownResult(
      amounts: sorted,
      percentages: percentages,
      total: total,
    );
  }
}
