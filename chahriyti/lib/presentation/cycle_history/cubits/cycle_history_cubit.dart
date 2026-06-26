import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/financial_cycle_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class CycleHistoryState {}

class CycleHistoryLoading extends CycleHistoryState {}

class CycleHistoryLoaded extends CycleHistoryState {
  final List<CycleWithStats> cycles;
  CycleHistoryLoaded(this.cycles);
}

class CycleHistoryError extends CycleHistoryState {
  final String message;
  CycleHistoryError(this.message);
}

// ─── Cycle with Stats ──────────────────────────────────────────────────────

class CycleWithStats {
  final FinancialCycleEntity cycle;
  final int totalExpenses;
  final int totalIncome;

  CycleWithStats({
    required this.cycle,
    required this.totalExpenses,
    required this.totalIncome,
  });

  int get balance => cycle.salaryAmount + totalIncome - totalExpenses;
}

// ─── Cubit ────────────────────────────────────────────────────────────────

class CycleHistoryCubit extends Cubit<CycleHistoryState> {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;

  CycleHistoryCubit({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository,
        super(CycleHistoryLoading());

  Future<void> loadHistory() async {
    emit(CycleHistoryLoading());
    try {
      debugPrint('📊 CYCLE HISTORY: Loading closed cycles...');
      final cycles = await _cycleRepository.getCycleHistory(limit: 12);
      debugPrint('📊 CYCLE HISTORY: Found ${cycles.length} cycles');

      final cyclesWithStats = <CycleWithStats>[];
      for (final cycle in cycles) {
        final totalExpenses = await _expenseRepository.getTotalExpenses(cycle.id);
        debugPrint('   - Cycle ${cycle.id}: $totalExpenses DZD expenses');
        cyclesWithStats.add(
          CycleWithStats(
            cycle: cycle,
            totalExpenses: totalExpenses,
            totalIncome: 0, // Can add income lookup if needed
          ),
        );
      }

      emit(CycleHistoryLoaded(cyclesWithStats));
    } catch (e) {
      debugPrint('❌ CYCLE HISTORY ERROR: $e');
      emit(CycleHistoryError('حدث خطأ في تحميل السجل: ${e.toString()}'));
    }
  }
}
