import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/models/scheduled_notification_record.dart';
import '../../domain/repositories/notification_schedule_repository.dart';

class NotificationScheduleRepositoryImpl
    implements NotificationScheduleRepository {
  final AppDatabase db;

  NotificationScheduleRepositoryImpl(this.db);

  ScheduledNotificationRecord _mapEntry(ScheduledNotificationEntry entry) {
    return ScheduledNotificationRecord(
      notificationId: entry.notificationId,
      taskId: entry.taskId,
      reminderType: ReminderType.fromDbValue(entry.reminderType),
      scheduledAt: entry.scheduledAt,
      deadlineSnapshot: entry.deadlineSnapshot,
      title: entry.title,
      body: entry.body,
      payload: entry.payload,
      status: NotificationScheduleStatus.fromDbValue(entry.status),
      createdAt: entry.createdAt,
    );
  }

  @override
  Future<List<ScheduledNotificationRecord>> getRecordsForTask(
      String taskId) async {
    final entries = await (db.select(db.scheduledNotificationsTable)
          ..where((t) => t.taskId.equals(taskId)))
        .get();
    return entries.map(_mapEntry).toList();
  }

  @override
  Future<List<ScheduledNotificationRecord>> getAllScheduledRecords() async {
    final entries = await (db.select(db.scheduledNotificationsTable)
          ..where((t) => t.status.equals(
              NotificationScheduleStatus.scheduled.dbValue)))
        .get();
    return entries.map(_mapEntry).toList();
  }

  @override
  Future<ScheduledNotificationRecord?> getRecordById(int notificationId) async {
    final entry = await (db.select(db.scheduledNotificationsTable)
          ..where((t) => t.notificationId.equals(notificationId)))
        .getSingleOrNull();
    return entry != null ? _mapEntry(entry) : null;
  }

  @override
  Future<void> upsertRecord(ScheduledNotificationRecord record) async {
    await db.into(db.scheduledNotificationsTable).insert(
          ScheduledNotificationsTableCompanion.insert(
            notificationId: Value(record.notificationId),
            taskId: record.taskId,
            reminderType: record.reminderType.dbValue,
            scheduledAt: record.scheduledAt,
            deadlineSnapshot: Value(record.deadlineSnapshot),
            title: record.title,
            body: record.body,
            payload: record.payload,
            status: record.status.dbValue,
            createdAt: Value(record.createdAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> updateStatus(
      int notificationId, NotificationScheduleStatus status) async {
    await (db.update(db.scheduledNotificationsTable)
          ..where((t) => t.notificationId.equals(notificationId)))
        .write(
      ScheduledNotificationsTableCompanion(
        status: Value(status.dbValue),
      ),
    );
  }

  @override
  Future<void> deleteRecordsForTask(String taskId) async {
    await (db.delete(db.scheduledNotificationsTable)
          ..where((t) => t.taskId.equals(taskId)))
        .go();
  }

  @override
  Future<void> deleteRecord(int notificationId) async {
    await (db.delete(db.scheduledNotificationsTable)
          ..where((t) => t.notificationId.equals(notificationId)))
        .go();
  }
}
