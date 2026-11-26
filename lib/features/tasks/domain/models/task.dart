enum TaskPriority {
  high('High'),
  medium('Medium'),
  low('Low');

  final String label;
  const TaskPriority(this.label);

  static TaskPriority fromString(String value) {
    switch (value.toLowerCase()) {
      case 'high':
        return TaskPriority.high;
      case 'medium':
        return TaskPriority.medium;
      case 'low':
      default:
        return TaskPriority.low;
    }
  }
}

enum TaskStatus {
  pending('Pending'),
  inProgress('In Progress'),
  completed('Completed');

  final String label;
  const TaskStatus(this.label);

  static TaskStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'completed':
        return TaskStatus.completed;
      case 'in_progress':
      case 'inprogress':
        return TaskStatus.inProgress;
      case 'pending':
      default:
        return TaskStatus.pending;
    }
  }

  String toDbString() {
    switch (this) {
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.inProgress:
        return 'in_progress';
      case TaskStatus.pending:
        return 'pending';
    }
  }
}

class Task {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final String categoryId;
  final DateTime? deadline;
  final DateTime? reminderAt;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.categoryId,
    this.deadline,
    this.reminderAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isCompleted => status == TaskStatus.completed;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    String? categoryId,
    DateTime? deadline,
    DateTime? reminderAt,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
      deadline: deadline ?? this.deadline,
      reminderAt: reminderAt ?? this.reminderAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
