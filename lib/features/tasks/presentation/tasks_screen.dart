import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/models/task_category.dart';
import 'providers/task_providers.dart';
import 'screens/category_management_screen.dart';
import 'screens/task_detail_screen.dart';
import 'widgets/task_card.dart';
import 'widgets/task_form_sheet.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCreateTaskSheet(BuildContext context, List<TaskCategory> categories) {
    final repository = ref.read(taskRepositoryProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterState = ref.watch(taskFilterProvider);
    final filterNotifier = ref.read(taskFilterProvider.notifier);
    final filteredTasksAsync = ref.watch(filteredTasksProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final repository = ref.read(taskRepositoryProvider);

    final categories = categoriesAsync.maybeWhen(
      data: (cats) => cats,
      orElse: () => <TaskCategory>[],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks & Deadlines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Manage Categories',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CategoryManagementScreen()),
              );
            },
          ),
          PopupMenuButton<TaskSortType>(
            icon: const Icon(Icons.sort_outlined),
            tooltip: 'Sort Tasks',
            initialValue: filterState.sortType,
            onSelected: (sortType) => filterNotifier.setSortType(sortType),
            itemBuilder: (context) => TaskSortType.values.map((sort) {
              return PopupMenuItem(
                value: sort,
                child: Row(
                  children: [
                    if (filterState.sortType == sort)
                      Icon(Icons.check, size: 18, color: theme.colorScheme.primary)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text('Sort by ${sort.label}'),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space8,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks by title or description...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          filterNotifier.setSearchQuery('');
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (query) {
                filterNotifier.setSearchQuery(query);
                setState(() {});
              },
            ),
          ),

          // Primary Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
            child: Row(
              children: TaskFilterType.values.map((filterType) {
                final isSelected = filterState.filterType == filterType;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(filterType.label),
                    selected: isSelected,
                    onSelected: (_) {
                      filterNotifier.setFilterType(filterType);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Category Quick-Filter Chips
          if (categories.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16, vertical: 6),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Categories'),
                    selected: filterState.selectedCategoryId == null,
                    onSelected: (_) => filterNotifier.setSelectedCategory(null),
                  ),
                  const SizedBox(width: 8),
                  ...categories.map((cat) {
                    final isSelected = filterState.selectedCategoryId == cat.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: isSelected,
                        onSelected: (_) {
                          if (isSelected) {
                            filterNotifier.setSelectedCategory(null);
                          } else {
                            filterNotifier.setSelectedCategory(cat.id);
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

          const Divider(height: 1),

          // Task List View
          Expanded(
            child: filteredTasksAsync.when(
              data: (tasksWithCat) {
                if (tasksWithCat.isEmpty) {
                  return _buildEmptyState(theme, filterState, categories);
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.space16),
                  itemCount: tasksWithCat.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.space12),
                  itemBuilder: (context, index) {
                    final item = tasksWithCat[index];
                    return TaskCard(
                      item: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetailScreen(initialTask: item.task),
                          ),
                        );
                      },
                      onToggleComplete: (bool? val) async {
                        if (val == true) {
                          await repository.markCompleted(item.task.id);
                        } else {
                          await repository.reopenTask(item.task.id);
                        }
                      },
                      onDelete: () async {
                        await repository.deleteTask(item.task.id);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.space20),
                  child: Text('Error loading tasks: $err'),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateTaskSheet(context, categories),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildEmptyState(
    ThemeData theme,
    TaskFilterState filterState,
    List<TaskCategory> categories,
  ) {
    String message = 'No tasks found';
    String hint = 'Create your first academic task to get started.';

    if (filterState.filterType == TaskFilterType.today) {
      message = "No tasks due today";
      hint = "You are all caught up on today's lecture and grading deadlines.";
    } else if (filterState.filterType == TaskFilterType.overdue) {
      message = "No overdue tasks";
      hint = "Excellent! All deadlines are on schedule.";
    } else if (filterState.filterType == TaskFilterType.completed) {
      message = "No completed tasks yet";
      hint = "Tasks marked complete will appear here.";
    } else if (filterState.searchQuery.isNotEmpty) {
      message = 'No matching tasks';
      hint = 'Try adjusting your search keywords.';
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(message, style: AppTypography.titleLarge),
            const SizedBox(height: AppDimensions.space8),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            ElevatedButton.icon(
              onPressed: () => _openCreateTaskSheet(context, categories),
              icon: const Icon(Icons.add),
              label: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
