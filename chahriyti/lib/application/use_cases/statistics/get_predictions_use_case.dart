import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

class PredictionResult {
  final int predictedEndBalance;
  final DateTime? depletionDate; // null if won't deplete
  final int currentDailyRate;

  const PredictionResult({
    required this.predictedEndBalance,
    this.depletionDate,
    required this.currentDailyRate,
  });
}

class GetPredictionsUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;

  const GetPredictionsUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository;

  Future<PredictionResult?> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return null;

    final now = DateTime.now();
    final totalExpenses = await _expenseRepository.getTotalExpenses(cycle.id);

    final daysElapsed = cycle.daysElapsed(now);
    final daysRemaining = cycle.daysRemaining(now);

    // Current daily spending rate
    final currentDailyRate = daysElapsed > 0 ? totalExpenses ~/ daysElapsed : 0;

    // Current balance
    final currentBalance = cycle.salaryAmount - totalExpenses;

    // Predicted total spending by end of cycle
    final predictedTotalSpending =
        totalExpenses + (currentDailyRate * daysRemaining);
    final predictedEndBalance = cycle.salaryAmount - predictedTotalSpending;

    // Calculate depletion date if spending will exceed balance
    DateTime? depletionDate;
    if (currentDailyRate > 0 && currentBalance > 0) {
      final daysUntilDepletion = currentBalance ~/ currentDailyRate;
      if (daysUntilDepletion < daysRemaining) {
        depletionDate = now.add(Duration(days: daysUntilDepletion));
      }
    } else if (currentBalance <= 0) {
      // Already depleted
      depletionDate = now;
    }

    return PredictionResult(
      predictedEndBalance: predictedEndBalance,
      depletionDate: depletionDate,
      currentDailyRate: currentDailyRate,
    );
  }
}
