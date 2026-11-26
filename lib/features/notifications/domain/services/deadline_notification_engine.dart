import 'package:intl/intl.dart';
import '../../../tasks/domain/models/task.dart';
import '../models/notification_settings.dart';
import '../models/scheduled_notification_record.dart';
import '../repositories/notification_schedule_repository.dart';
import 'local_notification_gateway.dart';

class _NotificationSpec {
  final ReminderType type;
  final DateTime scheduledAt;
  final String title;
  final String body;
  final DateTime? deadlineSnapshot;

  const _NotificationSpec({
    required this.type,
    required this.scheduledAt,
    required this.title,
    required this.body,
    this.deadlineSnapshot,
  });
}

class DeadlineNotificationEngine {
  final LocalNotificationGateway _gateway;
  final NotificationScheduleRepository _scheduleRepo;

  DeadlineNotificationEngine({
    required LocalNotificationGateway gateway,
    required NotificationScheduleRepository scheduleRepository,
  })  : _gateway = gateway,
        _scheduleRepo = scheduleRepository;

  Future<void> scheduleForTask(
    Task task,
    NotificationSettings settings, {
    DateTime? nowOverride,
  }) async {
    final now = nowOverride ?? DateTime.now();

    // Never notify for completed tasks or when reminders are disabled
    if (!settings.remindersEnabled ||
        (task.isCompleted && settings.cancelOnComplete) ||
        task.isCompleted) {
      await cancelForTask(task.id);
      return;
    }

    final existingRecords = await _scheduleRepo.getRecordsForTask(task.id);
    final existingByType = {
      for (final r in existingRecords) r.reminderType: r,
    };

    final desiredSpecs = _buildDesiredSpecs(
      task: task,
      settings: settings,
      now: now,
      existingByType: existingByType,
    );

    final desiredTypes = desiredSpecs.map((s) => s.type).toSet();

    // Cancel any previously scheduled notifications that are no longer desired
    for (final existing in existingRecords) {
      if (!desiredTypes.contains(existing.reminderType)) {
        // Keep delivered overdue record for the same deadline so we don't spam
        final isDeliveredOverdueForSameDeadline =
            existing.reminderType == ReminderType.overdue &&
                existing.deadlineSnapshot == task.deadline &&
                existing.scheduledAt.isBefore(now);

        if (!isDeliveredOverdueForSameDeadline) {
          await _gateway.cancelNotification(existing.notificationId);
          await _scheduleRepo.deleteRecord(existing.notificationId);
        }
      }
    }

    final platformPending = await _gateway.getPendingNotifications();
    final platformPendingIds = platformPending.map((p) => p.id).toSet();

    // Schedule or update desired notifications
    for (final spec in desiredSpecs) {
      final notifId =
          ScheduledNotificationRecord.generateNotificationId(task.id, spec.type);
      final existing = existingByType[spec.type];

      final isAlreadyScheduledIdentically = existing != null &&
          existing.status == NotificationScheduleStatus.scheduled &&
          existing.scheduledAt.isAtSameMomentAs(spec.scheduledAt) &&
          existing.title == spec.title &&
          existing.body == spec.body &&
          platformPendingIds.contains(notifId);

      if (isAlreadyScheduledIdentically) {
        continue;
      }

      final scheduled = await _gateway.scheduleZonedNotification(
        id: notifId,
        title: spec.title,
        body: spec.body,
        scheduledAt: spec.scheduledAt,
        payload: task.id,
      );

      final record = ScheduledNotificationRecord(
        notificationId: notifId,
        taskId: task.id,
        reminderType: spec.type,
        scheduledAt: spec.scheduledAt,
        deadlineSnapshot: spec.deadlineSnapshot,
        title: spec.title,
        body: spec.body,
        payload: task.id,
        status: scheduled
            ? NotificationScheduleStatus.scheduled
            : NotificationScheduleStatus.failedPermission,
        createdAt: now,
      );
      await _scheduleRepo.upsertRecord(record);
    }
  }

  List<_NotificationSpec> _buildDesiredSpecs({
    required Task task,
    required NotificationSettings settings,
    required DateTime now,
    required Map<ReminderType, ScheduledNotificationRecord> existingByType,
  }) {
    final specs = <_NotificationSpec>[];
    final deadline = task.deadline;
    final deadlineFormatted = deadline != null
        ? DateFormat('EEE, MMM d • h:mm a').format(deadline)
        : null;

    // 1. Custom user-picked reminder
    if (task.reminderAt != null && task.reminderAt!.isAfter(now)) {
      specs.add(
        _NotificationSpec(
          type: ReminderType.custom,
          scheduledAt: task.reminderAt!,
          title: 'Task Reminder: ${task.title}',
          body: deadlineFormatted != null
              ? 'Deadline: $deadlineFormatted'
              : 'Scheduled academic task reminder.',
          deadlineSnapshot: deadline,
        ),
      );
    }

    if (deadline == null) {
      return specs;
    }

    // 2. Upcoming reminders before deadline
    if (settings.upcomingRemindersEnabled) {
      if (settings.notify24HoursBefore) {
        final at24h = deadline.subtract(const Duration(hours: 24));
        if (at24h.isAfter(now)) {
          specs.add(
            _NotificationSpec(
              type: ReminderType.before24h,
              scheduledAt: at24h,
              title: 'Due Tomorrow: ${task.title}',
              body: 'Due in 24 hours ($deadlineFormatted).',
              deadlineSnapshot: deadline,
            ),
          );
        }
      }

      if (settings.notify3HoursBefore) {
        final at3h = deadline.subtract(const Duration(hours: 3));
        if (at3h.isAfter(now)) {
          specs.add(
            _NotificationSpec(
              type: ReminderType.before3h,
              scheduledAt: at3h,
              title: 'Due Soon: ${task.title}',
              body: 'Due in 3 hours ($deadlineFormatted).',
              deadlineSnapshot: deadline,
            ),
          );
        }
      }

      if (settings.customIntervalEnabled &&
          settings.defaultReminderLeadMinutes > 0) {
        final mins = settings.defaultReminderLeadMinutes;
        final duplicates24h = settings.notify24HoursBefore && mins == 1440;
        final duplicates3h = settings.notify3HoursBefore && mins == 180;
        if (!duplicates24h && !duplicates3h) {
          final atCustom = deadline.subtract(Duration(minutes: mins));
          if (atCustom.isAfter(now)) {
            specs.add(
              _NotificationSpec(
                type: ReminderType.customInterval,
                scheduledAt: atCustom,
                title: 'Upcoming Deadline: ${task.title}',
                body: 'Due ${_formatLeadDuration(mins)} ($deadlineFormatted).',
                deadlineSnapshot: deadline,
              ),
            );
          }
        }
      }

      if (task.priority == TaskPriority.high &&
          settings.highPriorityExtraReminderEnabled &&
          settings.highPriorityExtraMinutes > 0) {
        final atHighPriority = deadline
            .subtract(Duration(minutes: settings.highPriorityExtraMinutes));
        if (atHighPriority.isAfter(now)) {
          specs.add(
            _NotificationSpec(
              type: ReminderType.highPriorityExtra,
              scheduledAt: atHighPriority,
              title: 'High Priority Task: ${task.title}',
              body: 'Priority deadline approaching ($deadlineFormatted).',
              deadlineSnapshot: deadline,
            ),
          );
        }
      }
    }

    // 3. At deadline notification
    if (settings.deadlineNotificationsEnabled && deadline.isAfter(now)) {
      specs.add(
        _NotificationSpec(
          type: ReminderType.atDeadline,
          scheduledAt: deadline,
          title: 'Deadline Reached: ${task.title}',
          body: 'This academic task is due now ($deadlineFormatted).',
          deadlineSnapshot: deadline,
        ),
      );
    }

    // 4. Overdue notification (scheduled 1 hour after deadline, once per deadline)
    if (settings.overdueNotificationsEnabled) {
      final existingOverdue = existingByType[ReminderType.overdue];
      final alreadyNotifiedForThisDeadline = existingOverdue != null &&
          existingOverdue.deadlineSnapshot != null &&
          existingOverdue.deadlineSnapshot!.isAtSameMomentAs(deadline) &&
          existingOverdue.scheduledAt.isBefore(now) &&
          existingOverdue.status == NotificationScheduleStatus.scheduled;

      if (!alreadyNotifiedForThisDeadline) {
        final overdueAt = deadline.add(const Duration(hours: 1));
        if (overdueAt.isAfter(now)) {
          specs.add(
            _NotificationSpec(
              type: ReminderType.overdue,
              scheduledAt: overdueAt,
              title: 'Task Overdue: ${task.title}',
              body: 'Deadline passed ($deadlineFormatted). Still marked incomplete.',
              deadlineSnapshot: deadline,
            ),
          );
        } else if (now.difference(deadline) <= const Duration(days: 7)) {
          // If deadline passed recently (without an overdue alert yet), schedule once shortly
          specs.add(
            _NotificationSpec(
              type: ReminderType.overdue,
              scheduledAt: now.add(const Duration(minutes: 1)),
              title: 'Task Overdue: ${task.title}',
              body: 'Deadline passed ($deadlineFormatted). Still marked incomplete.',
              deadlineSnapshot: deadline,
            ),
          );
        }
      }
    }

    return specs;
  }

  String _formatLeadDuration(int minutes) {
    if (minutes >= 1440 && minutes % 1440 == 0) {
      final days = minutes ~/ 1440;
      return 'in $days day${days == 1 ? '' : 's'}';
    }
    if (minutes >= 60 && minutes % 60 == 0) {
      final hours = minutes ~/ 60;
      return 'in $hours hour${hours == 1 ? '' : 's'}';
    }
    return 'in $minutes minute${minutes == 1 ? '' : 's'}';
  }

  Future<void> cancelForTask(String taskId) async {
    final existing = await _scheduleRepo.getRecordsForTask(taskId);
    for (final record in existing) {
      await _gateway.cancelNotification(record.notificationId);
    }
    for (final type in ReminderType.values) {
      final id = ScheduledNotificationRecord.generateNotificationId(taskId, type);
      await _gateway.cancelNotification(id);
    }
    await _scheduleRepo.deleteRecordsForTask(taskId);
  }

  Future<void> reconcileAllTasks(
    List<Task> allTasks,
    NotificationSettings settings, {
    DateTime? nowOverride,
  }) async {
    await _gateway.refreshLocalTimezone();

    final taskById = {for (final t in allTasks) t.id: t};
    final platformPending = await _gateway.getPendingNotifications();
    final dbScheduled = await _scheduleRepo.getAllScheduledRecords();

    // 1. Cancel orphaned platform notifications (e.g., deleted or completed tasks)
    for (final pending in platformPending) {
      final taskId = pending.payload;
      if (taskId == null || !taskById.containsKey(taskId)) {
        await _gateway.cancelNotification(pending.id);
        await _scheduleRepo.deleteRecord(pending.id);
        continue;
      }
      final task = taskById[taskId]!;
      if (!settings.remindersEnabled || task.isCompleted) {
        await _gateway.cancelNotification(pending.id);
        await _scheduleRepo.deleteRecord(pending.id);
      }
    }

    // 2. Clean DB records whose tasks no longer exist
    for (final record in dbScheduled) {
      if (!taskById.containsKey(record.taskId)) {
        await _gateway.cancelNotification(record.notificationId);
        await _scheduleRepo.deleteRecord(record.notificationId);
      }
    }

    // 3. Re-evaluate every task against current time, timezone, and settings
    for (final task in allTasks) {
      await scheduleForTask(task, settings, nowOverride: nowOverride);
    }
  }
}
