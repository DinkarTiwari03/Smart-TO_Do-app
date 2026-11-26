import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/academic_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            Row(
              children: [
                Expanded(
                  child: AcademicCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.assignment_outlined, color: theme.colorScheme.primary),
                        const SizedBox(height: AppDimensions.space8),
                        Text('Pending Tasks', style: AppTypography.titleSmall),
                        const SizedBox(height: AppDimensions.space4),
                        Text(
                          'Phase 2 Modules',
                          style: AppTypography.bodySmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: AcademicCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_awesome_outlined, color: theme.colorScheme.secondary),
                        const SizedBox(height: AppDimensions.space8),
                        Text('AI Assistant', style: AppTypography.titleSmall),
                        const SizedBox(height: AppDimensions.space4),
                        Text(
                          'Phase 3 Modules',
                          style: AppTypography.bodySmall.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space16),
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
                    '• Clean Architecture foundation established\n'
                    '• Drift + SQLite local database operational\n'
                    '• Network infrastructure (Dio) configured\n'
                    '• Material 3 Academic theme active\n'
                    '• Riverpod state management ready',
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
