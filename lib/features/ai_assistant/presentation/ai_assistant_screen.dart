import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/academic_card.dart';

class AiAssistantScreen extends StatelessWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart AI Assistant', style: AppTypography.displayMedium),
            const SizedBox(height: AppDimensions.space4),
            Text(
              'Interactive conversational intelligence for lecture outlines, syllabus planning, and academic Q&A.',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.space20),
            AcademicCard(
              child: Row(
                children: [
                  Icon(Icons.auto_awesome_outlined, color: theme.colorScheme.secondary),
                  const SizedBox(width: AppDimensions.space12),
                  Expanded(
                    child: Text(
                      'Phase 3 feature module. LLM orchestration, conversation history persistence, and context-aware academic prompts will be implemented in Phase 3.',
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
