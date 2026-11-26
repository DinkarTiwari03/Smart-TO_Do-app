class TaskCategory {
  final String id;
  final String name;
  final String color;
  final bool isDefault;
  final DateTime? createdAt;

  const TaskCategory({
    required this.id,
    required this.name,
    required this.color,
    this.isDefault = false,
    this.createdAt,
  });

  TaskCategory copyWith({
    String? id,
    String? name,
    String? color,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return TaskCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
