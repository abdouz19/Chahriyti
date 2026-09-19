import '../../../domain/entities/savings_history_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/savings_repository.dart';

class SavingsBalancePoint {
  final DateTime month; // cycle start date — used as x-axis label
  final int balance;    // cumulative savings balance at end of that cycle
  final bool isActive;  // true for the current cycle point

  const SavingsBalancePoint({
    required this.month,
    required this.balance,
    required this.isActive,
  });
}

class GetSavingsBalanceHistoryUseCase {
  final CycleRepository _cycleRepository;
  final SavingsRepository _savingsRepository;

  const GetSavingsBalanceHistoryUseCase({
    required CycleRepository cycleRepository,
    required SavingsRepository savingsRepository,
  })  : _cycleRepository = cycleRepository,
        _savingsRepository = savingsRepository;

  Future<List<SavingsBalancePoint>> call() async {
    final history = await _cycleRepository.getCycleHistory(limit: 7);
    if (history.isEmpty) return [];

    // Fetch all savings transactions once — typically small dataset
    final allTx = await _savingsRepository.getSavingsHistory();
    if (allTx.isEmpty) return [];

    // Sort transactions chronologically for efficient prefix-sum scan
    final sorted = [...allTx]..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Cycles sorted oldest first for chart display
    final cyclesSorted = [...history]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final points = <SavingsBalancePoint>[];

    for (final cycle in cyclesSorted) {
      final cutoff = cycle.isActive ? DateTime.now() : cycle.endDate;

      int balance = 0;
      for (final tx in sorted) {
        if (tx.createdAt.isAfter(cutoff)) break;
        if (tx.type == SavingsTransactionType.deposit) {
          balance += tx.amount;
        } else {
          balance -= tx.amount;
        }
      }

      points.add(SavingsBalancePoint(
        month: cycle.startDate,
        balance: balance < 0 ? 0 : balance,
        isActive: cycle.isActive,
      ));
    }

    // Need at least 2 points to draw a meaningful line
    return points.length >= 2 ? points : [];
  }
}
