import '../../domain/models/task.dart';
import '../../domain/models/task_category.dart';

class TaskWithCategory {
  final Task task;
  final TaskCategory? category;

  const TaskWithCategory({
    required this.task,
    this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskWithCategory &&
          runtimeType == other.runtimeType &&
          task.id == other.task.id;

  @override
  int get hashCode => task.id.hashCode;
}
