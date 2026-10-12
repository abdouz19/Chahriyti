import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/goal_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../dashboard/get_dashboard_data_use_case.dart';

/// In-app alerts, most important first. The service shows at most one a day.
enum NotificationType {
  paceWarning,
  goalReachable,
  excellentPerformance,
  cycleComplete,
}

/// What to notify about, with the values to show. Texts are built in the
/// user's language by the notification service.
class NotificationContent {
  final NotificationType type;

  /// Same key = same notification; shown only once.
  final String dedupeKey;
  final int percent;
  final int balance;
  final int days;
  final int amount;
  final String name;
  final DateTime? date;

  const NotificationContent({
    required this.type,
    required this.dedupeKey,
    this.percent = 0,
    this.balance = 0,
    this.days = 0,
    this.amount = 0,
    this.name = '',
    this.date,
  });
}

class GenerateNotificationUseCase {
  final CycleRepository _cycleRepository;
  final GetDashboardDataUseCase _getDashboardData;
  final GoalRepository _goalRepository;
  final SavingsRepository _savingsRepository;

  const GenerateNotificationUseCase({
    required CycleRepository cycleRepository,
    required GetDashboardDataUseCase getDashboardData,
    required GoalRepository goalRepository,
    required SavingsRepository savingsRepository,
  })  : _cycleRepository = cycleRepository,
        _getDashboardData = getDashboardData,
        _goalRepository = goalRepository,
        _savingsRepository = savingsRepository;

  Future<List<NotificationContent>> call({DateTime? now}) async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return [];

    now ??= DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final data = await _getDashboardData();
    final spent = data.totalExpenses;
    final balance = data.currentBalance;
    final daysRemaining = cycle.daysRemaining(now);
    final daysElapsed = cycle.daysElapsed(now);
    final totalDays = daysElapsed + daysRemaining;

    final notifications = <NotificationContent>[];

    // Pace: when the money runs out at the current daily rate. Waits a few
    // days so one big early expense doesn't trigger it.
    if (daysElapsed >= 3 && spent > 0 && daysRemaining > 0) {
      final dailyRate = spent / daysElapsed;
      final daysOfMoney = (balance / dailyRate).floor();
      final shortBy = daysRemaining - daysOfMoney;
      if (shortBy >= 3) {
        notifications.add(NotificationContent(
          type: NotificationType.paceWarning,
          dedupeKey: 'c${cycle.id}',
          date: DateTime(today.year, today.month, today.day + daysOfMoney),
          days: shortBy,
        ));
      }
    }

    // A goal the savings now cover
    final savings = await _savingsRepository.getSavingsBalance();
    final goals = await _goalRepository.getActiveGoalsPaginated(limit: 50);
    for (final goal in goals) {
      if (!goal.isCompleted && goal.targetAmount <= savings) {
        notifications.add(NotificationContent(
          type: NotificationType.goalReachable,
          dedupeKey: 'g${goal.id}',
          name: goal.name,
        ));
      }
    }

    // More than half the cycle gone with less than half the money spent
    final available = spent + balance;
    if (totalDays > 0 &&
        daysElapsed > totalDays / 2 &&
        available > 0 &&
        spent / available < 0.5) {
      notifications.add(NotificationContent(
        type: NotificationType.excellentPerformance,
        dedupeKey: 'c${cycle.id}',
        percent: (spent / available * 100).round(),
        balance: balance,
      ));
    }

    return notifications;
  }
}
