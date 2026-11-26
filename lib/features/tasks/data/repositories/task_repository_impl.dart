import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../notifications/domain/models/notification_settings.dart';
import '../../../notifications/domain/services/deadline_notification_engine.dart';
import '../../domain/models/task.dart';
import '../../domain/models/task_category.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase db;
  final DeadlineNotificationEngine? notificationEngine;
  final NotificationSettings Function()? getNotificationSettings;

  TaskRepositoryImpl(
    this.db, {
    this.notificationEngine,
    this.getNotificationSettings,
  });

  Future<void> _syncNotificationsForTask(Task task) async {
    if (notificationEngine == null) return;
    final settings =
        getNotificationSettings?.call() ?? const NotificationSettings();
    await notificationEngine!.scheduleForTask(task, settings);
  }

  Future<void> _cancelNotificationsForTask(String taskId) async {
    if (notificationEngine == null) return;
    await notificationEngine!.cancelForTask(taskId);
  }

  Task _mapTaskEntryToModel(TaskEntry entry) {
    return Task(
      id: entry.id,
      title: entry.title,
      description: entry.description,
      priority: TaskPriority.fromString(entry.priority),
      categoryId: entry.categoryId,
      deadline: entry.deadline,
      reminderAt: entry.reminderAt,
      status: TaskStatus.fromString(entry.status),
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  TaskCategory _mapCategoryEntryToModel(CategoryEntry entry) {
    return TaskCategory(
      id: entry.id,
      name: entry.name,
      color: entry.color,
      isDefault: entry.isDefault,
      createdAt: entry.createdAt,
    );
  }

  @override
  Stream<List<Task>> watchAllTasks() {
    return (db.select(db.tasksTable)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch()
        .map((entries) => entries.map(_mapTaskEntryToModel).toList());
  }

  @override
  Stream<List<Task>> watchPendingTasks() {
    return (db.select(db.tasksTable)
          ..where((t) => t.status.isNotValue(TaskStatus.completed.toDbString()))
          ..orderBy([
            (t) => OrderingTerm(expression: t.deadline, mode: OrderingMode.asc),
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch()
        .map((entries) => entries.map(_mapTaskEntryToModel).toList());
  }

  @override
  Stream<List<Task>> watchCompletedTasks() {
    return (db.select(db.tasksTable)
          ..where((t) => t.status.equals(TaskStatus.completed.toDbString()))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
          ]))
        .watch()
        .map((entries) => entries.map(_mapTaskEntryToModel).toList());
  }

  @override
  Future<Task?> getTaskById(String id) async {
    final entry = await (db.select(db.tasksTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return entry != null ? _mapTaskEntryToModel(entry) : null;
  }

  @override
  Future<void> createTask(Task task) async {
    await db.into(db.tasksTable).insert(
          TasksTableCompanion.insert(
            id: task.id,
            title: task.title,
            description: Value(task.description),
            priority: task.priority.name,
            categoryId: task.categoryId,
            deadline: Value(task.deadline),
            reminderAt: Value(task.reminderAt),
            status: task.status.toDbString(),
            createdAt: Value(task.createdAt),
            updatedAt: Value(task.updatedAt),
          ),
        );
    await _syncNotificationsForTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await (db.update(db.tasksTable)..where((t) => t.id.equals(task.id))).write(
      TasksTableCompanion(
        title: Value(task.title),
        description: Value(task.description),
        priority: Value(task.priority.name),
        categoryId: Value(task.categoryId),
        deadline: Value(task.deadline),
        reminderAt: Value(task.reminderAt),
        status: Value(task.status.toDbString()),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _syncNotificationsForTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _cancelNotificationsForTask(id);
    await (db.delete(db.tasksTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> markCompleted(String id) async {
    await (db.update(db.tasksTable)..where((t) => t.id.equals(id))).write(
      TasksTableCompanion(
        status: Value(TaskStatus.completed.toDbString()),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final updated = await getTaskById(id);
    if (updated != null) {
      await _syncNotificationsForTask(updated);
    } else {
      await _cancelNotificationsForTask(id);
    }
  }

  @override
  Future<void> reopenTask(String id) async {
    await (db.update(db.tasksTable)..where((t) => t.id.equals(id))).write(
      TasksTableCompanion(
        status: Value(TaskStatus.pending.toDbString()),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final updated = await getTaskById(id);
    if (updated != null) {
      await _syncNotificationsForTask(updated);
    }
  }

  @override
  Future<void> updatePriority(String id, TaskPriority priority) async {
    await (db.update(db.tasksTable)..where((t) => t.id.equals(id))).write(
      TasksTableCompanion(
        priority: Value(priority.name),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final updated = await getTaskById(id);
    if (updated != null) {
      await _syncNotificationsForTask(updated);
    }
  }

  @override
  Future<void> updateDeadline(String id, DateTime? deadline) async {
    await (db.update(db.tasksTable)..where((t) => t.id.equals(id))).write(
      TasksTableCompanion(
        deadline: Value(deadline),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final updated = await getTaskById(id);
    if (updated != null) {
      await _syncNotificationsForTask(updated);
    }
  }

  @override
  Future<void> updateCategory(String id, String categoryId) async {
    await (db.update(db.tasksTable)..where((t) => t.id.equals(id))).write(
      TasksTableCompanion(
        categoryId: Value(categoryId),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Stream<List<TaskCategory>> watchCategories() {
    return (db.select(db.categoriesTable)
          ..orderBy([
            (c) => OrderingTerm(expression: c.name, mode: OrderingMode.asc),
          ]))
        .watch()
        .map((entries) => entries.map(_mapCategoryEntryToModel).toList());
  }

  @override
  Future<List<TaskCategory>> getCategories() async {
    final entries = await (db.select(db.categoriesTable)
          ..orderBy([
            (c) => OrderingTerm(expression: c.name, mode: OrderingMode.asc),
          ]))
        .get();
    return entries.map(_mapCategoryEntryToModel).toList();
  }

  @override
  Future<TaskCategory?> getCategoryById(String id) async {
    final entry = await (db.select(db.categoriesTable)
          ..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    return entry != null ? _mapCategoryEntryToModel(entry) : null;
  }

  @override
  Future<void> createCategory(TaskCategory category) async {
    await db.into(db.categoriesTable).insert(
          CategoriesTableCompanion.insert(
            id: category.id,
            name: category.name,
            color: category.color,
            isDefault: Value(category.isDefault),
            createdAt: Value(category.createdAt ?? DateTime.now()),
          ),
        );
  }

  @override
  Future<void> updateCategoryDetails(TaskCategory category) async {
    await (db.update(db.categoriesTable)
          ..where((c) => c.id.equals(category.id)))
        .write(
      CategoriesTableCompanion(
        name: Value(category.name),
        color: Value(category.color),
      ),
    );
  }

  @override
  Future<void> deleteCategory(String id, {String? reassignToCategoryId}) async {
    await db.transaction(() async {
      final category = await getCategoryById(id);
      if (category != null && category.isDefault) {
        throw Exception('Cannot delete a default system category.');
      }

      if (reassignToCategoryId != null) {
        await (db.update(db.tasksTable)
              ..where((t) => t.categoryId.equals(id)))
            .write(
          TasksTableCompanion(
            categoryId: Value(reassignToCategoryId),
            updatedAt: Value(DateTime.now()),
          ),
        );
      } else {
        final count = await countTasksInCategory(id);
        if (count > 0) {
          throw Exception(
              'Category has $count active task(s). Provide a reassignment category before deletion.');
        }
      }

      await (db.delete(db.categoriesTable)..where((c) => c.id.equals(id))).go();
    });
  }

  @override
  Future<int> countTasksInCategory(String categoryId) async {
    final countExp = db.tasksTable.id.count();
    final query = db.selectOnly(db.tasksTable)
      ..where(db.tasksTable.categoryId.equals(categoryId))
      ..addColumns([countExp]);
    final result = await query.map((row) => row.read(countExp)).getSingle();
    return result ?? 0;
  }
}
