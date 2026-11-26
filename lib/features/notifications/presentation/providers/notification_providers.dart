import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../data/repositories/notification_schedule_repository_impl.dart';
import '../../data/repositories/notification_settings_repository.dart';
import '../../data/services/flutter_local_notifications_gateway.dart';
import '../../domain/models/notification_settings.dart';
import '../../domain/repositories/notification_schedule_repository.dart';
import '../../domain/services/deadline_notification_engine.dart';
import '../../domain/services/local_notification_gateway.dart';

final localNotificationGatewayProvider =
    Provider<LocalNotificationGateway>((ref) {
  return FlutterLocalNotificationsGateway();
});

final notificationScheduleRepositoryProvider =
    Provider<NotificationScheduleRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return NotificationScheduleRepositoryImpl(db);
});

final notificationSettingsRepositoryProvider =
    Provider<NotificationSettingsRepository>((ref) {
  return NotificationSettingsRepository();
});

final deadlineNotificationEngineProvider =
    Provider<DeadlineNotificationEngine>((ref) {
  return DeadlineNotificationEngine(
    gateway: ref.watch(localNotificationGatewayProvider),
    scheduleRepository: ref.watch(notificationScheduleRepositoryProvider),
  );
});

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  final NotificationSettingsRepository _repo;
  Future<void> Function(NotificationSettings)? _onSettingsChanged;

  NotificationSettingsNotifier(this._repo)
      : super(const NotificationSettings()) {
    _load();
  }

  void registerOnSettingsChanged(
      Future<void> Function(NotificationSettings) callback) {
    _onSettingsChanged = callback;
  }

  Future<void> _load() async {
    final loaded = await _repo.loadSettings();
    if (mounted) {
      state = loaded;
    }
  }

  Future<void> updateSettings(NotificationSettings updated) async {
    state = updated;
    await _repo.saveSettings(updated);
    if (_onSettingsChanged != null) {
      await _onSettingsChanged!(updated);
    }
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
        (ref) {
  final repo = ref.watch(notificationSettingsRepositoryProvider);
  return NotificationSettingsNotifier(repo);
});

final notificationPermissionStatusProvider =
    FutureProvider<NotificationPermissionStatus>((ref) async {
  final gateway = ref.watch(localNotificationGatewayProvider);
  return gateway.getPermissionStatus();
});

/// Broadcasts taskId payloads when the user taps a local notification.
final notificationTapControllerProvider =
    Provider<StreamController<String>>((ref) {
  final controller = StreamController<String>.broadcast();
  ref.onDispose(() {
    controller.close();
  });
  return controller;
});
