import 'package:drift/drift.dart';

@DataClassName('CategoryEntry')
class CategoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get color => text().withLength(min: 4, max: 10)(); // Hex code e.g. #1E3A5F
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
