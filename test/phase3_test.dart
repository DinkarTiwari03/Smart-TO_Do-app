import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_professor_assistant/app.dart';
import 'package:smart_professor_assistant/core/database/app_database.dart';
import 'package:smart_professor_assistant/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:smart_professor_assistant/features/notifications/data/repositories/notification_schedule_repository_impl.dart';
import 'package:smart_professor_assistant/features/notifications/domain/models/notification_settings.dart';
import 'package:smart_professor_assistant/features/notifications/domain/models/scheduled_notification_record.dart';
import 'package:smart_professor_assistant/features/notifications/domain/services/deadline_notification_engine.dart';
import 'package:smart_professor_assistant/features/notifications/domain/services/local_notification_gateway.dart';
import 'package:smart_professor_assistant/features/notifications/presentation/providers/notification_providers.dart';
import 'package:smart_professor_assistant/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:smart_professor_assistant/features/tasks/domain/models/task.dart';
import 'package:smart_professor_assistant/features/tasks/domain/models/task_category.dart';

class FakeLocalNotificationGateway implements LocalNotificationGateway {
  bool initialized = false;
  bool permissionGranted = true;
  bool exactAlarmsAllowed = true;
  int timezoneRefreshCount = 0;
  void Function(String? payload)? _onTap;
  String? initialPayload;

  final Map<int, ({String title, String body, DateTime scheduledAt, String payload})>
      scheduledMap = {};
  int scheduleCallCount = 0;
  int cancelCallCount = 0;

  void simulateTap(String? payload) {
    _onTap?.call(payload);
  }

  @override
  Future<void> initialize({
    required void Function(String? payload) onNotificationTap,
  }) async {
    initialized = true;
    _onTap = onNotificationTap;
  }

  @override
  Future<String?> getInitialNotificationPayload() async => initialPayload;

  @override
  Future<NotificationPermissionStatus> getPermissionStatus() async {
    return NotificationPermissionStatus(
      notificationsGranted: permissionGranted,
      exactAlarmsAllowed: exactAlarmsAllowed,
    );
  }

  @override
  Future<bool> requestPermissions() async => permissionGranted;

  @override
  Future<bool> scheduleZonedNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
    bool allowExact = true,
  }) async {
    scheduleCallCount++;
    if (!permissionGranted) return false;
    scheduledMap[id] = (
      title: title,
      body: body,
      scheduledAt: scheduledAt,
      payload: payload,
    );
    return true;
  }

  @override
  Future<void> cancelNotification(int id) async {
    cancelCallCount++;
    scheduledMap.remove(id);
  }

  @override
  Future<void> cancelAllNotifications() async {
    scheduledMap.clear();
  }

  @override
  Future<List<PendingPlatformNotification>> getPendingNotifications() async {
    return scheduledMap.entries
        .map(
          (e) => PendingPlatformNotification(
            id: e.key,
            title: e.value.title,
            body: e.value.body,
            payload: e.value.payload,
          ),
        )
        .toList();
  }

  @override
  Future<void> refreshLocalTimezone() async {
    timezoneRefreshCount++;
  }
}

void main() {
  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  group('DashboardSummary calculations', () {
    test('Accurately calculates totals, priorities, today, overdue, and 7-day upcoming', () {
      final now = DateTime(2026, 11, 26, 10, 0);
      final categories = {
        'cat_academic': const TaskCategory(
          id: 'cat_academic',
          name: 'Academic',
          color: '#1E3A5F',
          isDefault: true,
        ),
      };

      final tasks = [
        // Overdue (yesterday)
        Task(
          id: 't1',
          title: 'Overdue Grading',
          priority: TaskPriority.high,
          categoryId: 'cat_academic',
          deadline: DateTime(2026, 11, 25, 17, 0),
          status: TaskStatus.pending,
          createdAt: now,
          updatedAt: now,
        ),
        // Due today
        Task(
          id: 't2',
          title: 'Today Lecture',
          priority: TaskPriority.medium,
          categoryId: 'cat_academic',
          deadline: DateTime(2026, 11, 26, 16, 0),
          status: TaskStatus.pending,
          createdAt: now,
          updatedAt: now,
        ),
        // Upcoming in 3 days
        Task(
          id: 't3',
          title: 'Grant Proposal',
          priority: TaskPriority.high,
          categoryId: 'cat_academic',
          deadline: DateTime(2026, 11, 29, 12, 0),
          status: TaskStatus.inProgress,
          createdAt: now,
          updatedAt: now,
        ),
        // Beyond 7 days (should not appear in 7-day upcoming)
        Task(
          id: 't4',
          title: 'Next Month Conference',
          priority: TaskPriority.low,
          categoryId: 'cat_academic',
          deadline: DateTime(2026, 12, 15, 9, 0),
          status: TaskStatus.pending,
          createdAt: now,
          updatedAt: now,
        ),
        // Completed (even with past deadline, not counted as overdue/pending)
        Task(
          id: 't5',
          title: 'Completed Syllabus',
          priority: TaskPriority.high,
          categoryId: 'cat_academic',
          deadline: DateTime(2026, 11, 20, 9, 0),
          status: TaskStatus.completed,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      final summary = DashboardSummary.fromTasks(
        tasks: tasks,
        categoriesById: categories,
        nowOverride: now,
      );

      expect(summary.totalCount, equals(5));
      expect(summary.pendingCount, equals(4));
      expect(summary.completedCount, equals(1));
      expect(summary.overdueCount, equals(1));
      expect(summary.highPriorityCount, equals(2));
      expect(summary.mediumPriorityCount, equals(1));
      expect(summary.lowPriorityCount, equals(1));
      expect(summary.todaysTasks.map((e) => e.task.id), equals(['t2']));
      expect(summary.upcomingSevenDaysTasks.map((e) => e.task.id), equals(['t3']));
    });
  });

  group('Automatic Deadline Notification Engine', () {
    late AppDatabase db;
    late FakeLocalNotificationGateway gateway;
    late NotificationScheduleRepositoryImpl scheduleRepo;
    late DeadlineNotificationEngine engine;
    late TaskRepositoryImpl taskRepo;

    Future<void> seedTask(Task task) async {
      await db.into(db.tasksTable).insert(
            TasksTableCompanion.insert(
              id: task.id,
              title: task.title,
              description: Value(task.description),
              priority: task.priority.name,
              categoryId: task.categoryId,
              deadline: Value(task.deadline),
              reminderAt: Value(task.reminderAt),
              status: task.status.toDbString(),
              createdAt: Value(task.createdAt),
              updatedAt: Value(task.updatedAt),
            ),
          );
    }

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      gateway = FakeLocalNotificationGateway();
      gateway.initialize(onNotificationTap: (_) {});
      scheduleRepo = NotificationScheduleRepositoryImpl(db);
      engine = DeadlineNotificationEngine(
        gateway: gateway,
        scheduleRepository: scheduleRepo,
      );
      taskRepo = TaskRepositoryImpl(
        db,
        notificationEngine: engine,
        getNotificationSettings: () => const NotificationSettings(),
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('Automatically schedules 24h, 3h, at-deadline, and overdue notifications', () async {
      final now = DateTime(2026, 11, 26, 10, 0);
      final deadline = now.add(const Duration(days: 2));
      final task = Task(
        id: 'task-auto-1',
        title: 'Submit Final Grades',
        priority: TaskPriority.medium,
        categoryId: 'cat_academic',
        deadline: deadline,
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
      );
      await seedTask(task);

      await engine.scheduleForTask(
        task,
        const NotificationSettings(),
        nowOverride: now,
      );

      final records = await scheduleRepo.getRecordsForTask(task.id);
      final types = records.map((r) => r.reminderType).toSet();

      expect(types, contains(ReminderType.before24h));
      expect(types, contains(ReminderType.before3h));
      expect(types, contains(ReminderType.atDeadline));
      expect(types, contains(ReminderType.overdue));
      expect(gateway.scheduledMap.length, equals(4));
    });

    test('High priority task schedules additional reminder when enabled', () async {
      final now = DateTime(2026, 11, 26, 10, 0);
      final deadline = now.add(const Duration(days: 2));
      final task = Task(
        id: 'task-hp-1',
        title: 'Dean Committee Review',
        priority: TaskPriority.high,
        categoryId: 'cat_dept_admin',
        deadline: deadline,
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
      );
      await seedTask(task);

      await engine.scheduleForTask(
        task,
        const NotificationSettings(highPriorityExtraReminderEnabled: true),
        nowOverride: now,
      );

      final records = await scheduleRepo.getRecordsForTask(task.id);
      expect(
        records.any((r) => r.reminderType == ReminderType.highPriorityExtra),
        isTrue,
      );
      expect(gateway.scheduledMap.length, equals(5));
    });

    test('Prevents duplicate scheduling when task and settings are unchanged', () async {
      final now = DateTime(2026, 11, 26, 10, 0);
      final task = Task(
        id: 'task-dup-1',
        title: 'Duplicate Guard Test',
        priority: TaskPriority.low,
        categoryId: 'cat_academic',
        deadline: now.add(const Duration(days: 2)),
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
      );
      await seedTask(task);

      await engine.scheduleForTask(task, const NotificationSettings(), nowOverride: now);
      final firstCount = gateway.scheduleCallCount;

      // Second call with identical task & settings should be a no-op
      await engine.scheduleForTask(task, const NotificationSettings(), nowOverride: now);
      expect(gateway.scheduleCallCount, equals(firstCount));
    });

    test('Reschedules notifications when deadline changes', () async {
      final now = DateTime(2026, 11, 26, 10, 0);
      final originalDeadline = now.add(const Duration(days: 2));
      final updatedDeadline = now.add(const Duration(days: 5));

      final task = Task(
        id: 'task-resched-1',
        title: 'Reschedule Test',
        priority: TaskPriority.medium,
        categoryId: 'cat_academic',
        deadline: originalDeadline,
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
      );
      await seedTask(task);

      await engine.scheduleForTask(task, const NotificationSettings(), nowOverride: now);
      final atDeadlineId = ScheduledNotificationRecord.generateNotificationId(
          task.id, ReminderType.atDeadline);
      expect(gateway.scheduledMap[atDeadlineId]!.scheduledAt, equals(originalDeadline));

      await engine.scheduleForTask(
        task.copyWith(deadline: updatedDeadline),
        const NotificationSettings(),
        nowOverride: now,
      );
      expect(gateway.scheduledMap[atDeadlineId]!.scheduledAt, equals(updatedDeadline));
    });

    test('Cancels notifications when task is completed or deleted', () async {
      final now = DateTime.now();
      final task = Task(
        id: 'task-cancel-1',
        title: 'Cancel Test',
        priority: TaskPriority.medium,
        categoryId: 'cat_academic',
        deadline: now.add(const Duration(days: 2)),
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
      );

      await taskRepo.createTask(task);
      expect(gateway.scheduledMap.isNotEmpty, isTrue);

      await taskRepo.markCompleted(task.id);
      expect(gateway.scheduledMap.isEmpty, isTrue);

      // Reopen re-schedules
      await taskRepo.reopenTask(task.id);
      expect(gateway.scheduledMap.isNotEmpty, isTrue);

      // Delete cancels
      await taskRepo.deleteTask(task.id);
      expect(gateway.scheduledMap.isEmpty, isTrue);
    });

    test('Prevents repeated overdue notification spam for same deadline', () async {
      final deadline = DateTime(2026, 11, 26, 10, 0);
      final beforeOverdue = DateTime(2026, 11, 26, 9, 0);
      final afterOverdueDelivered = DateTime(2026, 11, 26, 12, 0);

      final task = Task(
        id: 'task-spam-1',
        title: 'Overdue Spam Check',
        priority: TaskPriority.medium,
        categoryId: 'cat_academic',
        deadline: deadline,
        status: TaskStatus.pending,
        createdAt: beforeOverdue,
        updatedAt: beforeOverdue,
      );
      await seedTask(task);

      await engine.scheduleForTask(
        task,
        const NotificationSettings(),
        nowOverride: beforeOverdue,
      );
      final overdueId = ScheduledNotificationRecord.generateNotificationId(
          task.id, ReminderType.overdue);
      expect(gateway.scheduledMap.containsKey(overdueId), isTrue);

      // Simulate OS already fired/removed it and app reconciles later
      gateway.scheduledMap.remove(overdueId);
      final countBefore = gateway.scheduleCallCount;

      await engine.scheduleForTask(
        task,
        const NotificationSettings(),
        nowOverride: afterOverdueDelivered,
      );
      expect(gateway.scheduledMap.containsKey(overdueId), isFalse);
      expect(gateway.scheduleCallCount, equals(countBefore));
    });

    test('Handles permission denial without promising scheduled status', () async {
      gateway.permissionGranted = false;
      final now = DateTime(2026, 11, 26, 10, 0);
      final task = Task(
        id: 'task-perm-1',
        title: 'Permission Denied Task',
        priority: TaskPriority.medium,
        categoryId: 'cat_academic',
        deadline: now.add(const Duration(days: 2)),
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
      );
      await seedTask(task);

      await engine.scheduleForTask(task, const NotificationSettings(), nowOverride: now);
      final records = await scheduleRepo.getRecordsForTask(task.id);
      expect(records, isNotEmpty);
      expect(
        records.every((r) => r.status == NotificationScheduleStatus.failedPermission),
        isTrue,
      );
      expect(gateway.scheduledMap, isEmpty);
    });

    test('Reconcile cancels orphaned platform notifications on startup', () async {
      gateway.scheduledMap[999999] = (
        title: 'Orphan',
        body: 'Deleted task',
        scheduledAt: DateTime.now().add(const Duration(hours: 2)),
        payload: 'non-existent-task-id',
      );

      await engine.reconcileAllTasks([], const NotificationSettings());
      expect(gateway.scheduledMap.containsKey(999999), isFalse);
      expect(gateway.timezoneRefreshCount, equals(1));
    });
  });

  group('Dashboard UI, Notification Tap Navigation & Settings Tests', () {
    testWidgets('Dashboard shows reactive stats, quick actions, and notification tap opens TaskDetailScreen', (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final gateway = FakeLocalNotificationGateway();

      final now = DateTime.now();
      final task = Task(
        id: 'tap-task-1',
        title: 'CS101 Midterm Grading',
        priority: TaskPriority.high,
        categoryId: 'cat_academic',
        deadline: DateTime(now.year, now.month, now.day, 23, 30),
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
      );
      await TaskRepositoryImpl(db).createTask(task);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            localNotificationGatewayProvider.overrideWithValue(gateway),
          ],
          child: const SmartProfessorApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Dashboard sections
      expect(find.text('Total Tasks'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Overdue'), findsOneWidget);
      expect(find.text('Priority Overview'), findsOneWidget);
      expect(find.text("Today's Tasks"), findsOneWidget);
      expect(find.text('Upcoming Deadlines (7 Days)'), findsOneWidget);
      expect(find.text('CS101 Midterm Grading'), findsOneWidget);

      // Simulate tapping notification for tap-task-1
      gateway.simulateTap('tap-task-1');
      await tester.pumpAndSettle();

      expect(find.text('Task Details'), findsOneWidget);
      expect(find.text('CS101 Midterm Grading'), findsOneWidget);

      // Pop back and simulate tapping deleted task notification
      await tester.pageBack();
      await tester.pumpAndSettle();
      gateway.simulateTap('deleted-task-999');
      await tester.pumpAndSettle();
      expect(
        find.text('This task was deleted or is no longer available.'),
        findsOneWidget,
      );

      // Navigate to Settings and verify notification settings controls
      await tester.tap(find.widgetWithText(NavigationDestination, 'Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Deadline Notifications'), findsOneWidget);
      expect(find.text('Enable Reminders'), findsOneWidget);

      await db.close();
    });
  });
}
