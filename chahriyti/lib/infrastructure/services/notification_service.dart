import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../application/use_cases/notification/build_reminder_plan_use_case.dart';
import '../../application/use_cases/notification/generate_notification_use_case.dart';
import '../../core/extensions/money_extensions.dart';
import '../../l10n/app_localizations.dart';
import 'app_lock_service.dart';
import '../../core/storage/app_secure_storage.dart';

class NotificationService {
  final GenerateNotificationUseCase _generateNotificationUseCase;
  final BuildReminderPlanUseCase _buildReminderPlan;
  final AppLockService _appLock;

  /// Set per batch: amounts and names masked when the app lock hides them.
  bool _hidePrivate = false;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final _storage = appSecureStorage;
  // Language set by LocaleCubit
  final _localeStorage = appSecureStorage;

  /// Opens a screen of the app; set by the app once the router exists.
  void Function(String route)? onOpenRoute;

  /// Screen to open when the app was launched by tapping a notification.
  String? _launchRoute;

  // Important alerts pop up; everyday reminders arrive quietly
  static const _alertsChannelId = 'chahriyti_finance';
  static const _remindersChannelId = 'chahriyti_reminders';
  static const _icon = '@drawable/ic_notification';
  static const _eveningCategory = 'evening_reminder';
  static const _spentNothingAction = 'spent_nothing';

  static const _welcomeShownKey = 'chahriyti_welcome_notif_shown';
  static const _enabledKey = 'chahriyti_notifications_enabled';
  static const _askedKey = 'chahriyti_notifications_asked';
  static const _shownKey = 'chahriyti_notifications_shown';
  static const _localeKey = 'app_locale';
  static const _lastAlertDayKey = 'chahriyti_last_alert_day';

  static const _idWelcome = 999;
  // Repeating daily reminder from an earlier version
  static const _idLegacyDaily = 1001;
  // Half-hourly delivery test slots from a test build
  static const _idLegacyTestBase = 1300;
  static const _legacyTestSlotCount = 14;

  NotificationService({
    required GenerateNotificationUseCase generateNotificationUseCase,
    required BuildReminderPlanUseCase buildReminderPlan,
    required AppLockService appLock,
  }) : _generateNotificationUseCase = generateNotificationUseCase,
       _buildReminderPlan = buildReminderPlan,
       _appLock = appLock;

  Future<void> initialize() async {
    try {
      tz_data.initializeTimeZones();
      final l = await _l10n();
      const androidSettings = AndroidInitializationSettings(_icon);
      final iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        notificationCategories: [
          DarwinNotificationCategory(
            _eveningCategory,
            actions: [
              DarwinNotificationAction.plain(
                _spentNothingAction,
                l.notifSpentNothingAction,
              ),
            ],
          ),
        ],
      );
      await _plugin.initialize(
        InitializationSettings(android: androidSettings, iOS: iosSettings),
        onDidReceiveNotificationResponse: _onResponse,
      );
      final launch = await _plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp ?? false) {
        _launchRoute = _routeOf(launch!.notificationResponse);
      }
    } catch (_) {
      // Notification init must never block app launch
    }
  }

  /// Tapping a notification opens its screen; "I spent nothing" just
  /// dismisses the evening reminder.
  void _onResponse(NotificationResponse response) {
    final route = _routeOf(response);
    if (route != null) onOpenRoute?.call(route);
  }

  String? _routeOf(NotificationResponse? response) {
    if (response == null || response.actionId == _spentNothingAction) {
      return null;
    }
    final payload = response.payload;
    return payload == null || payload.isEmpty ? null : payload;
  }

  /// The screen of the notification that launched the app, once.
  String? takeLaunchRoute() {
    final route = _launchRoute;
    _launchRoute = null;
    return route;
  }

  // ── Settings ────────────────────────────────────────────────────────────

  Future<bool> isEnabled() async =>
      (await _storage.read(key: _enabledKey)) != 'false';

  /// Turning on asks for permission (if needed) and schedules reminders;
  /// turning off cancels everything.
  Future<void> setEnabled(bool enabled) async {
    await _storage.write(key: _enabledKey, value: '$enabled');
    if (enabled) {
      await requestPermissionsAndShowWelcome();
    } else {
      await _plugin.cancelAll();
    }
  }

  // ── Permission + welcome ────────────────────────────────────────────────

  /// Whether the explainer before the system prompt was already shown.
  Future<bool> hasAskedPermission() async =>
      (await _storage.read(key: _askedKey)) == 'true';

  /// Whether the system already allows our notifications.
  Future<bool> isPermissionGranted() async {
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android != null) {
        return await android.areNotificationsEnabled() ?? false;
      }
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (ios != null) {
        return (await ios.checkPermissions())?.isEnabled ?? false;
      }
    } catch (_) {}
    return false;
  }

  Future<void> markPermissionAsked() =>
      _storage.write(key: _askedKey, value: 'true');

  /// Returns whether notifications may be shown.
  Future<bool> _requestPermission() async {
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (ios != null) {
        return await ios.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
    } catch (_) {}
    return false;
  }

  /// System permission prompt (after our explainer), welcome, reminders.
  Future<void> requestPermissionsAndShowWelcome() async {
    try {
      await markPermissionAsked();
      if (!await isEnabled()) return;
      final granted = await _requestPermission();
      final alreadyShown = await _storage.read(key: _welcomeShownKey);
      if (granted && alreadyShown == null) {
        final l = await _l10n();
        await _plugin.show(
          _idWelcome,
          l.notifWelcomeTitle,
          l.notifWelcomeBody,
          _details(l, important: true),
        );
        await _storage.write(key: _welcomeShownKey, value: '1');
      }
      if (granted && !await canRemindOnTime()) {
        await _android?.requestExactAlarmsPermission();
      }
      await rescheduleReminders();
    } catch (_) {
      // Silent fail if permission request fails
    }
  }

  // ── On-time delivery (Android 12+) ──────────────────────────────────────

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  /// Whether reminders fire at their exact time. Without "Alarms &
  /// reminders" Android may hold them back (Doze, battery savers) until the
  /// app is opened again.
  Future<bool> canRemindOnTime() async {
    try {
      return await _android?.canScheduleExactNotifications() ?? true;
    } catch (_) {
      return true;
    }
  }

  /// Opens the system "Alarms & reminders" switch, then reschedules.
  Future<void> allowRemindOnTime() async {
    try {
      await _android?.requestExactAlarmsPermission();
    } catch (_) {}
    await rescheduleReminders();
  }

  Future<AndroidScheduleMode> _scheduleMode() async => await canRemindOnTime()
      ? AndroidScheduleMode.exactAllowWhileIdle
      : AndroidScheduleMode.inexactAllowWhileIdle;

  // ── Budget alerts (while the app is used) ───────────────────────────────

  /// Call after data changes: refreshes scheduled reminders with the new
  /// numbers and shows at most one new alert per day (most important first).
  Future<void> checkNotifications() async {
    if (!await isEnabled()) return;
    await rescheduleReminders();

    final now = DateTime.now();
    final todayKey = '${now.year}-${now.month}-${now.day}';
    if (await _storage.read(key: _lastAlertDayKey) == todayKey) return;

    final all = await _generateNotificationUseCase(now: now);
    final shown = await _readShown();
    for (final n in all) {
      final key = '${n.type.name}|${n.dedupeKey}';
      if (shown.contains(key)) continue;
      await _show(n);
      shown.add(key);
      await _writeShown(shown);
      await _storage.write(key: _lastAlertDayKey, value: todayKey);
      return;
    }
  }

  Future<void> show(NotificationContent notification) async {
    if (!await isEnabled()) return;
    await _show(notification);
  }

  /// Lets alerts fire again, e.g. after all data was reset.
  Future<void> resetSession() async {
    await _storage.delete(key: _shownKey);
    await _storage.delete(key: _lastAlertDayKey);
  }

  Future<Set<String>> _readShown() async {
    final raw = await _storage.read(key: _shownKey);
    if (raw == null) return {};
    try {
      return (jsonDecode(raw) as List).cast<String>().toSet();
    } catch (_) {
      return {};
    }
  }

  /// Keeps only the newest keys so storage stays small (keys of past cycles
  /// are never matched again anyway).
  Future<void> _writeShown(Set<String> shown) async {
    final kept = shown.length > 60 ? shown.skip(shown.length - 60) : shown;
    await _storage.write(key: _shownKey, value: jsonEncode(kept.toList()));
  }

  Future<void> _show(NotificationContent n) async {
    final l = await _l10n();
    _hidePrivate = await _appLock.shouldHideAmounts();
    final (title, body) = _texts(l, n);
    await _plugin.show(
      n.type.index,
      title,
      body,
      _details(l, important: true),
      payload: n.type == NotificationType.goalReachable ? '/goals' : '/home',
    );
  }

  String _money(AppLocalizations l, int v) => _hidePrivate
      ? '••• ${l.currencySymbol}'
      : v.toDZDString(symbol: l.currencySymbol);

  (String, String) _texts(AppLocalizations l, NotificationContent n) {
    switch (n.type) {
      case NotificationType.paceWarning:
        final d = n.date!;
        return (
          l.notifPaceTitle,
          l.notifPaceBody('${d.day}/${d.month}', n.days),
        );
      case NotificationType.goalReachable:
        return (
          _hidePrivate ? l.notifGoalTitleHidden : l.notifGoalTitle(n.name),
          l.notifGoalBody,
        );
      case NotificationType.excellentPerformance:
        return (
          l.notifExcellentTitle,
          l.notifExcellentBody(n.percent, _money(l, n.balance)),
        );
      case NotificationType.cycleComplete:
        return n.amount > 0
            ? (
                l.notifCycleSavedTitle,
                l.notifCycleSavedBody(_money(l, n.amount)),
              )
            : (l.notifCycleNewTitle, l.notifCycleNewBody);
    }
  }

  (String, String) _reminderTexts(AppLocalizations l, ScheduledReminder r) {
    switch (r.type) {
      case ReminderType.evening:
        return (l.notifDailyReminderTitle, l.notifDailyReminderBody);
      case ReminderType.morningCountdown:
        return (
          l.notifWeekTitle(r.days),
          r.amount > 0
              ? l.notifWeekBody(_money(l, r.amount))
              : l.notifWeekBodyTight,
        );
      case ReminderType.payday:
        return (
          l.notifSalaryDayTitle,
          r.amount <= 0
              ? l.notifSalaryDayBody
              : _hidePrivate
              ? l.notifSalaryDayBodyWithDebtHidden
              : l.notifSalaryDayBodyWithDebt(_money(l, r.amount), r.name),
        );
      case ReminderType.lending:
        return (
          l.notifLendingTitle,
          _hidePrivate
              ? l.notifLendingBodyHidden
              : r.count == 0
              ? l.notifLendingBodyOne(r.name, _money(l, r.amount))
              : l.notifLendingBodyMany(r.name, r.count, _money(l, r.amount)),
        );
      case ReminderType.inactive:
        return (l.notifInactiveTitle, l.notifInactiveBody);
    }
  }

  /// Screen a reminder opens when tapped.
  String _reminderRoute(ScheduledReminder r) => switch (r.type) {
    ReminderType.lending => '/lendings',
    ReminderType.payday when r.amount > 0 => '/debts',
    _ => '/home',
  };

  // ── Scheduled reminders (work with the app closed) ──────────────────────

  /// Replaces all scheduled reminders with a plan built from the current
  /// numbers. Call on app start and after any change (data, language,
  /// salary day, setting).
  Future<void> rescheduleReminders() async {
    try {
      await _plugin.cancel(_idLegacyDaily);
      for (final id in BuildReminderPlanUseCase.allIds) {
        await _plugin.cancel(id);
      }
      for (var i = 0; i < _legacyTestSlotCount; i++) {
        await _plugin.cancel(_idLegacyTestBase + i);
      }
      if (!await isEnabled()) return;

      final l = await _l10n();
      final mode = await _scheduleMode();
      _hidePrivate = await _appLock.shouldHideAmounts();
      for (final r in await _buildReminderPlan()) {
        final (title, body) = _reminderTexts(l, r);
        await _plugin.zonedSchedule(
          r.id,
          title,
          body,
          _at(r.at),
          _details(
            l,
            // Payday matters; the rest are everyday nudges
            important: r.type == ReminderType.payday,
            evening: r.type == ReminderType.evening,
          ),
          payload: _reminderRoute(r),
          androidScheduleMode: mode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        if (kDebugMode) debugPrint('🔔 scheduled ${r.type.name} at ${r.at}');
      }
      if (kDebugMode) {
        final pending = await _plugin.pendingNotificationRequests();
        debugPrint('🔔 ${pending.length} reminders registered with the system');
      }
    } catch (e) {
      // Scheduling must never break the app, but must not fail unseen either
      debugPrint('🔔❌ scheduling reminders failed: $e');
    }
  }

  /// Debug builds only: a reminder in one minute through the exact same
  /// path as the real ones, to prove delivery on a device.
  Future<void> scheduleTestReminder() async {
    final l = await _l10n();
    final at = DateTime.now().add(const Duration(minutes: 1));
    await _plugin.zonedSchedule(
      1999,
      l.notifDailyReminderTitle,
      l.notifDailyReminderBody,
      _at(at),
      _details(l, important: false, evening: true),
      payload: '/home',
      androidScheduleMode: await _scheduleMode(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    debugPrint('🔔 test reminder scheduled for $at');
  }

  /// Local wall-clock time as an absolute instant.
  tz.TZDateTime _at(DateTime local) => tz.TZDateTime.from(local, tz.UTC);

  // ── Helpers ─────────────────────────────────────────────────────────────

  Future<AppLocalizations> _l10n() async {
    final code = await _localeStorage.read(key: _localeKey) ?? 'ar';
    return lookupAppLocalizations(Locale(code));
  }

  NotificationDetails _details(
    AppLocalizations l, {
    required bool important,
    bool evening = false,
  }) => NotificationDetails(
    android: AndroidNotificationDetails(
      important ? _alertsChannelId : _remindersChannelId,
      important ? l.notifChannelName : l.notifRemindersChannelName,
      channelDescription: important
          ? l.notifChannelDesc
          : l.notifRemindersChannelDesc,
      importance: important ? Importance.high : Importance.defaultImportance,
      priority: important ? Priority.high : Priority.defaultPriority,
      icon: _icon,
      actions: evening
          ? [
              AndroidNotificationAction(
                _spentNothingAction,
                l.notifSpentNothingAction,
                cancelNotification: true,
              ),
            ]
          : null,
    ),
    iOS: DarwinNotificationDetails(
      categoryIdentifier: evening ? _eveningCategory : null,
    ),
  );
}
