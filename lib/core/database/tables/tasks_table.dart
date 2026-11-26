import 'package:drift/drift.dart';
import 'categories_table.dart';

@DataClassName('TaskEntry')
@TableIndex(name: 'idx_tasks_deadline', columns: {#deadline})
@TableIndex(name: 'idx_tasks_status', columns: {#status})
@TableIndex(name: 'idx_tasks_category', columns: {#categoryId})
@TableIndex(name: 'idx_tasks_priority', columns: {#priority})
class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  TextColumn get priority => text()(); // 'high', 'medium', 'low'
  TextColumn get categoryId => text().references(
        CategoriesTable,
        #id,
        onDelete: KeyAction.restrict,
        onUpdate: KeyAction.cascade,
      )();
  DateTimeColumn get deadline => dateTime().nullable()();
  DateTimeColumn get reminderAt => dateTime().nullable()();
  TextColumn get status => text()(); // 'pending', 'in_progress', 'completed'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
