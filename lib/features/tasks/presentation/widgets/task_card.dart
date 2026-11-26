import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/academic_card.dart';
import '../../domain/models/task.dart';
import '../../domain/models/task_with_category.dart';
import 'task_ui_helpers.dart';

class TaskCard extends StatelessWidget {
  final TaskWithCategory item;
  final VoidCallback onTap;
  final ValueChanged<bool?> onToggleComplete;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final task = item.task;
    final category = item.category;
    final categoryColor = category != null ? parseHexColor(category.color) : theme.colorScheme.primary;
    final priorityColor = getPriorityColor(task.priority);

    final isOverdue = task.deadline != null &&
        !task.isCompleted &&
        task.deadline!.isBefore(DateTime.now());

    final deadlineText = task.deadline != null
        ? DateFormat('EEE, MMM d, yyyy • h:mm a').format(task.deadline!)
        : 'No deadline set';

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimensions.space20),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Task'),
            content: Text('Are you sure you want to delete "${task.title}"?'),
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
      },
      onDismissed: (_) => onDelete(),
      child: AcademicCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: task.isCompleted,
                  onChanged: onToggleComplete,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.space12),

            // Main Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    task.title,
                    style: AppTypography.titleMedium.copyWith(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (task.description != null && task.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.space4),
                    Text(
                      task.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimensions.space8),

                  // Metadata Badges (Category, Priority, Deadline)
                  Wrap(
                    spacing: AppDimensions.space8,
                    runSpacing: AppDimensions.space4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          border: Border.Border.all(color: categoryColor.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(radius: 3.5, backgroundColor: categoryColor),
                            const SizedBox(width: 5),
                            Text(
                              category?.name ?? 'General',
                              style: AppTypography.labelMedium.copyWith(
                                color: categoryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Priority Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: priorityColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          border: Border.Border.all(color: priorityColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          task.priority.label,
                          style: AppTypography.labelMedium.copyWith(
                            color: priorityColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Deadline Badge
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: isOverdue ? Colors.red.shade700 : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            deadlineText,
                            style: AppTypography.bodySmall.copyWith(
                              color: isOverdue
                                  ? Colors.red.shade700
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
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
