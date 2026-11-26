enum ReminderType {
  custom('custom'),
  before24h('before_24h'),
  before3h('before_3h'),
  customInterval('custom_interval'),
  highPriorityExtra('high_priority_extra'),
  atDeadline('at_deadline'),
  overdue('overdue');

  final String dbValue;
  const ReminderType(this.dbValue);

  static ReminderType fromDbValue(String value) {
    return ReminderType.values.firstWhere(
      (e) => e.dbValue == value,
      orElse: () => ReminderType.custom,
    );
  }
}

enum NotificationScheduleStatus {
  scheduled('scheduled'),
  cancelled('cancelled'),
  delivered('delivered'),
  failedPermission('failed_permission');

  final String dbValue;
  const NotificationScheduleStatus(this.dbValue);

  static NotificationScheduleStatus fromDbValue(String value) {
    return NotificationScheduleStatus.values.firstWhere(
      (e) => e.dbValue == value,
      orElse: () => NotificationScheduleStatus.scheduled,
    );
  }
}

class ScheduledNotificationRecord {
  final int notificationId;
  final String taskId;
  final ReminderType reminderType;
  final DateTime scheduledAt;
  final DateTime? deadlineSnapshot;
  final String title;
  final String body;
  final String payload;
  final NotificationScheduleStatus status;
  final DateTime createdAt;

  const ScheduledNotificationRecord({
    required this.notificationId,
    required this.taskId,
    required this.reminderType,
    required this.scheduledAt,
    this.deadlineSnapshot,
    required this.title,
    required this.body,
    required this.payload,
    required this.status,
    required this.createdAt,
  });

  /// Generates a deterministic 31-bit positive integer ID from [taskId] and [type].
  /// Uses FNV-1a 32-bit hash masked to [0, 0x7FFFFFFF] so it is always a valid
  /// Android notification ID and stable across app restarts.
  static int generateNotificationId(String taskId, ReminderType type) {
    final input = '$taskId::${type.dbValue}';
    var hash = 0x811c9dc5;
    for (var i = 0; i < input.length; i++) {
      hash ^= input.codeUnitAt(i);
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash & 0x7FFFFFFF;
  }
}
