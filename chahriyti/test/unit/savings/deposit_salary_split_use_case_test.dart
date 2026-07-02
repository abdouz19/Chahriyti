import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/savings/deposit_salary_split_use_case.dart';
import 'package:chahriyti/domain/entities/financial_cycle_entity.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/repositories/cycle_repository.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';

class FakeCycleRepository implements CycleRepository {
  FinancialCycleEntity? cycle;
  int? lastUpdatedSplitAmount;

  @override
  Future<FinancialCycleEntity?> getCycleById(int id) async => cycle;

  @override
  Future<void> updateCycleSalarySplit(
      int cycleId, int salarySplitAmount) async {
    lastUpdatedSplitAmount = salarySplitAmount;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeSavingsRepository implements SavingsRepository {
  SavingsHistoryEntity? lastDeposit;

  @override
  Future<SavingsHistoryEntity> createDeposit({
    required int amount,
    required String description,
    required int cycleId,
  }) async {
    lastDeposit = SavingsHistoryEntity(
      id: 1,
      type: SavingsTransactionType.deposit,
      amount: amount,
      description: description,
      relatedCycleId: cycleId,
      createdAt: DateTime.now(),
    );
    return lastDeposit!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  late FakeCycleRepository cycleRepo;
  late FakeSavingsRepository savingsRepo;
  late DepositSalarySplitUseCase useCase;

  setUp(() {
    cycleRepo = FakeCycleRepository();
    savingsRepo = FakeSavingsRepository();
    useCase = DepositSalarySplitUseCase(
      cycleRepository: cycleRepo,
      savingsRepository: savingsRepo,
    );
  });

  FinancialCycleEntity makeCycle({int salary = 60000}) =>
      FinancialCycleEntity(
        id: 1,
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 7, 1),
        salaryAmount: salary,
        isActive: true,
      );

  test('valid split creates deposit and updates cycle', () async {
    cycleRepo.cycle = makeCycle(salary: 60000);

    await useCase(cycleId: 1, amount: 40000);

    expect(savingsRepo.lastDeposit, isNotNull);
    expect(savingsRepo.lastDeposit!.amount, 40000);
    expect(savingsRepo.lastDeposit!.description, 'تقسيم الراتب');
    expect(cycleRepo.lastUpdatedSplitAmount, 40000);
  });

  test('zero amount does nothing', () async {
    cycleRepo.cycle = makeCycle(salary: 60000);

    await useCase(cycleId: 1, amount: 0);

    expect(savingsRepo.lastDeposit, isNull);
    expect(cycleRepo.lastUpdatedSplitAmount, isNull);
  });

  test('negative amount does nothing', () async {
    cycleRepo.cycle = makeCycle(salary: 60000);

    await useCase(cycleId: 1, amount: -5000);

    expect(savingsRepo.lastDeposit, isNull);
    expect(cycleRepo.lastUpdatedSplitAmount, isNull);
  });

  test('amount exceeding salary throws ArgumentError', () async {
    cycleRepo.cycle = makeCycle(salary: 60000);

    expect(
      () => useCase(cycleId: 1, amount: 70000),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('full salary allocation works', () async {
    cycleRepo.cycle = makeCycle(salary: 60000);

    await useCase(cycleId: 1, amount: 60000);

    expect(savingsRepo.lastDeposit!.amount, 60000);
    expect(cycleRepo.lastUpdatedSplitAmount, 60000);
  });

  test('cycle not found throws StateError', () async {
    cycleRepo.cycle = null;

    expect(
      () => useCase(cycleId: 999, amount: 10000),
      throwsA(isA<StateError>()),
    );
  });
}
