import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/dashboard/get_dashboard_data_use_case.dart';
import 'package:chahriyti/application/use_cases/income/delete_income_use_case.dart';
import 'package:chahriyti/application/use_cases/income/update_income_use_case.dart';
import 'package:chahriyti/domain/entities/additional_income_entity.dart';
import 'package:chahriyti/domain/repositories/income_repository.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';

class FakeIncomeRepository extends Fake implements IncomeRepository {
  int? deletedId;
  int? updatedAmount;
  String? updatedDescription;

  @override
  Future<void> updateIncome(
      {required int id,
      required String description,
      required int amount}) async {
    updatedAmount = amount;
    updatedDescription = description;
  }

  @override
  Future<void> deleteIncome(int id) async => deletedId = id;
}

class FakeSavingsRepository extends Fake implements SavingsRepository {
  int balance = 10000;
  int? depositAmount = 5000; // deposit linked to the income
  bool depositDeleted = false;

  @override
  Future<int> getSavingsBalance() async => balance;

  @override
  Future<void> updateDepositAmountByIncomeId(int incomeId, int amount) async =>
      depositAmount = amount;

  @override
  Future<void> deleteDepositByIncomeId(int incomeId) async =>
      depositDeleted = true;
}

class FakeDashboard extends Fake implements GetDashboardDataUseCase {
  int balance = 10000;

  @override
  Future<DashboardData> call() async => DashboardData(
        currentBalance: balance,
        totalExpenses: 0,
        totalDebtPayments: 0,
        totalIn: 0,
        totalIncome: 0,
        salaryAmount: 0,
        daysRemaining: 0,
        daysElapsed: 0,
        dailyAverage: 0,
        safeDaily: 0,
        consumptionPercent: 0,
      );
}

void main() {
  late FakeIncomeRepository incomes;
  late FakeSavingsRepository savings;
  late FakeDashboard dashboard;

  AdditionalIncomeEntity income({int amount = 5000, bool toSavings = false}) =>
      AdditionalIncomeEntity(
        id: 7,
        cycleId: 1,
        description: 'Freelance',
        amount: amount,
        createdAt: DateTime(2026, 10, 7),
        toSavings: toSavings,
      );

  setUp(() {
    incomes = FakeIncomeRepository();
    savings = FakeSavingsRepository();
    dashboard = FakeDashboard();
  });

  group('delete', () {
    late DeleteIncomeUseCase useCase;
    setUp(() => useCase = DeleteIncomeUseCase(incomes, savings, dashboard));

    test('balance income: deleted when the balance covers it', () async {
      await useCase(income());
      expect(incomes.deletedId, 7);
    });

    test('balance income: refused when the balance would go negative',
        () async {
      dashboard.balance = 3000;
      await expectLater(useCase(income()), throwsA(isA<StateError>()));
      expect(incomes.deletedId, isNull);
    });

    test('savings income: removes its deposit too', () async {
      await useCase(income(toSavings: true));
      expect(savings.depositDeleted, isTrue);
      expect(incomes.deletedId, 7);
    });

    test('savings income: refused when savings would go negative', () async {
      savings.balance = 2000;
      await expectLater(
          useCase(income(toSavings: true)), throwsA(isA<StateError>()));
      expect(savings.depositDeleted, isFalse);
    });
  });

  group('update', () {
    late UpdateIncomeUseCase useCase;
    setUp(() => useCase = UpdateIncomeUseCase(incomes, savings, dashboard));

    test('savings income: deposit follows the new amount', () async {
      await useCase(
          income: income(toSavings: true), description: 'Freelance', amount: 8000);
      expect(savings.depositAmount, 8000);
      expect(incomes.updatedAmount, 8000);
    });

    test('balance income: lowering beyond the balance is refused', () async {
      dashboard.balance = 1000;
      await expectLater(
        useCase(income: income(), description: 'Freelance', amount: 2000),
        throwsA(isA<StateError>()),
      );
      expect(incomes.updatedAmount, isNull);
    });

    test('empty description or zero amount is refused', () async {
      expect(() => useCase(income: income(), description: ' ', amount: 10),
          throwsA(isA<ArgumentError>()));
      expect(() => useCase(income: income(), description: 'x', amount: 0),
          throwsA(isA<ArgumentError>()));
    });
  });
}
