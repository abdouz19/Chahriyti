import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/financial_cycle_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class CycleHistoryState {}

class CycleHistoryLoading extends CycleHistoryState {}

class CycleHistoryLoaded extends CycleHistoryState {
  final List<CycleWithStats> cycles;
  final bool hasMore;
  final int offset;
  CycleHistoryLoaded(this.cycles, {this.hasMore = false, this.offset = 0});
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

  static const _pageSize = 10;
  bool _isLoadingMore = false;

  CycleHistoryCubit({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository,
        super(CycleHistoryLoading());

  Future<void> loadHistory() async {
    emit(CycleHistoryLoading());
    try {
      final cycles = await _cycleRepository.getCycleHistory(
        limit: _pageSize,
        offset: 0,
      );

      final cyclesWithStats = await _buildStats(cycles);

      emit(CycleHistoryLoaded(
        cyclesWithStats,
        hasMore: cycles.length == _pageSize,
        offset: _pageSize,
      ));
    } catch (e) {
      emit(CycleHistoryError('حدث خطأ في تحميل السجل: ${e.toString()}'));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! CycleHistoryLoaded || !currentState.hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    try {
      final newCycles = await _cycleRepository.getCycleHistory(
        limit: _pageSize,
        offset: currentState.offset,
      );

      final newStats = await _buildStats(newCycles);

      emit(CycleHistoryLoaded(
        [...currentState.cycles, ...newStats],
        hasMore: newCycles.length == _pageSize,
        offset: currentState.offset + _pageSize,
      ));
    } catch (_) {}
    _isLoadingMore = false;
  }

  Future<List<CycleWithStats>> _buildStats(List<FinancialCycleEntity> cycles) async {
    final result = <CycleWithStats>[];
    for (final cycle in cycles) {
      final totalExpenses = await _expenseRepository.getTotalExpenses(cycle.id);
      result.add(CycleWithStats(
        cycle: cycle,
        totalExpenses: totalExpenses,
        totalIncome: 0,
      ));
    }
    return result;
  }
}
