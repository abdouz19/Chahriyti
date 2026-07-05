import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../application/use_cases/notification/generate_notification_use_case.dart';

class NotificationService {
  final GenerateNotificationUseCase _generateNotificationUseCase;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  final Set<NotificationType> _shownThisSession = {};

  static const _channelId = 'chahriyti_finance';
  static const _channelName = 'التنبيهات المالية';
  static const _channelDesc = 'تنبيهات تتعلق بالميزانية والمصاريف';
  static const _welcomeShownKey = 'chahriyti_welcome_notif_shown';
  static const _idWelcome = 999;

  NotificationService({
    required GenerateNotificationUseCase generateNotificationUseCase,
  }) : _generateNotificationUseCase = generateNotificationUseCase;

  Future<void> initialize() async {
    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      await _plugin.initialize(settings);

      // Request Android 13+ notification permission
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidImpl?.requestNotificationsPermission();

      // Show welcome notification once (only if permission granted)
      final alreadyShown = await _storage.read(key: _welcomeShownKey);
      if (alreadyShown == null && (androidImpl == null || (granted ?? false))) {
        await _showWelcome();
        await _storage.write(key: _welcomeShownKey, value: '1');
      }
    } catch (_) {
      // Notification init must never block app launch
    }
  }

  Future<void> _showWelcome() async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      _idWelcome,
      'أهلاً بك في شهريتي! 🎉',
      'التنبيهات مفعّلة — راح نذكّرك بميزانيتك كل يوم حتى توصل لآخر الشهر بفلوس 💪',
      details,
    );
  }

  Future<void> checkNotifications() async {
    final all = await _generateNotificationUseCase();
    final unshown =
        all.where((n) => !_shownThisSession.contains(n.type)).toList();

    for (final notification in unshown) {
      await _show(notification);
      _shownThisSession.add(notification.type);
    }
  }

  Future<void> show(NotificationContent notification) async {
    await _show(notification);
    _shownThisSession.add(notification.type);
  }

  Future<void> _show(NotificationContent notification) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      notification.type.index,
      notification.title,
      notification.body,
      details,
    );
  }

  void resetShownState() {
    _shownThisSession.clear();
  }
}
