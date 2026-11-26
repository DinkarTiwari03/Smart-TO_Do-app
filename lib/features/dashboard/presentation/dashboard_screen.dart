import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/academic_card.dart';
import '../../notifications/presentation/screens/notifications_overview_screen.dart';
import '../../tasks/domain/models/task.dart';
import '../../tasks/domain/models/task_category.dart';
import '../../tasks/domain/models/task_with_category.dart';
import '../../tasks/presentation/providers/task_providers.dart';
import '../../tasks/presentation/screens/task_detail_screen.dart';
import '../../tasks/presentation/widgets/task_form_sheet.dart';
import '../../tasks/presentation/widgets/task_ui_helpers.dart';
import '../domain/models/dashboard_summary.dart';
import 'providers/dashboard_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _greetingForHour(int hour) {
    if (hour < 12) return 'Good Morning, Professor';
    if (hour < 17) return 'Good Afternoon, Professor';
    return 'Good Evening, Professor';
  }

  void _openAddTaskSheet(BuildContext context, WidgetRef ref) {
    final categories = ref.read(categoriesStreamProvider).maybeWhen(
          data: (cats) => cats,
          orElse: () => <TaskCategory>[],
        );
    final repository = ref.read(taskRepositoryProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLarge)),
      ),
      builder: (ctx) => TaskFormSheet(
        categories: categories,
        onSave: (newTask) async {
          await repository.createTask(newTask);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Professor Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            tooltip: 'Reminders & Alerts',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsOverviewScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: summaryAsync.when(
        data: (summary) => _buildContent(context, ref, theme, now, summary),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space24),
            child: Text('Unable to load dashboard: $err'),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    DateTime now,
    DashboardSummary summary,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Welcome Section
          Text(
            _greetingForHour(now.hour),
            style: AppTypography.displayMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.space4),
          Text(
            DateFormat('EEEE, MMMM d, yyyy').format(now),
            style: AppTypography.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppDimensions.space20),

          // 2. Task Statistics (2x2 Grid)
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Total Tasks',
                  count: summary.totalCount,
                  icon: Icons.folder_copy_outlined,
                  accentColor: theme.colorScheme.primary,
                  onTap: () {
                    ref
                        .read(taskFilterProvider.notifier)
                        .setFilterType(TaskFilterType.all);
                    context.go(AppRouteNames.tasks);
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: _StatCard(
                  label: 'Pending',
                  count: summary.pendingCount,
                  icon: Icons.pending_actions_outlined,
                  accentColor: AppColors.info,
                  onTap: () {
                    ref
                        .read(taskFilterProvider.notifier)
                        .setFilterType(TaskFilterType.all);
                    context.go(AppRouteNames.tasks);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Completed',
                  count: summary.completedCount,
                  icon: Icons.check_circle_outline,
                  accentColor: AppColors.success,
                  onTap: () {
                    ref
                        .read(taskFilterProvider.notifier)
                        .setFilterType(TaskFilterType.completed);
                    context.go(AppRouteNames.tasks);
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: _StatCard(
                  label: 'Overdue',
                  count: summary.overdueCount,
                  icon: Icons.warning_amber_outlined,
                  accentColor: summary.overdueCount > 0
                      ? AppColors.error
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  onTap: () {
                    ref
                        .read(taskFilterProvider.notifier)
                        .setFilterType(TaskFilterType.overdue);
                    context.go(AppRouteNames.tasks);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space20),

          // 3. Quick Actions
          Text('Quick Actions', style: AppTypography.titleMedium),
          const SizedBox(height: AppDimensions.space12),
          Wrap(
            spacing: AppDimensions.space8,
            runSpacing: AppDimensions.space8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.add_task, size: 18),
                label: const Text('Add Task'),
                onPressed: () => _openAddTaskSheet(context, ref),
              ),
              ActionChip(
                avatar: const Icon(Icons.list_alt_outlined, size: 18),
                label: const Text('View All Tasks'),
                onPressed: () {
                  ref
                      .read(taskFilterProvider.notifier)
                      .setFilterType(TaskFilterType.all);
                  context.go(AppRouteNames.tasks);
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.auto_awesome_outlined, size: 18),
                label: const Text('AI Assistant'),
                onPressed: () => context.go(AppRouteNames.aiAssistant),
              ),
              ActionChip(
                avatar: const Icon(Icons.edit_note_outlined, size: 18),
                label: const Text('Writing Assistant'),
                onPressed: () => context.go(AppRouteNames.writing),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),

          // 4. Priority Overview
          Text('Priority Overview', style: AppTypography.titleMedium),
          const SizedBox(height: AppDimensions.space12),
          AcademicCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _PriorityCountItem(
                  label: 'High',
                  count: summary.highPriorityCount,
                  color: getPriorityColor(TaskPriority.high),
                ),
                _PriorityCountItem(
                  label: 'Medium',
                  count: summary.mediumPriorityCount,
                  color: getPriorityColor(TaskPriority.medium),
                ),
                _PriorityCountItem(
                  label: 'Low',
                  count: summary.lowPriorityCount,
                  color: getPriorityColor(TaskPriority.low),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space24),

          // 5. Today's Tasks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today's Tasks", style: AppTypography.titleMedium),
              TextButton(
                onPressed: () {
                  ref
                      .read(taskFilterProvider.notifier)
                      .setFilterType(TaskFilterType.today);
                  context.go(AppRouteNames.tasks);
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space8),
          if (summary.todaysTasks.isEmpty)
            AcademicCard(
              child: Row(
                children: [
                  Icon(Icons.event_available_outlined,
                      color: theme.colorScheme.primary.withValues(alpha: 0.7)),
                  const SizedBox(width: AppDimensions.space12),
                  Expanded(
                    child: Text(
                      'No tasks due today. Your schedule is clear.',
                      style: AppTypography.bodyMedium.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...summary.todaysTasks.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.space8),
                child: _DashboardTaskRow(item: item),
              ),
            ),

          const SizedBox(height: AppDimensions.space24),

          // 6. Upcoming Deadlines (Next 7 Days)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Upcoming Deadlines (7 Days)',
                  style: AppTypography.titleMedium),
              TextButton(
                onPressed: () {
                  ref
                      .read(taskFilterProvider.notifier)
                      .setFilterType(TaskFilterType.upcoming);
                  context.go(AppRouteNames.tasks);
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space8),
          if (summary.upcomingSevenDaysTasks.isEmpty)
            AcademicCard(
              child: Row(
                children: [
                  Icon(Icons.date_range_outlined,
                      color: theme.colorScheme.primary.withValues(alpha: 0.7)),
                  const SizedBox(width: AppDimensions.space12),
                  Expanded(
                    child: Text(
                      'No upcoming deadlines in the next 7 days.',
                      style: AppTypography.bodyMedium.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...summary.upcomingSevenDaysTasks.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.space8),
                child: _DashboardTaskRow(item: item),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _StatCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AcademicCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: accentColor, size: 22),
              Text(
                '$count',
                style: AppTypography.displayMedium.copyWith(
                  color: accentColor,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(label, style: AppTypography.titleSmall),
        ],
      ),
    );
  }
}

class _PriorityCountItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _PriorityCountItem({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Text(
            '$count',
            style: AppTypography.titleLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.space4),
        Text(label, style: AppTypography.labelMedium),
      ],
    );
  }
}

class _DashboardTaskRow extends ConsumerWidget {
  final TaskWithCategory item;

  const _DashboardTaskRow({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final task = item.task;
    final category = item.category;
    final priorityColor = getPriorityColor(task.priority);

    return AcademicCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailScreen(initialTask: task),
          ),
        );
      },
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space12,
        vertical: AppDimensions.space8,
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (val) async {
              final repo = ref.read(taskRepositoryProvider);
              if (val == true) {
                await repo.markCompleted(task.id);
              } else {
                await repo.reopenTask(task.id);
              }
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (category != null) category.name,
                    if (task.deadline != null)
                      DateFormat('EEE, MMM d • h:mm a').format(task.deadline!),
                  ].join(' • '),
                  style: AppTypography.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: priorityColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
