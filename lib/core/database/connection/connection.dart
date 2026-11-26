import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../constants/app_constants.dart';

LazyDatabase openConnection({bool inMemory = false}) {
  return LazyDatabase(() async {
    if (inMemory) {
      return NativeDatabase.memory();
    }
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
