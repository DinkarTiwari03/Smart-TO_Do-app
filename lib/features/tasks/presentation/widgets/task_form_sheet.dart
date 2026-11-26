import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/academic_button.dart';
import '../../../../core/widgets/academic_text_field.dart';
import '../../domain/models/task.dart';
import '../../domain/models/task_category.dart';
import '../widgets/task_ui_helpers.dart';

class TaskFormSheet extends StatefulWidget {
  final Task? taskToEdit;
  final List<TaskCategory> categories;
  final Future<void> Function(Task task) onSave;

  const TaskFormSheet({
    super.key,
    this.taskToEdit,
    required this.categories,
    required this.onSave,
  });

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TaskPriority _selectedPriority;
  late String _selectedCategoryId;
  DateTime? _selectedDeadline;
  DateTime? _selectedReminder;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final task = widget.taskToEdit;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descController = TextEditingController(text: task?.description ?? '');
    _selectedPriority = task?.priority ?? TaskPriority.medium;
    _selectedCategoryId = task?.categoryId ??
        (widget.categories.isNotEmpty ? widget.categories.first.id : 'cat_academic');
    _selectedDeadline = task?.deadline;
    _selectedReminder = task?.reminderAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({required bool isDeadline}) async {
    final now = DateTime.now();
    final initialDate = (isDeadline ? _selectedDeadline : _selectedReminder) ?? now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(now) ? now : initialDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 3)),
    );

    if (pickedDate != null && mounted) {
      final initialTime = TimeOfDay.fromDateTime(initialDate);
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (pickedTime != null) {
        final fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          if (isDeadline) {
            _selectedDeadline = fullDateTime;
          } else {
            _selectedReminder = fullDateTime;
          }
        });
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final now = DateTime.now();

    final task = Task(
      id: widget.taskToEdit?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      priority: _selectedPriority,
      categoryId: _selectedCategoryId,
      deadline: _selectedDeadline,
      reminderAt: _selectedReminder,
      status: widget.taskToEdit?.status ?? TaskStatus.pending,
      createdAt: widget.taskToEdit?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      await widget.onSave(task);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save task: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.taskToEdit != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space20,
          vertical: AppDimensions.space20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Task' : 'New Academic Task',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space16),

                // Title
                AcademicTextField(
                  controller: _titleController,
                  labelText: 'Task Title *',
                  hintText: 'e.g., Finalize syllabus for CS402',
                  prefixIcon: Icons.assignment_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.space16),

                // Description
                AcademicTextField(
                  controller: _descController,
                  labelText: 'Description (Optional)',
                  hintText: 'Add details, grading criteria, or committee notes...',
                  prefixIcon: Icons.notes_outlined,
                ),
                const SizedBox(height: AppDimensions.space16),

                // Category Selector
                Text('Category', style: theme.textTheme.labelLarge),
                const SizedBox(height: AppDimensions.space8),
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined, size: 20),
                  ),
                  items: widget.categories.map((cat) {
                    final catColor = parseHexColor(cat.color);
                    return DropdownMenuItem(
                      value: cat.id,
                      child: Row(
                        children: [
                          CircleAvatar(radius: 5, backgroundColor: catColor),
                          const SizedBox(width: 10),
                          Text(cat.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategoryId = val);
                  },
                ),
                const SizedBox(height: AppDimensions.space16),

                // Priority Segmented Button
                Text('Priority', style: theme.textTheme.labelLarge),
                const SizedBox(height: AppDimensions.space8),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<TaskPriority>(
                    segments: const [
                      ButtonSegment(
                        value: TaskPriority.low,
                        label: Text('Low'),
                        icon: Icon(Icons.low_priority, size: 18),
                      ),
                      ButtonSegment(
                        value: TaskPriority.medium,
                        label: Text('Medium'),
                        icon: Icon(Icons.remove, size: 18),
                      ),
                      ButtonSegment(
                        value: TaskPriority.high,
                        label: Text('High'),
                        icon: Icon(Icons.priority_high, size: 18),
                      ),
                    ],
                    selected: {_selectedPriority},
                    onSelectionChanged: (newSelection) {
                      setState(() => _selectedPriority = newSelection.first);
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.space20),

                // Deadline Picker
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.calendar_today_outlined,
                    color: _selectedDeadline != null ? theme.colorScheme.primary : null,
                  ),
                  title: const Text('Deadline'),
                  subtitle: Text(
                    _selectedDeadline != null
                        ? DateFormat('EEE, MMM d, yyyy • h:mm a').format(_selectedDeadline!)
                        : 'No deadline set',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_selectedDeadline != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _selectedDeadline = null),
                        ),
                      TextButton(
                        onPressed: () => _pickDateTime(isDeadline: true),
                        child: Text(_selectedDeadline != null ? 'Change' : 'Set'),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Reminder Picker
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.notifications_active_outlined,
                    color: _selectedReminder != null ? theme.colorScheme.secondary : null,
                  ),
                  title: const Text('Reminder'),
                  subtitle: Text(
                    _selectedReminder != null
                        ? DateFormat('EEE, MMM d, yyyy • h:mm a').format(_selectedReminder!)
                        : 'No reminder scheduled',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_selectedReminder != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _selectedReminder = null),
                        ),
                      TextButton(
                        onPressed: () => _pickDateTime(isDeadline: false),
                        child: Text(_selectedReminder != null ? 'Change' : 'Set'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.space24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: AcademicButton(
                    label: isEditing ? 'Update Task' : 'Create Task',
                    icon: isEditing ? Icons.check : Icons.add_task,
                    isLoading: _isSaving,
                    onPressed: _handleSubmit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
