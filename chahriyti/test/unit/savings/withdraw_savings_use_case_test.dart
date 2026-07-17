import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/savings/withdraw_savings_use_case.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';

class FakeSavingsRepository implements SavingsRepository {
  int _balance = 0;
  final List<SavingsHistoryEntity> _created = [];

  void setBalance(int balance) => _balance = balance;
  List<SavingsHistoryEntity> get createdRecords => _created;

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
  }) async {
    final entity = SavingsHistoryEntity(
      id: _created.length + 1,
      type: SavingsTransactionType.withdrawal,
      amount: amount,
      description: description,
      relatedExpenseId: expenseId,
      relatedDebtPaymentId: debtPaymentId,
      createdAt: DateTime.now(),
    );
    _created.add(entity);
    _balance -= amount;
    return entity;
  }

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
  @override
  Future<void> createInitialDeposit({required int amount}) async {}
}

void main() {
  late FakeSavingsRepository repository;
  late WithdrawSavingsUseCase useCase;

  setUp(() {
    repository = FakeSavingsRepository();
    useCase = WithdrawSavingsUseCase(repository);
  });

  test('successful withdrawal creates record and decreases balance', () async {
    repository.setBalance(5000);

    await useCase.call(
      amount: 2000,
      description: 'سداد مصروف',
      expenseId: 1,
    );

    expect(repository.createdRecords, hasLength(1));
    expect(repository.createdRecords.first.amount, 2000);
    expect(repository.createdRecords.first.type,
        SavingsTransactionType.withdrawal);
    expect(repository.createdRecords.first.relatedExpenseId, 1);
  });

  test('throws error when insufficient balance', () async {
    repository.setBalance(1000);

    expect(
      () => useCase.call(
        amount: 2000,
        description: 'سداد مصروف',
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('throws error when amount is zero', () async {
    repository.setBalance(5000);

    expect(
      () => useCase.call(
        amount: 0,
        description: 'سداد مصروف',
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('throws error when amount is negative', () async {
    repository.setBalance(5000);

    expect(
      () => useCase.call(
        amount: -100,
        description: 'سداد مصروف',
      ),
      throwsA(isA<ArgumentError>()),
    );
  });
}
