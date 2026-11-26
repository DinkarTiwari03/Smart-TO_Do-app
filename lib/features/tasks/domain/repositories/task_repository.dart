import '../models/task.dart';
import '../models/task_category.dart';

abstract class TaskRepository {
  Stream<List<Task>> watchAllTasks();
  Stream<List<Task>> watchPendingTasks();
  Stream<List<Task>> watchCompletedTasks();
  Future<Task?> getTaskById(String id);
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> markCompleted(String id);
  Future<void> reopenTask(String id);
  Future<void> updatePriority(String id, TaskPriority priority);
  Future<void> updateDeadline(String id, DateTime? deadline);
  Future<void> updateCategory(String id, String categoryId);

  // Category operations
  Stream<List<TaskCategory>> watchCategories();
  Future<List<TaskCategory>> getCategories();
  Future<TaskCategory?> getCategoryById(String id);
  Future<void> createCategory(TaskCategory category);
  Future<void> updateCategoryDetails(TaskCategory category);
  Future<void> deleteCategory(String id, {String? reassignToCategoryId});
  Future<int> countTasksInCategory(String categoryId);
}
