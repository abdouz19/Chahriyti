import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/statistics/get_savings_balance_history_use_case.dart';

import 'fakes.dart';

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeSavingsRepository savingsRepo;
  late GetSavingsBalanceHistoryUseCase useCase;

  setUp(() {
    cycleRepo = FakeCycleRepository();
    savingsRepo = FakeSavingsRepository();
    useCase = GetSavingsBalanceHistoryUseCase(
      cycleRepository: cycleRepo,
      savingsRepository: savingsRepo,
    );
  });

  test('returns empty when no cycle history', () async {
    cycleRepo.history = [];
    final result = await useCase();
    expect(result, isEmpty);
  });

  test('returns empty when no savings transactions', () async {
    cycleRepo.history = [
      makeCycle(id: 1, isActive: false, startDate: DateTime(2024, 1, 1)),
      makeCycle(id: 2, isActive: true, startDate: DateTime(2024, 2, 1)),
    ];
    // no transactions added
    final result = await useCase();
    expect(result, isEmpty);
  });

  test('returns empty when only 1 point', () async {
    cycleRepo.history = [
      makeCycle(id: 1, isActive: true, startDate: DateTime(2024, 1, 1)),
    ];
    savingsRepo.addTransaction(
      id: 1,
      type: SavingsTransactionType.deposit,
      amount: 5000,
      createdAt: DateTime(2024, 1, 5),
    );
    final result = await useCase();
    expect(result, isEmpty);
  });

  test('two cycles with deposits produce correct cumulative balances', () async {
    cycleRepo.history = [
      makeCycle(
          id: 1,
          isActive: false,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31)),
      makeCycle(
          id: 2,
          isActive: false,
          startDate: DateTime(2024, 2, 1),
          endDate: DateTime(2024, 2, 29)),
    ];
    // deposit before cycle 1 end
    savingsRepo.addTransaction(
      id: 1,
      type: SavingsTransactionType.deposit,
      amount: 10000,
      createdAt: DateTime(2024, 1, 15),
    );
    // deposit before cycle 2 end
    savingsRepo.addTransaction(
      id: 2,
      type: SavingsTransactionType.deposit,
      amount: 5000,
      createdAt: DateTime(2024, 2, 10),
    );

    final result = await useCase();
    expect(result.length, 2);
    // cycle 1: 10000 cumulative
    expect(result[0].balance, 10000);
    expect(result[0].isActive, isFalse);
    // cycle 2: 10000 + 5000 = 15000 cumulative
    expect(result[1].balance, 15000);
    expect(result[1].isActive, isFalse);
  });

  test('withdrawal reduces balance correctly', () async {
    cycleRepo.history = [
      makeCycle(
          id: 1,
          isActive: false,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31)),
      makeCycle(
          id: 2,
          isActive: false,
          startDate: DateTime(2024, 2, 1),
          endDate: DateTime(2024, 2, 29)),
    ];
    savingsRepo.addTransaction(
      id: 1,
      type: SavingsTransactionType.deposit,
      amount: 20000,
      createdAt: DateTime(2024, 1, 10),
    );
    savingsRepo.addTransaction(
      id: 2,
      type: SavingsTransactionType.withdrawal,
      amount: 8000,
      createdAt: DateTime(2024, 2, 5),
    );

    final result = await useCase();
    expect(result[0].balance, 20000);
    expect(result[1].balance, 12000); // 20000 - 8000
  });

  test('transactions after cycle cutoff excluded from that cycle', () async {
    cycleRepo.history = [
      makeCycle(
          id: 1,
          isActive: false,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31)),
      makeCycle(
          id: 2,
          isActive: false,
          startDate: DateTime(2024, 2, 1),
          endDate: DateTime(2024, 2, 29)),
    ];
    // Before cycle 1 end — counted in cycle 1
    savingsRepo.addTransaction(
      id: 1,
      type: SavingsTransactionType.deposit,
      amount: 10000,
      createdAt: DateTime(2024, 1, 20),
    );
    // After cycle 1 end — counted in cycle 2 only
    savingsRepo.addTransaction(
      id: 2,
      type: SavingsTransactionType.deposit,
      amount: 5000,
      createdAt: DateTime(2024, 2, 1), // cycle 2 start = after cycle 1 end
    );

    final result = await useCase();
    expect(result[0].balance, 10000); // only first deposit
    expect(result[1].balance, 15000); // both deposits cumulative
  });

  test('balance never goes below zero', () async {
    cycleRepo.history = [
      makeCycle(
          id: 1,
          isActive: false,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31)),
      makeCycle(
          id: 2,
          isActive: false,
          startDate: DateTime(2024, 2, 1),
          endDate: DateTime(2024, 2, 29)),
    ];
    savingsRepo.addTransaction(
      id: 1,
      type: SavingsTransactionType.withdrawal,
      amount: 50000,
      createdAt: DateTime(2024, 1, 10),
    );
    savingsRepo.addTransaction(
      id: 2,
      type: SavingsTransactionType.deposit,
      amount: 1000,
      createdAt: DateTime(2024, 2, 10),
    );

    final result = await useCase();
    expect(result[0].balance, 0); // clamped to 0
    expect(result[1].balance, 0); // -50000 + 1000 still negative → 0
  });

  test('active cycle marked correctly', () async {
    cycleRepo.history = [
      makeCycle(
          id: 1,
          isActive: false,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31)),
      makeCycle(
          id: 2,
          isActive: true,
          startDate: DateTime(2024, 2, 1),
          endDate: DateTime(2024, 2, 29)),
    ];
    savingsRepo.addTransaction(
      id: 1,
      type: SavingsTransactionType.deposit,
      amount: 5000,
      createdAt: DateTime(2024, 1, 5),
    );
    savingsRepo.addTransaction(
      id: 2,
      type: SavingsTransactionType.deposit,
      amount: 3000,
      createdAt: DateTime(2024, 2, 5),
    );

    final result = await useCase();
    expect(result[0].isActive, isFalse);
    expect(result[1].isActive, isTrue);
  });

  test('points sorted oldest first', () async {
    // Pass history in reverse order
    cycleRepo.history = [
      makeCycle(
          id: 2,
          isActive: true,
          startDate: DateTime(2024, 2, 1),
          endDate: DateTime(2024, 2, 29)),
      makeCycle(
          id: 1,
          isActive: false,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31)),
    ];
    savingsRepo.addTransaction(
      id: 1,
      type: SavingsTransactionType.deposit,
      amount: 10000,
      createdAt: DateTime(2024, 1, 5),
    );
    savingsRepo.addTransaction(
      id: 2,
      type: SavingsTransactionType.deposit,
      amount: 2000,
      createdAt: DateTime(2024, 2, 5),
    );

    final result = await useCase();
    expect(result[0].month, DateTime(2024, 1, 1));
    expect(result[1].month, DateTime(2024, 2, 1));
  });

  test('month label uses cycle start date', () async {
    final startDate = DateTime(2024, 3, 15);
    cycleRepo.history = [
      makeCycle(
          id: 1,
          isActive: false,
          startDate: startDate,
          endDate: DateTime(2024, 3, 31)),
      makeCycle(
          id: 2,
          isActive: true,
          startDate: DateTime(2024, 4, 1),
          endDate: DateTime(2024, 4, 30)),
    ];
    savingsRepo.addTransaction(
      id: 1,
      type: SavingsTransactionType.deposit,
      amount: 1000,
      createdAt: DateTime(2024, 3, 20),
    );
    savingsRepo.addTransaction(
      id: 2,
      type: SavingsTransactionType.deposit,
      amount: 500,
      createdAt: DateTime(2024, 4, 5),
    );

    final result = await useCase();
    expect(result[0].month, startDate);
  });
}
