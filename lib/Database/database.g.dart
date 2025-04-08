// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TaskTableTable extends TaskTable
    with TableInfo<$TaskTableTable, TaskTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventNameMeta = const VerificationMeta(
    'eventName',
  );
  @override
  late final GeneratedColumn<String> eventName = GeneratedColumn<String>(
    'event_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventCategoryMeta = const VerificationMeta(
    'eventCategory',
  );
  @override
  late final GeneratedColumn<String> eventCategory = GeneratedColumn<String>(
    'event_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventPriorityMeta = const VerificationMeta(
    'eventPriority',
  );
  @override
  late final GeneratedColumn<String> eventPriority = GeneratedColumn<String>(
    'event_priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anticipatedTimeMeta = const VerificationMeta(
    'anticipatedTime',
  );
  @override
  late final GeneratedColumn<int> anticipatedTime = GeneratedColumn<int>(
    'anticipated_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventName,
    eventCategory,
    eventPriority,
    startDate,
    endDate,
    startTime,
    endTime,
    anticipatedTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_name')) {
      context.handle(
        _eventNameMeta,
        eventName.isAcceptableOrUnknown(data['event_name']!, _eventNameMeta),
      );
    } else if (isInserting) {
      context.missing(_eventNameMeta);
    }
    if (data.containsKey('event_category')) {
      context.handle(
        _eventCategoryMeta,
        eventCategory.isAcceptableOrUnknown(
          data['event_category']!,
          _eventCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_eventCategoryMeta);
    }
    if (data.containsKey('event_priority')) {
      context.handle(
        _eventPriorityMeta,
        eventPriority.isAcceptableOrUnknown(
          data['event_priority']!,
          _eventPriorityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_eventPriorityMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('anticipated_time')) {
      context.handle(
        _anticipatedTimeMeta,
        anticipatedTime.isAcceptableOrUnknown(
          data['anticipated_time']!,
          _anticipatedTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_anticipatedTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      eventName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_name'],
          )!,
      eventCategory:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_category'],
          )!,
      eventPriority:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_priority'],
          )!,
      startDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_date'],
          )!,
      endDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}end_date'],
          )!,
      startTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_time'],
          )!,
      endTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}end_time'],
          )!,
      anticipatedTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}anticipated_time'],
          )!,
    );
  }

  @override
  $TaskTableTable createAlias(String alias) {
    return $TaskTableTable(attachedDatabase, alias);
  }
}

class TaskTableData extends DataClass implements Insertable<TaskTableData> {
  final int id;
  final String eventName;
  final String eventCategory;
  final String eventPriority;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime startTime;
  final DateTime endTime;
  final int anticipatedTime;
  const TaskTableData({
    required this.id,
    required this.eventName,
    required this.eventCategory,
    required this.eventPriority,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.anticipatedTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_name'] = Variable<String>(eventName);
    map['event_category'] = Variable<String>(eventCategory);
    map['event_priority'] = Variable<String>(eventPriority);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['anticipated_time'] = Variable<int>(anticipatedTime);
    return map;
  }

  TaskTableCompanion toCompanion(bool nullToAbsent) {
    return TaskTableCompanion(
      id: Value(id),
      eventName: Value(eventName),
      eventCategory: Value(eventCategory),
      eventPriority: Value(eventPriority),
      startDate: Value(startDate),
      endDate: Value(endDate),
      startTime: Value(startTime),
      endTime: Value(endTime),
      anticipatedTime: Value(anticipatedTime),
    );
  }

  factory TaskTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskTableData(
      id: serializer.fromJson<int>(json['id']),
      eventName: serializer.fromJson<String>(json['eventName']),
      eventCategory: serializer.fromJson<String>(json['eventCategory']),
      eventPriority: serializer.fromJson<String>(json['eventPriority']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      anticipatedTime: serializer.fromJson<int>(json['anticipatedTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventName': serializer.toJson<String>(eventName),
      'eventCategory': serializer.toJson<String>(eventCategory),
      'eventPriority': serializer.toJson<String>(eventPriority),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'anticipatedTime': serializer.toJson<int>(anticipatedTime),
    };
  }

  TaskTableData copyWith({
    int? id,
    String? eventName,
    String? eventCategory,
    String? eventPriority,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? startTime,
    DateTime? endTime,
    int? anticipatedTime,
  }) => TaskTableData(
    id: id ?? this.id,
    eventName: eventName ?? this.eventName,
    eventCategory: eventCategory ?? this.eventCategory,
    eventPriority: eventPriority ?? this.eventPriority,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    anticipatedTime: anticipatedTime ?? this.anticipatedTime,
  );
  TaskTableData copyWithCompanion(TaskTableCompanion data) {
    return TaskTableData(
      id: data.id.present ? data.id.value : this.id,
      eventName: data.eventName.present ? data.eventName.value : this.eventName,
      eventCategory:
          data.eventCategory.present
              ? data.eventCategory.value
              : this.eventCategory,
      eventPriority:
          data.eventPriority.present
              ? data.eventPriority.value
              : this.eventPriority,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      anticipatedTime:
          data.anticipatedTime.present
              ? data.anticipatedTime.value
              : this.anticipatedTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskTableData(')
          ..write('id: $id, ')
          ..write('eventName: $eventName, ')
          ..write('eventCategory: $eventCategory, ')
          ..write('eventPriority: $eventPriority, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('anticipatedTime: $anticipatedTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventName,
    eventCategory,
    eventPriority,
    startDate,
    endDate,
    startTime,
    endTime,
    anticipatedTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskTableData &&
          other.id == this.id &&
          other.eventName == this.eventName &&
          other.eventCategory == this.eventCategory &&
          other.eventPriority == this.eventPriority &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.anticipatedTime == this.anticipatedTime);
}

class TaskTableCompanion extends UpdateCompanion<TaskTableData> {
  final Value<int> id;
  final Value<String> eventName;
  final Value<String> eventCategory;
  final Value<String> eventPriority;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int> anticipatedTime;
  const TaskTableCompanion({
    this.id = const Value.absent(),
    this.eventName = const Value.absent(),
    this.eventCategory = const Value.absent(),
    this.eventPriority = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.anticipatedTime = const Value.absent(),
  });
  TaskTableCompanion.insert({
    this.id = const Value.absent(),
    required String eventName,
    required String eventCategory,
    required String eventPriority,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime startTime,
    required DateTime endTime,
    required int anticipatedTime,
  }) : eventName = Value(eventName),
       eventCategory = Value(eventCategory),
       eventPriority = Value(eventPriority),
       startDate = Value(startDate),
       endDate = Value(endDate),
       startTime = Value(startTime),
       endTime = Value(endTime),
       anticipatedTime = Value(anticipatedTime);
  static Insertable<TaskTableData> custom({
    Expression<int>? id,
    Expression<String>? eventName,
    Expression<String>? eventCategory,
    Expression<String>? eventPriority,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? anticipatedTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventName != null) 'event_name': eventName,
      if (eventCategory != null) 'event_category': eventCategory,
      if (eventPriority != null) 'event_priority': eventPriority,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (anticipatedTime != null) 'anticipated_time': anticipatedTime,
    });
  }

  TaskTableCompanion copyWith({
    Value<int>? id,
    Value<String>? eventName,
    Value<String>? eventCategory,
    Value<String>? eventPriority,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<int>? anticipatedTime,
  }) {
    return TaskTableCompanion(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      eventCategory: eventCategory ?? this.eventCategory,
      eventPriority: eventPriority ?? this.eventPriority,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      anticipatedTime: anticipatedTime ?? this.anticipatedTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventName.present) {
      map['event_name'] = Variable<String>(eventName.value);
    }
    if (eventCategory.present) {
      map['event_category'] = Variable<String>(eventCategory.value);
    }
    if (eventPriority.present) {
      map['event_priority'] = Variable<String>(eventPriority.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (anticipatedTime.present) {
      map['anticipated_time'] = Variable<int>(anticipatedTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskTableCompanion(')
          ..write('id: $id, ')
          ..write('eventName: $eventName, ')
          ..write('eventCategory: $eventCategory, ')
          ..write('eventPriority: $eventPriority, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('anticipatedTime: $anticipatedTime')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskTableTable taskTable = $TaskTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [taskTable];
}

typedef $$TaskTableTableCreateCompanionBuilder =
    TaskTableCompanion Function({
      Value<int> id,
      required String eventName,
      required String eventCategory,
      required String eventPriority,
      required DateTime startDate,
      required DateTime endDate,
      required DateTime startTime,
      required DateTime endTime,
      required int anticipatedTime,
    });
typedef $$TaskTableTableUpdateCompanionBuilder =
    TaskTableCompanion Function({
      Value<int> id,
      Value<String> eventName,
      Value<String> eventCategory,
      Value<String> eventPriority,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<int> anticipatedTime,
    });

class $$TaskTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaskTableTable> {
  $$TaskTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventName => $composableBuilder(
    column: $table.eventName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventCategory => $composableBuilder(
    column: $table.eventCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventPriority => $composableBuilder(
    column: $table.eventPriority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anticipatedTime => $composableBuilder(
    column: $table.anticipatedTime,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskTableTable> {
  $$TaskTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventName => $composableBuilder(
    column: $table.eventName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventCategory => $composableBuilder(
    column: $table.eventCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventPriority => $composableBuilder(
    column: $table.eventPriority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anticipatedTime => $composableBuilder(
    column: $table.anticipatedTime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskTableTable> {
  $$TaskTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventName =>
      $composableBuilder(column: $table.eventName, builder: (column) => column);

  GeneratedColumn<String> get eventCategory => $composableBuilder(
    column: $table.eventCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventPriority => $composableBuilder(
    column: $table.eventPriority,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get anticipatedTime => $composableBuilder(
    column: $table.anticipatedTime,
    builder: (column) => column,
  );
}

class $$TaskTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskTableTable,
          TaskTableData,
          $$TaskTableTableFilterComposer,
          $$TaskTableTableOrderingComposer,
          $$TaskTableTableAnnotationComposer,
          $$TaskTableTableCreateCompanionBuilder,
          $$TaskTableTableUpdateCompanionBuilder,
          (
            TaskTableData,
            BaseReferences<_$AppDatabase, $TaskTableTable, TaskTableData>,
          ),
          TaskTableData,
          PrefetchHooks Function()
        > {
  $$TaskTableTableTableManager(_$AppDatabase db, $TaskTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TaskTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TaskTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventName = const Value.absent(),
                Value<String> eventCategory = const Value.absent(),
                Value<String> eventPriority = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<int> anticipatedTime = const Value.absent(),
              }) => TaskTableCompanion(
                id: id,
                eventName: eventName,
                eventCategory: eventCategory,
                eventPriority: eventPriority,
                startDate: startDate,
                endDate: endDate,
                startTime: startTime,
                endTime: endTime,
                anticipatedTime: anticipatedTime,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventName,
                required String eventCategory,
                required String eventPriority,
                required DateTime startDate,
                required DateTime endDate,
                required DateTime startTime,
                required DateTime endTime,
                required int anticipatedTime,
              }) => TaskTableCompanion.insert(
                id: id,
                eventName: eventName,
                eventCategory: eventCategory,
                eventPriority: eventPriority,
                startDate: startDate,
                endDate: endDate,
                startTime: startTime,
                endTime: endTime,
                anticipatedTime: anticipatedTime,
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

typedef $$TaskTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskTableTable,
      TaskTableData,
      $$TaskTableTableFilterComposer,
      $$TaskTableTableOrderingComposer,
      $$TaskTableTableAnnotationComposer,
      $$TaskTableTableCreateCompanionBuilder,
      $$TaskTableTableUpdateCompanionBuilder,
      (
        TaskTableData,
        BaseReferences<_$AppDatabase, $TaskTableTable, TaskTableData>,
      ),
      TaskTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskTableTableTableManager get taskTable =>
      $$TaskTableTableTableManager(_db, _db.taskTable);
}
