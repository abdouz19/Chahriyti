import '../../../domain/repositories/cycle_repository.dart';

class SavingsRateResult {
  final int salarySplitAmount;
  final int salaryAmount;
  final double rate;          // salarySplitAmount / salaryAmount * 100
  final double? previousRate; // same for last closed cycle (null = no data)
  final double? rateDelta;    // rate - previousRate

  const SavingsRateResult({
    required this.salarySplitAmount,
    required this.salaryAmount,
    required this.rate,
    this.previousRate,
    this.rateDelta,
  });

  bool get hasComparison => previousRate != null;
  bool get isDeltaPositive => (rateDelta ?? 0) >= 0;

  static const empty = SavingsRateResult(
    salarySplitAmount: 0,
    salaryAmount: 0,
    rate: 0,
  );
}

class GetSavingsRateUseCase {
  final CycleRepository _cycleRepository;

  const GetSavingsRateUseCase({required CycleRepository cycleRepository})
      : _cycleRepository = cycleRepository;

  Future<SavingsRateResult> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null || cycle.salaryAmount <= 0) return SavingsRateResult.empty;

    final rate = (cycle.salarySplitAmount / cycle.salaryAmount) * 100;

    // Compare against most recent closed cycle
    final history = await _cycleRepository.getCycleHistory(limit: 6);
    final closed = history
        .where((c) => !c.isActive && c.salaryAmount > 0)
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    if (closed.isEmpty) {
      return SavingsRateResult(
        salarySplitAmount: cycle.salarySplitAmount,
        salaryAmount: cycle.salaryAmount,
        rate: rate,
      );
    }

    final prev = closed.first;
    final previousRate = (prev.salarySplitAmount / prev.salaryAmount) * 100;
    final delta = rate - previousRate;

    return SavingsRateResult(
      salarySplitAmount: cycle.salarySplitAmount,
      salaryAmount: cycle.salaryAmount,
      rate: rate,
      previousRate: previousRate,
      rateDelta: delta,
    );
  }
}
