import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/savings/deposit_from_balance_use_case.dart';
import '../../../application/use_cases/savings/withdraw_to_balance_use_case.dart';
import '../../../application/use_cases/savings/get_savings_balance_use_case.dart';
import '../../../application/use_cases/savings/get_savings_history_use_case.dart';
import '../../../application/use_cases/dashboard/get_dashboard_data_use_case.dart';
import 'savings_state.dart';

class SavingsCubit extends Cubit<SavingsState> {
  final GetSavingsBalanceUseCase _getBalance;
  final GetSavingsHistoryUseCase _getHistory;
  final DepositFromBalanceUseCase _depositFromBalance;
  final WithdrawToBalanceUseCase _withdrawToBalance;
  final GetDashboardDataUseCase _getDashboardData;

  static const _pageSize = 10;
  bool _isLoadingMore = false;

  SavingsCubit(
    this._getBalance,
    this._getHistory,
    this._depositFromBalance,
    this._withdrawToBalance,
    this._getDashboardData,
  ) : super(const SavingsState.loading());

  Future<void> loadSavings() async {
    emit(const SavingsState.loading());
    try {
      final balance = await _getBalance();
      final history = await _getHistory(limit: _pageSize, offset: 0);
      emit(SavingsState.loaded(
        balance: balance,
        history: history,
        hasMore: history.length == _pageSize,
        offset: _pageSize,
      ));
    } catch (e) {
      emit(SavingsState.error('فشل تحميل المدخرات: ${e.toString()}'));
    }
  }

  Future<int> fetchAvailableBalance() async {
    final data = await _getDashboardData();
    return data.currentBalance;
  }

  Future<String?> deposit(int amount) async {
    try {
      await _depositFromBalance(amount: amount);
      await loadSavings();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> withdraw(int amount) async {
    try {
      await _withdrawToBalance(amount: amount);
      await loadSavings();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! SavingsLoaded || !currentState.hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    try {
      final newHistory = await _getHistory(
        limit: _pageSize,
        offset: currentState.offset,
      );
      emit(SavingsState.loaded(
        balance: currentState.balance,
        history: [...currentState.history, ...newHistory],
        hasMore: newHistory.length == _pageSize,
        offset: currentState.offset + _pageSize,
      ));
    } catch (_) {}
    _isLoadingMore = false;
  }
}
