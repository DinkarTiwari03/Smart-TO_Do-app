// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppMetadataTableTable extends AppMetadataTable
    with TableInfo<$AppMetadataTableTable, AppMetadataEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetadataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_metadata_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetadataEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetadataEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetadataEntry(
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $AppMetadataTableTable createAlias(String alias) {
    return $AppMetadataTableTable(attachedDatabase, alias);
  }
}

class AppMetadataEntry extends DataClass
    implements Insertable<AppMetadataEntry> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppMetadataEntry({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppMetadataTableCompanion toCompanion(bool nullToAbsent) {
    return AppMetadataTableCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppMetadataEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetadataEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppMetadataEntry copyWith({
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => AppMetadataEntry(
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppMetadataEntry copyWithCompanion(AppMetadataTableCompanion data) {
    return AppMetadataEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataEntry(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetadataEntry &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppMetadataTableCompanion extends UpdateCompanion<AppMetadataEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppMetadataTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetadataTableCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetadataEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetadataTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppMetadataTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 4,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color, isDefault, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryEntry(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      color:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}color'],
          )!,
      isDefault:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_default'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoryEntry extends DataClass implements Insertable<CategoryEntry> {
  final String id;
  final String name;
  final String color;
  final bool isDefault;
  final DateTime createdAt;
  const CategoryEntry({
    required this.id,
    required this.name,
    required this.color,
    required this.isDefault,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
    );
  }

  factory CategoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CategoryEntry copyWith({
    String? id,
    String? name,
    String? color,
    bool? isDefault,
    DateTime? createdAt,
  }) => CategoryEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
  );
  CategoryEntry copyWithCompanion(CategoriesTableCompanion data) {
    return CategoryEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, isDefault, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoryEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> color;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String name,
    required String color,
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       color = Value(color);
  static Insertable<CategoryEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? color,
    Value<bool>? isDefault,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TaskEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories_table (id) ON UPDATE CASCADE ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderAtMeta = const VerificationMeta(
    'reminderAt',
  );
  @override
  late final GeneratedColumn<DateTime> reminderAt = GeneratedColumn<DateTime>(
    'reminder_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    priority,
    categoryId,
    deadline,
    reminderAt,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('reminder_at')) {
      context.handle(
        _reminderAtMeta,
        reminderAt.isAcceptableOrUnknown(data['reminder_at']!, _reminderAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEntry(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      priority:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}priority'],
          )!,
      categoryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}category_id'],
          )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      ),
      reminderAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_at'],
      ),
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }
}

class TaskEntry extends DataClass implements Insertable<TaskEntry> {
  final String id;
  final String title;
  final String? description;
  final String priority;
  final String categoryId;
  final DateTime? deadline;
  final DateTime? reminderAt;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskEntry({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.categoryId,
    this.deadline,
    this.reminderAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['priority'] = Variable<String>(priority);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<DateTime>(reminderAt);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      title: Value(title),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      priority: Value(priority),
      categoryId: Value(categoryId),
      deadline:
          deadline == null && nullToAbsent
              ? const Value.absent()
              : Value(deadline),
      reminderAt:
          reminderAt == null && nullToAbsent
              ? const Value.absent()
              : Value(reminderAt),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      priority: serializer.fromJson<String>(json['priority']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      reminderAt: serializer.fromJson<DateTime?>(json['reminderAt']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'priority': serializer.toJson<String>(priority),
      'categoryId': serializer.toJson<String>(categoryId),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'reminderAt': serializer.toJson<DateTime?>(reminderAt),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskEntry copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? priority,
    String? categoryId,
    Value<DateTime?> deadline = const Value.absent(),
    Value<DateTime?> reminderAt = const Value.absent(),
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    priority: priority ?? this.priority,
    categoryId: categoryId ?? this.categoryId,
    deadline: deadline.present ? deadline.value : this.deadline,
    reminderAt: reminderAt.present ? reminderAt.value : this.reminderAt,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskEntry copyWithCompanion(TasksTableCompanion data) {
    return TaskEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      priority: data.priority.present ? data.priority.value : this.priority,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      reminderAt:
          data.reminderAt.present ? data.reminderAt.value : this.reminderAt,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('categoryId: $categoryId, ')
          ..write('deadline: $deadline, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    priority,
    categoryId,
    deadline,
    reminderAt,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.priority == this.priority &&
          other.categoryId == this.categoryId &&
          other.deadline == this.deadline &&
          other.reminderAt == this.reminderAt &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksTableCompanion extends UpdateCompanion<TaskEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> priority;
  final Value<String> categoryId;
  final Value<DateTime?> deadline;
  final Value<DateTime?> reminderAt;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.priority = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.deadline = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required String priority,
    required String categoryId,
    this.deadline = const Value.absent(),
    this.reminderAt = const Value.absent(),
    required String status,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       priority = Value(priority),
       categoryId = Value(categoryId),
       status = Value(status);
  static Insertable<TaskEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? priority,
    Expression<String>? categoryId,
    Expression<DateTime>? deadline,
    Expression<DateTime>? reminderAt,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (priority != null) 'priority': priority,
      if (categoryId != null) 'category_id': categoryId,
      if (deadline != null) 'deadline': deadline,
      if (reminderAt != null) 'reminder_at': reminderAt,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? priority,
    Value<String>? categoryId,
    Value<DateTime?>? deadline,
    Value<DateTime?>? reminderAt,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TasksTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
      deadline: deadline ?? this.deadline,
      reminderAt: reminderAt ?? this.reminderAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<DateTime>(reminderAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('categoryId: $categoryId, ')
          ..write('deadline: $deadline, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduledNotificationsTableTable extends ScheduledNotificationsTable
    with
        TableInfo<
          $ScheduledNotificationsTableTable,
          ScheduledNotificationEntry
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledNotificationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks_table (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _reminderTypeMeta = const VerificationMeta(
    'reminderType',
  );
  @override
  late final GeneratedColumn<String> reminderType = GeneratedColumn<String>(
    'reminder_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deadlineSnapshotMeta = const VerificationMeta(
    'deadlineSnapshot',
  );
  @override
  late final GeneratedColumn<DateTime> deadlineSnapshot =
      GeneratedColumn<DateTime>(
        'deadline_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    notificationId,
    taskId,
    reminderType,
    scheduledAt,
    deadlineSnapshot,
    title,
    body,
    payload,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_notifications_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduledNotificationEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('reminder_type')) {
      context.handle(
        _reminderTypeMeta,
        reminderType.isAcceptableOrUnknown(
          data['reminder_type']!,
          _reminderTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reminderTypeMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('deadline_snapshot')) {
      context.handle(
        _deadlineSnapshotMeta,
        deadlineSnapshot.isAcceptableOrUnknown(
          data['deadline_snapshot']!,
          _deadlineSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {notificationId};
  @override
  ScheduledNotificationEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledNotificationEntry(
      notificationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}notification_id'],
          )!,
      taskId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}task_id'],
          )!,
      reminderType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}reminder_type'],
          )!,
      scheduledAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}scheduled_at'],
          )!,
      deadlineSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline_snapshot'],
      ),
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      body:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}body'],
          )!,
      payload:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}payload'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $ScheduledNotificationsTableTable createAlias(String alias) {
    return $ScheduledNotificationsTableTable(attachedDatabase, alias);
  }
}

class ScheduledNotificationEntry extends DataClass
    implements Insertable<ScheduledNotificationEntry> {
  final int notificationId;
  final String taskId;
  final String reminderType;
  final DateTime scheduledAt;
  final DateTime? deadlineSnapshot;
  final String title;
  final String body;
  final String payload;
  final String status;
  final DateTime createdAt;
  const ScheduledNotificationEntry({
    required this.notificationId,
    required this.taskId,
    required this.reminderType,
    required this.scheduledAt,
    this.deadlineSnapshot,
    required this.title,
    required this.body,
    required this.payload,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['notification_id'] = Variable<int>(notificationId);
    map['task_id'] = Variable<String>(taskId);
    map['reminder_type'] = Variable<String>(reminderType);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || deadlineSnapshot != null) {
      map['deadline_snapshot'] = Variable<DateTime>(deadlineSnapshot);
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScheduledNotificationsTableCompanion toCompanion(bool nullToAbsent) {
    return ScheduledNotificationsTableCompanion(
      notificationId: Value(notificationId),
      taskId: Value(taskId),
      reminderType: Value(reminderType),
      scheduledAt: Value(scheduledAt),
      deadlineSnapshot:
          deadlineSnapshot == null && nullToAbsent
              ? const Value.absent()
              : Value(deadlineSnapshot),
      title: Value(title),
      body: Value(body),
      payload: Value(payload),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory ScheduledNotificationEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledNotificationEntry(
      notificationId: serializer.fromJson<int>(json['notificationId']),
      taskId: serializer.fromJson<String>(json['taskId']),
      reminderType: serializer.fromJson<String>(json['reminderType']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      deadlineSnapshot: serializer.fromJson<DateTime?>(
        json['deadlineSnapshot'],
      ),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'notificationId': serializer.toJson<int>(notificationId),
      'taskId': serializer.toJson<String>(taskId),
      'reminderType': serializer.toJson<String>(reminderType),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'deadlineSnapshot': serializer.toJson<DateTime?>(deadlineSnapshot),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScheduledNotificationEntry copyWith({
    int? notificationId,
    String? taskId,
    String? reminderType,
    DateTime? scheduledAt,
    Value<DateTime?> deadlineSnapshot = const Value.absent(),
    String? title,
    String? body,
    String? payload,
    String? status,
    DateTime? createdAt,
  }) => ScheduledNotificationEntry(
    notificationId: notificationId ?? this.notificationId,
    taskId: taskId ?? this.taskId,
    reminderType: reminderType ?? this.reminderType,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    deadlineSnapshot:
        deadlineSnapshot.present
            ? deadlineSnapshot.value
            : this.deadlineSnapshot,
    title: title ?? this.title,
    body: body ?? this.body,
    payload: payload ?? this.payload,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  ScheduledNotificationEntry copyWithCompanion(
    ScheduledNotificationsTableCompanion data,
  ) {
    return ScheduledNotificationEntry(
      notificationId:
          data.notificationId.present
              ? data.notificationId.value
              : this.notificationId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      reminderType:
          data.reminderType.present
              ? data.reminderType.value
              : this.reminderType,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      deadlineSnapshot:
          data.deadlineSnapshot.present
              ? data.deadlineSnapshot.value
              : this.deadlineSnapshot,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledNotificationEntry(')
          ..write('notificationId: $notificationId, ')
          ..write('taskId: $taskId, ')
          ..write('reminderType: $reminderType, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('deadlineSnapshot: $deadlineSnapshot, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    notificationId,
    taskId,
    reminderType,
    scheduledAt,
    deadlineSnapshot,
    title,
    body,
    payload,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledNotificationEntry &&
          other.notificationId == this.notificationId &&
          other.taskId == this.taskId &&
          other.reminderType == this.reminderType &&
          other.scheduledAt == this.scheduledAt &&
          other.deadlineSnapshot == this.deadlineSnapshot &&
          other.title == this.title &&
          other.body == this.body &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ScheduledNotificationsTableCompanion
    extends UpdateCompanion<ScheduledNotificationEntry> {
  final Value<int> notificationId;
  final Value<String> taskId;
  final Value<String> reminderType;
  final Value<DateTime> scheduledAt;
  final Value<DateTime?> deadlineSnapshot;
  final Value<String> title;
  final Value<String> body;
  final Value<String> payload;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const ScheduledNotificationsTableCompanion({
    this.notificationId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.deadlineSnapshot = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ScheduledNotificationsTableCompanion.insert({
    this.notificationId = const Value.absent(),
    required String taskId,
    required String reminderType,
    required DateTime scheduledAt,
    this.deadlineSnapshot = const Value.absent(),
    required String title,
    required String body,
    required String payload,
    required String status,
    this.createdAt = const Value.absent(),
  }) : taskId = Value(taskId),
       reminderType = Value(reminderType),
       scheduledAt = Value(scheduledAt),
       title = Value(title),
       body = Value(body),
       payload = Value(payload),
       status = Value(status);
  static Insertable<ScheduledNotificationEntry> custom({
    Expression<int>? notificationId,
    Expression<String>? taskId,
    Expression<String>? reminderType,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? deadlineSnapshot,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (notificationId != null) 'notification_id': notificationId,
      if (taskId != null) 'task_id': taskId,
      if (reminderType != null) 'reminder_type': reminderType,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (deadlineSnapshot != null) 'deadline_snapshot': deadlineSnapshot,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ScheduledNotificationsTableCompanion copyWith({
    Value<int>? notificationId,
    Value<String>? taskId,
    Value<String>? reminderType,
    Value<DateTime>? scheduledAt,
    Value<DateTime?>? deadlineSnapshot,
    Value<String>? title,
    Value<String>? body,
    Value<String>? payload,
    Value<String>? status,
    Value<DateTime>? createdAt,
  }) {
    return ScheduledNotificationsTableCompanion(
      notificationId: notificationId ?? this.notificationId,
      taskId: taskId ?? this.taskId,
      reminderType: reminderType ?? this.reminderType,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      deadlineSnapshot: deadlineSnapshot ?? this.deadlineSnapshot,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (reminderType.present) {
      map['reminder_type'] = Variable<String>(reminderType.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (deadlineSnapshot.present) {
      map['deadline_snapshot'] = Variable<DateTime>(deadlineSnapshot.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledNotificationsTableCompanion(')
          ..write('notificationId: $notificationId, ')
          ..write('taskId: $taskId, ')
          ..write('reminderType: $reminderType, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('deadlineSnapshot: $deadlineSnapshot, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppMetadataTableTable appMetadataTable = $AppMetadataTableTable(
    this,
  );
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $ScheduledNotificationsTableTable scheduledNotificationsTable =
      $ScheduledNotificationsTableTable(this);
  late final Index idxTasksDeadline = Index(
    'idx_tasks_deadline',
    'CREATE INDEX idx_tasks_deadline ON tasks_table (deadline)',
  );
  late final Index idxTasksStatus = Index(
    'idx_tasks_status',
    'CREATE INDEX idx_tasks_status ON tasks_table (status)',
  );
  late final Index idxTasksCategory = Index(
    'idx_tasks_category',
    'CREATE INDEX idx_tasks_category ON tasks_table (category_id)',
  );
  late final Index idxTasksPriority = Index(
    'idx_tasks_priority',
    'CREATE INDEX idx_tasks_priority ON tasks_table (priority)',
  );
  late final Index idxNotificationsTaskId = Index(
    'idx_notifications_task_id',
    'CREATE INDEX idx_notifications_task_id ON scheduled_notifications_table (task_id)',
  );
  late final Index idxNotificationsStatus = Index(
    'idx_notifications_status',
    'CREATE INDEX idx_notifications_status ON scheduled_notifications_table (status)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMetadataTable,
    categoriesTable,
    tasksTable,
    scheduledNotificationsTable,
    idxTasksDeadline,
    idxTasksStatus,
    idxTasksCategory,
    idxTasksPriority,
    idxNotificationsTaskId,
    idxNotificationsStatus,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories_table',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('tasks_table', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('scheduled_notifications_table', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks_table',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('scheduled_notifications_table', kind: UpdateKind.update),
      ],
    ),
  ]);
}

typedef $$AppMetadataTableTableCreateCompanionBuilder =
    AppMetadataTableCompanion Function({
      required String key,
      required String value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AppMetadataTableTableUpdateCompanionBuilder =
    AppMetadataTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppMetadataTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetadataTableTable> {
  $$AppMetadataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetadataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetadataTableTable> {
  $$AppMetadataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetadataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetadataTableTable> {
  $$AppMetadataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppMetadataTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetadataTableTable,
          AppMetadataEntry,
          $$AppMetadataTableTableFilterComposer,
          $$AppMetadataTableTableOrderingComposer,
          $$AppMetadataTableTableAnnotationComposer,
          $$AppMetadataTableTableCreateCompanionBuilder,
          $$AppMetadataTableTableUpdateCompanionBuilder,
          (
            AppMetadataEntry,
            BaseReferences<
              _$AppDatabase,
              $AppMetadataTableTable,
              AppMetadataEntry
            >,
          ),
          AppMetadataEntry,
          PrefetchHooks Function()
        > {
  $$AppMetadataTableTableTableManager(
    _$AppDatabase db,
    $AppMetadataTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$AppMetadataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AppMetadataTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$AppMetadataTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataTableCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataTableCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetadataTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetadataTableTable,
      AppMetadataEntry,
      $$AppMetadataTableTableFilterComposer,
      $$AppMetadataTableTableOrderingComposer,
      $$AppMetadataTableTableAnnotationComposer,
      $$AppMetadataTableTableCreateCompanionBuilder,
      $$AppMetadataTableTableUpdateCompanionBuilder,
      (
        AppMetadataEntry,
        BaseReferences<_$AppDatabase, $AppMetadataTableTable, AppMetadataEntry>,
      ),
      AppMetadataEntry,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      required String id,
      required String name,
      required String color,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> color,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CategoriesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryEntry> {
  $$CategoriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TasksTableTable, List<TaskEntry>>
  _tasksTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tasksTable,
    aliasName: $_aliasNameGenerator(
      db.categoriesTable.id,
      db.tasksTable.categoryId,
    ),
  );

  $$TasksTableTableProcessedTableManager get tasksTableRefs {
    final manager = $$TasksTableTableTableManager(
      $_db,
      $_db.tasksTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tasksTableRefs(
    Expression<bool> Function($$TasksTableTableFilterComposer f) f,
  ) {
    final $$TasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableFilterComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> tasksTableRefs<T extends Object>(
    Expression<T> Function($$TasksTableTableAnnotationComposer a) f,
  ) {
    final $$TasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoryEntry,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (CategoryEntry, $$CategoriesTableTableReferences),
          CategoryEntry,
          PrefetchHooks Function({bool tasksTableRefs})
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CategoriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$CategoriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                name: name,
                color: color,
                isDefault: isDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String color,
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                name: name,
                color: color,
                isDefault: isDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CategoriesTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({tasksTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tasksTableRefs) db.tasksTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksTableRefs)
                    await $_getPrefetchedData<
                      CategoryEntry,
                      $CategoriesTableTable,
                      TaskEntry
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableTableReferences
                          ._tasksTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.categoryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoryEntry,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (CategoryEntry, $$CategoriesTableTableReferences),
      CategoryEntry,
      PrefetchHooks Function({bool tasksTableRefs})
    >;
typedef $$TasksTableTableCreateCompanionBuilder =
    TasksTableCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      required String priority,
      required String categoryId,
      Value<DateTime?> deadline,
      Value<DateTime?> reminderAt,
      required String status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TasksTableTableUpdateCompanionBuilder =
    TasksTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<String> priority,
      Value<String> categoryId,
      Value<DateTime?> deadline,
      Value<DateTime?> reminderAt,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TasksTableTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTableTable, TaskEntry> {
  $$TasksTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) =>
      db.categoriesTable.createAlias(
        $_aliasNameGenerator(db.tasksTable.categoryId, db.categoriesTable.id),
      );

  $$CategoriesTableTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ScheduledNotificationsTableTable,
    List<ScheduledNotificationEntry>
  >
  _scheduledNotificationsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.scheduledNotificationsTable,
        aliasName: $_aliasNameGenerator(
          db.tasksTable.id,
          db.scheduledNotificationsTable.taskId,
        ),
      );

  $$ScheduledNotificationsTableTableProcessedTableManager
  get scheduledNotificationsTableRefs {
    final manager = $$ScheduledNotificationsTableTableTableManager(
      $_db,
      $_db.scheduledNotificationsTable,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scheduledNotificationsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableTableFilterComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> scheduledNotificationsTableRefs(
    Expression<bool> Function(
      $$ScheduledNotificationsTableTableFilterComposer f,
    )
    f,
  ) {
    final $$ScheduledNotificationsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.scheduledNotificationsTable,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ScheduledNotificationsTableTableFilterComposer(
                $db: $db,
                $table: $db.scheduledNotificationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> scheduledNotificationsTableRefs<T extends Object>(
    Expression<T> Function(
      $$ScheduledNotificationsTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$ScheduledNotificationsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.scheduledNotificationsTable,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ScheduledNotificationsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.scheduledNotificationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TasksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTableTable,
          TaskEntry,
          $$TasksTableTableFilterComposer,
          $$TasksTableTableOrderingComposer,
          $$TasksTableTableAnnotationComposer,
          $$TasksTableTableCreateCompanionBuilder,
          $$TasksTableTableUpdateCompanionBuilder,
          (TaskEntry, $$TasksTableTableReferences),
          TaskEntry,
          PrefetchHooks Function({
            bool categoryId,
            bool scheduledNotificationsTableRefs,
          })
        > {
  $$TasksTableTableTableManager(_$AppDatabase db, $TasksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion(
                id: id,
                title: title,
                description: description,
                priority: priority,
                categoryId: categoryId,
                deadline: deadline,
                reminderAt: reminderAt,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                required String priority,
                required String categoryId,
                Value<DateTime?> deadline = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                required String status,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                priority: priority,
                categoryId: categoryId,
                deadline: deadline,
                reminderAt: reminderAt,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TasksTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            categoryId = false,
            scheduledNotificationsTableRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (scheduledNotificationsTableRefs)
                  db.scheduledNotificationsTable,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (categoryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TasksTableTableReferences
                                ._categoryIdTable(db),
                            referencedColumn:
                                $$TasksTableTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (scheduledNotificationsTableRefs)
                    await $_getPrefetchedData<
                      TaskEntry,
                      $TasksTableTable,
                      ScheduledNotificationEntry
                    >(
                      currentTable: table,
                      referencedTable: $$TasksTableTableReferences
                          ._scheduledNotificationsTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TasksTableTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduledNotificationsTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TasksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTableTable,
      TaskEntry,
      $$TasksTableTableFilterComposer,
      $$TasksTableTableOrderingComposer,
      $$TasksTableTableAnnotationComposer,
      $$TasksTableTableCreateCompanionBuilder,
      $$TasksTableTableUpdateCompanionBuilder,
      (TaskEntry, $$TasksTableTableReferences),
      TaskEntry,
      PrefetchHooks Function({
        bool categoryId,
        bool scheduledNotificationsTableRefs,
      })
    >;
typedef $$ScheduledNotificationsTableTableCreateCompanionBuilder =
    ScheduledNotificationsTableCompanion Function({
      Value<int> notificationId,
      required String taskId,
      required String reminderType,
      required DateTime scheduledAt,
      Value<DateTime?> deadlineSnapshot,
      required String title,
      required String body,
      required String payload,
      required String status,
      Value<DateTime> createdAt,
    });
typedef $$ScheduledNotificationsTableTableUpdateCompanionBuilder =
    ScheduledNotificationsTableCompanion Function({
      Value<int> notificationId,
      Value<String> taskId,
      Value<String> reminderType,
      Value<DateTime> scheduledAt,
      Value<DateTime?> deadlineSnapshot,
      Value<String> title,
      Value<String> body,
      Value<String> payload,
      Value<String> status,
      Value<DateTime> createdAt,
    });

final class $$ScheduledNotificationsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ScheduledNotificationsTableTable,
          ScheduledNotificationEntry
        > {
  $$ScheduledNotificationsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTableTable _taskIdTable(_$AppDatabase db) =>
      db.tasksTable.createAlias(
        $_aliasNameGenerator(
          db.scheduledNotificationsTable.taskId,
          db.tasksTable.id,
        ),
      );

  $$TasksTableTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableTableManager(
      $_db,
      $_db.tasksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScheduledNotificationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledNotificationsTableTable> {
  $$ScheduledNotificationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadlineSnapshot => $composableBuilder(
    column: $table.deadlineSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableTableFilterComposer get taskId {
    final $$TasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableFilterComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledNotificationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledNotificationsTableTable> {
  $$ScheduledNotificationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadlineSnapshot => $composableBuilder(
    column: $table.deadlineSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableTableOrderingComposer get taskId {
    final $$TasksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableOrderingComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledNotificationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledNotificationsTableTable> {
  $$ScheduledNotificationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deadlineSnapshot => $composableBuilder(
    column: $table.deadlineSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TasksTableTableAnnotationComposer get taskId {
    final $$TasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledNotificationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduledNotificationsTableTable,
          ScheduledNotificationEntry,
          $$ScheduledNotificationsTableTableFilterComposer,
          $$ScheduledNotificationsTableTableOrderingComposer,
          $$ScheduledNotificationsTableTableAnnotationComposer,
          $$ScheduledNotificationsTableTableCreateCompanionBuilder,
          $$ScheduledNotificationsTableTableUpdateCompanionBuilder,
          (
            ScheduledNotificationEntry,
            $$ScheduledNotificationsTableTableReferences,
          ),
          ScheduledNotificationEntry,
          PrefetchHooks Function({bool taskId})
        > {
  $$ScheduledNotificationsTableTableTableManager(
    _$AppDatabase db,
    $ScheduledNotificationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ScheduledNotificationsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ScheduledNotificationsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ScheduledNotificationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> notificationId = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> reminderType = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<DateTime?> deadlineSnapshot = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ScheduledNotificationsTableCompanion(
                notificationId: notificationId,
                taskId: taskId,
                reminderType: reminderType,
                scheduledAt: scheduledAt,
                deadlineSnapshot: deadlineSnapshot,
                title: title,
                body: body,
                payload: payload,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> notificationId = const Value.absent(),
                required String taskId,
                required String reminderType,
                required DateTime scheduledAt,
                Value<DateTime?> deadlineSnapshot = const Value.absent(),
                required String title,
                required String body,
                required String payload,
                required String status,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ScheduledNotificationsTableCompanion.insert(
                notificationId: notificationId,
                taskId: taskId,
                reminderType: reminderType,
                scheduledAt: scheduledAt,
                deadlineSnapshot: deadlineSnapshot,
                title: title,
                body: body,
                payload: payload,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ScheduledNotificationsTableTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (taskId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable:
                                $$ScheduledNotificationsTableTableReferences
                                    ._taskIdTable(db),
                            referencedColumn:
                                $$ScheduledNotificationsTableTableReferences
                                    ._taskIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScheduledNotificationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduledNotificationsTableTable,
      ScheduledNotificationEntry,
      $$ScheduledNotificationsTableTableFilterComposer,
      $$ScheduledNotificationsTableTableOrderingComposer,
      $$ScheduledNotificationsTableTableAnnotationComposer,
      $$ScheduledNotificationsTableTableCreateCompanionBuilder,
      $$ScheduledNotificationsTableTableUpdateCompanionBuilder,
      (
        ScheduledNotificationEntry,
        $$ScheduledNotificationsTableTableReferences,
      ),
      ScheduledNotificationEntry,
      PrefetchHooks Function({bool taskId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppMetadataTableTableTableManager get appMetadataTable =>
      $$AppMetadataTableTableTableManager(_db, _db.appMetadataTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
  $$ScheduledNotificationsTableTableTableManager
  get scheduledNotificationsTable =>
      $$ScheduledNotificationsTableTableTableManager(
        _db,
        _db.scheduledNotificationsTable,
      );
}
