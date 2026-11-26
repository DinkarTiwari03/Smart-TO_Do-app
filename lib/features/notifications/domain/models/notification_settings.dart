class NotificationSettings {
  final bool remindersEnabled;
  final bool deadlineNotificationsEnabled;
  final bool upcomingRemindersEnabled;
  final bool overdueNotificationsEnabled;
  final bool notify24HoursBefore;
  final bool notify3HoursBefore;
  final bool customIntervalEnabled;
  final int defaultReminderLeadMinutes;
  final bool highPriorityExtraReminderEnabled;
  final int highPriorityExtraMinutes;
  final bool cancelOnComplete;

  const NotificationSettings({
    this.remindersEnabled = true,
    this.deadlineNotificationsEnabled = true,
    this.upcomingRemindersEnabled = true,
    this.overdueNotificationsEnabled = true,
    this.notify24HoursBefore = true,
    this.notify3HoursBefore = true,
    this.customIntervalEnabled = false,
    this.defaultReminderLeadMinutes = 60,
    this.highPriorityExtraReminderEnabled = true,
    this.highPriorityExtraMinutes = 360,
    this.cancelOnComplete = true,
  });

  NotificationSettings copyWith({
    bool? remindersEnabled,
    bool? deadlineNotificationsEnabled,
    bool? upcomingRemindersEnabled,
    bool? overdueNotificationsEnabled,
    bool? notify24HoursBefore,
    bool? notify3HoursBefore,
    bool? customIntervalEnabled,
    int? defaultReminderLeadMinutes,
    bool? highPriorityExtraReminderEnabled,
    int? highPriorityExtraMinutes,
    bool? cancelOnComplete,
  }) {
    return NotificationSettings(
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      deadlineNotificationsEnabled:
          deadlineNotificationsEnabled ?? this.deadlineNotificationsEnabled,
      upcomingRemindersEnabled:
          upcomingRemindersEnabled ?? this.upcomingRemindersEnabled,
      overdueNotificationsEnabled:
          overdueNotificationsEnabled ?? this.overdueNotificationsEnabled,
      notify24HoursBefore: notify24HoursBefore ?? this.notify24HoursBefore,
      notify3HoursBefore: notify3HoursBefore ?? this.notify3HoursBefore,
      customIntervalEnabled:
          customIntervalEnabled ?? this.customIntervalEnabled,
      defaultReminderLeadMinutes:
          defaultReminderLeadMinutes ?? this.defaultReminderLeadMinutes,
      highPriorityExtraReminderEnabled: highPriorityExtraReminderEnabled ??
          this.highPriorityExtraReminderEnabled,
      highPriorityExtraMinutes:
          highPriorityExtraMinutes ?? this.highPriorityExtraMinutes,
      cancelOnComplete: cancelOnComplete ?? this.cancelOnComplete,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remindersEnabled': remindersEnabled,
      'deadlineNotificationsEnabled': deadlineNotificationsEnabled,
      'upcomingRemindersEnabled': upcomingRemindersEnabled,
      'overdueNotificationsEnabled': overdueNotificationsEnabled,
      'notify24HoursBefore': notify24HoursBefore,
      'notify3HoursBefore': notify3HoursBefore,
      'customIntervalEnabled': customIntervalEnabled,
      'defaultReminderLeadMinutes': defaultReminderLeadMinutes,
      'highPriorityExtraReminderEnabled': highPriorityExtraReminderEnabled,
      'highPriorityExtraMinutes': highPriorityExtraMinutes,
      'cancelOnComplete': cancelOnComplete,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      remindersEnabled: json['remindersEnabled'] as bool? ?? true,
      deadlineNotificationsEnabled:
          json['deadlineNotificationsEnabled'] as bool? ?? true,
      upcomingRemindersEnabled:
          json['upcomingRemindersEnabled'] as bool? ?? true,
      overdueNotificationsEnabled:
          json['overdueNotificationsEnabled'] as bool? ?? true,
      notify24HoursBefore: json['notify24HoursBefore'] as bool? ?? true,
      notify3HoursBefore: json['notify3HoursBefore'] as bool? ?? true,
      customIntervalEnabled: json['customIntervalEnabled'] as bool? ?? false,
      defaultReminderLeadMinutes:
          json['defaultReminderLeadMinutes'] as int? ?? 60,
      highPriorityExtraReminderEnabled:
          json['highPriorityExtraReminderEnabled'] as bool? ?? true,
      highPriorityExtraMinutes:
          json['highPriorityExtraMinutes'] as int? ?? 360,
      cancelOnComplete: json['cancelOnComplete'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationSettings &&
        other.remindersEnabled == remindersEnabled &&
        other.deadlineNotificationsEnabled == deadlineNotificationsEnabled &&
        other.upcomingRemindersEnabled == upcomingRemindersEnabled &&
        other.overdueNotificationsEnabled == overdueNotificationsEnabled &&
        other.notify24HoursBefore == notify24HoursBefore &&
        other.notify3HoursBefore == notify3HoursBefore &&
        other.customIntervalEnabled == customIntervalEnabled &&
        other.defaultReminderLeadMinutes == defaultReminderLeadMinutes &&
        other.highPriorityExtraReminderEnabled ==
            highPriorityExtraReminderEnabled &&
        other.highPriorityExtraMinutes == highPriorityExtraMinutes &&
        other.cancelOnComplete == cancelOnComplete;
  }

  @override
  int get hashCode => Object.hash(
        remindersEnabled,
        deadlineNotificationsEnabled,
        upcomingRemindersEnabled,
        overdueNotificationsEnabled,
        notify24HoursBefore,
        notify3HoursBefore,
        customIntervalEnabled,
        defaultReminderLeadMinutes,
        highPriorityExtraReminderEnabled,
        highPriorityExtraMinutes,
        cancelOnComplete,
      );
}
