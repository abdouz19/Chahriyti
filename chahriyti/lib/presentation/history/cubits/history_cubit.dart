import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/expense/delete_expense_use_case.dart';
import '../../../domain/entities/expense_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class HistoryState {
  const HistoryState();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<ExpenseEntity> expenses;
  final bool hasMore;
  final int? activeCycleId;

  const HistoryLoaded({
    required this.expenses,
    required this.hasMore,
    this.activeCycleId,
  });
}

class HistoryLoadingMore extends HistoryState {
  final List<ExpenseEntity> currentExpenses;
  final int? activeCycleId;

  const HistoryLoadingMore({
    required this.currentExpenses,
    this.activeCycleId,
  });
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class HistoryCubit extends Cubit<HistoryState> {
  final ExpenseRepository _expenseRepository;
  final CycleRepository _cycleRepository;
  final DeleteExpenseUseCase _deleteExpenseUseCase;

  static const int _pageSize = 10;
  int _currentOffset = 0;
  int? _cycleId;
  int? _activeCycleId;

  HistoryCubit({
    required ExpenseRepository expenseRepository,
    required CycleRepository cycleRepository,
    required DeleteExpenseUseCase deleteExpenseUseCase,
  })  : _expenseRepository = expenseRepository,
        _cycleRepository = cycleRepository,
        _deleteExpenseUseCase = deleteExpenseUseCase,
        super(const HistoryLoading());

  Future<void> loadExpenses() async {
    emit(const HistoryLoading());
    _currentOffset = 0;

    try {
      final cycle = await _cycleRepository.getActiveCycle();
      if (cycle == null) {
        emit(const HistoryLoaded(expenses: [], hasMore: false));
        return;
      }

      _cycleId = cycle.id;
      _activeCycleId = cycle.id;

      final expenses = await _expenseRepository.getExpenses(
        cycle.id,
        limit: _pageSize,
        offset: 0,
      );

      _currentOffset = expenses.length;

      emit(HistoryLoaded(
        expenses: expenses,
        hasMore: expenses.length >= _pageSize,
        activeCycleId: _activeCycleId,
      ));
    } catch (e) {
      emit(HistoryError('حدث خطأ في تحميل السجل: ${e.toString()}'));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! HistoryLoaded || !current.hasMore) return;
    if (_cycleId == null) return;

    emit(HistoryLoadingMore(
      currentExpenses: current.expenses,
      activeCycleId: _activeCycleId,
    ));

    try {
      final moreExpenses = await _expenseRepository.getExpenses(
        _cycleId!,
        limit: _pageSize,
        offset: _currentOffset,
      );

      _currentOffset += moreExpenses.length;

      emit(HistoryLoaded(
        expenses: [...current.expenses, ...moreExpenses],
        hasMore: moreExpenses.length >= _pageSize,
        activeCycleId: _activeCycleId,
      ));
    } catch (e) {
      // Restore loaded state on error
      emit(HistoryLoaded(
        expenses: current.expenses,
        hasMore: current.hasMore,
        activeCycleId: _activeCycleId,
      ));
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    if (_activeCycleId == null) return;
    try {
      await _deleteExpenseUseCase(
        expenseId: expenseId,
        cycleId: _activeCycleId!,
      );
      await loadExpenses();
    } catch (e) {
      emit(HistoryError('حدث خطأ في حذف المصروف: ${e.toString()}'));
    }
  }
}
