import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

enum NotificationType {
  spendingMilestone70,
  spendingMilestone90,
  oneWeekRemaining,
  excellentPerformance,
  cycleComplete,
  weeklyProgress,
}

class NotificationContent {
  final NotificationType type;
  final String title;
  final String body;

  const NotificationContent({
    required this.type,
    required this.title,
    required this.body,
  });
}

class GenerateNotificationUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;

  const GenerateNotificationUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository;

  Future<List<NotificationContent>> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return [];

    final now = DateTime.now();
    final totalExpenses = await _expenseRepository.getTotalExpenses(cycle.id);
    final totalIn = cycle.salaryAmount - cycle.salarySplitAmount;
    final remaining = totalIn - totalExpenses;
    final consumptionPercent =
        totalIn > 0 ? (totalExpenses / totalIn * 100) : 0.0;
    final daysRemaining = cycle.daysRemaining(now);
    final daysElapsed = cycle.daysElapsed(now);
    final totalDays = daysElapsed + daysRemaining;

    final notifications = <NotificationContent>[];

    // 70% spending milestone
    if (consumptionPercent >= 70 && consumptionPercent < 90) {
      final pct = consumptionPercent.toStringAsFixed(0);
      notifications.add(NotificationContent(
        type: NotificationType.spendingMilestone70,
        title: '🟡 $pct% من ميزانيتك راحت',
        body: 'باقيلك $remaining دج على $daysRemaining يوم — افتح شهريتي وراجع وين تقدر توفر!',
      ));
    }

    // 90% spending milestone
    if (consumptionPercent >= 90) {
      final pct = consumptionPercent.toStringAsFixed(0);
      notifications.add(NotificationContent(
        type: NotificationType.spendingMilestone90,
        title: '🔴 $pct% من ميزانيتك انصرفت',
        body: remaining > 0
            ? 'باقيلك غير $remaining دج — اصرف على الضروري بصح. $daysRemaining يوم للراتب!'
            : 'رصيدك وصل للنهاية — $daysRemaining يوم للراتب. تحمّل شوية!',
      ));
    }

    // One week remaining
    if (daysRemaining <= 7 && daysRemaining > 0) {
      final dailySafe = daysRemaining > 0 ? (remaining ~/ daysRemaining) : 0;
      notifications.add(NotificationContent(
        type: NotificationType.oneWeekRemaining,
        title: '📅 $daysRemaining يوم للراتب',
        body: dailySafe > 0
            ? 'اصرف مش أكثر من $dailySafe دج في اليوم وتوصل بسلام 💪'
            : 'الأيام الأخيرة — اصرف على الضروري بصح وتعدّاها!',
      ));
    }

    // Excellent performance
    if (totalDays > 0 &&
        daysElapsed > totalDays / 2 &&
        consumptionPercent < 50) {
      final pct = consumptionPercent.toStringAsFixed(0);
      notifications.add(NotificationContent(
        type: NotificationType.excellentPerformance,
        title: '🏆 أداء ممتاز هذا الشهر!',
        body: 'نصف الشهر عدى وما صرفتش غير $pct% — باقيلك $remaining دج. واصل على هذا النهج!',
      ));
    }

    return notifications;
  }

  static NotificationContent cycleCompleteNotification(int savedAmount) =>
      NotificationContent(
        type: NotificationType.cycleComplete,
        title: savedAmount > 0 ? '✅ دورة ناجحة!' : '🔄 دورة جديدة بدات',
        body: savedAmount > 0
            ? 'أحسنت! وفّرت $savedAmount دج هذا الشهر وانضافوا لمدخراتك. الشهر الجاي أحسن!'
            : 'الدورة انتهت. الشهر الجاي عندك فرصة توفّر — ابدأ بالتخطيط من البداية!',
      );

  static const NotificationContent weeklyProgressNotification =
      NotificationContent(
    type: NotificationType.weeklyProgress,
    title: '📊 ملخص أسبوعك',
    body: 'شوف وين راحت فلوسك هذا الأسبوع — دقيقة وتعرف كيفاش توفّر أكثر!',
  );
}
