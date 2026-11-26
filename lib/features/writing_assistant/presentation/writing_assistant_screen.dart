import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/academic_card.dart';

class WritingAssistantScreen extends StatelessWidget {
  const WritingAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Writing Assistant'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Academic Writing & Editing', style: AppTypography.displayMedium),
            const SizedBox(height: AppDimensions.space4),
            Text(
              'Assistance for journal papers, grant proposals, recommendation letters, and peer reviews.',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.space20),
            AcademicCard(
              child: Row(
                children: [
                  Icon(Icons.edit_note_outlined, color: theme.colorScheme.primary),
                  const SizedBox(width: AppDimensions.space12),
                  Expanded(
                    child: Text(
                      'Phase 4 feature module. Paper drafting, citation formatting, proofreading, and document export will be implemented in Phase 4.',
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
