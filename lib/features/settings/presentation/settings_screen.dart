import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/academic_card.dart';
import '../../notifications/presentation/providers/notification_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const List<int> _leadOptionsMinutes = [15, 30, 60, 120, 360, 720, 1440];

  String _formatLeadMinutes(int minutes) {
    if (minutes >= 1440 && minutes % 1440 == 0) {
      final days = minutes ~/ 1440;
      return '$days day${days == 1 ? '' : 's'} before';
    }
    if (minutes >= 60 && minutes % 60 == 0) {
      final hours = minutes ~/ 60;
      return '$hours hour${hours == 1 ? '' : 's'} before';
    }
    return '$minutes minutes before';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentThemeMode = ref.watch(themeModeProvider);
    final notifSettings = ref.watch(notificationSettingsProvider);
    final notifNotifier = ref.read(notificationSettingsProvider.notifier);
    final permissionAsync = ref.watch(notificationPermissionStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preferences & Diagnostics', style: AppTypography.displayMedium),
            const SizedBox(height: AppDimensions.space4),
            Text(
              'Application configuration, reminders, appearance, and local storage status.',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.space20),

            // Appearance Card
            AcademicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appearance', style: AppTypography.titleMedium),
                  const SizedBox(height: AppDimensions.space12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.brightness_medium_outlined),
                    title: const Text('Theme Mode'),
                    subtitle: Text(
                      currentThemeMode == ThemeMode.system
                          ? 'System Default'
                          : currentThemeMode == ThemeMode.dark
                              ? 'Dark Mode'
                              : 'Light Mode',
                    ),
                    trailing: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode_outlined, size: 18),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.auto_mode_outlined, size: 18),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode_outlined, size: 18),
                        ),
                      ],
                      selected: {currentThemeMode},
                      onSelectionChanged: (Set<ThemeMode> newSelection) {
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(newSelection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Notification Settings Card
            AcademicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Deadline Notifications',
                          style: AppTypography.titleMedium),
                      permissionAsync.when(
                        data: (perm) => Chip(
                          label: Text(
                            perm.notificationsGranted
                                ? 'Permitted'
                                : 'Permission Off',
                            style: AppTypography.bodySmall,
                          ),
                          avatar: Icon(
                            perm.notificationsGranted
                                ? Icons.check_circle_outline
                                : Icons.error_outline,
                            size: 16,
                            color: perm.notificationsGranted
                                ? Colors.green
                                : theme.colorScheme.error,
                          ),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Enable Reminders'),
                    subtitle: const Text(
                        'Automatically schedule local alerts for task deadlines'),
                    value: notifSettings.remindersEnabled,
                    onChanged: (val) async {
                      if (val) {
                        await ref
                            .read(localNotificationGatewayProvider)
                            .requestPermissions();
                        ref.invalidate(notificationPermissionStatusProvider);
                      }
                      await notifNotifier.updateSettings(
                        notifSettings.copyWith(remindersEnabled: val),
                      );
                    },
                  ),
                  if (notifSettings.remindersEnabled) ...[
                    const Divider(),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('At Deadline Notification'),
                      subtitle:
                          const Text('Notify when the exact deadline arrives'),
                      value: notifSettings.deadlineNotificationsEnabled,
                      onChanged: (val) => notifNotifier.updateSettings(
                        notifSettings.copyWith(
                            deadlineNotificationsEnabled: val),
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Upcoming Task Reminders'),
                      subtitle: const Text(
                          'Enable automatic advance deadline warnings'),
                      value: notifSettings.upcomingRemindersEnabled,
                      onChanged: (val) => notifNotifier.updateSettings(
                        notifSettings.copyWith(upcomingRemindersEnabled: val),
                      ),
                    ),
                    if (notifSettings.upcomingRemindersEnabled) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          children: [
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('24 Hours Before Deadline'),
                              value: notifSettings.notify24HoursBefore,
                              onChanged: (val) => notifNotifier.updateSettings(
                                notifSettings.copyWith(
                                    notify24HoursBefore: val ?? true),
                              ),
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('3 Hours Before Deadline'),
                              value: notifSettings.notify3HoursBefore,
                              onChanged: (val) => notifNotifier.updateSettings(
                                notifSettings.copyWith(
                                    notify3HoursBefore: val ?? true),
                              ),
                            ),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Custom Reminder Timing'),
                              subtitle: Text(_formatLeadMinutes(
                                  notifSettings.defaultReminderLeadMinutes)),
                              value: notifSettings.customIntervalEnabled,
                              onChanged: (val) => notifNotifier.updateSettings(
                                notifSettings.copyWith(
                                    customIntervalEnabled: val),
                              ),
                            ),
                            if (notifSettings.customIntervalEnabled)
                              DropdownButtonFormField<int>(
                                value: _leadOptionsMinutes.contains(
                                        notifSettings.defaultReminderLeadMinutes)
                                    ? notifSettings.defaultReminderLeadMinutes
                                    : 60,
                                decoration: const InputDecoration(
                                  labelText: 'Default Reminder Timing',
                                ),
                                items: _leadOptionsMinutes
                                    .map(
                                      (m) => DropdownMenuItem(
                                        value: m,
                                        child: Text(_formatLeadMinutes(m)),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    notifNotifier.updateSettings(
                                      notifSettings.copyWith(
                                          defaultReminderLeadMinutes: val),
                                    );
                                  }
                                },
                              ),
                            const SizedBox(height: AppDimensions.space8),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('High-Priority Extra Alert'),
                              subtitle: Text(
                                'Additional reminder (${_formatLeadMinutes(notifSettings.highPriorityExtraMinutes)})',
                              ),
                              value: notifSettings
                                  .highPriorityExtraReminderEnabled,
                              onChanged: (val) => notifNotifier.updateSettings(
                                notifSettings.copyWith(
                                    highPriorityExtraReminderEnabled: val),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Divider(),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Overdue Alerts'),
                      subtitle: const Text(
                          'Single reminder 1 hour after deadline if incomplete'),
                      value: notifSettings.overdueNotificationsEnabled,
                      onChanged: (val) => notifNotifier.updateSettings(
                        notifSettings.copyWith(
                            overdueNotificationsEnabled: val),
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Cancel When Completed'),
                      subtitle: const Text(
                          'Automatically remove pending alerts on completion'),
                      value: notifSettings.cancelOnComplete,
                      onChanged: (val) => notifNotifier.updateSettings(
                        notifSettings.copyWith(cancelOnComplete: val),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Diagnostics Card
            AcademicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Local Database Diagnostics',
                      style: AppTypography.titleMedium),
                  const SizedBox(height: AppDimensions.space8),
                  FutureBuilder<String?>(
                    future: ref
                        .read(appDatabaseProvider)
                        .getMetadata('schema_initialized_at'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Reading database status...');
                      }
                      if (snapshot.hasError) {
                        return Text('Database error: ${snapshot.error}');
                      }
                      final initTime = snapshot.data ?? 'Not found';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Database Name: ${AppConstants.databaseName}'),
                          Text(
                              'Schema Version: ${ref.read(appDatabaseProvider).schemaVersion}'),
                          Text('Initialized At: $initTime'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            AcademicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About', style: AppTypography.titleMedium),
                  const SizedBox(height: AppDimensions.space8),
                  Text('${AppConstants.appName} v${AppConstants.appVersion}'),
                  Text(
                    AppConstants.appTagline,
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
