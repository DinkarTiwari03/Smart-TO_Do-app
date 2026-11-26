import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/academic_card.dart';
import '../../domain/models/task.dart';
import '../../domain/models/task_category.dart';
import '../providers/task_providers.dart';
import '../widgets/task_form_sheet.dart';
import '../widgets/task_ui_helpers.dart';

class TaskDetailScreen extends ConsumerWidget {
  final Task initialTask;

  const TaskDetailScreen({super.key, required this.initialTask});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repository = ref.watch(taskRepositoryProvider);
    final allTasksAsync = ref.watch(allTasksStreamProvider);
    final categoriesMap = ref.watch(categoriesMapProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    // Watch live updates to this task from the stream
    final currentTask = allTasksAsync.maybeWhen(
      data: (tasks) => tasks.firstWhere(
        (t) => t.id == initialTask.id,
        orElse: () => initialTask,
      ),
      orElse: () => initialTask,
    );

    final category = categoriesMap[currentTask.categoryId];
    final categoryColor = category != null ? parseHexColor(category.color) : theme.colorScheme.primary;
    final priorityColor = getPriorityColor(currentTask.priority);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Task',
            onPressed: () {
              final cats = categoriesAsync.maybeWhen(
                data: (data) => data,
                orElse: () => <TaskCategory>[],
              );
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
                ),
                builder: (ctx) => TaskFormSheet(
                  taskToEdit: currentTask,
                  categories: cats,
                  onSave: (updatedTask) async {
                    await repository.updateTask(updatedTask);
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Task',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: Text('Are you sure you want to permanently delete "${currentTask.title}"?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await repository.deleteTask(currentTask.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Status Card
            AcademicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: currentTask.isCompleted,
                        onChanged: (val) async {
                          if (val == true) {
                            await repository.markCompleted(currentTask.id);
                          } else {
                            await repository.reopenTask(currentTask.id);
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          currentTask.title,
                          style: AppTypography.displayMedium.copyWith(
                            fontSize: 22,
                            decoration: currentTask.isCompleted ? TextDecoration.lineThrough : null,
                            color: currentTask.isCompleted
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  const Divider(),
                  const SizedBox(height: AppDimensions.space12),
                  Row(
                    children: [
                      Text('Status: ', style: AppTypography.labelMedium),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: currentTask.isCompleted
                              ? Colors.green.shade100
                              : theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        ),
                        child: Text(
                          currentTask.status.label,
                          style: AppTypography.labelMedium.copyWith(
                            color: currentTask.isCompleted
                                ? Colors.green.shade900
                                : theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (currentTask.isCompleted)
                        TextButton.icon(
                          onPressed: () => repository.reopenTask(currentTask.id),
                          icon: const Icon(Icons.replay, size: 18),
                          label: const Text('Reopen Task'),
                        )
                      else
                        FilledButton.tonalIcon(
                          onPressed: () => repository.markCompleted(currentTask.id),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Mark Complete'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Metadata card: Priority, Category, Deadline, Reminder
            AcademicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Properties', style: AppTypography.titleMedium),
                  const SizedBox(height: AppDimensions.space12),

                  // Category
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(radius: 8, backgroundColor: categoryColor),
                    title: const Text('Category'),
                    subtitle: Text(category?.name ?? 'General'),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      _showQuickCategorySelector(context, ref, currentTask);
                    },
                  ),
                  const Divider(),

                  // Priority
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.flag_outlined, color: priorityColor),
                    title: const Text('Priority'),
                    subtitle: Text(currentTask.priority.label),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      _showQuickPrioritySelector(context, ref, currentTask);
                    },
                  ),
                  const Divider(),

                  // Deadline
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Deadline'),
                    subtitle: Text(
                      currentTask.deadline != null
                          ? DateFormat('EEEE, MMMM d, yyyy • h:mm a').format(currentTask.deadline!)
                          : 'No deadline assigned',
                    ),
                  ),
                  if (currentTask.reminderAt != null) ...[
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.notifications_active_outlined),
                      title: const Text('Reminder Alert'),
                      subtitle: Text(
                        DateFormat('EEEE, MMMM d, yyyy • h:mm a').format(currentTask.reminderAt!),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Description Card
            AcademicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notes & Description', style: AppTypography.titleMedium),
                  const SizedBox(height: AppDimensions.space8),
                  if (currentTask.description != null && currentTask.description!.trim().isNotEmpty)
                    Text(
                      currentTask.description!,
                      style: AppTypography.bodyMedium.copyWith(height: 1.6),
                    )
                  else
                    Text(
                      'No additional details provided for this task.',
                      style: AppTypography.bodyMedium.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Timestamps
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
              child: Text(
                'Created: ${DateFormat('MMM d, yyyy • h:mm a').format(currentTask.createdAt)}\n'
                'Last modified: ${DateFormat('MMM d, yyyy • h:mm a').format(currentTask.updatedAt)}',
                style: AppTypography.bodySmall.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickCategorySelector(BuildContext context, WidgetRef ref, Task task) {
    final categoriesAsync = ref.read(categoriesStreamProvider);
    final repository = ref.read(taskRepositoryProvider);

    categoriesAsync.whenData((categories) {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space16),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16, vertical: 8),
              child: Text('Change Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            ...categories.map((cat) {
              final catColor = parseHexColor(cat.color);
              final isSelected = cat.id == task.categoryId;
              return ListTile(
                leading: CircleAvatar(radius: 6, backgroundColor: catColor),
                title: Text(cat.name),
                trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () async {
                  await repository.updateCategory(task.id, cat.id);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      );
    });
  }

  void _showQuickPrioritySelector(BuildContext context, WidgetRef ref, Task task) {
    final repository = ref.read(taskRepositoryProvider);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16, vertical: 8),
            child: Text('Update Priority', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ...TaskPriority.values.map((p) {
            final isSelected = p == task.priority;
            return ListTile(
              leading: Icon(Icons.flag, color: getPriorityColor(p)),
              title: Text(p.label),
              trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () async {
                await repository.updatePriority(task.id, p);
                if (ctx.mounted) Navigator.pop(ctx);
              },
            );
          }),
        ],
      ),
    );
  }
}
