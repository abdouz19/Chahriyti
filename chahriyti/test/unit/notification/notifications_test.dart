import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/dashboard/get_dashboard_data_use_case.dart';
import 'package:chahriyti/application/use_cases/notification/build_reminder_plan_use_case.dart';
import 'package:chahriyti/application/use_cases/notification/generate_notification_use_case.dart';
import 'package:chahriyti/domain/entities/debt_entity.dart';
import 'package:chahriyti/domain/entities/expense_entity.dart';
import 'package:chahriyti/domain/entities/financial_cycle_entity.dart';
import 'package:chahriyti/domain/entities/goal_entity.dart';
import 'package:chahriyti/domain/entities/lending_entity.dart';
import 'package:chahriyti/domain/entities/user_entity.dart';
import 'package:chahriyti/domain/repositories/cycle_repository.dart';
import 'package:chahriyti/domain/repositories/debt_repository.dart';
import 'package:chahriyti/domain/repositories/expense_repository.dart';
import 'package:chahriyti/domain/repositories/goal_repository.dart';
import 'package:chahriyti/domain/repositories/lending_repository.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';
import 'package:chahriyti/domain/repositories/user_repository.dart';

// Fixed clock: 10:00 on day 11 of a 30-day cycle (Oct 1 – Oct 30, payday 31)
final now = DateTime(2026, 10, 11, 10);
final cycle = FinancialCycleEntity(
  id: 1,
  startDate: DateTime(2026, 10, 1),
  endDate: DateTime(2026, 10, 30),
  salaryAmount: 80000,
  isActive: true,
);

class FakeCycles extends Fake implements CycleRepository {
  FinancialCycleEntity? active = cycle;
  @override
  Future<FinancialCycleEntity?> getActiveCycle() async => active;
}

class FakeDashboard extends Fake implements GetDashboardDataUseCase {
  int expenses = 0;
  int balance = 0;
  @override
  Future<DashboardData> call() async => DashboardData(
        currentBalance: balance,
        totalExpenses: expenses,
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

class FakeGoals extends Fake implements GoalRepository {
  List<GoalEntity> goals = [];
  @override
  Future<List<GoalEntity>> getActiveGoalsPaginated(
          {int? limit, int? offset}) async =>
      goals;
}

class FakeSavings extends Fake implements SavingsRepository {
  int balance = 0;
  @override
  Future<int> getSavingsBalance() async => balance;
}

class FakeUsers extends Fake implements UserRepository {
  @override
  Future<UserEntity?> getUser() async => UserEntity(
        id: 1,
        monthlySalary: 80000,
        salaryDay: 31,
        fullName: 'x',
        phoneNumber: '0',
        wilayaCode: 16,
        isActivated: true,
        challengesEnabled: false,
        createdAt: DateTime(2026),
      );
}

class FakeExpenses extends Fake implements ExpenseRepository {
  DateTime? lastExpenseAt;
  @override
  Future<List<ExpenseEntity>> getRecentExpenses(int cycleId,
          {int limit = 5}) async =>
      lastExpenseAt == null
          ? []
          : [
              ExpenseEntity(
                id: 1,
                cycleId: 1,
                category: 'food',
                subcategory: '',
                itemName: '',
                amount: 100,
                createdAt: lastExpenseAt!,
                updatedAt: lastExpenseAt!,
              )
            ];
}

class FakeDebts extends Fake implements DebtRepository {
  List<DebtEntity> debts = [];
  @override
  Future<List<DebtEntity>> getActiveDebts({int? limit, int? offset}) async =>
      debts;
}

class FakeLendings extends Fake implements LendingRepository {
  List<LendingEntity> lendings = [];
  @override
  Future<List<LendingEntity>> getActiveLendings(
          {int? limit, int? offset}) async =>
      lendings;
}

void main() {
  group('alerts', () {
    late FakeDashboard dashboard;
    late FakeGoals goals;
    late FakeSavings savings;
    late GenerateNotificationUseCase useCase;

    setUp(() {
      dashboard = FakeDashboard();
      goals = FakeGoals();
      savings = FakeSavings();
      useCase = GenerateNotificationUseCase(
        cycleRepository: FakeCycles(),
        getDashboardData: dashboard,
        goalRepository: goals,
        savingsRepository: savings,
      );
    });

    List<NotificationType> types(List<NotificationContent> l) =>
        l.map((n) => n.type).toList();

    test('pace warning when money runs out well before payday', () async {
      // 10 full days elapsed: 22000 spent = 2200/day; 20000 left = 9 days;
      // 20 days to payday → runs out Oct 20, 11 days short
      dashboard
        ..expenses = 22000
        ..balance = 20000;
      final result = await useCase(now: now);
      final pace =
          result.firstWhere((n) => n.type == NotificationType.paceWarning);
      expect(pace.date, DateTime(2026, 10, 20));
      expect(pace.days, 11);
    });

    test('no pace warning when on track', () async {
      dashboard
        ..expenses = 11000
        ..balance = 40000;
      expect(types(await useCase(now: now)),
          isNot(contains(NotificationType.paceWarning)));
    });

    test('no pace warning in the first days of a cycle', () async {
      dashboard
        ..expenses = 30000
        ..balance = 1000;
      final early = DateTime(2026, 10, 2, 10);
      expect(types(await useCase(now: early)),
          isNot(contains(NotificationType.paceWarning)));
    });

    test('goal reachable once savings cover it', () async {
      savings.balance = 50000;
      goals.goals = [
        GoalEntity(
            id: 3, name: 'Laptop', targetAmount: 45000, createdAt: now),
        GoalEntity(id: 4, name: 'Car', targetAmount: 900000, createdAt: now),
      ];
      final result = await useCase(now: now);
      final goal =
          result.where((n) => n.type == NotificationType.goalReachable);
      expect(goal.map((n) => n.name), ['Laptop']);
    });

    test('excellent performance past halfway with under half spent',
        () async {
      dashboard
        ..expenses = 10000
        ..balance = 40000;
      final late = DateTime(2026, 10, 20, 10);
      expect(types(await useCase(now: late)),
          contains(NotificationType.excellentPerformance));
    });
  });

  group('reminder plan', () {
    late FakeDashboard dashboard;
    late FakeExpenses expenses;
    late FakeDebts debts;
    late FakeLendings lendings;
    late BuildReminderPlanUseCase useCase;

    setUp(() {
      dashboard = FakeDashboard()..balance = 14000;
      expenses = FakeExpenses();
      debts = FakeDebts();
      lendings = FakeLendings();
      useCase = BuildReminderPlanUseCase(
        userRepository: FakeUsers(),
        cycleRepository: FakeCycles(),
        getDashboardData: dashboard,
        expenseRepository: expenses,
        debtRepository: debts,
        lendingRepository: lendings,
      );
    });

    List<ScheduledReminder> ofType(
            List<ScheduledReminder> plan, ReminderType t) =>
        plan.where((r) => r.type == t).toList();

    test('evening reminder skips today once something was recorded',
        () async {
      expenses.lastExpenseAt = DateTime(2026, 10, 11, 8);
      final evenings = ofType(await useCase(now: now), ReminderType.evening);
      expect(evenings.first.at, DateTime(2026, 10, 12, 20));
      expect(evenings, hasLength(6));
    });

    test('evening reminder tonight when nothing recorded today', () async {
      expenses.lastExpenseAt = DateTime(2026, 10, 10, 8);
      final evenings = ofType(await useCase(now: now), ReminderType.evening);
      expect(evenings.first.at, DateTime(2026, 10, 11, 20));
    });

    test('morning countdown only in the last week, with daily amount',
        () async {
      final week = DateTime(2026, 10, 26, 8); // payday Oct 31
      final mornings =
          ofType(await useCase(now: week), ReminderType.morningCountdown);
      expect(mornings.first.at, DateTime(2026, 10, 26, 9));
      expect(mornings.first.days, 5);
      expect(mornings.first.amount, 14000 ~/ 5);
      expect(mornings.last.days, 1);

      final early =
          ofType(await useCase(now: now), ReminderType.morningCountdown);
      expect(early, isEmpty);
    });

    test('payday mentions the biggest debt', () async {
      debts.debts = [
        DebtEntity(
            id: 1,
            creditorName: 'Small',
            totalAmount: 2000,
            paidAmount: 0,
            isFullyPaid: false,
            createdAt: now),
        DebtEntity(
            id: 2,
            creditorName: 'Ilyes',
            totalAmount: 7000,
            paidAmount: 1000,
            isFullyPaid: false,
            createdAt: now),
      ];
      final payday = ofType(await useCase(now: now), ReminderType.payday).single;
      expect(payday.at, DateTime(2026, 10, 31, 9));
      expect(payday.name, 'Ilyes');
      expect(payday.amount, 6000);
    });

    test('lending nudge two days after payday, with total and count',
        () async {
      lendings.lendings = [
        LendingEntity(
            id: 1, borrowerName: 'Ahmed', totalAmount: 20000, createdAt: now),
        LendingEntity(
            id: 2,
            borrowerName: 'Sami',
            totalAmount: 5000,
            collectedAmount: 1000,
            createdAt: now),
      ];
      final nudge = ofType(await useCase(now: now), ReminderType.lending).single;
      expect(nudge.at, DateTime(2026, 11, 2, 13));
      expect(nudge.name, 'Ahmed');
      expect(nudge.count, 1);
      expect(nudge.amount, 24000);
    });

    test('no lending nudge without outstanding lendings', () async {
      expect(ofType(await useCase(now: now), ReminderType.lending), isEmpty);
    });
  
    test('payday morning before 9:00 keeps today\'s payday reminder',
        () async {
      final paydayMorning = DateTime(2026, 10, 31, 7, 30);
      final payday =
          ofType(await useCase(now: paydayMorning), ReminderType.payday).single;
      expect(payday.at, DateTime(2026, 10, 31, 9));
    });

    test('payday after 9:00 moves to next month', () async {
      final paydayNoon = DateTime(2026, 10, 31, 12);
      final payday =
          ofType(await useCase(now: paydayNoon), ReminderType.payday).single;
      expect(payday.at, DateTime(2026, 11, 30, 9));
    });

    test('opening the app on payday keeps this month\'s lending nudge',
        () async {
      lendings.lendings = [
        LendingEntity(
            id: 1, borrowerName: 'Ahmed', totalAmount: 20000, createdAt: now),
      ];
      final paydayNoon = DateTime(2026, 10, 31, 12);
      final nudge =
          ofType(await useCase(now: paydayNoon), ReminderType.lending).single;
      expect(nudge.at, DateTime(2026, 11, 2, 13));
    });

    test('inactivity nudge three days after the last opening', () async {
      final quiet =
          ofType(await useCase(now: now), ReminderType.inactive).single;
      expect(quiet.at, DateTime(2026, 10, 14, 19));
    });
  });
}
