import 'package:drift/drift.dart';
import '../errors/app_exception.dart';

abstract class BaseLocalRepository<TTable extends Table, TData> {
  final GeneratedDatabase db;

  const BaseLocalRepository(this.db);

  T handleDatabaseError<T>(Object error, [StackTrace? stackTrace]) {
    throw DatabaseException(
      'Database operation failed: ${error.toString()}',
      details: stackTrace,
    );
  }
}
