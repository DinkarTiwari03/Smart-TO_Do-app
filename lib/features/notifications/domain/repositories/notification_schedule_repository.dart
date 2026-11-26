import '../models/scheduled_notification_record.dart';

abstract class NotificationScheduleRepository {
  Future<List<ScheduledNotificationRecord>> getRecordsForTask(String taskId);
  Future<List<ScheduledNotificationRecord>> getAllScheduledRecords();
  Future<ScheduledNotificationRecord?> getRecordById(int notificationId);
  Future<void> upsertRecord(ScheduledNotificationRecord record);
  Future<void> updateStatus(int notificationId, NotificationScheduleStatus status);
  Future<void> deleteRecordsForTask(String taskId);
  Future<void> deleteRecord(int notificationId);
}
