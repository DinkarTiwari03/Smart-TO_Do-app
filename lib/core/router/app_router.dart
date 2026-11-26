import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/main_shell_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/ai_assistant/presentation/ai_assistant_screen.dart';
import '../../features/writing_assistant/presentation/writing_assistant_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

class AppRouteNames {
  AppRouteNames._();

  static const String home = '/';
  static const String tasks = '/tasks';
  static const String aiAssistant = '/ai-assistant';
  static const String writing = '/writing';
  static const String settings = '/settings';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRouteNames.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteNames.home,
                name: 'home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashboardScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteNames.tasks,
                name: 'tasks',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TasksScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteNames.aiAssistant,
                name: 'aiAssistant',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AiAssistantScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteNames.writing,
                name: 'writing',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: WritingAssistantScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouteNames.settings,
                name: 'settings',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
