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
    final totalIn = cycle.salaryAmount;
    final consumptionPercent =
        totalIn > 0 ? (totalExpenses / totalIn * 100) : 0.0;
    final daysRemaining = cycle.daysRemaining(now);

    final notifications = <NotificationContent>[];

    // 70% spending milestone
    if (consumptionPercent >= 70 && consumptionPercent < 90) {
      notifications.add(const NotificationContent(
        type: NotificationType.spendingMilestone70,
        title: 'تنبيه ذكي',
        body: 'صرفت 70% من ميزانيتك. حاول تقلل المصاريف الباقي أيام الدورة. أنت تقدر!',
      ));
    }

    // 90% spending milestone
    if (consumptionPercent >= 90) {
      notifications.add(const NotificationContent(
        type: NotificationType.spendingMilestone90,
        title: 'انتبه لمصاريفك',
        body: 'رصيدك قارب ينفد! حاول تصرف فقط على الضروريات الباقي أيام.',
      ));
    }

    // One week remaining
    if (daysRemaining == 7) {
      notifications.add(const NotificationContent(
        type: NotificationType.oneWeekRemaining,
        title: 'أسبوع قبل الراتب',
        body: 'باقي أسبوع على الراتب. نظم مصاريفك باش توصل بسلام!',
      ));
    }

    // Excellent performance (< 50% spent with > half cycle elapsed)
    final daysElapsed = cycle.daysElapsed(now);
    final totalDays = daysElapsed + daysRemaining;
    if (totalDays > 0 &&
        daysElapsed > totalDays / 2 &&
        consumptionPercent < 50) {
      notifications.add(const NotificationContent(
        type: NotificationType.excellentPerformance,
        title: 'أداء ممتاز!',
        body: 'مبروك! مسارك المالي ممتاز هذا الشهر. واصل على هذا النهج!',
      ));
    }

    return notifications;
  }

  static NotificationContent cycleCompleteNotification(int savedAmount) {
    final saved = savedAmount;
    return NotificationContent(
      type: NotificationType.cycleComplete,
      title: 'انتهت الدورة المالية',
      body: saved > 0
          ? 'أحسنت! وفرت $saved دج هذا الشهر. بداية جديدة تنتظرك!'
          : 'انتهت الدورة. الشهر الجاي إن شاء الله أحسن!',
    );
  }

  static const NotificationContent weeklyProgressNotification =
      NotificationContent(
    type: NotificationType.weeklyProgress,
    title: 'ملخص الأسبوع',
    body: 'شوف ملخص مصاريفك هذا الأسبوع واكتشف وين تقدر توفر!',
  );
}
