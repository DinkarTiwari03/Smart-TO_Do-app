import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connection/connection.dart';
import 'tables/app_metadata_table.dart';
import 'tables/categories_table.dart';
import 'tables/tasks_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [AppMetadataTable, CategoriesTable, TasksTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? openConnection());

  @override
  int get schemaVersion => 2;

  static const List<Map<String, dynamic>> defaultCategories = [
    {'id': 'cat_academic', 'name': 'Academic', 'color': '#1E3A5F', 'isDefault': true},
    {'id': 'cat_dept_admin', 'name': 'Department Administration', 'color': '#4A5568', 'isDefault': true},
    {'id': 'cat_student_activities', 'name': 'Student Activities', 'color': '#2B6CB0', 'isDefault': true},
    {'id': 'cat_research', 'name': 'Research', 'color': '#C08A3E', 'isDefault': true},
    {'id': 'cat_meetings', 'name': 'Meetings', 'color': '#805AD5', 'isDefault': true},
    {'id': 'cat_personal', 'name': 'Personal', 'color': '#319795', 'isDefault': true},
    {'id': 'cat_other', 'name': 'Other', 'color': '#718096', 'isDefault': true},
  ];

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Seed initial metadata
        await into(appMetadataTable).insert(
          AppMetadataTableCompanion.insert(
            key: 'schema_initialized_at',
            value: DateTime.now().toIso8601String(),
          ),
          mode: InsertMode.insertOrReplace,
        );
        // Seed default categories
        await _seedDefaultCategories();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(categoriesTable);
          await m.createTable(tasksTable);
          await _seedDefaultCategories();
        }
      },
      beforeOpen: (details) async {
        // Enforce foreign key constraints
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _seedDefaultCategories() async {
    for (final cat in defaultCategories) {
      await into(categoriesTable).insert(
        CategoriesTableCompanion.insert(
          id: cat['id'] as String,
          name: cat['name'] as String,
          color: cat['color'] as String,
          isDefault: Value(cat['isDefault'] as bool),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  // Repository-level helper methods for metadata/diagnostics
  Future<String?> getMetadata(String key) async {
    final query = select(appMetadataTable)..where((tbl) => tbl.key.equals(key));
    final entry = await query.getSingleOrNull();
    return entry?.value;
  }

  Future<void> setMetadata(String key, String value) async {
    await into(appMetadataTable).insert(
      AppMetadataTableCompanion.insert(
        key: key,
        value: value,
        updatedAt: Value(DateTime.now()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() {
    db.close();
  });
  return db;
});
