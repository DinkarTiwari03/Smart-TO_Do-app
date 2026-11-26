import '../../../tasks/domain/models/task.dart';
import '../../../tasks/domain/models/task_category.dart';
import '../../../tasks/domain/models/task_with_category.dart';

class DashboardSummary {
  final int totalCount;
  final int pendingCount;
  final int completedCount;
  final int overdueCount;
  final int highPriorityCount;
  final int mediumPriorityCount;
  final int lowPriorityCount;
  final List<TaskWithCategory> todaysTasks;
  final List<TaskWithCategory> upcomingSevenDaysTasks;

  const DashboardSummary({
    required this.totalCount,
    required this.pendingCount,
    required this.completedCount,
    required this.overdueCount,
    required this.highPriorityCount,
    required this.mediumPriorityCount,
    required this.lowPriorityCount,
    required this.todaysTasks,
    required this.upcomingSevenDaysTasks,
  });

  factory DashboardSummary.fromTasks({
    required List<Task> tasks,
    required Map<String, TaskCategory> categoriesById,
    DateTime? nowOverride,
  }) {
    final now = nowOverride ?? DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    final sevenDaysEnd = DateTime(
      now.year,
      now.month,
      now.day + 7,
      23,
      59,
      59,
      999,
    );

    int pending = 0;
    int completed = 0;
    int overdue = 0;
    int high = 0;
    int medium = 0;
    int low = 0;

    final todays = <TaskWithCategory>[];
    final upcoming = <TaskWithCategory>[];

    for (final task in tasks) {
      if (task.isCompleted) {
        completed++;
        continue;
      }

      pending++;

      switch (task.priority) {
        case TaskPriority.high:
          high++;
          break;
        case TaskPriority.medium:
          medium++;
          break;
        case TaskPriority.low:
          low++;
          break;
      }

      final deadline = task.deadline;
      if (deadline != null) {
        if (deadline.isBefore(todayStart)) {
          overdue++;
        } else if (!deadline.isAfter(todayEnd)) {
          todays.add(
            TaskWithCategory(
              task: task,
              category: categoriesById[task.categoryId],
            ),
          );
        } else if (!deadline.isAfter(sevenDaysEnd)) {
          upcoming.add(
            TaskWithCategory(
              task: task,
              category: categoriesById[task.categoryId],
            ),
          );
        }
      }
    }

    todays.sort((a, b) => a.task.deadline!.compareTo(b.task.deadline!));
    upcoming.sort((a, b) => a.task.deadline!.compareTo(b.task.deadline!));

    return DashboardSummary(
      totalCount: tasks.length,
      pendingCount: pending,
      completedCount: completed,
      overdueCount: overdue,
      highPriorityCount: high,
      mediumPriorityCount: medium,
      lowPriorityCount: low,
      todaysTasks: todays,
      upcomingSevenDaysTasks: upcoming,
    );
  }
}
