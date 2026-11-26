import 'package:drift/drift.dart';
import 'tasks_table.dart';

@DataClassName('ScheduledNotificationEntry')
@TableIndex(name: 'idx_notifications_task_id', columns: {#taskId})
@TableIndex(name: 'idx_notifications_status', columns: {#status})
class ScheduledNotificationsTable extends Table {
  IntColumn get notificationId => integer()();
  TextColumn get taskId => text().references(
        TasksTable,
        #id,
        onDelete: KeyAction.cascade,
        onUpdate: KeyAction.cascade,
      )();
  TextColumn get reminderType => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  DateTimeColumn get deadlineSnapshot => dateTime().nullable()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get payload => text()();
  TextColumn get status => text()(); // 'scheduled', 'cancelled', 'delivered', 'failed_permission'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {notificationId};
}
