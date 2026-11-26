import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/academic_card.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks & Deadlines'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Academic Task Management', style: AppTypography.displayMedium),
            const SizedBox(height: AppDimensions.space4),
            Text(
              'Organize lecture preparation, student grading, research deadlines, and committee duties.',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.space20),
            AcademicCard(
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.primary),
                  const SizedBox(width: AppDimensions.space12),
                  Expanded(
                    child: Text(
                      'Phase 2 feature module. Full task CRUD, priority sorting, course tagging, and deadline reminders will be implemented in Phase 2.',
                      style: AppTypography.bodyMedium,
                    ),
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
