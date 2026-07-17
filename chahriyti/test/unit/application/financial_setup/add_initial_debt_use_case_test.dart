import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/financial_setup/add_initial_debt_use_case.dart';
import 'package:chahriyti/domain/entities/debt_entity.dart';
import 'package:chahriyti/domain/repositories/debt_repository.dart';

class FakeDebtRepository implements DebtRepository {
  String? lastCreditorName;
  int? lastTotalAmount;

  @override
  Future<int> createDebt({
    required String creditorName,
    required int totalAmount,
    String? notes,
    int? cycleId,
    bool isSpent = true,
  }) async {
    lastCreditorName = creditorName;
    lastTotalAmount = totalAmount;
    return 1;
  }

  @override
  Future<DebtEntity> addDebt({
    required String creditorName,
    required int totalAmount,
    required int paidAmount,
  }) async =>
      throw UnimplementedError();

  @override
  Future<DebtEntity?> getDebtById(int id) async => throw UnimplementedError();

  @override
  Future<List<DebtEntity>> getUserDebts({int limit = 20, int offset = 0}) async =>
      throw UnimplementedError();

  @override
  Future<List<DebtEntity>> getActiveDebts({int? limit, int? offset}) async =>
      throw UnimplementedError();

  @override
  Future<List<DebtEntity>> getCompletedDebts({int? limit, int? offset}) async =>
      throw UnimplementedError();

  @override
  Future<void> updateDebt({
    required int id,
    String? creditorName,
    int? totalAmount,
    String? notes,
    bool? isSpent,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteDebt(int id) async => throw UnimplementedError();

  @override
  Future<void> addPayment({
    required int debtId,
    required int amount,
    bool fromSavings = false,
    int savingsAmount = 0,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> markDebtCompleted(int id) async => throw UnimplementedError();

  @override
  Future<void> makePayment({
    required int debtId,
    required int amount,
    required int cycleId,
    bool fromSavings = false,
  }) async =>
      throw UnimplementedError();

  @override
  Future<int> getTotalDebtPaymentsForCycle(int cycleId) async =>
      throw UnimplementedError();

  @override
  Future<int> getTotalDebtPaymentsFromSavingsForCycle(int cycleId) async =>
      throw UnimplementedError();

  @override
  Future<int> getTotalDebtsCreatedForCycle(int cycleId) async =>
      throw UnimplementedError();

  @override
  Future<List<int>> getSavingsPaymentIds(int debtId) async =>
      throw UnimplementedError();

  @override
  Future<int> getTotalActiveRemainingAmount() async =>
      throw UnimplementedError();
}

void main() {
  late FakeDebtRepository repository;
  late AddInitialDebtUseCase useCase;

  setUp(() {
    repository = FakeDebtRepository();
    useCase = AddInitialDebtUseCase(repository);
  });

  test('creates debt with correct creditorName and totalAmount', () async {
    await useCase.call(creditorName: 'بنك السلام', totalAmount: 150000);

    expect(repository.lastCreditorName, 'بنك السلام');
    expect(repository.lastTotalAmount, 150000);
  });

  test('throws ArgumentError for empty name', () {
    expect(
      () => useCase.call(creditorName: '', totalAmount: 50000),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('throws ArgumentError for whitespace-only name', () {
    expect(
      () => useCase.call(creditorName: '   ', totalAmount: 50000),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('throws ArgumentError for amount <= 0', () {
    expect(
      () => useCase.call(creditorName: 'دائن', totalAmount: 0),
      throwsA(isA<ArgumentError>()),
    );

    expect(
      () => useCase.call(creditorName: 'دائن', totalAmount: -1000),
      throwsA(isA<ArgumentError>()),
    );
  });
}
