import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_professor_assistant/app.dart';
import 'package:smart_professor_assistant/core/database/app_database.dart';
import 'package:smart_professor_assistant/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:smart_professor_assistant/features/tasks/domain/models/task.dart';
import 'package:smart_professor_assistant/features/tasks/domain/models/task_category.dart';

void main() {
  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  group('Phase 2 Task Repository & SQLite Tests', () {
    test('Categories are seeded by default in AppDatabase', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final repo = TaskRepositoryImpl(db);

      final categories = await repo.getCategories();
      expect(categories.length, greaterThanOrEqualTo(7));

      final names = categories.map((c) => c.name).toList();
      expect(names, contains('Academic'));
      expect(names, contains('Research'));
      expect(names, contains('Student Activities'));
      expect(names, contains('Department Administration'));

      await db.close();
    });

    test('Task CRUD operations and completion workflows', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final repo = TaskRepositoryImpl(db);

      // Create Task
      final now = DateTime.now();
      final task = Task(
        id: 'task_1',
        title: 'Review Ph.D. Dissertation',
        description: 'Chapter 3 methodology review',
        priority: TaskPriority.high,
        categoryId: 'cat_academic',
        deadline: now.add(const Duration(days: 2)),
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
      );

      await repo.createTask(task);

      // Read Task
      final retrieved = await repo.getTaskById('task_1');
      expect(retrieved, isNotNull);
      expect(retrieved!.title, equals('Review Ph.D. Dissertation'));
      expect(retrieved.priority, equals(TaskPriority.high));
      expect(retrieved.isCompleted, isFalse);

      // Mark Complete
      await repo.markCompleted('task_1');
      final completed = await repo.getTaskById('task_1');
      expect(completed!.status, equals(TaskStatus.completed));
      expect(completed.isCompleted, isTrue);

      // Reopen Task
      await repo.reopenTask('task_1');
      final reopened = await repo.getTaskById('task_1');
      expect(reopened!.status, equals(TaskStatus.pending));

      // Update Priority & Category
      await repo.updatePriority('task_1', TaskPriority.low);
      await repo.updateCategory('task_1', 'cat_research');
      final updated = await repo.getTaskById('task_1');
      expect(updated!.priority, equals(TaskPriority.low));
      expect(updated.categoryId, equals('cat_research'));

      // Delete Task
      await repo.deleteTask('task_1');
      final deleted = await repo.getTaskById('task_1');
      expect(deleted, isNull);

      await db.close();
    });

    test('Custom category creation, editing, task reassignment, and safe deletion', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final repo = TaskRepositoryImpl(db);

      // Create Custom Category
      final customCat = TaskCategory(
        id: 'cat_curriculum_2026',
        name: 'Curriculum 2026 Review',
        color: '#805AD5',
        isDefault: false,
        createdAt: DateTime.now(),
      );
      await repo.createCategory(customCat);

      var categories = await repo.getCategories();
      expect(categories.any((c) => c.id == 'cat_curriculum_2026'), isTrue);

      // Assign a task to this custom category
      final now = DateTime.now();
      final task = Task(
        id: 'task_committee',
        title: 'Committee Meeting Notes',
        priority: TaskPriority.medium,
        categoryId: 'cat_curriculum_2026',
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
      );
      await repo.createTask(task);

      expect(await repo.countTasksInCategory('cat_curriculum_2026'), equals(1));

      // Attempting to delete category without reassignment should fail
      expect(
        () async => await repo.deleteCategory('cat_curriculum_2026'),
        throwsA(isA<Exception>()),
      );

      // Reassign to Academic and Delete
      await repo.deleteCategory('cat_curriculum_2026', reassignToCategoryId: 'cat_academic');

      final taskAfter = await repo.getTaskById('task_committee');
      expect(taskAfter!.categoryId, equals('cat_academic'));

      final categoriesAfter = await repo.getCategories();
      expect(categoriesAfter.any((c) => c.id == 'cat_curriculum_2026'), isFalse);

      await db.close();
    });

    test('Prevent deletion of default system categories', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final repo = TaskRepositoryImpl(db);

      expect(
        () async => await repo.deleteCategory('cat_academic'),
        throwsA(isA<Exception>()),
      );

      await db.close();
    });
  });

  group('UI Integration & Navigation Tests', () {
    testWidgets('Tasks screen displays search, filter chips, and floating action button', (tester) async {
      final inMemoryDb = AppDatabase(NativeDatabase.memory());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
          ],
          child: const SmartProfessorApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to Tasks tab
      await tester.tap(find.widgetWithText(NavigationDestination, 'Tasks'));
      await tester.pumpAndSettle();

      // Verify Tasks screen elements
      expect(find.text('Tasks & Deadlines'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget); // Search bar
      expect(find.text('All Tasks'), findsOneWidget);
      expect(find.text("Today's Tasks"), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('High Priority'), findsOneWidget);
      expect(find.text('Overdue'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Add Task'), findsOneWidget);

      await inMemoryDb.close();
    });
  });
}
