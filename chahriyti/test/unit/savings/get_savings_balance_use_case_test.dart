import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/savings/get_savings_balance_use_case.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';

class FakeSavingsRepository implements SavingsRepository {
  int _balance = 0;

  void setBalance(int balance) => _balance = balance;

  @override
  Future<int> getSavingsBalance() async => _balance;

  @override
  Future<List<SavingsHistoryEntity>> getSavingsHistory({int? limit, int? offset}) async => [];
  @override
  Future<SavingsHistoryEntity> createDeposit({
    required int amount,
    required String description,
    required int cycleId,
  }) async =>
      throw UnimplementedError();
  @override
  Future<SavingsHistoryEntity> createWithdrawal({
    required int amount,
    required String description,
    int? expenseId,
    int? debtPaymentId,
    int? lendingId,
  }) async =>
      throw UnimplementedError();
  @override
  Future<void> deleteWithdrawalByExpenseId(int expenseId) async {}
  @override
  Future<void> deleteWithdrawalByDebtPaymentId(int debtPaymentId) async {}
  @override
  Future<void> deleteWithdrawalByLendingId(int lendingId) async {}
  @override
  Future<void> updateWithdrawalAmountByExpenseId(
      int expenseId, int newAmount) async {}
  @override
  Future<void> updateWithdrawalAmountByDebtPaymentId(
      int debtPaymentId, int newAmount) async {}
}

void main() {
  late FakeSavingsRepository repository;
  late GetSavingsBalanceUseCase useCase;

  setUp(() {
    repository = FakeSavingsRepository();
    useCase = GetSavingsBalanceUseCase(repository);
  });

  test('returns correct balance', () async {
    repository.setBalance(5000);
    final balance = await useCase();
    expect(balance, 5000);
  });

  test('returns zero when no history', () async {
    repository.setBalance(0);
    final balance = await useCase();
    expect(balance, 0);
  });
}
