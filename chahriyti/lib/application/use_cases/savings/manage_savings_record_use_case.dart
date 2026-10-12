import '../../../domain/entities/savings_history_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../dashboard/get_dashboard_data_use_case.dart';

/// Edits and deletes savings history records without breaking the link
/// between savings and the balance.
class ManageSavingsRecordUseCase {
  final SavingsRepository _savingsRepo;
  final CycleRepository _cycleRepo;
  final GetDashboardDataUseCase _getDashboardData;

  const ManageSavingsRecordUseCase(
      this._savingsRepo, this._cycleRepo, this._getDashboardData);

  /// Only setup savings and manual transfers of the active cycle can change.
  /// Everything else belongs to an expense, lending, goal or a closed cycle,
  /// and must be changed from there.
  bool canModify(SavingsHistoryEntity record, int? activeCycleId) =>
      switch (record.kind) {
        SavingsRecordKind.initial => true,
        SavingsRecordKind.transfer =>
          activeCycleId != null && record.relatedCycleId == activeCycleId,
        SavingsRecordKind.other => false,
      };

  Future<void> delete(SavingsHistoryEntity record) async {
    await _checkAffordable(record, newAmount: 0);
    await _savingsRepo.deleteTransaction(record.id);
  }

  Future<void> edit(
    SavingsHistoryEntity record, {
    required int amount,
    required String description,
  }) async {
    if (amount <= 0) throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');
    await _checkAffordable(record, newAmount: amount);
    await _savingsRepo.updateTransaction(record.id,
        amount: amount, description: description);
  }

  /// Neither savings nor the balance may end up negative.
  Future<void> _checkAffordable(
    SavingsHistoryEntity record, {
    required int newAmount,
  }) async {
    final cycle = await _cycleRepo.getActiveCycle();
    if (!canModify(record, cycle?.id)) {
      throw StateError('هذه العملية مرتبطة بعملية أخرى ولا يمكن تعديلها من هنا');
    }

    final sign = record.type == SavingsTransactionType.deposit ? 1 : -1;
    final savingsDelta = sign * (newAmount - record.amount);
    // A transfer moves the same money the other way in the balance
    final balanceDelta =
        record.kind == SavingsRecordKind.transfer ? -savingsDelta : 0;

    if (savingsDelta < 0) {
      final savings = await _savingsRepo.getSavingsBalance();
      if (savings + savingsDelta < 0) {
        throw StateError('رصيد المدخرات غير كافٍ ($savings دج متاح)');
      }
    }
    if (balanceDelta < 0) {
      final balance = (await _getDashboardData()).currentBalance;
      if (balance + balanceDelta < 0) {
        throw StateError('الرصيد الحالي غير كافٍ ($balance دج متاح)');
      }
    }
  }
}
