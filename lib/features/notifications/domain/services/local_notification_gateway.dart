class PendingPlatformNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  const PendingPlatformNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });
}

class NotificationPermissionStatus {
  final bool notificationsGranted;
  final bool exactAlarmsAllowed;

  const NotificationPermissionStatus({
    required this.notificationsGranted,
    required this.exactAlarmsAllowed,
  });
}

abstract class LocalNotificationGateway {
  Future<void> initialize({
    required void Function(String? payload) onNotificationTap,
  });

  Future<String?> getInitialNotificationPayload();

  Future<NotificationPermissionStatus> getPermissionStatus();

  Future<bool> requestPermissions();

  Future<bool> scheduleZonedNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
    bool allowExact = true,
  });

  Future<void> cancelNotification(int id);

  Future<void> cancelAllNotifications();

  Future<List<PendingPlatformNotification>> getPendingNotifications();

  Future<void> refreshLocalTimezone();
}
