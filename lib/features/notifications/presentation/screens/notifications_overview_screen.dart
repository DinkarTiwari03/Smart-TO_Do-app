import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/academic_card.dart';
import '../../../tasks/presentation/providers/task_providers.dart';
import '../../../tasks/presentation/screens/task_detail_screen.dart';
import '../../domain/models/scheduled_notification_record.dart';
import '../providers/notification_providers.dart';

class NotificationsOverviewScreen extends ConsumerStatefulWidget {
  const NotificationsOverviewScreen({super.key});

  @override
  ConsumerState<NotificationsOverviewScreen> createState() =>
      _NotificationsOverviewScreenState();
}

class _NotificationsOverviewScreenState
    extends ConsumerState<NotificationsOverviewScreen> {
  Future<List<ScheduledNotificationRecord>> _loadScheduled() {
    return ref
        .read(notificationScheduleRepositoryProvider)
        .getAllScheduledRecords();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final permissionAsync = ref.watch(notificationPermissionStatusProvider);
    final settings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders & Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            tooltip: 'Notification Settings',
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRouteNames.settings);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        children: [
          permissionAsync.when(
            data: (perm) {
              if (!perm.notificationsGranted) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppDimensions.space16),
                  child: AcademicCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notifications_off_outlined,
                                color: theme.colorScheme.error),
                            const SizedBox(width: AppDimensions.space8),
                            Text(
                              'Notifications Disabled',
                              style: AppTypography.titleMedium.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.space8),
                        const Text(
                          'Android notification permission is currently denied. Grant permission so deadline alerts can be delivered.',
                        ),
                        const SizedBox(height: AppDimensions.space12),
                        FilledButton.icon(
                          onPressed: () async {
                            final gateway =
                                ref.read(localNotificationGatewayProvider);
                            await gateway.requestPermissions();
                            ref.invalidate(
                                notificationPermissionStatusProvider);
                            final tasks = await ref
                                .read(taskRepositoryProvider)
                                .watchAllTasks()
                                .first;
                            await ref
                                .read(deadlineNotificationEngineProvider)
                                .reconcileAllTasks(tasks, settings);
                            if (mounted) setState(() {});
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Grant Permission'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Text('Scheduled Notifications', style: AppTypography.titleLarge),
          const SizedBox(height: AppDimensions.space4),
          Text(
            settings.remindersEnabled
                ? 'Active local reminders synced with your task deadlines.'
                : 'Reminders are currently paused in Settings.',
            style: AppTypography.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          FutureBuilder<List<ScheduledNotificationRecord>>(
            future: _loadScheduled(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.space24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final records = (snapshot.data ?? [])
                ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

              if (records.isEmpty) {
                return AcademicCard(
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_none_outlined,
                        size: 48,
                        color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: AppDimensions.space12),
                      Text(
                        'No Pending Reminders',
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.space4),
                      Text(
                        'Tasks with upcoming deadlines or custom reminders will automatically schedule alerts here.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: records.map((rec) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppDimensions.space12),
                    child: AcademicCard(
                      onTap: () async {
                        final task = await ref
                            .read(taskRepositoryProvider)
                            .getTaskById(rec.taskId);
                        if (!context.mounted) return;
                        if (task == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('This task no longer exists.')),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetailScreen(initialTask: task),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.alarm_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: AppDimensions.space12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(rec.title, style: AppTypography.titleSmall),
                                const SizedBox(height: 2),
                                Text(
                                  rec.body,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('EEE, MMM d • h:mm a')
                                      .format(rec.scheduledAt),
                                  style: AppTypography.labelMedium.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 18),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
