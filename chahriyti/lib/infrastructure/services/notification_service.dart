import '../../application/use_cases/notification/generate_notification_use_case.dart';

/// Local notification scheduling service.
///
/// In production, this would integrate with flutter_local_notifications.
/// For now, it provides trigger logic and content generation that can be
/// checked on dashboard load.
class NotificationService {
  final GenerateNotificationUseCase _generateNotificationUseCase;

  final Set<NotificationType> _shownThisSession = {};

  NotificationService({
    required GenerateNotificationUseCase generateNotificationUseCase,
  }) : _generateNotificationUseCase = generateNotificationUseCase;

  /// Check for notifications that should be shown.
  /// Returns only notifications not already shown in this session.
  Future<List<NotificationContent>> checkNotifications() async {
    final all = await _generateNotificationUseCase();
    final unshown = all
        .where((n) => !_shownThisSession.contains(n.type))
        .toList();
    return unshown;
  }

  /// Mark a notification type as shown so it won't trigger again this session.
  void markShown(NotificationType type) {
    _shownThisSession.add(type);
  }

  /// Reset shown state (e.g., when a new cycle starts).
  void resetShownState() {
    _shownThisSession.clear();
  }
}
