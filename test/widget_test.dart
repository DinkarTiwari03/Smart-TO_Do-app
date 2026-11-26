import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_professor_assistant/app.dart';
import 'package:smart_professor_assistant/core/database/app_database.dart';

void main() {
  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  testWidgets('App initializes, renders Dashboard, and supports bottom navigation', (tester) async {
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

    // Verify Dashboard is rendered
    expect(find.text('Academic Dashboard'), findsOneWidget);
    expect(find.text('System Status'), findsOneWidget);

    // Verify bottom navigation bar destinations using NavigationDestination finder
    expect(find.widgetWithText(NavigationDestination, 'Home'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'Tasks'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'AI Assistant'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'Writing'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'Settings'), findsOneWidget);

    // Navigate to Tasks
    await tester.tap(find.widgetWithText(NavigationDestination, 'Tasks'));
    await tester.pumpAndSettle();
    expect(find.text('Academic Task Management'), findsOneWidget);

    // Navigate to AI Assistant
    await tester.tap(find.widgetWithText(NavigationDestination, 'AI Assistant'));
    await tester.pumpAndSettle();
    expect(find.text('Smart AI Assistant'), findsOneWidget);

    // Navigate to Writing
    await tester.tap(find.widgetWithText(NavigationDestination, 'Writing'));
    await tester.pumpAndSettle();
    expect(find.text('Academic Writing & Editing'), findsOneWidget);

    // Navigate to Settings
    await tester.tap(find.widgetWithText(NavigationDestination, 'Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Preferences & Diagnostics'), findsOneWidget);

    // Clean up
    await inMemoryDb.close();
  });

  test('Drift in-memory database initializes with default metadata and handles CRUD', () async {
    final db = AppDatabase(NativeDatabase.memory());

    // Write metadata
    await db.setMetadata('test_key', 'test_value');

    // Read metadata
    final val = await db.getMetadata('test_key');
    expect(val, equals('test_value'));

    // Check initialization key
    final initKey = await db.getMetadata('schema_initialized_at');
    expect(initKey, isNotNull);

    await db.close();
  });
}
