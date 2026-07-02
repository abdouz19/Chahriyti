import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/lending/add_lending_collection_use_case.dart';
import '../../../application/use_cases/lending/create_lending_use_case.dart';
import '../../../application/use_cases/lending/delete_lending_use_case.dart';
import '../../../application/use_cases/lending/get_lendings_use_case.dart';
import '../../../application/use_cases/lending/update_lending_use_case.dart';
import '../../../application/use_cases/savings/get_savings_balance_use_case.dart';
import 'lending_state.dart';

class LendingCubit extends Cubit<LendingState> {
  final CreateLendingUseCase _createLendingUseCase;
  final GetLendingsUseCase _getLendingsUseCase;
  final AddLendingCollectionUseCase _addCollectionUseCase;
  final DeleteLendingUseCase _deleteLendingUseCase;
  final GetSavingsBalanceUseCase _getSavingsBalanceUseCase;
  final UpdateLendingUseCase _updateLendingUseCase;

  static const _pageSize = 10;
  bool _isLoadingMore = false;

  LendingCubit(
    this._createLendingUseCase,
    this._getLendingsUseCase,
    this._addCollectionUseCase,
    this._deleteLendingUseCase,
    this._getSavingsBalanceUseCase,
    this._updateLendingUseCase,
  ) : super(const LendingState.initial());

  Future<void> loadLendings() async {
    emit(const LendingState.loading());
    try {
      final lendings = await _getLendingsUseCase.getActiveLendings(
        limit: _pageSize,
        offset: 0,
      );
      emit(LendingState.lendingsLoaded(
        lendings,
        hasMore: lendings.length == _pageSize,
        offset: _pageSize,
      ));
    } catch (e) {
      emit(LendingState.error(e.toString()));
    }
  }

  Future<void> loadCollectedLendings() async {
    emit(const LendingState.loading());
    try {
      final lendings = await _getLendingsUseCase.getCollectedLendings(
        limit: _pageSize,
        offset: 0,
      );
      emit(LendingState.lendingsLoaded(
        lendings,
        isCollectedTab: true,
        hasMore: lendings.length == _pageSize,
        offset: _pageSize,
      ));
    } catch (e) {
      emit(LendingState.error(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! LendingsLoaded || !currentState.hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    try {
      final newLendings = currentState.isCollectedTab
          ? await _getLendingsUseCase.getCollectedLendings(
              limit: _pageSize,
              offset: currentState.offset,
            )
          : await _getLendingsUseCase.getActiveLendings(
              limit: _pageSize,
              offset: currentState.offset,
            );
      emit(LendingState.lendingsLoaded(
        [...currentState.lendings, ...newLendings],
        hasMore: newLendings.length == _pageSize,
        offset: currentState.offset + _pageSize,
        isCollectedTab: currentState.isCollectedTab,
      ));
    } catch (_) {}
    _isLoadingMore = false;
  }

  Future<void> loadLendingById(int id) async {
    emit(const LendingState.loading());
    try {
      final lending = await _getLendingsUseCase.getLendingById(id);
      if (lending == null) {
        emit(const LendingState.error('السلفة غير موجودة'));
        return;
      }
      final collections =
          await _getLendingsUseCase.getCollectionsForLending(id);
      emit(LendingState.lendingLoaded(lending, collections));
    } catch (e) {
      emit(LendingState.error(e.toString()));
    }
  }

  Future<void> createLending({
    required String borrowerName,
    required int amount,
    bool fromSavings = false,
    int savingsAmount = 0,
    String? notes,
  }) async {
    emit(const LendingState.loading());
    try {
      final lending = await _createLendingUseCase(
        borrowerName: borrowerName,
        amount: amount,
        fromSavings: fromSavings,
        savingsAmount: savingsAmount,
        notes: notes,
      );
      emit(LendingState.lendingCreated(lending));
    } catch (e) {
      emit(LendingState.error(e.toString()));
    }
  }

  Future<void> addCollection({
    required int lendingId,
    required int amount,
    bool toSavings = false,
  }) async {
    try {
      await _addCollectionUseCase(
        lendingId: lendingId,
        amount: amount,
        toSavings: toSavings,
      );
      emit(const LendingState.collectionAdded());
      await loadLendingById(lendingId);
    } catch (e) {
      emit(LendingState.error(e.toString()));
    }
  }

  Future<void> deleteLending(int id) async {
    try {
      await _deleteLendingUseCase(id);
      emit(const LendingState.lendingDeleted());
    } catch (e) {
      emit(LendingState.error(e.toString()));
    }
  }

  Future<int> getSavingsBalance() async {
    return _getSavingsBalanceUseCase();
  }

  Future<void> updateLending({
    required int id,
    String? borrowerName,
    String? notes,
    int? totalAmount,
  }) async {
    emit(const LendingState.loading());
    try {
      await _updateLendingUseCase(UpdateLendingRequest(
        id: id,
        borrowerName: borrowerName,
        notes: notes,
        totalAmount: totalAmount,
      ));
      await loadLendingById(id);
    } catch (e) {
      emit(LendingState.error(e.toString()));
    }
  }
}
