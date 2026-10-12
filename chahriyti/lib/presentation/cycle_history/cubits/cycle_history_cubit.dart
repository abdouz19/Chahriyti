import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/statistics/get_past_cycles_use_case.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class CycleHistoryState {}

class CycleHistoryLoading extends CycleHistoryState {}

class CycleHistoryLoaded extends CycleHistoryState {
  final List<PastCycleSummary> cycles;
  final bool hasMore;
  final int offset;
  CycleHistoryLoaded(this.cycles, {this.hasMore = false, this.offset = 0});
}

class CycleHistoryError extends CycleHistoryState {
  final String message;
  CycleHistoryError(this.message);
}

// ─── Cubit ────────────────────────────────────────────────────────────────

class CycleHistoryCubit extends Cubit<CycleHistoryState> {
  final GetPastCyclesUseCase _getPastCycles;

  static const _pageSize = 10;
  bool _isLoadingMore = false;

  CycleHistoryCubit({required GetPastCyclesUseCase getPastCycles})
      : _getPastCycles = getPastCycles,
        super(CycleHistoryLoading());

  Future<void> loadHistory() async {
    emit(CycleHistoryLoading());
    try {
      final cycles = await _getPastCycles(limit: _pageSize);
      emit(CycleHistoryLoaded(
        cycles,
        hasMore: cycles.length == _pageSize,
        offset: _pageSize,
      ));
    } catch (e) {
      emit(CycleHistoryError('حدث خطأ في تحميل السجل: ${e.toString()}'));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! CycleHistoryLoaded || !current.hasMore || _isLoadingMore) {
      return;
    }
    _isLoadingMore = true;
    try {
      final more = await _getPastCycles(limit: _pageSize, offset: current.offset);
      emit(CycleHistoryLoaded(
        [...current.cycles, ...more],
        hasMore: more.length == _pageSize,
        offset: current.offset + _pageSize,
      ));
    } catch (_) {}
    _isLoadingMore = false;
  }
}
