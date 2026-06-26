import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/debt/add_debt_payment_use_case.dart';
import '../../../application/use_cases/debt/create_debt_use_case.dart';
import '../../../application/use_cases/debt/delete_debt_use_case.dart';
import '../../../application/use_cases/debt/get_debts_use_case.dart';
import '../../../application/use_cases/debt/update_debt_use_case.dart';
import '../../../infrastructure/services/notification_service.dart';
import 'debt_state.dart';

class DebtCubit extends Cubit<DebtState> {
  final CreateDebtUseCase _createDebtUseCase;
  final GetDebtsUseCase _getDebtsUseCase;
  final UpdateDebtUseCase _updateDebtUseCase;
  final DeleteDebtUseCase _deleteDebtUseCase;
  final AddDebtPaymentUseCase _addPaymentUseCase;
  final NotificationService? _notificationService;

  DebtCubit(
    this._createDebtUseCase,
    this._getDebtsUseCase,
    this._updateDebtUseCase,
    this._deleteDebtUseCase,
    this._addPaymentUseCase, {
    NotificationService? notificationService,
  })  : _notificationService = notificationService,
        super(const DebtState.initial());

  Future<void> loadDebts({int limit = 20, int offset = 0}) async {
    emit(const DebtState.loading());
    try {
      final debts = await _getDebtsUseCase(limit: limit, offset: offset);
      emit(DebtState.debtsLoaded(
        debts,
        hasMore: debts.length == limit,
        offset: offset,
      ));
    } catch (e) {
      emit(DebtState.error('فشل تحميل الديون: ${e.toString()}'));
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

  Future<void> addPayment({
    required int debtId,
    required int amount,
  }) async {
    emit(const DebtState.loading());
    try {
      await _addPaymentUseCase(debtId: debtId, amount: amount);
      emit(const DebtState.paymentAdded());

      // Trigger motivational notifications
      _notificationService?.checkNotifications();

      // Reload debts
      await loadDebts();
    } catch (e) {
      emit(DebtState.error('فشل إضافة السداد: ${e.toString()}'));
    }
  }

  Future<void> refresh() async {
    await loadDebts();
  }
}
