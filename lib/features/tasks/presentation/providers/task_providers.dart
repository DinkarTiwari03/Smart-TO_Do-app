import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/models/task.dart';
import '../../domain/models/task_category.dart';
import '../../domain/models/task_with_category.dart';
import '../../domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final engine = ref.watch(deadlineNotificationEngineProvider);
  return TaskRepositoryImpl(
    db,
    notificationEngine: engine,
    getNotificationSettings: () => ref.read(notificationSettingsProvider),
  );
});

// Categories stream
final categoriesStreamProvider = StreamProvider<List<TaskCategory>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchCategories();
});

// Map of categories by ID for O(1) lookup
final categoriesMapProvider = Provider<Map<String, TaskCategory>>((ref) {
  final categoriesAsync = ref.watch(categoriesStreamProvider);
  return categoriesAsync.maybeWhen(
    data: (categories) => {for (var c in categories) c.id: c},
    orElse: () => {},
  );
});

// All tasks stream
final allTasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchAllTasks();
});

// Filter definition
enum TaskFilterType {
  all('All Tasks'),
  today("Today's Tasks"),
  upcoming('Upcoming'),
  highPriority('High Priority'),
  overdue('Overdue'),
  completed('Completed');

  final String label;
  const TaskFilterType(this.label);
}

enum TaskSortType {
  deadline('Deadline'),
  priority('Priority'),
  createdDate('Created Date');

  final String label;
  const TaskSortType(this.label);
}

class TaskFilterState {
  final TaskFilterType filterType;
  final TaskSortType sortType;
  final String searchQuery;
  final String? selectedCategoryId;

  const TaskFilterState({
    this.filterType = TaskFilterType.all,
    this.sortType = TaskSortType.deadline,
    this.searchQuery = '',
    this.selectedCategoryId,
  });

  TaskFilterState copyWith({
    TaskFilterType? filterType,
    TaskSortType? sortType,
    String? searchQuery,
    String? selectedCategoryId,
    bool clearCategory = false,
  }) {
    return TaskFilterState(
      filterType: filterType ?? this.filterType,
      sortType: sortType ?? this.sortType,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
    );
  }
}

class TaskFilterNotifier extends StateNotifier<TaskFilterState> {
  TaskFilterNotifier() : super(const TaskFilterState());

  void setFilterType(TaskFilterType type) => state = state.copyWith(filterType: type);
  void setSortType(TaskSortType type) => state = state.copyWith(sortType: type);
  void setSearchQuery(String query) => state = state.copyWith(searchQuery: query);
  void setSelectedCategory(String? categoryId) {
    if (categoryId == null) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategoryId: categoryId);
    }
  }
  void reset() => state = const TaskFilterState();
}

final taskFilterProvider = StateNotifierProvider<TaskFilterNotifier, TaskFilterState>((ref) {
  return TaskFilterNotifier();
});

// Filtered and sorted tasks stream
final filteredTasksProvider = Provider<AsyncValue<List<TaskWithCategory>>>((ref) {
  final tasksAsync = ref.watch(allTasksStreamProvider);
  final categoriesMap = ref.watch(categoriesMapProvider);
  final filter = ref.watch(taskFilterProvider);

  return tasksAsync.whenData((tasks) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    final filtered = tasks.where((task) {
      // 1. Status / FilterType filter
      switch (filter.filterType) {
        case TaskFilterType.all:
          break;
        case TaskFilterType.today:
          if (task.isCompleted) return false;
          if (task.deadline == null) return false;
          final d = task.deadline!;
          if (d.isBefore(todayStart) || d.isAfter(todayEnd)) return false;
          break;
        case TaskFilterType.upcoming:
          if (task.isCompleted) return false;
          if (task.deadline == null) return false;
          if (task.deadline!.isBefore(todayEnd)) return false;
          break;
        case TaskFilterType.highPriority:
          if (task.isCompleted) return false;
          if (task.priority != TaskPriority.high) return false;
          break;
        case TaskFilterType.overdue:
          if (task.isCompleted) return false;
          if (task.deadline == null) return false;
          if (!task.deadline!.isBefore(todayStart)) return false;
          break;
        case TaskFilterType.completed:
          if (!task.isCompleted) return false;
          break;
      }

      // 2. Category filter
      if (filter.selectedCategoryId != null && task.categoryId != filter.selectedCategoryId) {
        return false;
      }

      // 3. Search query
      if (filter.searchQuery.trim().isNotEmpty) {
        final query = filter.searchQuery.toLowerCase().trim();
        final titleMatches = task.title.toLowerCase().contains(query);
        final descMatches = task.description?.toLowerCase().contains(query) ?? false;
        if (!titleMatches && !descMatches) return false;
      }

      return true;
    }).toList();

    // 4. Sorting
    filtered.sort((a, b) {
      switch (filter.sortType) {
        case TaskSortType.deadline:
          if (a.deadline == null && b.deadline == null) return 0;
          if (a.deadline == null) return 1;
          if (b.deadline == null) return -1;
          return a.deadline!.compareTo(b.deadline!);
        case TaskSortType.priority:
          final priorityOrder = {TaskPriority.high: 0, TaskPriority.medium: 1, TaskPriority.low: 2};
          final comp = priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
          if (comp != 0) return comp;
          return b.createdAt.compareTo(a.createdAt);
        case TaskSortType.createdDate:
          return b.createdAt.compareTo(a.createdAt);
      }
    });

    return filtered.map((task) => TaskWithCategory(
          task: task,
          category: categoriesMap[task.categoryId],
        )).toList();
  });
});
