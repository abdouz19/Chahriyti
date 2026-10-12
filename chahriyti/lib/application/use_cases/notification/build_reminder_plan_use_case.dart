import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/debt_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../domain/value_objects/cycle_dates.dart';
import '../dashboard/get_dashboard_data_use_case.dart';

enum ReminderType { evening, morningCountdown, payday, lending, inactive }

/// One notification to schedule, with the values to show.
class ScheduledReminder {
  final int id;
  final DateTime at;
  final ReminderType type;
  final int amount;
  final int days;
  final int count;
  final String name;

  const ScheduledReminder({
    required this.id,
    required this.at,
    required this.type,
    this.amount = 0,
    this.days = 0,
    this.count = 0,
    this.name = '',
  });
}

/// Works out the reminders for the coming week from the current numbers.
/// Rebuilt whenever data changes, so amounts stay fresh.
class BuildReminderPlanUseCase {
  final UserRepository _userRepository;
  final CycleRepository _cycleRepository;
  final GetDashboardDataUseCase _getDashboardData;
  final ExpenseRepository _expenseRepository;
  final DebtRepository _debtRepository;
  final LendingRepository _lendingRepository;

  const BuildReminderPlanUseCase({
    required UserRepository userRepository,
    required CycleRepository cycleRepository,
    required GetDashboardDataUseCase getDashboardData,
    required ExpenseRepository expenseRepository,
    required DebtRepository debtRepository,
    required LendingRepository lendingRepository,
  })  : _userRepository = userRepository,
        _cycleRepository = cycleRepository,
        _getDashboardData = getDashboardData,
        _expenseRepository = expenseRepository,
        _debtRepository = debtRepository,
        _lendingRepository = lendingRepository;

  // ids: evenings 1100+, mornings 1200+, payday and lending fixed
  static const eveningBaseId = 1100;
  static const morningBaseId = 1200;
  static const paydayId = 1002;
  static const lendingId = 1003;
  static const inactiveId = 1004;
  static const daysAhead = 7;
  static final allIds = [
    for (var i = 0; i < daysAhead; i++) eveningBaseId + i,
    for (var i = 0; i < daysAhead; i++) morningBaseId + i,
    paydayId,
    lendingId,
    inactiveId,
  ];

  static const eveningHour = 20;
  static const morningHour = 9;
  static const lendingHour = 13;
  static const inactiveHour = 19;
  static const inactiveAfterDays = 3;

  Future<List<ScheduledReminder>> call({DateTime? now}) async {
    now ??= DateTime.now();
    final user = await _userRepository.getUser();
    final cycle = await _cycleRepository.getActiveCycle();
    if (user == null || cycle == null) return [];

    final today = DateTime(now.year, now.month, now.day);
    DateTime day(int offset, int hour) =>
        DateTime(today.year, today.month, today.day + offset, hour);

    final plan = <ScheduledReminder>[];

    // Evening: only on days nothing was recorded yet (today known for sure)
    final latest = await _expenseRepository.getRecentExpenses(cycle.id, limit: 1);
    final recordedToday = latest.isNotEmpty &&
        DateTime(latest.first.createdAt.year, latest.first.createdAt.month,
                latest.first.createdAt.day) ==
            today;
    for (var i = 0; i < daysAhead; i++) {
      final at = day(i, eveningHour);
      if (!at.isAfter(now) || (i == 0 && recordedToday)) continue;
      plan.add(ScheduledReminder(
          id: eveningBaseId + i, at: at, type: ReminderType.evening));
    }

    // Morning countdown: last 7 days before payday, with the safe daily amount
    final balance = (await _getDashboardData()).currentBalance;
    final payday = CycleDates.dayAfter(cycle.endDate);
    for (var i = 0; i < daysAhead; i++) {
      final at = day(i, morningHour);
      if (!at.isAfter(now)) continue;
      final daysToPayday =
          DateTime(payday.year, payday.month, payday.day)
              .difference(DateTime(at.year, at.month, at.day))
              .inDays;
      if (daysToPayday < 1 || daysToPayday > 7) continue;
      plan.add(ScheduledReminder(
        id: morningBaseId + i,
        at: at,
        type: ReminderType.morningCountdown,
        days: daysToPayday,
        amount: balance > 0 ? balance ~/ daysToPayday : 0,
      ));
    }

    // Payday: save first, and the biggest debt to plan for. Today counts
    // while its reminder time is still ahead (app opened early on payday).
    final todaysSalaryDate =
        CycleDates.salaryDateIn(user.salaryDay, today.year, today.month);
    final nextPayday =
        todaysSalaryDate == today && now.isBefore(day(0, morningHour))
            ? today
            : CycleDates.nextSalaryDateAfter(user.salaryDay, now);
    final debts = await _debtRepository.getActiveDebts(limit: 100);
    final topDebt = debts.isEmpty
        ? null
        : debts.reduce((a, b) => a.remainingAmount >= b.remainingAmount ? a : b);
    plan.add(ScheduledReminder(
      id: paydayId,
      at: DateTime(nextPayday.year, nextPayday.month, nextPayday.day,
          morningHour),
      type: ReminderType.payday,
      name: topDebt?.creditorName ?? '',
      amount: topDebt?.remainingAmount ?? 0,
    ));

    // Lendings: a gentle nudge two days after payday, when people repay
    final lendings = (await _lendingRepository.getActiveLendings(limit: 100))
        .where((l) => l.remainingAmount > 0)
        .toList();
    if (lendings.isNotEmpty) {
      final top = lendings
          .reduce((a, b) => a.remainingAmount >= b.remainingAmount ? a : b);
      // Two days after the most recent payday if still ahead; opening the
      // app on payday must not push this month's nudge to next month
      final lastPayday = CycleDates.currentCycleStart(user.salaryDay, now);
      final afterLast = DateTime(lastPayday.year, lastPayday.month,
          lastPayday.day + 2, lendingHour);
      final lendingAt = afterLast.isAfter(now)
          ? afterLast
          : DateTime(nextPayday.year, nextPayday.month, nextPayday.day + 2,
              lendingHour);
      plan.add(ScheduledReminder(
        id: lendingId,
        at: lendingAt,
        type: ReminderType.lending,
        name: top.borrowerName,
        amount: lendings.length == 1
            ? top.remainingAmount
            : lendings.fold(0, (sum, l) => sum + l.remainingAmount),
        count: lendings.length - 1,
      ));
    }

    // Gone quiet: one gentle nudge 3 days after the app was last opened
    // (every opening rebuilds this plan, pushing it back)
    plan.add(ScheduledReminder(
      id: inactiveId,
      at: day(inactiveAfterDays, inactiveHour),
      type: ReminderType.inactive,
    ));

    return plan;
  }
}
