import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/debt_entity.dart';
import '../../../application/use_cases/debt/add_debt_payment_use_case.dart';
import '../../../application/use_cases/debt/create_debt_use_case.dart';
import '../../../application/use_cases/debt/delete_debt_use_case.dart';
import '../../../application/use_cases/debt/get_debts_use_case.dart';
import '../../../application/use_cases/debt/update_debt_use_case.dart';
import '../../../application/use_cases/savings/get_savings_balance_use_case.dart';
import '../../../infrastructure/services/notification_service.dart';
import 'debt_state.dart';

class DebtCubit extends Cubit<DebtState> {
  final CreateDebtUseCase _createDebtUseCase;
  final GetDebtsUseCase _getDebtsUseCase;
  final UpdateDebtUseCase _updateDebtUseCase;
  final DeleteDebtUseCase _deleteDebtUseCase;
  final AddDebtPaymentUseCase _addPaymentUseCase;
  final GetSavingsBalanceUseCase _getSavingsBalance;
  final NotificationService? _notificationService;

  static const _pageSize = 10;
  bool _isLoadingMore = false;

  DebtCubit(
    this._createDebtUseCase,
    this._getDebtsUseCase,
    this._updateDebtUseCase,
    this._deleteDebtUseCase,
    this._addPaymentUseCase,
    this._getSavingsBalance, {
    NotificationService? notificationService,
  })  : _notificationService = notificationService,
        super(const DebtState.initial());

  Future<int> getSavingsBalance() => _getSavingsBalance();

  Future<void> loadDebts() async {
    emit(const DebtState.loading());
    try {
      final results = await Future.wait([
        _getDebtsUseCase.getActiveDebts(limit: _pageSize, offset: 0),
        _getDebtsUseCase.getTotalActiveRemainingAmount(),
      ]);
      final debts = results[0] as List<DebtEntity>;
      final totalRemaining = results[1] as int;
      emit(DebtState.debtsLoaded(
        debts,
        hasMore: debts.length == _pageSize,
        offset: _pageSize,
        totalRemaining: totalRemaining,
      ));
    } catch (e) {
      emit(DebtState.error('فشل تحميل الديون: ${e.toString()}'));
    }
  }

  Future<void> loadCompletedDebts() async {
    emit(const DebtState.loading());
    try {
      final debts = await _getDebtsUseCase.getCompletedDebts(
        limit: _pageSize,
        offset: 0,
      );
      emit(DebtState.debtsLoaded(
        debts,
        isCompletedTab: true,
        hasMore: debts.length == _pageSize,
        offset: _pageSize,
      ));
    } catch (e) {
      emit(DebtState.error('فشل تحميل الديون: ${e.toString()}'));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! DebtsLoaded || !currentState.hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    try {
      final newDebts = currentState.isCompletedTab
          ? await _getDebtsUseCase.getCompletedDebts(
              limit: _pageSize,
              offset: currentState.offset,
            )
          : await _getDebtsUseCase.getActiveDebts(
              limit: _pageSize,
              offset: currentState.offset,
            );
      emit(DebtState.debtsLoaded(
        [...currentState.debts, ...newDebts],
        hasMore: newDebts.length == _pageSize,
        offset: currentState.offset + _pageSize,
        isCompletedTab: currentState.isCompletedTab,
        totalRemaining: currentState.totalRemaining,
      ));
    } catch (_) {}
    _isLoadingMore = false;
  }

  Future<void> loadDebtById(int debtId) async {
    emit(const DebtState.loading());
    try {
      final allDebts = await _getDebtsUseCase();
      final debt = allDebts.firstWhere(
        (d) => d.id == debtId,
        orElse: () => throw Exception('الدين غير موجود'),
      );
      emit(DebtState.debtLoaded(debt));
    } catch (e) {
      emit(DebtState.error('فشل تحميل تفاصيل الدين: ${e.toString()}'));
    }
  }

  Future<void> createDebt({
    required String creditorName,
    required int totalAmount,
    String? notes,
  }) async {
    emit(const DebtState.loading());
    try {
      final request = CreateDebtRequest(
        creditorName: creditorName,
        totalAmount: totalAmount,
        notes: notes,
      );
      final debtId = await _createDebtUseCase(request);
      emit(DebtState.debtCreated(debtId));

      // Trigger notifications
      _notificationService?.checkNotifications();

      // Reload debts
      await loadDebts();
    } catch (e) {
      emit(DebtState.error('فشل إنشاء الدين: ${e.toString()}'));
    }
  }

  Future<void> updateDebt({
    required int id,
    String? creditorName,
    int? totalAmount,
    String? notes,
  }) async {
    emit(const DebtState.loading());
    try {
      final request = UpdateDebtRequest(
        id: id,
        creditorName: creditorName,
        totalAmount: totalAmount,
        notes: notes,
      );
      await _updateDebtUseCase(request);
      emit(const DebtState.debtUpdated());
      // Reload debts
      await loadDebts();
    } catch (e) {
      emit(DebtState.error('فشل تحديث الدين: ${e.toString()}'));
    }
  }

  Future<void> deleteDebt(int id) async {
    emit(const DebtState.loading());
    try {
      await _deleteDebtUseCase(id);
      emit(const DebtState.debtDeleted());
      // Reload debts
      await loadDebts();
    } catch (e) {
      emit(DebtState.error('فشل حذف الدين: ${e.toString()}'));
    }
  }

  Future<String?> addPayment({
    required int debtId,
    required int amount,
    bool fromSavings = false,
    int savingsAmount = 0,
  }) async {
    emit(const DebtState.loading());
    try {
      await _addPaymentUseCase(
        debtId: debtId,
        amount: amount,
        fromSavings: fromSavings,
        savingsAmount: savingsAmount,
      );
      // Trigger motivational notifications
      _notificationService?.checkNotifications();

      // Reload the debt detail
      await loadDebtById(debtId);
      return null;
    } catch (e) {
      // Reload the debt so the detail view is preserved
      await loadDebtById(debtId);
      if (e is ArgumentError) {
        return e.message.toString();
      }
      return e.toString();
    }
  }

  Future<void> refresh() async {
    await loadDebts();
  }
}
