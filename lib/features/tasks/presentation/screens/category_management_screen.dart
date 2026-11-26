import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/academic_button.dart';
import '../../../../core/widgets/academic_card.dart';
import '../../../../core/widgets/academic_text_field.dart';
import '../../domain/models/task_category.dart';
import '../providers/task_providers.dart';
import '../widgets/task_ui_helpers.dart';

class CategoryManagementScreen extends ConsumerStatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  ConsumerState<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends ConsumerState<CategoryManagementScreen> {
  static const List<String> _palette = [
    '#1E3A5F', // Oxford Navy
    '#C08A3E', // Academic Bronze
    '#2563EB', // Blue
    '#16A34A', // Green
    '#D97706', // Amber
    '#DC2626', // Red
    '#805AD5', // Purple
    '#319795', // Teal
    '#4A5568', // Slate Grey
  ];

  void _showCategoryDialog([TaskCategory? categoryToEdit]) {
    final nameController = TextEditingController(text: categoryToEdit?.name ?? '');
    String selectedColor = categoryToEdit?.color ?? _palette.first;
    final isEditing = categoryToEdit != null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(isEditing ? 'Edit Category' : 'New Academic Category'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AcademicTextField(
                    controller: nameController,
                    labelText: 'Category Name',
                    hintText: 'e.g., Curriculum Committee',
                  ),
                  const SizedBox(height: AppDimensions.space16),
                  Text('Color Identifier', style: AppTypography.labelMedium),
                  const SizedBox(height: AppDimensions.space8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _palette.map((colorHex) {
                      final c = parseHexColor(colorHex);
                      final isSelected = selectedColor.toLowerCase() == colorHex.toLowerCase();
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() => selectedColor = colorHex);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 18, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              FilledButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  final repo = ref.read(taskRepositoryProvider);
                  if (isEditing) {
                    await repo.updateCategoryDetails(
                      categoryToEdit.copyWith(name: name, color: selectedColor),
                    );
                  } else {
                    await repo.createCategory(
                      TaskCategory(
                        id: const Uuid().v4(),
                        name: name,
                        color: selectedColor,
                        isDefault: false,
                        createdAt: DateTime.now(),
                      ),
                    );
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: Text(isEditing ? 'Save Changes' : 'Create'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleDeleteCategory(TaskCategory category, List<TaskCategory> allCategories) async {
    final repo = ref.read(taskRepositoryProvider);
    final count = await repo.countTasksInCategory(category.id);

    if (!mounted) return;

    if (count == 0) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Category'),
          content: Text('Delete category "${category.name}"?'),
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
        await repo.deleteCategory(category.id);
      }
      return;
    }

    // Has tasks: prompt reassignment
    final eligibleTargets = allCategories.where((c) => c.id != category.id).toList();
    String? selectedTargetId = eligibleTargets.isNotEmpty ? eligibleTargets.first.id : null;

    if (selectedTargetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete category because no other category exists to reassign tasks to.')),
      );
      return;
    }

    final reassignAndConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Category Contains Tasks'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This category currently has $count assigned task(s). '
                  'Please select a category to reassign these tasks before deleting "${category.name}":',
                ),
                const SizedBox(height: AppDimensions.space16),
                DropdownButtonFormField<String>(
                  value: selectedTargetId,
                  decoration: const InputDecoration(labelText: 'Reassign tasks to:'),
                  items: eligibleTargets.map((c) {
                    return DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedTargetId = val);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
                child: const Text('Reassign & Delete'),
              ),
            ],
          );
        },
      ),
    );

    if (reassignAndConfirm == true && selectedTargetId != null) {
      await repo.deleteCategory(category.id, reassignToCategoryId: selectedTargetId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tasks reassigned and "${category.name}" removed.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Categories'),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          return ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.space16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.space12),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final catColor = parseHexColor(cat.color);

              return AcademicCard(
                child: Row(
                  children: [
                    CircleAvatar(radius: 10, backgroundColor: catColor),
                    const SizedBox(width: AppDimensions.space16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.name, style: AppTypography.titleMedium),
                          const SizedBox(height: AppDimensions.space2),
                          Text(
                            cat.isDefault ? 'Standard System Category' : 'Custom Category',
                            style: AppTypography.bodySmall.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!cat.isDefault) ...[
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        tooltip: 'Edit Category',
                        onPressed: () => _showCategoryDialog(cat),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        tooltip: 'Delete Category',
                        onPressed: () => _handleDeleteCategory(cat, categories),
                      ),
                    ] else
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.lock_outline,
                          size: 18,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: AcademicButton(
            label: 'Add Custom Category',
            icon: Icons.add,
            onPressed: () => _showCategoryDialog(),
          ),
        ),
      ),
    );
  }
}
