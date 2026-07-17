import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/debt_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/income_repository.dart';
import '../../../domain/repositories/lending_repository.dart';

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
  final IncomeRepository _incomeRepository;
  final DebtRepository _debtRepository;
  final LendingRepository? _lendingRepository;

  const GenerateNotificationUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
    required IncomeRepository incomeRepository,
    required DebtRepository debtRepository,
    LendingRepository? lendingRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository,
        _incomeRepository = incomeRepository,
        _debtRepository = debtRepository,
        _lendingRepository = lendingRepository;

  Future<List<NotificationContent>> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return [];

    final now = DateTime.now();

    final results = await Future.wait([
      _expenseRepository.getTotalExpenses(cycle.id),
      _incomeRepository.getTotalIncomeForCycle(cycle.id),
      _debtRepository.getTotalDebtPaymentsForCycle(cycle.id),
      _debtRepository.getTotalDebtsCreatedForCycle(cycle.id),
    ]);

    final totalExpenses = results[0];
    final totalIncome = results[1];
    final totalDebtPayments = results[2];
    final totalDebtsCreated = results[3];

    int totalLendingsFromBalance = 0;
    int totalCollectionsToBalance = 0;
    if (_lendingRepository != null) {
      final lendingResults = await Future.wait([
        _lendingRepository.getTotalLendingsFromBalanceForCycle(cycle.id),
        _lendingRepository.getTotalCollectionsToBalanceForCycle(cycle.id),
      ]);
      totalLendingsFromBalance = lendingResults[0];
      totalCollectionsToBalance = lendingResults[1];
    }

    final totalIn = cycle.salaryAmount - cycle.salarySplitAmount + totalIncome + totalDebtsCreated;
    final currentBalance = totalIn -
        totalExpenses -
        totalDebtPayments -
        totalLendingsFromBalance +
        totalCollectionsToBalance;
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
        body: 'باقيلك $currentBalance دج على $daysRemaining يوم — افتح شهريتي وراجع وين تقدر توفر!',
      ));
    }

    // 90% spending milestone
    if (consumptionPercent >= 90) {
      final pct = consumptionPercent.toStringAsFixed(0);
      notifications.add(NotificationContent(
        type: NotificationType.spendingMilestone90,
        title: '🔴 $pct% من ميزانيتك انصرفت',
        body: currentBalance > 0
            ? 'باقيلك غير $currentBalance دج — اصرف على الضروري بصح. $daysRemaining يوم للراتب!'
            : 'رصيدك وصل للنهاية — $daysRemaining يوم للراتب. تحمّل شوية!',
      ));
    }

    // One week remaining
    if (daysRemaining <= 7 && daysRemaining > 0) {
      final dailySafe = daysRemaining > 0 ? (currentBalance ~/ daysRemaining) : 0;
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
        body: 'نصف الشهر عدى وما صرفتش غير $pct% — باقيلك $currentBalance دج. واصل على هذا النهج!',
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
