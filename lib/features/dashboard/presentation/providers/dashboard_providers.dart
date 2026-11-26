import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../tasks/presentation/providers/task_providers.dart';
import '../../domain/models/dashboard_summary.dart';

final dashboardSummaryProvider = Provider<AsyncValue<DashboardSummary>>((ref) {
  final tasksAsync = ref.watch(allTasksStreamProvider);
  final categoriesMap = ref.watch(categoriesMapProvider);

  return tasksAsync.whenData(
    (tasks) => DashboardSummary.fromTasks(
      tasks: tasks,
      categoriesById: categoriesMap,
    ),
  );
});
