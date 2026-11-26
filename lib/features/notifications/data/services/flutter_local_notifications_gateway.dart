import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../../domain/services/local_notification_gateway.dart';

class FlutterLocalNotificationsGateway implements LocalNotificationGateway {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const String _channelId = 'smart_professor_deadlines';
  static const String _channelName = 'Academic Deadlines & Reminders';
  static const String _channelDescription =
      'Notifications for academic task deadlines, upcoming reminders, and overdue alerts.';

  FlutterLocalNotificationsGateway([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize({
    required void Function(String? payload) onNotificationTap,
  }) async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    await refreshLocalTimezone();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onNotificationTap(response.payload);
      },
    );

    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
        ),
      );
    }

    _initialized = true;
  }

  @override
  Future<void> refreshLocalTimezone() async {
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      // Fallback safely to UTC if platform timezone lookup is unavailable
      tz.setLocalLocation(tz.UTC);
    }
  }

  @override
  Future<String?> getInitialNotificationPayload() async {
    try {
      final launchDetails = await _plugin.getNotificationAppLaunchDetails();
      if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
        return launchDetails.notificationResponse?.payload;
      }
    } catch (_) {
      // Unsupported platform or test environment
    }
    return null;
  }

  @override
  Future<NotificationPermissionStatus> getPermissionStatus() async {
    if (kIsWeb || !Platform.isAndroid) {
      return const NotificationPermissionStatus(
        notificationsGranted: true,
        exactAlarmsAllowed: true,
      );
    }

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) {
      return const NotificationPermissionStatus(
        notificationsGranted: false,
        exactAlarmsAllowed: false,
      );
    }

    final granted = await androidPlugin.areNotificationsEnabled() ?? false;
    final exact = await androidPlugin.canScheduleExactNotifications() ?? false;
    return NotificationPermissionStatus(
      notificationsGranted: granted,
      exactAlarmsAllowed: exact,
    );
  }

  @override
  Future<bool> requestPermissions() async {
    if (kIsWeb || !Platform.isAndroid) return true;

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return false;

    final granted =
        await androidPlugin.requestNotificationsPermission() ?? false;
    // Request exact alarm permission if available (Android 12+/14+)
    await androidPlugin.requestExactAlarmsPermission();
    return granted;
  }

  @override
  Future<bool> scheduleZonedNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
    bool allowExact = true,
  }) async {
    if (!_initialized) return false;

    final status = await getPermissionStatus();
    if (!status.notificationsGranted) {
      return false;
    }

    final scheduleMode = (allowExact && status.exactAlarmsAllowed)
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    final tzScheduled = tz.TZDateTime.from(scheduledAt, tz.local);

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduled,
        details,
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      return true;
    } catch (_) {
      // Fallback to inexact if exact alarm threw SecurityException on Android
      if (scheduleMode == AndroidScheduleMode.exactAllowWhileIdle) {
        try {
          await _plugin.zonedSchedule(
            id,
            title,
            body,
            tzScheduled,
            details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: payload,
          );
          return true;
        } catch (_) {
          return false;
        }
      }
      return false;
    }
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  @override
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  @override
  Future<List<PendingPlatformNotification>> getPendingNotifications() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending
        .map(
          (p) => PendingPlatformNotification(
            id: p.id,
            title: p.title,
            body: p.body,
            payload: p.payload,
          ),
        )
        .toList();
  }
}
