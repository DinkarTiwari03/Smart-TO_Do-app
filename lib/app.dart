import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/notifications/domain/models/notification_settings.dart';
import 'features/notifications/presentation/providers/notification_providers.dart';
import 'features/tasks/presentation/providers/task_providers.dart';
import 'features/tasks/presentation/screens/task_detail_screen.dart';

class SmartProfessorApp extends ConsumerStatefulWidget {
  const SmartProfessorApp({super.key});

  @override
  ConsumerState<SmartProfessorApp> createState() => _SmartProfessorAppState();
}

class _SmartProfessorAppState extends ConsumerState<SmartProfessorApp>
    with WidgetsBindingObserver {
  StreamSubscription<String>? _tapSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initNotificationsAndReconcile();
  }

  Future<void> _initNotificationsAndReconcile() async {
    final gateway = ref.read(localNotificationGatewayProvider);
    final tapController = ref.read(notificationTapControllerProvider);

    _tapSubscription = tapController.stream.listen(_handleNotificationTap);

    await gateway.initialize(
      onNotificationTap: (payload) {
        if (payload != null && payload.isNotEmpty) {
          tapController.add(payload);
        }
      },
    );

    ref
        .read(notificationSettingsProvider.notifier)
        .registerOnSettingsChanged((updatedSettings) async {
      await _reconcileNotifications(settingsOverride: updatedSettings);
    });

    await _reconcileNotifications();

    final initialPayload = await gateway.getInitialNotificationPayload();
    if (initialPayload != null && initialPayload.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotificationTap(initialPayload);
      });
    }
  }

  Future<void> _reconcileNotifications({
    NotificationSettings? settingsOverride,
  }) async {
    try {
      final tasks =
          await ref.read(taskRepositoryProvider).watchAllTasks().first;
      final NotificationSettings settings =
          settingsOverride ?? ref.read(notificationSettingsProvider);
      await ref
          .read(deadlineNotificationEngineProvider)
          .reconcileAllTasks(tasks, settings);
      ref.invalidate(notificationPermissionStatusProvider);
    } catch (_) {
      // Safe guard during disposal or test teardown
    }
  }

  Future<void> _handleNotificationTap(String taskId) async {
    final task = await ref.read(taskRepositoryProvider).getTaskById(taskId);
    final navState = rootNavigatorKey.currentState;
    final navContext = rootNavigatorKey.currentContext;
    if (navState == null || navContext == null) return;

    if (task == null) {
      if (navContext.mounted) {
        ScaffoldMessenger.of(navContext).showSnackBar(
          const SnackBar(
            content: Text('This task was deleted or is no longer available.'),
          ),
        );
        ref.read(routerProvider).go(AppRouteNames.tasks);
      }
      return;
    }

    navState.push(
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(initialTask: task),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _reconcileNotifications();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tapSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
