import 'package:drift/drift.dart';

@DataClassName('AppMetadataEntry')
class AppMetadataTable extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}
