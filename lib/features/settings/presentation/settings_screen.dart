import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/academic_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preferences & Diagnostics', style: AppTypography.displayMedium),
            const SizedBox(height: AppDimensions.space4),
            Text(
              'Application configuration, appearance, and local storage diagnostic status.',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.space20),
            AcademicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appearance', style: AppTypography.titleMedium),
                  const SizedBox(height: AppDimensions.space12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.brightness_medium_outlined),
                    title: const Text('Theme Mode'),
                    subtitle: Text(
                      currentThemeMode == ThemeMode.system
                          ? 'System Default'
                          : currentThemeMode == ThemeMode.dark
                              ? 'Dark Mode'
                              : 'Light Mode',
                    ),
                    trailing: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode_outlined, size: 18)),
                        ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.auto_mode_outlined, size: 18)),
                        ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode_outlined, size: 18)),
                      ],
                      selected: {currentThemeMode},
                      onSelectionChanged: (Set<ThemeMode> newSelection) {
                        ref.read(themeModeProvider.notifier).setThemeMode(newSelection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            AcademicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Local Database Diagnostics', style: AppTypography.titleMedium),
                  const SizedBox(height: AppDimensions.space8),
                  FutureBuilder<String?>(
                    future: ref.read(appDatabaseProvider).getMetadata('schema_initialized_at'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Reading database status...');
                      }
                      if (snapshot.hasError) {
                        return Text('Database error: ${snapshot.error}');
                      }
                      final initTime = snapshot.data ?? 'Not found';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Database Name: ${AppConstants.databaseName}'),
                          Text('Schema Version: ${AppConstants.databaseSchemaVersion}'),
                          Text('Initialized At: $initTime'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            AcademicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About', style: AppTypography.titleMedium),
                  const SizedBox(height: AppDimensions.space8),
                  Text('${AppConstants.appName} v${AppConstants.appVersion}'),
                  Text(
                    AppConstants.appTagline,
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
