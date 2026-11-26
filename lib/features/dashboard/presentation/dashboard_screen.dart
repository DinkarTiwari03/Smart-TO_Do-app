import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/academic_card.dart';
import '../../tasks/domain/models/task.dart';
import '../../tasks/presentation/providers/task_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tasksAsync = ref.watch(allTasksStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Professor Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Academic Dashboard',
              style: AppTypography.displayMedium.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.space4),
            Text(
              'Welcome back, Professor. Overview of research, teaching, and schedule.',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),

            // Live Task Stats
            tasksAsync.when(
              data: (tasks) {
                final pendingTasks = tasks.where((t) => !t.isCompleted).length;
                final highPriority = tasks.where((t) => !t.isCompleted && t.priority == TaskPriority.high).length;
                final completedCount = tasks.where((t) => t.isCompleted).length;

                return Row(
                  children: [
                    Expanded(
                      child: AcademicCard(
                        onTap: () => context.go(AppRouteNames.tasks),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.assignment_outlined, color: theme.colorScheme.primary),
                                Text(
                                  '$pendingTasks',
                                  style: AppTypography.displayLarge.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontSize: 26,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.space8),
                            Text('Active Tasks', style: AppTypography.titleSmall),
                            const SizedBox(height: AppDimensions.space2),
                            Text(
                              highPriority > 0 ? '$highPriority high priority' : 'All on track',
                              style: AppTypography.bodySmall.copyWith(
                                color: highPriority > 0 ? Colors.red.shade700 : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                fontWeight: highPriority > 0 ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: AcademicCard(
                        onTap: () {
                          ref.read(taskFilterProvider.notifier).setFilterType(TaskFilterType.completed);
                          context.go(AppRouteNames.tasks);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.green),
                                Text(
                                  '$completedCount',
                                  style: AppTypography.displayLarge.copyWith(
                                    color: Colors.green.shade700,
                                    fontSize: 26,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.space8),
                            Text('Completed', style: AppTypography.titleSmall),
                            const SizedBox(height: AppDimensions.space2),
                            Text(
                              'Archived tasks',
                              style: AppTypography.bodySmall.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            const SizedBox(height: AppDimensions.space16),

            // AI Assistant Card
            AcademicCard(
              onTap: () => context.go(AppRouteNames.aiAssistant),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome_outlined, size: 32, color: theme.colorScheme.secondary),
                  const SizedBox(width: AppDimensions.space16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI Academic Assistant', style: AppTypography.titleMedium),
                        const SizedBox(height: AppDimensions.space4),
                        Text(
                          'Phase 3 module: Syllabus design, lecture prompts, student feedback.',
                          style: AppTypography.bodySmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.space16),

            // System Status Card
            AcademicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_outlined, color: theme.colorScheme.primary),
                      const SizedBox(width: AppDimensions.space8),
                      Text('System Status', style: AppTypography.titleMedium),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  const Divider(),
                  const SizedBox(height: AppDimensions.space12),
                  Text(
                    '• Phase 2 Task Management System Active\n'
                    '• SQLite Reactive Queries (Drift) operational\n'
                    '• Custom & Default Academic Categories active\n'
                    '• Full offline CRUD, search, priority & deadline filters\n'
                    '• Material 3 Academic theme verified',
                    style: AppTypography.bodyMedium.copyWith(height: 1.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
