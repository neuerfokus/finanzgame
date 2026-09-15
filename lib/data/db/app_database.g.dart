// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GameClockTableTable extends GameClockTable
    with TableInfo<$GameClockTableTable, GameClockRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameClockTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, dayIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_clock_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameClockRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameClockRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameClockRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
    );
  }

  @override
  $GameClockTableTable createAlias(String alias) {
    return $GameClockTableTable(attachedDatabase, alias);
  }
}

class GameClockRow extends DataClass implements Insertable<GameClockRow> {
  final int id;
  final int dayIndex;
  const GameClockRow({required this.id, required this.dayIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_index'] = Variable<int>(dayIndex);
    return map;
  }

  GameClockTableCompanion toCompanion(bool nullToAbsent) {
    return GameClockTableCompanion(id: Value(id), dayIndex: Value(dayIndex));
  }

  factory GameClockRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameClockRow(
      id: serializer.fromJson<int>(json['id']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayIndex': serializer.toJson<int>(dayIndex),
    };
  }

  GameClockRow copyWith({int? id, int? dayIndex}) =>
      GameClockRow(id: id ?? this.id, dayIndex: dayIndex ?? this.dayIndex);
  GameClockRow copyWithCompanion(GameClockTableCompanion data) {
    return GameClockRow(
      id: data.id.present ? data.id.value : this.id,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameClockRow(')
          ..write('id: $id, ')
          ..write('dayIndex: $dayIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dayIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameClockRow &&
          other.id == this.id &&
          other.dayIndex == this.dayIndex);
}

class GameClockTableCompanion extends UpdateCompanion<GameClockRow> {
  final Value<int> id;
  final Value<int> dayIndex;
  const GameClockTableCompanion({
    this.id = const Value.absent(),
    this.dayIndex = const Value.absent(),
  });
  GameClockTableCompanion.insert({
    this.id = const Value.absent(),
    this.dayIndex = const Value.absent(),
  });
  static Insertable<GameClockRow> custom({
    Expression<int>? id,
    Expression<int>? dayIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayIndex != null) 'day_index': dayIndex,
    });
  }

  GameClockTableCompanion copyWith({Value<int>? id, Value<int>? dayIndex}) {
    return GameClockTableCompanion(
      id: id ?? this.id,
      dayIndex: dayIndex ?? this.dayIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameClockTableCompanion(')
          ..write('id: $id, ')
          ..write('dayIndex: $dayIndex')
          ..write(')'))
        .toString();
  }
}

class $CashTableTable extends CashTable
    with TableInfo<$CashTableTable, CashRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _centsMeta = const VerificationMeta('cents');
  @override
  late final GeneratedColumn<int> cents = GeneratedColumn<int>(
    'cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5000),
  );
  static const VerificationMeta _plantHarvestTotalCentsMeta =
      const VerificationMeta('plantHarvestTotalCents');
  @override
  late final GeneratedColumn<int> plantHarvestTotalCents = GeneratedColumn<int>(
    'plant_harvest_total_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, cents, plantHarvestTotalCents];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cents')) {
      context.handle(
        _centsMeta,
        cents.isAcceptableOrUnknown(data['cents']!, _centsMeta),
      );
    }
    if (data.containsKey('plant_harvest_total_cents')) {
      context.handle(
        _plantHarvestTotalCentsMeta,
        plantHarvestTotalCents.isAcceptableOrUnknown(
          data['plant_harvest_total_cents']!,
          _plantHarvestTotalCentsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cents'],
      )!,
      plantHarvestTotalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plant_harvest_total_cents'],
      )!,
    );
  }

  @override
  $CashTableTable createAlias(String alias) {
    return $CashTableTable(attachedDatabase, alias);
  }
}

class CashRow extends DataClass implements Insertable<CashRow> {
  final int id;
  final int cents;
  final int plantHarvestTotalCents;
  const CashRow({
    required this.id,
    required this.cents,
    required this.plantHarvestTotalCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cents'] = Variable<int>(cents);
    map['plant_harvest_total_cents'] = Variable<int>(plantHarvestTotalCents);
    return map;
  }

  CashTableCompanion toCompanion(bool nullToAbsent) {
    return CashTableCompanion(
      id: Value(id),
      cents: Value(cents),
      plantHarvestTotalCents: Value(plantHarvestTotalCents),
    );
  }

  factory CashRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashRow(
      id: serializer.fromJson<int>(json['id']),
      cents: serializer.fromJson<int>(json['cents']),
      plantHarvestTotalCents: serializer.fromJson<int>(
        json['plantHarvestTotalCents'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cents': serializer.toJson<int>(cents),
      'plantHarvestTotalCents': serializer.toJson<int>(plantHarvestTotalCents),
    };
  }

  CashRow copyWith({int? id, int? cents, int? plantHarvestTotalCents}) =>
      CashRow(
        id: id ?? this.id,
        cents: cents ?? this.cents,
        plantHarvestTotalCents:
            plantHarvestTotalCents ?? this.plantHarvestTotalCents,
      );
  CashRow copyWithCompanion(CashTableCompanion data) {
    return CashRow(
      id: data.id.present ? data.id.value : this.id,
      cents: data.cents.present ? data.cents.value : this.cents,
      plantHarvestTotalCents: data.plantHarvestTotalCents.present
          ? data.plantHarvestTotalCents.value
          : this.plantHarvestTotalCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashRow(')
          ..write('id: $id, ')
          ..write('cents: $cents, ')
          ..write('plantHarvestTotalCents: $plantHarvestTotalCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cents, plantHarvestTotalCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashRow &&
          other.id == this.id &&
          other.cents == this.cents &&
          other.plantHarvestTotalCents == this.plantHarvestTotalCents);
}

class CashTableCompanion extends UpdateCompanion<CashRow> {
  final Value<int> id;
  final Value<int> cents;
  final Value<int> plantHarvestTotalCents;
  const CashTableCompanion({
    this.id = const Value.absent(),
    this.cents = const Value.absent(),
    this.plantHarvestTotalCents = const Value.absent(),
  });
  CashTableCompanion.insert({
    this.id = const Value.absent(),
    this.cents = const Value.absent(),
    this.plantHarvestTotalCents = const Value.absent(),
  });
  static Insertable<CashRow> custom({
    Expression<int>? id,
    Expression<int>? cents,
    Expression<int>? plantHarvestTotalCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cents != null) 'cents': cents,
      if (plantHarvestTotalCents != null)
        'plant_harvest_total_cents': plantHarvestTotalCents,
    });
  }

  CashTableCompanion copyWith({
    Value<int>? id,
    Value<int>? cents,
    Value<int>? plantHarvestTotalCents,
  }) {
    return CashTableCompanion(
      id: id ?? this.id,
      cents: cents ?? this.cents,
      plantHarvestTotalCents:
          plantHarvestTotalCents ?? this.plantHarvestTotalCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cents.present) {
      map['cents'] = Variable<int>(cents.value);
    }
    if (plantHarvestTotalCents.present) {
      map['plant_harvest_total_cents'] = Variable<int>(
        plantHarvestTotalCents.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashTableCompanion(')
          ..write('id: $id, ')
          ..write('cents: $cents, ')
          ..write('plantHarvestTotalCents: $plantHarvestTotalCents')
          ..write(')'))
        .toString();
  }
}

class $PlantsTableTable extends PlantsTable
    with TableInfo<$PlantsTableTable, PlantRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _islandIdMeta = const VerificationMeta(
    'islandId',
  );
  @override
  late final GeneratedColumn<String> islandId = GeneratedColumn<String>(
    'island_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plotIndexMeta = const VerificationMeta(
    'plotIndex',
  );
  @override
  late final GeneratedColumn<int> plotIndex = GeneratedColumn<int>(
    'plot_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plantedOnDayIndexMeta = const VerificationMeta(
    'plantedOnDayIndex',
  );
  @override
  late final GeneratedColumn<int> plantedOnDayIndex = GeneratedColumn<int>(
    'planted_on_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStageMeta = const VerificationMeta(
    'currentStage',
  );
  @override
  late final GeneratedColumn<int> currentStage = GeneratedColumn<int>(
    'current_stage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _growthProgressMeta = const VerificationMeta(
    'growthProgress',
  );
  @override
  late final GeneratedColumn<int> growthProgress = GeneratedColumn<int>(
    'growth_progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('growing'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    islandId,
    plotIndex,
    kind,
    plantedOnDayIndex,
    currentStage,
    growthProgress,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plants_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlantRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('island_id')) {
      context.handle(
        _islandIdMeta,
        islandId.isAcceptableOrUnknown(data['island_id']!, _islandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_islandIdMeta);
    }
    if (data.containsKey('plot_index')) {
      context.handle(
        _plotIndexMeta,
        plotIndex.isAcceptableOrUnknown(data['plot_index']!, _plotIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_plotIndexMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('planted_on_day_index')) {
      context.handle(
        _plantedOnDayIndexMeta,
        plantedOnDayIndex.isAcceptableOrUnknown(
          data['planted_on_day_index']!,
          _plantedOnDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plantedOnDayIndexMeta);
    }
    if (data.containsKey('current_stage')) {
      context.handle(
        _currentStageMeta,
        currentStage.isAcceptableOrUnknown(
          data['current_stage']!,
          _currentStageMeta,
        ),
      );
    }
    if (data.containsKey('growth_progress')) {
      context.handle(
        _growthProgressMeta,
        growthProgress.isAcceptableOrUnknown(
          data['growth_progress']!,
          _growthProgressMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlantRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlantRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      islandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}island_id'],
      )!,
      plotIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plot_index'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      plantedOnDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planted_on_day_index'],
      )!,
      currentStage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_stage'],
      )!,
      growthProgress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}growth_progress'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $PlantsTableTable createAlias(String alias) {
    return $PlantsTableTable(attachedDatabase, alias);
  }
}

class PlantRow extends DataClass implements Insertable<PlantRow> {
  final String id;
  final String islandId;
  final int plotIndex;
  final String kind;
  final int plantedOnDayIndex;
  final int currentStage;
  final int growthProgress;
  final String status;
  const PlantRow({
    required this.id,
    required this.islandId,
    required this.plotIndex,
    required this.kind,
    required this.plantedOnDayIndex,
    required this.currentStage,
    required this.growthProgress,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['island_id'] = Variable<String>(islandId);
    map['plot_index'] = Variable<int>(plotIndex);
    map['kind'] = Variable<String>(kind);
    map['planted_on_day_index'] = Variable<int>(plantedOnDayIndex);
    map['current_stage'] = Variable<int>(currentStage);
    map['growth_progress'] = Variable<int>(growthProgress);
    map['status'] = Variable<String>(status);
    return map;
  }

  PlantsTableCompanion toCompanion(bool nullToAbsent) {
    return PlantsTableCompanion(
      id: Value(id),
      islandId: Value(islandId),
      plotIndex: Value(plotIndex),
      kind: Value(kind),
      plantedOnDayIndex: Value(plantedOnDayIndex),
      currentStage: Value(currentStage),
      growthProgress: Value(growthProgress),
      status: Value(status),
    );
  }

  factory PlantRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlantRow(
      id: serializer.fromJson<String>(json['id']),
      islandId: serializer.fromJson<String>(json['islandId']),
      plotIndex: serializer.fromJson<int>(json['plotIndex']),
      kind: serializer.fromJson<String>(json['kind']),
      plantedOnDayIndex: serializer.fromJson<int>(json['plantedOnDayIndex']),
      currentStage: serializer.fromJson<int>(json['currentStage']),
      growthProgress: serializer.fromJson<int>(json['growthProgress']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'islandId': serializer.toJson<String>(islandId),
      'plotIndex': serializer.toJson<int>(plotIndex),
      'kind': serializer.toJson<String>(kind),
      'plantedOnDayIndex': serializer.toJson<int>(plantedOnDayIndex),
      'currentStage': serializer.toJson<int>(currentStage),
      'growthProgress': serializer.toJson<int>(growthProgress),
      'status': serializer.toJson<String>(status),
    };
  }

  PlantRow copyWith({
    String? id,
    String? islandId,
    int? plotIndex,
    String? kind,
    int? plantedOnDayIndex,
    int? currentStage,
    int? growthProgress,
    String? status,
  }) => PlantRow(
    id: id ?? this.id,
    islandId: islandId ?? this.islandId,
    plotIndex: plotIndex ?? this.plotIndex,
    kind: kind ?? this.kind,
    plantedOnDayIndex: plantedOnDayIndex ?? this.plantedOnDayIndex,
    currentStage: currentStage ?? this.currentStage,
    growthProgress: growthProgress ?? this.growthProgress,
    status: status ?? this.status,
  );
  PlantRow copyWithCompanion(PlantsTableCompanion data) {
    return PlantRow(
      id: data.id.present ? data.id.value : this.id,
      islandId: data.islandId.present ? data.islandId.value : this.islandId,
      plotIndex: data.plotIndex.present ? data.plotIndex.value : this.plotIndex,
      kind: data.kind.present ? data.kind.value : this.kind,
      plantedOnDayIndex: data.plantedOnDayIndex.present
          ? data.plantedOnDayIndex.value
          : this.plantedOnDayIndex,
      currentStage: data.currentStage.present
          ? data.currentStage.value
          : this.currentStage,
      growthProgress: data.growthProgress.present
          ? data.growthProgress.value
          : this.growthProgress,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlantRow(')
          ..write('id: $id, ')
          ..write('islandId: $islandId, ')
          ..write('plotIndex: $plotIndex, ')
          ..write('kind: $kind, ')
          ..write('plantedOnDayIndex: $plantedOnDayIndex, ')
          ..write('currentStage: $currentStage, ')
          ..write('growthProgress: $growthProgress, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    islandId,
    plotIndex,
    kind,
    plantedOnDayIndex,
    currentStage,
    growthProgress,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlantRow &&
          other.id == this.id &&
          other.islandId == this.islandId &&
          other.plotIndex == this.plotIndex &&
          other.kind == this.kind &&
          other.plantedOnDayIndex == this.plantedOnDayIndex &&
          other.currentStage == this.currentStage &&
          other.growthProgress == this.growthProgress &&
          other.status == this.status);
}

class PlantsTableCompanion extends UpdateCompanion<PlantRow> {
  final Value<String> id;
  final Value<String> islandId;
  final Value<int> plotIndex;
  final Value<String> kind;
  final Value<int> plantedOnDayIndex;
  final Value<int> currentStage;
  final Value<int> growthProgress;
  final Value<String> status;
  final Value<int> rowid;
  const PlantsTableCompanion({
    this.id = const Value.absent(),
    this.islandId = const Value.absent(),
    this.plotIndex = const Value.absent(),
    this.kind = const Value.absent(),
    this.plantedOnDayIndex = const Value.absent(),
    this.currentStage = const Value.absent(),
    this.growthProgress = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlantsTableCompanion.insert({
    required String id,
    required String islandId,
    required int plotIndex,
    required String kind,
    required int plantedOnDayIndex,
    this.currentStage = const Value.absent(),
    this.growthProgress = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       islandId = Value(islandId),
       plotIndex = Value(plotIndex),
       kind = Value(kind),
       plantedOnDayIndex = Value(plantedOnDayIndex);
  static Insertable<PlantRow> custom({
    Expression<String>? id,
    Expression<String>? islandId,
    Expression<int>? plotIndex,
    Expression<String>? kind,
    Expression<int>? plantedOnDayIndex,
    Expression<int>? currentStage,
    Expression<int>? growthProgress,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (islandId != null) 'island_id': islandId,
      if (plotIndex != null) 'plot_index': plotIndex,
      if (kind != null) 'kind': kind,
      if (plantedOnDayIndex != null) 'planted_on_day_index': plantedOnDayIndex,
      if (currentStage != null) 'current_stage': currentStage,
      if (growthProgress != null) 'growth_progress': growthProgress,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlantsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? islandId,
    Value<int>? plotIndex,
    Value<String>? kind,
    Value<int>? plantedOnDayIndex,
    Value<int>? currentStage,
    Value<int>? growthProgress,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return PlantsTableCompanion(
      id: id ?? this.id,
      islandId: islandId ?? this.islandId,
      plotIndex: plotIndex ?? this.plotIndex,
      kind: kind ?? this.kind,
      plantedOnDayIndex: plantedOnDayIndex ?? this.plantedOnDayIndex,
      currentStage: currentStage ?? this.currentStage,
      growthProgress: growthProgress ?? this.growthProgress,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (islandId.present) {
      map['island_id'] = Variable<String>(islandId.value);
    }
    if (plotIndex.present) {
      map['plot_index'] = Variable<int>(plotIndex.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (plantedOnDayIndex.present) {
      map['planted_on_day_index'] = Variable<int>(plantedOnDayIndex.value);
    }
    if (currentStage.present) {
      map['current_stage'] = Variable<int>(currentStage.value);
    }
    if (growthProgress.present) {
      map['growth_progress'] = Variable<int>(growthProgress.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantsTableCompanion(')
          ..write('id: $id, ')
          ..write('islandId: $islandId, ')
          ..write('plotIndex: $plotIndex, ')
          ..write('kind: $kind, ')
          ..write('plantedOnDayIndex: $plantedOnDayIndex, ')
          ..write('currentStage: $currentStage, ')
          ..write('growthProgress: $growthProgress, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EtfHoldingsTableTable extends EtfHoldingsTable
    with TableInfo<$EtfHoldingsTableTable, EtfHoldingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EtfHoldingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _etfIdMeta = const VerificationMeta('etfId');
  @override
  late final GeneratedColumn<String> etfId = GeneratedColumn<String>(
    'etf_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<int> shares = GeneratedColumn<int>(
    'shares',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _averageBuyPriceCentsMeta =
      const VerificationMeta('averageBuyPriceCents');
  @override
  late final GeneratedColumn<int> averageBuyPriceCents = GeneratedColumn<int>(
    'average_buy_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [etfId, shares, averageBuyPriceCents];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'etf_holdings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EtfHoldingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('etf_id')) {
      context.handle(
        _etfIdMeta,
        etfId.isAcceptableOrUnknown(data['etf_id']!, _etfIdMeta),
      );
    } else if (isInserting) {
      context.missing(_etfIdMeta);
    }
    if (data.containsKey('shares')) {
      context.handle(
        _sharesMeta,
        shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta),
      );
    } else if (isInserting) {
      context.missing(_sharesMeta);
    }
    if (data.containsKey('average_buy_price_cents')) {
      context.handle(
        _averageBuyPriceCentsMeta,
        averageBuyPriceCents.isAcceptableOrUnknown(
          data['average_buy_price_cents']!,
          _averageBuyPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_averageBuyPriceCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {etfId};
  @override
  EtfHoldingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EtfHoldingRow(
      etfId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etf_id'],
      )!,
      shares: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shares'],
      )!,
      averageBuyPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_buy_price_cents'],
      )!,
    );
  }

  @override
  $EtfHoldingsTableTable createAlias(String alias) {
    return $EtfHoldingsTableTable(attachedDatabase, alias);
  }
}

class EtfHoldingRow extends DataClass implements Insertable<EtfHoldingRow> {
  final String etfId;
  final int shares;
  final int averageBuyPriceCents;
  const EtfHoldingRow({
    required this.etfId,
    required this.shares,
    required this.averageBuyPriceCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['etf_id'] = Variable<String>(etfId);
    map['shares'] = Variable<int>(shares);
    map['average_buy_price_cents'] = Variable<int>(averageBuyPriceCents);
    return map;
  }

  EtfHoldingsTableCompanion toCompanion(bool nullToAbsent) {
    return EtfHoldingsTableCompanion(
      etfId: Value(etfId),
      shares: Value(shares),
      averageBuyPriceCents: Value(averageBuyPriceCents),
    );
  }

  factory EtfHoldingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EtfHoldingRow(
      etfId: serializer.fromJson<String>(json['etfId']),
      shares: serializer.fromJson<int>(json['shares']),
      averageBuyPriceCents: serializer.fromJson<int>(
        json['averageBuyPriceCents'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'etfId': serializer.toJson<String>(etfId),
      'shares': serializer.toJson<int>(shares),
      'averageBuyPriceCents': serializer.toJson<int>(averageBuyPriceCents),
    };
  }

  EtfHoldingRow copyWith({
    String? etfId,
    int? shares,
    int? averageBuyPriceCents,
  }) => EtfHoldingRow(
    etfId: etfId ?? this.etfId,
    shares: shares ?? this.shares,
    averageBuyPriceCents: averageBuyPriceCents ?? this.averageBuyPriceCents,
  );
  EtfHoldingRow copyWithCompanion(EtfHoldingsTableCompanion data) {
    return EtfHoldingRow(
      etfId: data.etfId.present ? data.etfId.value : this.etfId,
      shares: data.shares.present ? data.shares.value : this.shares,
      averageBuyPriceCents: data.averageBuyPriceCents.present
          ? data.averageBuyPriceCents.value
          : this.averageBuyPriceCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EtfHoldingRow(')
          ..write('etfId: $etfId, ')
          ..write('shares: $shares, ')
          ..write('averageBuyPriceCents: $averageBuyPriceCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(etfId, shares, averageBuyPriceCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EtfHoldingRow &&
          other.etfId == this.etfId &&
          other.shares == this.shares &&
          other.averageBuyPriceCents == this.averageBuyPriceCents);
}

class EtfHoldingsTableCompanion extends UpdateCompanion<EtfHoldingRow> {
  final Value<String> etfId;
  final Value<int> shares;
  final Value<int> averageBuyPriceCents;
  final Value<int> rowid;
  const EtfHoldingsTableCompanion({
    this.etfId = const Value.absent(),
    this.shares = const Value.absent(),
    this.averageBuyPriceCents = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EtfHoldingsTableCompanion.insert({
    required String etfId,
    required int shares,
    required int averageBuyPriceCents,
    this.rowid = const Value.absent(),
  }) : etfId = Value(etfId),
       shares = Value(shares),
       averageBuyPriceCents = Value(averageBuyPriceCents);
  static Insertable<EtfHoldingRow> custom({
    Expression<String>? etfId,
    Expression<int>? shares,
    Expression<int>? averageBuyPriceCents,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (etfId != null) 'etf_id': etfId,
      if (shares != null) 'shares': shares,
      if (averageBuyPriceCents != null)
        'average_buy_price_cents': averageBuyPriceCents,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EtfHoldingsTableCompanion copyWith({
    Value<String>? etfId,
    Value<int>? shares,
    Value<int>? averageBuyPriceCents,
    Value<int>? rowid,
  }) {
    return EtfHoldingsTableCompanion(
      etfId: etfId ?? this.etfId,
      shares: shares ?? this.shares,
      averageBuyPriceCents: averageBuyPriceCents ?? this.averageBuyPriceCents,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (etfId.present) {
      map['etf_id'] = Variable<String>(etfId.value);
    }
    if (shares.present) {
      map['shares'] = Variable<int>(shares.value);
    }
    if (averageBuyPriceCents.present) {
      map['average_buy_price_cents'] = Variable<int>(
        averageBuyPriceCents.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EtfHoldingsTableCompanion(')
          ..write('etfId: $etfId, ')
          ..write('shares: $shares, ')
          ..write('averageBuyPriceCents: $averageBuyPriceCents, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EtfQuotesTableTable extends EtfQuotesTable
    with TableInfo<$EtfQuotesTableTable, EtfQuoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EtfQuotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _etfIdMeta = const VerificationMeta('etfId');
  @override
  late final GeneratedColumn<String> etfId = GeneratedColumn<String>(
    'etf_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerShareCentsMeta =
      const VerificationMeta('pricePerShareCents');
  @override
  late final GeneratedColumn<int> pricePerShareCents = GeneratedColumn<int>(
    'price_per_share_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onDayIndexMeta = const VerificationMeta(
    'onDayIndex',
  );
  @override
  late final GeneratedColumn<int> onDayIndex = GeneratedColumn<int>(
    'on_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [etfId, pricePerShareCents, onDayIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'etf_quotes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EtfQuoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('etf_id')) {
      context.handle(
        _etfIdMeta,
        etfId.isAcceptableOrUnknown(data['etf_id']!, _etfIdMeta),
      );
    } else if (isInserting) {
      context.missing(_etfIdMeta);
    }
    if (data.containsKey('price_per_share_cents')) {
      context.handle(
        _pricePerShareCentsMeta,
        pricePerShareCents.isAcceptableOrUnknown(
          data['price_per_share_cents']!,
          _pricePerShareCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerShareCentsMeta);
    }
    if (data.containsKey('on_day_index')) {
      context.handle(
        _onDayIndexMeta,
        onDayIndex.isAcceptableOrUnknown(
          data['on_day_index']!,
          _onDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_onDayIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {etfId};
  @override
  EtfQuoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EtfQuoteRow(
      etfId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etf_id'],
      )!,
      pricePerShareCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_per_share_cents'],
      )!,
      onDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}on_day_index'],
      )!,
    );
  }

  @override
  $EtfQuotesTableTable createAlias(String alias) {
    return $EtfQuotesTableTable(attachedDatabase, alias);
  }
}

class EtfQuoteRow extends DataClass implements Insertable<EtfQuoteRow> {
  final String etfId;
  final int pricePerShareCents;
  final int onDayIndex;
  const EtfQuoteRow({
    required this.etfId,
    required this.pricePerShareCents,
    required this.onDayIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['etf_id'] = Variable<String>(etfId);
    map['price_per_share_cents'] = Variable<int>(pricePerShareCents);
    map['on_day_index'] = Variable<int>(onDayIndex);
    return map;
  }

  EtfQuotesTableCompanion toCompanion(bool nullToAbsent) {
    return EtfQuotesTableCompanion(
      etfId: Value(etfId),
      pricePerShareCents: Value(pricePerShareCents),
      onDayIndex: Value(onDayIndex),
    );
  }

  factory EtfQuoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EtfQuoteRow(
      etfId: serializer.fromJson<String>(json['etfId']),
      pricePerShareCents: serializer.fromJson<int>(json['pricePerShareCents']),
      onDayIndex: serializer.fromJson<int>(json['onDayIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'etfId': serializer.toJson<String>(etfId),
      'pricePerShareCents': serializer.toJson<int>(pricePerShareCents),
      'onDayIndex': serializer.toJson<int>(onDayIndex),
    };
  }

  EtfQuoteRow copyWith({
    String? etfId,
    int? pricePerShareCents,
    int? onDayIndex,
  }) => EtfQuoteRow(
    etfId: etfId ?? this.etfId,
    pricePerShareCents: pricePerShareCents ?? this.pricePerShareCents,
    onDayIndex: onDayIndex ?? this.onDayIndex,
  );
  EtfQuoteRow copyWithCompanion(EtfQuotesTableCompanion data) {
    return EtfQuoteRow(
      etfId: data.etfId.present ? data.etfId.value : this.etfId,
      pricePerShareCents: data.pricePerShareCents.present
          ? data.pricePerShareCents.value
          : this.pricePerShareCents,
      onDayIndex: data.onDayIndex.present
          ? data.onDayIndex.value
          : this.onDayIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EtfQuoteRow(')
          ..write('etfId: $etfId, ')
          ..write('pricePerShareCents: $pricePerShareCents, ')
          ..write('onDayIndex: $onDayIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(etfId, pricePerShareCents, onDayIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EtfQuoteRow &&
          other.etfId == this.etfId &&
          other.pricePerShareCents == this.pricePerShareCents &&
          other.onDayIndex == this.onDayIndex);
}

class EtfQuotesTableCompanion extends UpdateCompanion<EtfQuoteRow> {
  final Value<String> etfId;
  final Value<int> pricePerShareCents;
  final Value<int> onDayIndex;
  final Value<int> rowid;
  const EtfQuotesTableCompanion({
    this.etfId = const Value.absent(),
    this.pricePerShareCents = const Value.absent(),
    this.onDayIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EtfQuotesTableCompanion.insert({
    required String etfId,
    required int pricePerShareCents,
    required int onDayIndex,
    this.rowid = const Value.absent(),
  }) : etfId = Value(etfId),
       pricePerShareCents = Value(pricePerShareCents),
       onDayIndex = Value(onDayIndex);
  static Insertable<EtfQuoteRow> custom({
    Expression<String>? etfId,
    Expression<int>? pricePerShareCents,
    Expression<int>? onDayIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (etfId != null) 'etf_id': etfId,
      if (pricePerShareCents != null)
        'price_per_share_cents': pricePerShareCents,
      if (onDayIndex != null) 'on_day_index': onDayIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EtfQuotesTableCompanion copyWith({
    Value<String>? etfId,
    Value<int>? pricePerShareCents,
    Value<int>? onDayIndex,
    Value<int>? rowid,
  }) {
    return EtfQuotesTableCompanion(
      etfId: etfId ?? this.etfId,
      pricePerShareCents: pricePerShareCents ?? this.pricePerShareCents,
      onDayIndex: onDayIndex ?? this.onDayIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (etfId.present) {
      map['etf_id'] = Variable<String>(etfId.value);
    }
    if (pricePerShareCents.present) {
      map['price_per_share_cents'] = Variable<int>(pricePerShareCents.value);
    }
    if (onDayIndex.present) {
      map['on_day_index'] = Variable<int>(onDayIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EtfQuotesTableCompanion(')
          ..write('etfId: $etfId, ')
          ..write('pricePerShareCents: $pricePerShareCents, ')
          ..write('onDayIndex: $onDayIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockHoldingsTableTable extends StockHoldingsTable
    with TableInfo<$StockHoldingsTableTable, StockHoldingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockHoldingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _stockIdMeta = const VerificationMeta(
    'stockId',
  );
  @override
  late final GeneratedColumn<String> stockId = GeneratedColumn<String>(
    'stock_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<int> shares = GeneratedColumn<int>(
    'shares',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _averageBuyPriceCentsMeta =
      const VerificationMeta('averageBuyPriceCents');
  @override
  late final GeneratedColumn<int> averageBuyPriceCents = GeneratedColumn<int>(
    'average_buy_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [stockId, shares, averageBuyPriceCents];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_holdings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockHoldingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('stock_id')) {
      context.handle(
        _stockIdMeta,
        stockId.isAcceptableOrUnknown(data['stock_id']!, _stockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stockIdMeta);
    }
    if (data.containsKey('shares')) {
      context.handle(
        _sharesMeta,
        shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta),
      );
    } else if (isInserting) {
      context.missing(_sharesMeta);
    }
    if (data.containsKey('average_buy_price_cents')) {
      context.handle(
        _averageBuyPriceCentsMeta,
        averageBuyPriceCents.isAcceptableOrUnknown(
          data['average_buy_price_cents']!,
          _averageBuyPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_averageBuyPriceCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {stockId};
  @override
  StockHoldingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockHoldingRow(
      stockId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stock_id'],
      )!,
      shares: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shares'],
      )!,
      averageBuyPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_buy_price_cents'],
      )!,
    );
  }

  @override
  $StockHoldingsTableTable createAlias(String alias) {
    return $StockHoldingsTableTable(attachedDatabase, alias);
  }
}

class StockHoldingRow extends DataClass implements Insertable<StockHoldingRow> {
  final String stockId;
  final int shares;
  final int averageBuyPriceCents;
  const StockHoldingRow({
    required this.stockId,
    required this.shares,
    required this.averageBuyPriceCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['stock_id'] = Variable<String>(stockId);
    map['shares'] = Variable<int>(shares);
    map['average_buy_price_cents'] = Variable<int>(averageBuyPriceCents);
    return map;
  }

  StockHoldingsTableCompanion toCompanion(bool nullToAbsent) {
    return StockHoldingsTableCompanion(
      stockId: Value(stockId),
      shares: Value(shares),
      averageBuyPriceCents: Value(averageBuyPriceCents),
    );
  }

  factory StockHoldingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockHoldingRow(
      stockId: serializer.fromJson<String>(json['stockId']),
      shares: serializer.fromJson<int>(json['shares']),
      averageBuyPriceCents: serializer.fromJson<int>(
        json['averageBuyPriceCents'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'stockId': serializer.toJson<String>(stockId),
      'shares': serializer.toJson<int>(shares),
      'averageBuyPriceCents': serializer.toJson<int>(averageBuyPriceCents),
    };
  }

  StockHoldingRow copyWith({
    String? stockId,
    int? shares,
    int? averageBuyPriceCents,
  }) => StockHoldingRow(
    stockId: stockId ?? this.stockId,
    shares: shares ?? this.shares,
    averageBuyPriceCents: averageBuyPriceCents ?? this.averageBuyPriceCents,
  );
  StockHoldingRow copyWithCompanion(StockHoldingsTableCompanion data) {
    return StockHoldingRow(
      stockId: data.stockId.present ? data.stockId.value : this.stockId,
      shares: data.shares.present ? data.shares.value : this.shares,
      averageBuyPriceCents: data.averageBuyPriceCents.present
          ? data.averageBuyPriceCents.value
          : this.averageBuyPriceCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockHoldingRow(')
          ..write('stockId: $stockId, ')
          ..write('shares: $shares, ')
          ..write('averageBuyPriceCents: $averageBuyPriceCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(stockId, shares, averageBuyPriceCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockHoldingRow &&
          other.stockId == this.stockId &&
          other.shares == this.shares &&
          other.averageBuyPriceCents == this.averageBuyPriceCents);
}

class StockHoldingsTableCompanion extends UpdateCompanion<StockHoldingRow> {
  final Value<String> stockId;
  final Value<int> shares;
  final Value<int> averageBuyPriceCents;
  final Value<int> rowid;
  const StockHoldingsTableCompanion({
    this.stockId = const Value.absent(),
    this.shares = const Value.absent(),
    this.averageBuyPriceCents = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockHoldingsTableCompanion.insert({
    required String stockId,
    required int shares,
    required int averageBuyPriceCents,
    this.rowid = const Value.absent(),
  }) : stockId = Value(stockId),
       shares = Value(shares),
       averageBuyPriceCents = Value(averageBuyPriceCents);
  static Insertable<StockHoldingRow> custom({
    Expression<String>? stockId,
    Expression<int>? shares,
    Expression<int>? averageBuyPriceCents,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (stockId != null) 'stock_id': stockId,
      if (shares != null) 'shares': shares,
      if (averageBuyPriceCents != null)
        'average_buy_price_cents': averageBuyPriceCents,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockHoldingsTableCompanion copyWith({
    Value<String>? stockId,
    Value<int>? shares,
    Value<int>? averageBuyPriceCents,
    Value<int>? rowid,
  }) {
    return StockHoldingsTableCompanion(
      stockId: stockId ?? this.stockId,
      shares: shares ?? this.shares,
      averageBuyPriceCents: averageBuyPriceCents ?? this.averageBuyPriceCents,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (stockId.present) {
      map['stock_id'] = Variable<String>(stockId.value);
    }
    if (shares.present) {
      map['shares'] = Variable<int>(shares.value);
    }
    if (averageBuyPriceCents.present) {
      map['average_buy_price_cents'] = Variable<int>(
        averageBuyPriceCents.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockHoldingsTableCompanion(')
          ..write('stockId: $stockId, ')
          ..write('shares: $shares, ')
          ..write('averageBuyPriceCents: $averageBuyPriceCents, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockQuotesTableTable extends StockQuotesTable
    with TableInfo<$StockQuotesTableTable, StockQuoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockQuotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _stockIdMeta = const VerificationMeta(
    'stockId',
  );
  @override
  late final GeneratedColumn<String> stockId = GeneratedColumn<String>(
    'stock_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerShareCentsMeta =
      const VerificationMeta('pricePerShareCents');
  @override
  late final GeneratedColumn<int> pricePerShareCents = GeneratedColumn<int>(
    'price_per_share_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onDayIndexMeta = const VerificationMeta(
    'onDayIndex',
  );
  @override
  late final GeneratedColumn<int> onDayIndex = GeneratedColumn<int>(
    'on_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    stockId,
    pricePerShareCents,
    onDayIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_quotes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockQuoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('stock_id')) {
      context.handle(
        _stockIdMeta,
        stockId.isAcceptableOrUnknown(data['stock_id']!, _stockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stockIdMeta);
    }
    if (data.containsKey('price_per_share_cents')) {
      context.handle(
        _pricePerShareCentsMeta,
        pricePerShareCents.isAcceptableOrUnknown(
          data['price_per_share_cents']!,
          _pricePerShareCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerShareCentsMeta);
    }
    if (data.containsKey('on_day_index')) {
      context.handle(
        _onDayIndexMeta,
        onDayIndex.isAcceptableOrUnknown(
          data['on_day_index']!,
          _onDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_onDayIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {stockId};
  @override
  StockQuoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockQuoteRow(
      stockId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stock_id'],
      )!,
      pricePerShareCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_per_share_cents'],
      )!,
      onDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}on_day_index'],
      )!,
    );
  }

  @override
  $StockQuotesTableTable createAlias(String alias) {
    return $StockQuotesTableTable(attachedDatabase, alias);
  }
}

class StockQuoteRow extends DataClass implements Insertable<StockQuoteRow> {
  final String stockId;
  final int pricePerShareCents;
  final int onDayIndex;
  const StockQuoteRow({
    required this.stockId,
    required this.pricePerShareCents,
    required this.onDayIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['stock_id'] = Variable<String>(stockId);
    map['price_per_share_cents'] = Variable<int>(pricePerShareCents);
    map['on_day_index'] = Variable<int>(onDayIndex);
    return map;
  }

  StockQuotesTableCompanion toCompanion(bool nullToAbsent) {
    return StockQuotesTableCompanion(
      stockId: Value(stockId),
      pricePerShareCents: Value(pricePerShareCents),
      onDayIndex: Value(onDayIndex),
    );
  }

  factory StockQuoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockQuoteRow(
      stockId: serializer.fromJson<String>(json['stockId']),
      pricePerShareCents: serializer.fromJson<int>(json['pricePerShareCents']),
      onDayIndex: serializer.fromJson<int>(json['onDayIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'stockId': serializer.toJson<String>(stockId),
      'pricePerShareCents': serializer.toJson<int>(pricePerShareCents),
      'onDayIndex': serializer.toJson<int>(onDayIndex),
    };
  }

  StockQuoteRow copyWith({
    String? stockId,
    int? pricePerShareCents,
    int? onDayIndex,
  }) => StockQuoteRow(
    stockId: stockId ?? this.stockId,
    pricePerShareCents: pricePerShareCents ?? this.pricePerShareCents,
    onDayIndex: onDayIndex ?? this.onDayIndex,
  );
  StockQuoteRow copyWithCompanion(StockQuotesTableCompanion data) {
    return StockQuoteRow(
      stockId: data.stockId.present ? data.stockId.value : this.stockId,
      pricePerShareCents: data.pricePerShareCents.present
          ? data.pricePerShareCents.value
          : this.pricePerShareCents,
      onDayIndex: data.onDayIndex.present
          ? data.onDayIndex.value
          : this.onDayIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockQuoteRow(')
          ..write('stockId: $stockId, ')
          ..write('pricePerShareCents: $pricePerShareCents, ')
          ..write('onDayIndex: $onDayIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(stockId, pricePerShareCents, onDayIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockQuoteRow &&
          other.stockId == this.stockId &&
          other.pricePerShareCents == this.pricePerShareCents &&
          other.onDayIndex == this.onDayIndex);
}

class StockQuotesTableCompanion extends UpdateCompanion<StockQuoteRow> {
  final Value<String> stockId;
  final Value<int> pricePerShareCents;
  final Value<int> onDayIndex;
  final Value<int> rowid;
  const StockQuotesTableCompanion({
    this.stockId = const Value.absent(),
    this.pricePerShareCents = const Value.absent(),
    this.onDayIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockQuotesTableCompanion.insert({
    required String stockId,
    required int pricePerShareCents,
    required int onDayIndex,
    this.rowid = const Value.absent(),
  }) : stockId = Value(stockId),
       pricePerShareCents = Value(pricePerShareCents),
       onDayIndex = Value(onDayIndex);
  static Insertable<StockQuoteRow> custom({
    Expression<String>? stockId,
    Expression<int>? pricePerShareCents,
    Expression<int>? onDayIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (stockId != null) 'stock_id': stockId,
      if (pricePerShareCents != null)
        'price_per_share_cents': pricePerShareCents,
      if (onDayIndex != null) 'on_day_index': onDayIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockQuotesTableCompanion copyWith({
    Value<String>? stockId,
    Value<int>? pricePerShareCents,
    Value<int>? onDayIndex,
    Value<int>? rowid,
  }) {
    return StockQuotesTableCompanion(
      stockId: stockId ?? this.stockId,
      pricePerShareCents: pricePerShareCents ?? this.pricePerShareCents,
      onDayIndex: onDayIndex ?? this.onDayIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (stockId.present) {
      map['stock_id'] = Variable<String>(stockId.value);
    }
    if (pricePerShareCents.present) {
      map['price_per_share_cents'] = Variable<int>(pricePerShareCents.value);
    }
    if (onDayIndex.present) {
      map['on_day_index'] = Variable<int>(onDayIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockQuotesTableCompanion(')
          ..write('stockId: $stockId, ')
          ..write('pricePerShareCents: $pricePerShareCents, ')
          ..write('onDayIndex: $onDayIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CryptoHoldingsTableTable extends CryptoHoldingsTable
    with TableInfo<$CryptoHoldingsTableTable, CryptoHoldingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CryptoHoldingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<int> shares = GeneratedColumn<int>(
    'shares',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _averageBuyPriceCentsMeta =
      const VerificationMeta('averageBuyPriceCents');
  @override
  late final GeneratedColumn<int> averageBuyPriceCents = GeneratedColumn<int>(
    'average_buy_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [assetId, shares, averageBuyPriceCents];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crypto_holdings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CryptoHoldingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('shares')) {
      context.handle(
        _sharesMeta,
        shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta),
      );
    } else if (isInserting) {
      context.missing(_sharesMeta);
    }
    if (data.containsKey('average_buy_price_cents')) {
      context.handle(
        _averageBuyPriceCentsMeta,
        averageBuyPriceCents.isAcceptableOrUnknown(
          data['average_buy_price_cents']!,
          _averageBuyPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_averageBuyPriceCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assetId};
  @override
  CryptoHoldingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CryptoHoldingRow(
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      shares: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shares'],
      )!,
      averageBuyPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_buy_price_cents'],
      )!,
    );
  }

  @override
  $CryptoHoldingsTableTable createAlias(String alias) {
    return $CryptoHoldingsTableTable(attachedDatabase, alias);
  }
}

class CryptoHoldingRow extends DataClass
    implements Insertable<CryptoHoldingRow> {
  final String assetId;
  final int shares;
  final int averageBuyPriceCents;
  const CryptoHoldingRow({
    required this.assetId,
    required this.shares,
    required this.averageBuyPriceCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['asset_id'] = Variable<String>(assetId);
    map['shares'] = Variable<int>(shares);
    map['average_buy_price_cents'] = Variable<int>(averageBuyPriceCents);
    return map;
  }

  CryptoHoldingsTableCompanion toCompanion(bool nullToAbsent) {
    return CryptoHoldingsTableCompanion(
      assetId: Value(assetId),
      shares: Value(shares),
      averageBuyPriceCents: Value(averageBuyPriceCents),
    );
  }

  factory CryptoHoldingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CryptoHoldingRow(
      assetId: serializer.fromJson<String>(json['assetId']),
      shares: serializer.fromJson<int>(json['shares']),
      averageBuyPriceCents: serializer.fromJson<int>(
        json['averageBuyPriceCents'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'assetId': serializer.toJson<String>(assetId),
      'shares': serializer.toJson<int>(shares),
      'averageBuyPriceCents': serializer.toJson<int>(averageBuyPriceCents),
    };
  }

  CryptoHoldingRow copyWith({
    String? assetId,
    int? shares,
    int? averageBuyPriceCents,
  }) => CryptoHoldingRow(
    assetId: assetId ?? this.assetId,
    shares: shares ?? this.shares,
    averageBuyPriceCents: averageBuyPriceCents ?? this.averageBuyPriceCents,
  );
  CryptoHoldingRow copyWithCompanion(CryptoHoldingsTableCompanion data) {
    return CryptoHoldingRow(
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      shares: data.shares.present ? data.shares.value : this.shares,
      averageBuyPriceCents: data.averageBuyPriceCents.present
          ? data.averageBuyPriceCents.value
          : this.averageBuyPriceCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CryptoHoldingRow(')
          ..write('assetId: $assetId, ')
          ..write('shares: $shares, ')
          ..write('averageBuyPriceCents: $averageBuyPriceCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(assetId, shares, averageBuyPriceCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CryptoHoldingRow &&
          other.assetId == this.assetId &&
          other.shares == this.shares &&
          other.averageBuyPriceCents == this.averageBuyPriceCents);
}

class CryptoHoldingsTableCompanion extends UpdateCompanion<CryptoHoldingRow> {
  final Value<String> assetId;
  final Value<int> shares;
  final Value<int> averageBuyPriceCents;
  final Value<int> rowid;
  const CryptoHoldingsTableCompanion({
    this.assetId = const Value.absent(),
    this.shares = const Value.absent(),
    this.averageBuyPriceCents = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CryptoHoldingsTableCompanion.insert({
    required String assetId,
    required int shares,
    required int averageBuyPriceCents,
    this.rowid = const Value.absent(),
  }) : assetId = Value(assetId),
       shares = Value(shares),
       averageBuyPriceCents = Value(averageBuyPriceCents);
  static Insertable<CryptoHoldingRow> custom({
    Expression<String>? assetId,
    Expression<int>? shares,
    Expression<int>? averageBuyPriceCents,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (assetId != null) 'asset_id': assetId,
      if (shares != null) 'shares': shares,
      if (averageBuyPriceCents != null)
        'average_buy_price_cents': averageBuyPriceCents,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CryptoHoldingsTableCompanion copyWith({
    Value<String>? assetId,
    Value<int>? shares,
    Value<int>? averageBuyPriceCents,
    Value<int>? rowid,
  }) {
    return CryptoHoldingsTableCompanion(
      assetId: assetId ?? this.assetId,
      shares: shares ?? this.shares,
      averageBuyPriceCents: averageBuyPriceCents ?? this.averageBuyPriceCents,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (shares.present) {
      map['shares'] = Variable<int>(shares.value);
    }
    if (averageBuyPriceCents.present) {
      map['average_buy_price_cents'] = Variable<int>(
        averageBuyPriceCents.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CryptoHoldingsTableCompanion(')
          ..write('assetId: $assetId, ')
          ..write('shares: $shares, ')
          ..write('averageBuyPriceCents: $averageBuyPriceCents, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CryptoQuotesTableTable extends CryptoQuotesTable
    with TableInfo<$CryptoQuotesTableTable, CryptoQuoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CryptoQuotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerShareCentsMeta =
      const VerificationMeta('pricePerShareCents');
  @override
  late final GeneratedColumn<int> pricePerShareCents = GeneratedColumn<int>(
    'price_per_share_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onDayIndexMeta = const VerificationMeta(
    'onDayIndex',
  );
  @override
  late final GeneratedColumn<int> onDayIndex = GeneratedColumn<int>(
    'on_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    assetId,
    pricePerShareCents,
    onDayIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crypto_quotes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CryptoQuoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('price_per_share_cents')) {
      context.handle(
        _pricePerShareCentsMeta,
        pricePerShareCents.isAcceptableOrUnknown(
          data['price_per_share_cents']!,
          _pricePerShareCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerShareCentsMeta);
    }
    if (data.containsKey('on_day_index')) {
      context.handle(
        _onDayIndexMeta,
        onDayIndex.isAcceptableOrUnknown(
          data['on_day_index']!,
          _onDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_onDayIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assetId};
  @override
  CryptoQuoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CryptoQuoteRow(
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      pricePerShareCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_per_share_cents'],
      )!,
      onDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}on_day_index'],
      )!,
    );
  }

  @override
  $CryptoQuotesTableTable createAlias(String alias) {
    return $CryptoQuotesTableTable(attachedDatabase, alias);
  }
}

class CryptoQuoteRow extends DataClass implements Insertable<CryptoQuoteRow> {
  final String assetId;
  final int pricePerShareCents;
  final int onDayIndex;
  const CryptoQuoteRow({
    required this.assetId,
    required this.pricePerShareCents,
    required this.onDayIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['asset_id'] = Variable<String>(assetId);
    map['price_per_share_cents'] = Variable<int>(pricePerShareCents);
    map['on_day_index'] = Variable<int>(onDayIndex);
    return map;
  }

  CryptoQuotesTableCompanion toCompanion(bool nullToAbsent) {
    return CryptoQuotesTableCompanion(
      assetId: Value(assetId),
      pricePerShareCents: Value(pricePerShareCents),
      onDayIndex: Value(onDayIndex),
    );
  }

  factory CryptoQuoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CryptoQuoteRow(
      assetId: serializer.fromJson<String>(json['assetId']),
      pricePerShareCents: serializer.fromJson<int>(json['pricePerShareCents']),
      onDayIndex: serializer.fromJson<int>(json['onDayIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'assetId': serializer.toJson<String>(assetId),
      'pricePerShareCents': serializer.toJson<int>(pricePerShareCents),
      'onDayIndex': serializer.toJson<int>(onDayIndex),
    };
  }

  CryptoQuoteRow copyWith({
    String? assetId,
    int? pricePerShareCents,
    int? onDayIndex,
  }) => CryptoQuoteRow(
    assetId: assetId ?? this.assetId,
    pricePerShareCents: pricePerShareCents ?? this.pricePerShareCents,
    onDayIndex: onDayIndex ?? this.onDayIndex,
  );
  CryptoQuoteRow copyWithCompanion(CryptoQuotesTableCompanion data) {
    return CryptoQuoteRow(
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      pricePerShareCents: data.pricePerShareCents.present
          ? data.pricePerShareCents.value
          : this.pricePerShareCents,
      onDayIndex: data.onDayIndex.present
          ? data.onDayIndex.value
          : this.onDayIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CryptoQuoteRow(')
          ..write('assetId: $assetId, ')
          ..write('pricePerShareCents: $pricePerShareCents, ')
          ..write('onDayIndex: $onDayIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(assetId, pricePerShareCents, onDayIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CryptoQuoteRow &&
          other.assetId == this.assetId &&
          other.pricePerShareCents == this.pricePerShareCents &&
          other.onDayIndex == this.onDayIndex);
}

class CryptoQuotesTableCompanion extends UpdateCompanion<CryptoQuoteRow> {
  final Value<String> assetId;
  final Value<int> pricePerShareCents;
  final Value<int> onDayIndex;
  final Value<int> rowid;
  const CryptoQuotesTableCompanion({
    this.assetId = const Value.absent(),
    this.pricePerShareCents = const Value.absent(),
    this.onDayIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CryptoQuotesTableCompanion.insert({
    required String assetId,
    required int pricePerShareCents,
    required int onDayIndex,
    this.rowid = const Value.absent(),
  }) : assetId = Value(assetId),
       pricePerShareCents = Value(pricePerShareCents),
       onDayIndex = Value(onDayIndex);
  static Insertable<CryptoQuoteRow> custom({
    Expression<String>? assetId,
    Expression<int>? pricePerShareCents,
    Expression<int>? onDayIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (assetId != null) 'asset_id': assetId,
      if (pricePerShareCents != null)
        'price_per_share_cents': pricePerShareCents,
      if (onDayIndex != null) 'on_day_index': onDayIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CryptoQuotesTableCompanion copyWith({
    Value<String>? assetId,
    Value<int>? pricePerShareCents,
    Value<int>? onDayIndex,
    Value<int>? rowid,
  }) {
    return CryptoQuotesTableCompanion(
      assetId: assetId ?? this.assetId,
      pricePerShareCents: pricePerShareCents ?? this.pricePerShareCents,
      onDayIndex: onDayIndex ?? this.onDayIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (pricePerShareCents.present) {
      map['price_per_share_cents'] = Variable<int>(pricePerShareCents.value);
    }
    if (onDayIndex.present) {
      map['on_day_index'] = Variable<int>(onDayIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CryptoQuotesTableCompanion(')
          ..write('assetId: $assetId, ')
          ..write('pricePerShareCents: $pricePerShareCents, ')
          ..write('onDayIndex: $onDayIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetalHoldingsTableTable extends MetalHoldingsTable
    with TableInfo<$MetalHoldingsTableTable, MetalHoldingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetalHoldingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<int> shares = GeneratedColumn<int>(
    'shares',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _averageBuyPriceCentsMeta =
      const VerificationMeta('averageBuyPriceCents');
  @override
  late final GeneratedColumn<int> averageBuyPriceCents = GeneratedColumn<int>(
    'average_buy_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [assetId, shares, averageBuyPriceCents];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metal_holdings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetalHoldingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('shares')) {
      context.handle(
        _sharesMeta,
        shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta),
      );
    } else if (isInserting) {
      context.missing(_sharesMeta);
    }
    if (data.containsKey('average_buy_price_cents')) {
      context.handle(
        _averageBuyPriceCentsMeta,
        averageBuyPriceCents.isAcceptableOrUnknown(
          data['average_buy_price_cents']!,
          _averageBuyPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_averageBuyPriceCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assetId};
  @override
  MetalHoldingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetalHoldingRow(
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      shares: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shares'],
      )!,
      averageBuyPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_buy_price_cents'],
      )!,
    );
  }

  @override
  $MetalHoldingsTableTable createAlias(String alias) {
    return $MetalHoldingsTableTable(attachedDatabase, alias);
  }
}

class MetalHoldingRow extends DataClass implements Insertable<MetalHoldingRow> {
  final String assetId;
  final int shares;
  final int averageBuyPriceCents;
  const MetalHoldingRow({
    required this.assetId,
    required this.shares,
    required this.averageBuyPriceCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['asset_id'] = Variable<String>(assetId);
    map['shares'] = Variable<int>(shares);
    map['average_buy_price_cents'] = Variable<int>(averageBuyPriceCents);
    return map;
  }

  MetalHoldingsTableCompanion toCompanion(bool nullToAbsent) {
    return MetalHoldingsTableCompanion(
      assetId: Value(assetId),
      shares: Value(shares),
      averageBuyPriceCents: Value(averageBuyPriceCents),
    );
  }

  factory MetalHoldingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetalHoldingRow(
      assetId: serializer.fromJson<String>(json['assetId']),
      shares: serializer.fromJson<int>(json['shares']),
      averageBuyPriceCents: serializer.fromJson<int>(
        json['averageBuyPriceCents'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'assetId': serializer.toJson<String>(assetId),
      'shares': serializer.toJson<int>(shares),
      'averageBuyPriceCents': serializer.toJson<int>(averageBuyPriceCents),
    };
  }

  MetalHoldingRow copyWith({
    String? assetId,
    int? shares,
    int? averageBuyPriceCents,
  }) => MetalHoldingRow(
    assetId: assetId ?? this.assetId,
    shares: shares ?? this.shares,
    averageBuyPriceCents: averageBuyPriceCents ?? this.averageBuyPriceCents,
  );
  MetalHoldingRow copyWithCompanion(MetalHoldingsTableCompanion data) {
    return MetalHoldingRow(
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      shares: data.shares.present ? data.shares.value : this.shares,
      averageBuyPriceCents: data.averageBuyPriceCents.present
          ? data.averageBuyPriceCents.value
          : this.averageBuyPriceCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetalHoldingRow(')
          ..write('assetId: $assetId, ')
          ..write('shares: $shares, ')
          ..write('averageBuyPriceCents: $averageBuyPriceCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(assetId, shares, averageBuyPriceCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetalHoldingRow &&
          other.assetId == this.assetId &&
          other.shares == this.shares &&
          other.averageBuyPriceCents == this.averageBuyPriceCents);
}

class MetalHoldingsTableCompanion extends UpdateCompanion<MetalHoldingRow> {
  final Value<String> assetId;
  final Value<int> shares;
  final Value<int> averageBuyPriceCents;
  final Value<int> rowid;
  const MetalHoldingsTableCompanion({
    this.assetId = const Value.absent(),
    this.shares = const Value.absent(),
    this.averageBuyPriceCents = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetalHoldingsTableCompanion.insert({
    required String assetId,
    required int shares,
    required int averageBuyPriceCents,
    this.rowid = const Value.absent(),
  }) : assetId = Value(assetId),
       shares = Value(shares),
       averageBuyPriceCents = Value(averageBuyPriceCents);
  static Insertable<MetalHoldingRow> custom({
    Expression<String>? assetId,
    Expression<int>? shares,
    Expression<int>? averageBuyPriceCents,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (assetId != null) 'asset_id': assetId,
      if (shares != null) 'shares': shares,
      if (averageBuyPriceCents != null)
        'average_buy_price_cents': averageBuyPriceCents,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetalHoldingsTableCompanion copyWith({
    Value<String>? assetId,
    Value<int>? shares,
    Value<int>? averageBuyPriceCents,
    Value<int>? rowid,
  }) {
    return MetalHoldingsTableCompanion(
      assetId: assetId ?? this.assetId,
      shares: shares ?? this.shares,
      averageBuyPriceCents: averageBuyPriceCents ?? this.averageBuyPriceCents,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (shares.present) {
      map['shares'] = Variable<int>(shares.value);
    }
    if (averageBuyPriceCents.present) {
      map['average_buy_price_cents'] = Variable<int>(
        averageBuyPriceCents.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetalHoldingsTableCompanion(')
          ..write('assetId: $assetId, ')
          ..write('shares: $shares, ')
          ..write('averageBuyPriceCents: $averageBuyPriceCents, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetalQuotesTableTable extends MetalQuotesTable
    with TableInfo<$MetalQuotesTableTable, MetalQuoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetalQuotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerShareCentsMeta =
      const VerificationMeta('pricePerShareCents');
  @override
  late final GeneratedColumn<int> pricePerShareCents = GeneratedColumn<int>(
    'price_per_share_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onDayIndexMeta = const VerificationMeta(
    'onDayIndex',
  );
  @override
  late final GeneratedColumn<int> onDayIndex = GeneratedColumn<int>(
    'on_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    assetId,
    pricePerShareCents,
    onDayIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metal_quotes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetalQuoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('price_per_share_cents')) {
      context.handle(
        _pricePerShareCentsMeta,
        pricePerShareCents.isAcceptableOrUnknown(
          data['price_per_share_cents']!,
          _pricePerShareCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerShareCentsMeta);
    }
    if (data.containsKey('on_day_index')) {
      context.handle(
        _onDayIndexMeta,
        onDayIndex.isAcceptableOrUnknown(
          data['on_day_index']!,
          _onDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_onDayIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assetId};
  @override
  MetalQuoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetalQuoteRow(
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      pricePerShareCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_per_share_cents'],
      )!,
      onDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}on_day_index'],
      )!,
    );
  }

  @override
  $MetalQuotesTableTable createAlias(String alias) {
    return $MetalQuotesTableTable(attachedDatabase, alias);
  }
}

class MetalQuoteRow extends DataClass implements Insertable<MetalQuoteRow> {
  final String assetId;
  final int pricePerShareCents;
  final int onDayIndex;
  const MetalQuoteRow({
    required this.assetId,
    required this.pricePerShareCents,
    required this.onDayIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['asset_id'] = Variable<String>(assetId);
    map['price_per_share_cents'] = Variable<int>(pricePerShareCents);
    map['on_day_index'] = Variable<int>(onDayIndex);
    return map;
  }

  MetalQuotesTableCompanion toCompanion(bool nullToAbsent) {
    return MetalQuotesTableCompanion(
      assetId: Value(assetId),
      pricePerShareCents: Value(pricePerShareCents),
      onDayIndex: Value(onDayIndex),
    );
  }

  factory MetalQuoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetalQuoteRow(
      assetId: serializer.fromJson<String>(json['assetId']),
      pricePerShareCents: serializer.fromJson<int>(json['pricePerShareCents']),
      onDayIndex: serializer.fromJson<int>(json['onDayIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'assetId': serializer.toJson<String>(assetId),
      'pricePerShareCents': serializer.toJson<int>(pricePerShareCents),
      'onDayIndex': serializer.toJson<int>(onDayIndex),
    };
  }

  MetalQuoteRow copyWith({
    String? assetId,
    int? pricePerShareCents,
    int? onDayIndex,
  }) => MetalQuoteRow(
    assetId: assetId ?? this.assetId,
    pricePerShareCents: pricePerShareCents ?? this.pricePerShareCents,
    onDayIndex: onDayIndex ?? this.onDayIndex,
  );
  MetalQuoteRow copyWithCompanion(MetalQuotesTableCompanion data) {
    return MetalQuoteRow(
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      pricePerShareCents: data.pricePerShareCents.present
          ? data.pricePerShareCents.value
          : this.pricePerShareCents,
      onDayIndex: data.onDayIndex.present
          ? data.onDayIndex.value
          : this.onDayIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetalQuoteRow(')
          ..write('assetId: $assetId, ')
          ..write('pricePerShareCents: $pricePerShareCents, ')
          ..write('onDayIndex: $onDayIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(assetId, pricePerShareCents, onDayIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetalQuoteRow &&
          other.assetId == this.assetId &&
          other.pricePerShareCents == this.pricePerShareCents &&
          other.onDayIndex == this.onDayIndex);
}

class MetalQuotesTableCompanion extends UpdateCompanion<MetalQuoteRow> {
  final Value<String> assetId;
  final Value<int> pricePerShareCents;
  final Value<int> onDayIndex;
  final Value<int> rowid;
  const MetalQuotesTableCompanion({
    this.assetId = const Value.absent(),
    this.pricePerShareCents = const Value.absent(),
    this.onDayIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetalQuotesTableCompanion.insert({
    required String assetId,
    required int pricePerShareCents,
    required int onDayIndex,
    this.rowid = const Value.absent(),
  }) : assetId = Value(assetId),
       pricePerShareCents = Value(pricePerShareCents),
       onDayIndex = Value(onDayIndex);
  static Insertable<MetalQuoteRow> custom({
    Expression<String>? assetId,
    Expression<int>? pricePerShareCents,
    Expression<int>? onDayIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (assetId != null) 'asset_id': assetId,
      if (pricePerShareCents != null)
        'price_per_share_cents': pricePerShareCents,
      if (onDayIndex != null) 'on_day_index': onDayIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetalQuotesTableCompanion copyWith({
    Value<String>? assetId,
    Value<int>? pricePerShareCents,
    Value<int>? onDayIndex,
    Value<int>? rowid,
  }) {
    return MetalQuotesTableCompanion(
      assetId: assetId ?? this.assetId,
      pricePerShareCents: pricePerShareCents ?? this.pricePerShareCents,
      onDayIndex: onDayIndex ?? this.onDayIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (pricePerShareCents.present) {
      map['price_per_share_cents'] = Variable<int>(pricePerShareCents.value);
    }
    if (onDayIndex.present) {
      map['on_day_index'] = Variable<int>(onDayIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetalQuotesTableCompanion(')
          ..write('assetId: $assetId, ')
          ..write('pricePerShareCents: $pricePerShareCents, ')
          ..write('onDayIndex: $onDayIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RealEstateHoldingsTableTable extends RealEstateHoldingsTable
    with TableInfo<$RealEstateHoldingsTableTable, RealEstateHoldingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RealEstateHoldingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _specIdMeta = const VerificationMeta('specId');
  @override
  late final GeneratedColumn<String> specId = GeneratedColumn<String>(
    'spec_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownedSinceDayIndexMeta =
      const VerificationMeta('ownedSinceDayIndex');
  @override
  late final GeneratedColumn<int> ownedSinceDayIndex = GeneratedColumn<int>(
    'owned_since_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasePriceCentsMeta =
      const VerificationMeta('purchasePriceCents');
  @override
  late final GeneratedColumn<int> purchasePriceCents = GeneratedColumn<int>(
    'purchase_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usageMeta = const VerificationMeta('usage');
  @override
  late final GeneratedColumn<String> usage = GeneratedColumn<String>(
    'usage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('rented'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    specId,
    ownedSinceDayIndex,
    purchasePriceCents,
    usage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'real_estate_holdings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RealEstateHoldingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('spec_id')) {
      context.handle(
        _specIdMeta,
        specId.isAcceptableOrUnknown(data['spec_id']!, _specIdMeta),
      );
    } else if (isInserting) {
      context.missing(_specIdMeta);
    }
    if (data.containsKey('owned_since_day_index')) {
      context.handle(
        _ownedSinceDayIndexMeta,
        ownedSinceDayIndex.isAcceptableOrUnknown(
          data['owned_since_day_index']!,
          _ownedSinceDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownedSinceDayIndexMeta);
    }
    if (data.containsKey('purchase_price_cents')) {
      context.handle(
        _purchasePriceCentsMeta,
        purchasePriceCents.isAcceptableOrUnknown(
          data['purchase_price_cents']!,
          _purchasePriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasePriceCentsMeta);
    }
    if (data.containsKey('usage')) {
      context.handle(
        _usageMeta,
        usage.isAcceptableOrUnknown(data['usage']!, _usageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {specId};
  @override
  RealEstateHoldingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RealEstateHoldingRow(
      specId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spec_id'],
      )!,
      ownedSinceDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owned_since_day_index'],
      )!,
      purchasePriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_price_cents'],
      )!,
      usage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usage'],
      )!,
    );
  }

  @override
  $RealEstateHoldingsTableTable createAlias(String alias) {
    return $RealEstateHoldingsTableTable(attachedDatabase, alias);
  }
}

class RealEstateHoldingRow extends DataClass
    implements Insertable<RealEstateHoldingRow> {
  final String specId;
  final int ownedSinceDayIndex;
  final int purchasePriceCents;

  /// Drift v39: "selfOccupied" oder "rented" (RealEstateUsage.name).
  /// Selbst bewohnt = keine Miete, dafuer entfaellt der Miet-Anteil der
  /// Lebenskosten. Default "rented", damit Bestaende aus aelteren
  /// Spielstaenden nicht ploetzlich Lebenskosten sparen.
  final String usage;
  const RealEstateHoldingRow({
    required this.specId,
    required this.ownedSinceDayIndex,
    required this.purchasePriceCents,
    required this.usage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['spec_id'] = Variable<String>(specId);
    map['owned_since_day_index'] = Variable<int>(ownedSinceDayIndex);
    map['purchase_price_cents'] = Variable<int>(purchasePriceCents);
    map['usage'] = Variable<String>(usage);
    return map;
  }

  RealEstateHoldingsTableCompanion toCompanion(bool nullToAbsent) {
    return RealEstateHoldingsTableCompanion(
      specId: Value(specId),
      ownedSinceDayIndex: Value(ownedSinceDayIndex),
      purchasePriceCents: Value(purchasePriceCents),
      usage: Value(usage),
    );
  }

  factory RealEstateHoldingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RealEstateHoldingRow(
      specId: serializer.fromJson<String>(json['specId']),
      ownedSinceDayIndex: serializer.fromJson<int>(json['ownedSinceDayIndex']),
      purchasePriceCents: serializer.fromJson<int>(json['purchasePriceCents']),
      usage: serializer.fromJson<String>(json['usage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'specId': serializer.toJson<String>(specId),
      'ownedSinceDayIndex': serializer.toJson<int>(ownedSinceDayIndex),
      'purchasePriceCents': serializer.toJson<int>(purchasePriceCents),
      'usage': serializer.toJson<String>(usage),
    };
  }

  RealEstateHoldingRow copyWith({
    String? specId,
    int? ownedSinceDayIndex,
    int? purchasePriceCents,
    String? usage,
  }) => RealEstateHoldingRow(
    specId: specId ?? this.specId,
    ownedSinceDayIndex: ownedSinceDayIndex ?? this.ownedSinceDayIndex,
    purchasePriceCents: purchasePriceCents ?? this.purchasePriceCents,
    usage: usage ?? this.usage,
  );
  RealEstateHoldingRow copyWithCompanion(
    RealEstateHoldingsTableCompanion data,
  ) {
    return RealEstateHoldingRow(
      specId: data.specId.present ? data.specId.value : this.specId,
      ownedSinceDayIndex: data.ownedSinceDayIndex.present
          ? data.ownedSinceDayIndex.value
          : this.ownedSinceDayIndex,
      purchasePriceCents: data.purchasePriceCents.present
          ? data.purchasePriceCents.value
          : this.purchasePriceCents,
      usage: data.usage.present ? data.usage.value : this.usage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RealEstateHoldingRow(')
          ..write('specId: $specId, ')
          ..write('ownedSinceDayIndex: $ownedSinceDayIndex, ')
          ..write('purchasePriceCents: $purchasePriceCents, ')
          ..write('usage: $usage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(specId, ownedSinceDayIndex, purchasePriceCents, usage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RealEstateHoldingRow &&
          other.specId == this.specId &&
          other.ownedSinceDayIndex == this.ownedSinceDayIndex &&
          other.purchasePriceCents == this.purchasePriceCents &&
          other.usage == this.usage);
}

class RealEstateHoldingsTableCompanion
    extends UpdateCompanion<RealEstateHoldingRow> {
  final Value<String> specId;
  final Value<int> ownedSinceDayIndex;
  final Value<int> purchasePriceCents;
  final Value<String> usage;
  final Value<int> rowid;
  const RealEstateHoldingsTableCompanion({
    this.specId = const Value.absent(),
    this.ownedSinceDayIndex = const Value.absent(),
    this.purchasePriceCents = const Value.absent(),
    this.usage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RealEstateHoldingsTableCompanion.insert({
    required String specId,
    required int ownedSinceDayIndex,
    required int purchasePriceCents,
    this.usage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : specId = Value(specId),
       ownedSinceDayIndex = Value(ownedSinceDayIndex),
       purchasePriceCents = Value(purchasePriceCents);
  static Insertable<RealEstateHoldingRow> custom({
    Expression<String>? specId,
    Expression<int>? ownedSinceDayIndex,
    Expression<int>? purchasePriceCents,
    Expression<String>? usage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (specId != null) 'spec_id': specId,
      if (ownedSinceDayIndex != null)
        'owned_since_day_index': ownedSinceDayIndex,
      if (purchasePriceCents != null)
        'purchase_price_cents': purchasePriceCents,
      if (usage != null) 'usage': usage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RealEstateHoldingsTableCompanion copyWith({
    Value<String>? specId,
    Value<int>? ownedSinceDayIndex,
    Value<int>? purchasePriceCents,
    Value<String>? usage,
    Value<int>? rowid,
  }) {
    return RealEstateHoldingsTableCompanion(
      specId: specId ?? this.specId,
      ownedSinceDayIndex: ownedSinceDayIndex ?? this.ownedSinceDayIndex,
      purchasePriceCents: purchasePriceCents ?? this.purchasePriceCents,
      usage: usage ?? this.usage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (specId.present) {
      map['spec_id'] = Variable<String>(specId.value);
    }
    if (ownedSinceDayIndex.present) {
      map['owned_since_day_index'] = Variable<int>(ownedSinceDayIndex.value);
    }
    if (purchasePriceCents.present) {
      map['purchase_price_cents'] = Variable<int>(purchasePriceCents.value);
    }
    if (usage.present) {
      map['usage'] = Variable<String>(usage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RealEstateHoldingsTableCompanion(')
          ..write('specId: $specId, ')
          ..write('ownedSinceDayIndex: $ownedSinceDayIndex, ')
          ..write('purchasePriceCents: $purchasePriceCents, ')
          ..write('usage: $usage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectibleHoldingsTableTable extends CollectibleHoldingsTable
    with TableInfo<$CollectibleHoldingsTableTable, CollectibleHoldingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectibleHoldingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _specIdMeta = const VerificationMeta('specId');
  @override
  late final GeneratedColumn<String> specId = GeneratedColumn<String>(
    'spec_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boughtAtDayIndexMeta = const VerificationMeta(
    'boughtAtDayIndex',
  );
  @override
  late final GeneratedColumn<int> boughtAtDayIndex = GeneratedColumn<int>(
    'bought_at_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boughtPriceCentsMeta = const VerificationMeta(
    'boughtPriceCents',
  );
  @override
  late final GeneratedColumn<int> boughtPriceCents = GeneratedColumn<int>(
    'bought_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    specId,
    boughtAtDayIndex,
    boughtPriceCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collectible_holdings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollectibleHoldingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('spec_id')) {
      context.handle(
        _specIdMeta,
        specId.isAcceptableOrUnknown(data['spec_id']!, _specIdMeta),
      );
    } else if (isInserting) {
      context.missing(_specIdMeta);
    }
    if (data.containsKey('bought_at_day_index')) {
      context.handle(
        _boughtAtDayIndexMeta,
        boughtAtDayIndex.isAcceptableOrUnknown(
          data['bought_at_day_index']!,
          _boughtAtDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_boughtAtDayIndexMeta);
    }
    if (data.containsKey('bought_price_cents')) {
      context.handle(
        _boughtPriceCentsMeta,
        boughtPriceCents.isAcceptableOrUnknown(
          data['bought_price_cents']!,
          _boughtPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_boughtPriceCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  CollectibleHoldingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectibleHoldingRow(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      specId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spec_id'],
      )!,
      boughtAtDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bought_at_day_index'],
      )!,
      boughtPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bought_price_cents'],
      )!,
    );
  }

  @override
  $CollectibleHoldingsTableTable createAlias(String alias) {
    return $CollectibleHoldingsTableTable(attachedDatabase, alias);
  }
}

class CollectibleHoldingRow extends DataClass
    implements Insertable<CollectibleHoldingRow> {
  final int rowId;
  final String specId;
  final int boughtAtDayIndex;
  final int boughtPriceCents;
  const CollectibleHoldingRow({
    required this.rowId,
    required this.specId,
    required this.boughtAtDayIndex,
    required this.boughtPriceCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['spec_id'] = Variable<String>(specId);
    map['bought_at_day_index'] = Variable<int>(boughtAtDayIndex);
    map['bought_price_cents'] = Variable<int>(boughtPriceCents);
    return map;
  }

  CollectibleHoldingsTableCompanion toCompanion(bool nullToAbsent) {
    return CollectibleHoldingsTableCompanion(
      rowId: Value(rowId),
      specId: Value(specId),
      boughtAtDayIndex: Value(boughtAtDayIndex),
      boughtPriceCents: Value(boughtPriceCents),
    );
  }

  factory CollectibleHoldingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectibleHoldingRow(
      rowId: serializer.fromJson<int>(json['rowId']),
      specId: serializer.fromJson<String>(json['specId']),
      boughtAtDayIndex: serializer.fromJson<int>(json['boughtAtDayIndex']),
      boughtPriceCents: serializer.fromJson<int>(json['boughtPriceCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'specId': serializer.toJson<String>(specId),
      'boughtAtDayIndex': serializer.toJson<int>(boughtAtDayIndex),
      'boughtPriceCents': serializer.toJson<int>(boughtPriceCents),
    };
  }

  CollectibleHoldingRow copyWith({
    int? rowId,
    String? specId,
    int? boughtAtDayIndex,
    int? boughtPriceCents,
  }) => CollectibleHoldingRow(
    rowId: rowId ?? this.rowId,
    specId: specId ?? this.specId,
    boughtAtDayIndex: boughtAtDayIndex ?? this.boughtAtDayIndex,
    boughtPriceCents: boughtPriceCents ?? this.boughtPriceCents,
  );
  CollectibleHoldingRow copyWithCompanion(
    CollectibleHoldingsTableCompanion data,
  ) {
    return CollectibleHoldingRow(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      specId: data.specId.present ? data.specId.value : this.specId,
      boughtAtDayIndex: data.boughtAtDayIndex.present
          ? data.boughtAtDayIndex.value
          : this.boughtAtDayIndex,
      boughtPriceCents: data.boughtPriceCents.present
          ? data.boughtPriceCents.value
          : this.boughtPriceCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectibleHoldingRow(')
          ..write('rowId: $rowId, ')
          ..write('specId: $specId, ')
          ..write('boughtAtDayIndex: $boughtAtDayIndex, ')
          ..write('boughtPriceCents: $boughtPriceCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(rowId, specId, boughtAtDayIndex, boughtPriceCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectibleHoldingRow &&
          other.rowId == this.rowId &&
          other.specId == this.specId &&
          other.boughtAtDayIndex == this.boughtAtDayIndex &&
          other.boughtPriceCents == this.boughtPriceCents);
}

class CollectibleHoldingsTableCompanion
    extends UpdateCompanion<CollectibleHoldingRow> {
  final Value<int> rowId;
  final Value<String> specId;
  final Value<int> boughtAtDayIndex;
  final Value<int> boughtPriceCents;
  const CollectibleHoldingsTableCompanion({
    this.rowId = const Value.absent(),
    this.specId = const Value.absent(),
    this.boughtAtDayIndex = const Value.absent(),
    this.boughtPriceCents = const Value.absent(),
  });
  CollectibleHoldingsTableCompanion.insert({
    this.rowId = const Value.absent(),
    required String specId,
    required int boughtAtDayIndex,
    required int boughtPriceCents,
  }) : specId = Value(specId),
       boughtAtDayIndex = Value(boughtAtDayIndex),
       boughtPriceCents = Value(boughtPriceCents);
  static Insertable<CollectibleHoldingRow> custom({
    Expression<int>? rowId,
    Expression<String>? specId,
    Expression<int>? boughtAtDayIndex,
    Expression<int>? boughtPriceCents,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (specId != null) 'spec_id': specId,
      if (boughtAtDayIndex != null) 'bought_at_day_index': boughtAtDayIndex,
      if (boughtPriceCents != null) 'bought_price_cents': boughtPriceCents,
    });
  }

  CollectibleHoldingsTableCompanion copyWith({
    Value<int>? rowId,
    Value<String>? specId,
    Value<int>? boughtAtDayIndex,
    Value<int>? boughtPriceCents,
  }) {
    return CollectibleHoldingsTableCompanion(
      rowId: rowId ?? this.rowId,
      specId: specId ?? this.specId,
      boughtAtDayIndex: boughtAtDayIndex ?? this.boughtAtDayIndex,
      boughtPriceCents: boughtPriceCents ?? this.boughtPriceCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (specId.present) {
      map['spec_id'] = Variable<String>(specId.value);
    }
    if (boughtAtDayIndex.present) {
      map['bought_at_day_index'] = Variable<int>(boughtAtDayIndex.value);
    }
    if (boughtPriceCents.present) {
      map['bought_price_cents'] = Variable<int>(boughtPriceCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectibleHoldingsTableCompanion(')
          ..write('rowId: $rowId, ')
          ..write('specId: $specId, ')
          ..write('boughtAtDayIndex: $boughtAtDayIndex, ')
          ..write('boughtPriceCents: $boughtPriceCents')
          ..write(')'))
        .toString();
  }
}

class $IslandDecorTableTable extends IslandDecorTable
    with TableInfo<$IslandDecorTableTable, IslandDecorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IslandDecorTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _islandIdMeta = const VerificationMeta(
    'islandId',
  );
  @override
  late final GeneratedColumn<String> islandId = GeneratedColumn<String>(
    'island_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decorIdMeta = const VerificationMeta(
    'decorId',
  );
  @override
  late final GeneratedColumn<String> decorId = GeneratedColumn<String>(
    'decor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<double> x = GeneratedColumn<double>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<double> y = GeneratedColumn<double>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotationMeta = const VerificationMeta(
    'rotation',
  );
  @override
  late final GeneratedColumn<int> rotation = GeneratedColumn<int>(
    'rotation',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    islandId,
    decorId,
    x,
    y,
    rotation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'island_decor_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<IslandDecorRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('island_id')) {
      context.handle(
        _islandIdMeta,
        islandId.isAcceptableOrUnknown(data['island_id']!, _islandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_islandIdMeta);
    }
    if (data.containsKey('decor_id')) {
      context.handle(
        _decorIdMeta,
        decorId.isAcceptableOrUnknown(data['decor_id']!, _decorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_decorIdMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('rotation')) {
      context.handle(
        _rotationMeta,
        rotation.isAcceptableOrUnknown(data['rotation']!, _rotationMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  IslandDecorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IslandDecorRow(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      islandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}island_id'],
      )!,
      decorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decor_id'],
      )!,
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}y'],
      )!,
      rotation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rotation'],
      )!,
    );
  }

  @override
  $IslandDecorTableTable createAlias(String alias) {
    return $IslandDecorTableTable(attachedDatabase, alias);
  }
}

class IslandDecorRow extends DataClass implements Insertable<IslandDecorRow> {
  final int rowId;
  final String islandId;
  final String decorId;
  final double x;
  final double y;
  final int rotation;
  const IslandDecorRow({
    required this.rowId,
    required this.islandId,
    required this.decorId,
    required this.x,
    required this.y,
    required this.rotation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['island_id'] = Variable<String>(islandId);
    map['decor_id'] = Variable<String>(decorId);
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    map['rotation'] = Variable<int>(rotation);
    return map;
  }

  IslandDecorTableCompanion toCompanion(bool nullToAbsent) {
    return IslandDecorTableCompanion(
      rowId: Value(rowId),
      islandId: Value(islandId),
      decorId: Value(decorId),
      x: Value(x),
      y: Value(y),
      rotation: Value(rotation),
    );
  }

  factory IslandDecorRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IslandDecorRow(
      rowId: serializer.fromJson<int>(json['rowId']),
      islandId: serializer.fromJson<String>(json['islandId']),
      decorId: serializer.fromJson<String>(json['decorId']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
      rotation: serializer.fromJson<int>(json['rotation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'islandId': serializer.toJson<String>(islandId),
      'decorId': serializer.toJson<String>(decorId),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
      'rotation': serializer.toJson<int>(rotation),
    };
  }

  IslandDecorRow copyWith({
    int? rowId,
    String? islandId,
    String? decorId,
    double? x,
    double? y,
    int? rotation,
  }) => IslandDecorRow(
    rowId: rowId ?? this.rowId,
    islandId: islandId ?? this.islandId,
    decorId: decorId ?? this.decorId,
    x: x ?? this.x,
    y: y ?? this.y,
    rotation: rotation ?? this.rotation,
  );
  IslandDecorRow copyWithCompanion(IslandDecorTableCompanion data) {
    return IslandDecorRow(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      islandId: data.islandId.present ? data.islandId.value : this.islandId,
      decorId: data.decorId.present ? data.decorId.value : this.decorId,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      rotation: data.rotation.present ? data.rotation.value : this.rotation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IslandDecorRow(')
          ..write('rowId: $rowId, ')
          ..write('islandId: $islandId, ')
          ..write('decorId: $decorId, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('rotation: $rotation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, islandId, decorId, x, y, rotation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IslandDecorRow &&
          other.rowId == this.rowId &&
          other.islandId == this.islandId &&
          other.decorId == this.decorId &&
          other.x == this.x &&
          other.y == this.y &&
          other.rotation == this.rotation);
}

class IslandDecorTableCompanion extends UpdateCompanion<IslandDecorRow> {
  final Value<int> rowId;
  final Value<String> islandId;
  final Value<String> decorId;
  final Value<double> x;
  final Value<double> y;
  final Value<int> rotation;
  const IslandDecorTableCompanion({
    this.rowId = const Value.absent(),
    this.islandId = const Value.absent(),
    this.decorId = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.rotation = const Value.absent(),
  });
  IslandDecorTableCompanion.insert({
    this.rowId = const Value.absent(),
    required String islandId,
    required String decorId,
    required double x,
    required double y,
    this.rotation = const Value.absent(),
  }) : islandId = Value(islandId),
       decorId = Value(decorId),
       x = Value(x),
       y = Value(y);
  static Insertable<IslandDecorRow> custom({
    Expression<int>? rowId,
    Expression<String>? islandId,
    Expression<String>? decorId,
    Expression<double>? x,
    Expression<double>? y,
    Expression<int>? rotation,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (islandId != null) 'island_id': islandId,
      if (decorId != null) 'decor_id': decorId,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (rotation != null) 'rotation': rotation,
    });
  }

  IslandDecorTableCompanion copyWith({
    Value<int>? rowId,
    Value<String>? islandId,
    Value<String>? decorId,
    Value<double>? x,
    Value<double>? y,
    Value<int>? rotation,
  }) {
    return IslandDecorTableCompanion(
      rowId: rowId ?? this.rowId,
      islandId: islandId ?? this.islandId,
      decorId: decorId ?? this.decorId,
      x: x ?? this.x,
      y: y ?? this.y,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (islandId.present) {
      map['island_id'] = Variable<String>(islandId.value);
    }
    if (decorId.present) {
      map['decor_id'] = Variable<String>(decorId.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (rotation.present) {
      map['rotation'] = Variable<int>(rotation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IslandDecorTableCompanion(')
          ..write('rowId: $rowId, ')
          ..write('islandId: $islandId, ')
          ..write('decorId: $decorId, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('rotation: $rotation')
          ..write(')'))
        .toString();
  }
}

class $QuestPassivePaymentsTableTable extends QuestPassivePaymentsTable
    with TableInfo<$QuestPassivePaymentsTableTable, QuestPassiveRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestPassivePaymentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _questIdMeta = const VerificationMeta(
    'questId',
  );
  @override
  late final GeneratedColumn<String> questId = GeneratedColumn<String>(
    'quest_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthsRemainingMeta = const VerificationMeta(
    'monthsRemaining',
  );
  @override
  late final GeneratedColumn<int> monthsRemaining = GeneratedColumn<int>(
    'months_remaining',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyCentsMeta = const VerificationMeta(
    'monthlyCents',
  );
  @override
  late final GeneratedColumn<int> monthlyCents = GeneratedColumn<int>(
    'monthly_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPaidDayIndexMeta = const VerificationMeta(
    'lastPaidDayIndex',
  );
  @override
  late final GeneratedColumn<int> lastPaidDayIndex = GeneratedColumn<int>(
    'last_paid_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    questId,
    monthsRemaining,
    monthlyCents,
    lastPaidDayIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quest_passive_payments_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestPassiveRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('quest_id')) {
      context.handle(
        _questIdMeta,
        questId.isAcceptableOrUnknown(data['quest_id']!, _questIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questIdMeta);
    }
    if (data.containsKey('months_remaining')) {
      context.handle(
        _monthsRemainingMeta,
        monthsRemaining.isAcceptableOrUnknown(
          data['months_remaining']!,
          _monthsRemainingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthsRemainingMeta);
    }
    if (data.containsKey('monthly_cents')) {
      context.handle(
        _monthlyCentsMeta,
        monthlyCents.isAcceptableOrUnknown(
          data['monthly_cents']!,
          _monthlyCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyCentsMeta);
    }
    if (data.containsKey('last_paid_day_index')) {
      context.handle(
        _lastPaidDayIndexMeta,
        lastPaidDayIndex.isAcceptableOrUnknown(
          data['last_paid_day_index']!,
          _lastPaidDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastPaidDayIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  QuestPassiveRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestPassiveRow(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      questId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quest_id'],
      )!,
      monthsRemaining: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}months_remaining'],
      )!,
      monthlyCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_cents'],
      )!,
      lastPaidDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_paid_day_index'],
      )!,
    );
  }

  @override
  $QuestPassivePaymentsTableTable createAlias(String alias) {
    return $QuestPassivePaymentsTableTable(attachedDatabase, alias);
  }
}

class QuestPassiveRow extends DataClass implements Insertable<QuestPassiveRow> {
  final int rowId;
  final String questId;
  final int monthsRemaining;
  final int monthlyCents;
  final int lastPaidDayIndex;
  const QuestPassiveRow({
    required this.rowId,
    required this.questId,
    required this.monthsRemaining,
    required this.monthlyCents,
    required this.lastPaidDayIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['quest_id'] = Variable<String>(questId);
    map['months_remaining'] = Variable<int>(monthsRemaining);
    map['monthly_cents'] = Variable<int>(monthlyCents);
    map['last_paid_day_index'] = Variable<int>(lastPaidDayIndex);
    return map;
  }

  QuestPassivePaymentsTableCompanion toCompanion(bool nullToAbsent) {
    return QuestPassivePaymentsTableCompanion(
      rowId: Value(rowId),
      questId: Value(questId),
      monthsRemaining: Value(monthsRemaining),
      monthlyCents: Value(monthlyCents),
      lastPaidDayIndex: Value(lastPaidDayIndex),
    );
  }

  factory QuestPassiveRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestPassiveRow(
      rowId: serializer.fromJson<int>(json['rowId']),
      questId: serializer.fromJson<String>(json['questId']),
      monthsRemaining: serializer.fromJson<int>(json['monthsRemaining']),
      monthlyCents: serializer.fromJson<int>(json['monthlyCents']),
      lastPaidDayIndex: serializer.fromJson<int>(json['lastPaidDayIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'questId': serializer.toJson<String>(questId),
      'monthsRemaining': serializer.toJson<int>(monthsRemaining),
      'monthlyCents': serializer.toJson<int>(monthlyCents),
      'lastPaidDayIndex': serializer.toJson<int>(lastPaidDayIndex),
    };
  }

  QuestPassiveRow copyWith({
    int? rowId,
    String? questId,
    int? monthsRemaining,
    int? monthlyCents,
    int? lastPaidDayIndex,
  }) => QuestPassiveRow(
    rowId: rowId ?? this.rowId,
    questId: questId ?? this.questId,
    monthsRemaining: monthsRemaining ?? this.monthsRemaining,
    monthlyCents: monthlyCents ?? this.monthlyCents,
    lastPaidDayIndex: lastPaidDayIndex ?? this.lastPaidDayIndex,
  );
  QuestPassiveRow copyWithCompanion(QuestPassivePaymentsTableCompanion data) {
    return QuestPassiveRow(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      questId: data.questId.present ? data.questId.value : this.questId,
      monthsRemaining: data.monthsRemaining.present
          ? data.monthsRemaining.value
          : this.monthsRemaining,
      monthlyCents: data.monthlyCents.present
          ? data.monthlyCents.value
          : this.monthlyCents,
      lastPaidDayIndex: data.lastPaidDayIndex.present
          ? data.lastPaidDayIndex.value
          : this.lastPaidDayIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestPassiveRow(')
          ..write('rowId: $rowId, ')
          ..write('questId: $questId, ')
          ..write('monthsRemaining: $monthsRemaining, ')
          ..write('monthlyCents: $monthlyCents, ')
          ..write('lastPaidDayIndex: $lastPaidDayIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    questId,
    monthsRemaining,
    monthlyCents,
    lastPaidDayIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestPassiveRow &&
          other.rowId == this.rowId &&
          other.questId == this.questId &&
          other.monthsRemaining == this.monthsRemaining &&
          other.monthlyCents == this.monthlyCents &&
          other.lastPaidDayIndex == this.lastPaidDayIndex);
}

class QuestPassivePaymentsTableCompanion
    extends UpdateCompanion<QuestPassiveRow> {
  final Value<int> rowId;
  final Value<String> questId;
  final Value<int> monthsRemaining;
  final Value<int> monthlyCents;
  final Value<int> lastPaidDayIndex;
  const QuestPassivePaymentsTableCompanion({
    this.rowId = const Value.absent(),
    this.questId = const Value.absent(),
    this.monthsRemaining = const Value.absent(),
    this.monthlyCents = const Value.absent(),
    this.lastPaidDayIndex = const Value.absent(),
  });
  QuestPassivePaymentsTableCompanion.insert({
    this.rowId = const Value.absent(),
    required String questId,
    required int monthsRemaining,
    required int monthlyCents,
    required int lastPaidDayIndex,
  }) : questId = Value(questId),
       monthsRemaining = Value(monthsRemaining),
       monthlyCents = Value(monthlyCents),
       lastPaidDayIndex = Value(lastPaidDayIndex);
  static Insertable<QuestPassiveRow> custom({
    Expression<int>? rowId,
    Expression<String>? questId,
    Expression<int>? monthsRemaining,
    Expression<int>? monthlyCents,
    Expression<int>? lastPaidDayIndex,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (questId != null) 'quest_id': questId,
      if (monthsRemaining != null) 'months_remaining': monthsRemaining,
      if (monthlyCents != null) 'monthly_cents': monthlyCents,
      if (lastPaidDayIndex != null) 'last_paid_day_index': lastPaidDayIndex,
    });
  }

  QuestPassivePaymentsTableCompanion copyWith({
    Value<int>? rowId,
    Value<String>? questId,
    Value<int>? monthsRemaining,
    Value<int>? monthlyCents,
    Value<int>? lastPaidDayIndex,
  }) {
    return QuestPassivePaymentsTableCompanion(
      rowId: rowId ?? this.rowId,
      questId: questId ?? this.questId,
      monthsRemaining: monthsRemaining ?? this.monthsRemaining,
      monthlyCents: monthlyCents ?? this.monthlyCents,
      lastPaidDayIndex: lastPaidDayIndex ?? this.lastPaidDayIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (questId.present) {
      map['quest_id'] = Variable<String>(questId.value);
    }
    if (monthsRemaining.present) {
      map['months_remaining'] = Variable<int>(monthsRemaining.value);
    }
    if (monthlyCents.present) {
      map['monthly_cents'] = Variable<int>(monthlyCents.value);
    }
    if (lastPaidDayIndex.present) {
      map['last_paid_day_index'] = Variable<int>(lastPaidDayIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestPassivePaymentsTableCompanion(')
          ..write('rowId: $rowId, ')
          ..write('questId: $questId, ')
          ..write('monthsRemaining: $monthsRemaining, ')
          ..write('monthlyCents: $monthlyCents, ')
          ..write('lastPaidDayIndex: $lastPaidDayIndex')
          ..write(')'))
        .toString();
  }
}

class $VorsorgeContractsTableTable extends VorsorgeContractsTable
    with TableInfo<$VorsorgeContractsTableTable, VorsorgeContractRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VorsorgeContractsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedOnDayIndexMeta = const VerificationMeta(
    'startedOnDayIndex',
  );
  @override
  late final GeneratedColumn<int> startedOnDayIndex = GeneratedColumn<int>(
    'started_on_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalContributedCentsMeta =
      const VerificationMeta('totalContributedCents');
  @override
  late final GeneratedColumn<int> totalContributedCents = GeneratedColumn<int>(
    'total_contributed_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalSubsidyCentsMeta = const VerificationMeta(
    'totalSubsidyCents',
  );
  @override
  late final GeneratedColumn<int> totalSubsidyCents = GeneratedColumn<int>(
    'total_subsidy_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    type,
    startedOnDayIndex,
    totalContributedCents,
    totalSubsidyCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vorsorge_contracts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<VorsorgeContractRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('started_on_day_index')) {
      context.handle(
        _startedOnDayIndexMeta,
        startedOnDayIndex.isAcceptableOrUnknown(
          data['started_on_day_index']!,
          _startedOnDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedOnDayIndexMeta);
    }
    if (data.containsKey('total_contributed_cents')) {
      context.handle(
        _totalContributedCentsMeta,
        totalContributedCents.isAcceptableOrUnknown(
          data['total_contributed_cents']!,
          _totalContributedCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalContributedCentsMeta);
    }
    if (data.containsKey('total_subsidy_cents')) {
      context.handle(
        _totalSubsidyCentsMeta,
        totalSubsidyCents.isAcceptableOrUnknown(
          data['total_subsidy_cents']!,
          _totalSubsidyCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalSubsidyCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {type};
  @override
  VorsorgeContractRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VorsorgeContractRow(
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      startedOnDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_on_day_index'],
      )!,
      totalContributedCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_contributed_cents'],
      )!,
      totalSubsidyCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_subsidy_cents'],
      )!,
    );
  }

  @override
  $VorsorgeContractsTableTable createAlias(String alias) {
    return $VorsorgeContractsTableTable(attachedDatabase, alias);
  }
}

class VorsorgeContractRow extends DataClass
    implements Insertable<VorsorgeContractRow> {
  /// Stores VorsorgeType.name (`bausparer`, `riester`, …).
  final String type;
  final int startedOnDayIndex;
  final int totalContributedCents;
  final int totalSubsidyCents;
  const VorsorgeContractRow({
    required this.type,
    required this.startedOnDayIndex,
    required this.totalContributedCents,
    required this.totalSubsidyCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['type'] = Variable<String>(type);
    map['started_on_day_index'] = Variable<int>(startedOnDayIndex);
    map['total_contributed_cents'] = Variable<int>(totalContributedCents);
    map['total_subsidy_cents'] = Variable<int>(totalSubsidyCents);
    return map;
  }

  VorsorgeContractsTableCompanion toCompanion(bool nullToAbsent) {
    return VorsorgeContractsTableCompanion(
      type: Value(type),
      startedOnDayIndex: Value(startedOnDayIndex),
      totalContributedCents: Value(totalContributedCents),
      totalSubsidyCents: Value(totalSubsidyCents),
    );
  }

  factory VorsorgeContractRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VorsorgeContractRow(
      type: serializer.fromJson<String>(json['type']),
      startedOnDayIndex: serializer.fromJson<int>(json['startedOnDayIndex']),
      totalContributedCents: serializer.fromJson<int>(
        json['totalContributedCents'],
      ),
      totalSubsidyCents: serializer.fromJson<int>(json['totalSubsidyCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'type': serializer.toJson<String>(type),
      'startedOnDayIndex': serializer.toJson<int>(startedOnDayIndex),
      'totalContributedCents': serializer.toJson<int>(totalContributedCents),
      'totalSubsidyCents': serializer.toJson<int>(totalSubsidyCents),
    };
  }

  VorsorgeContractRow copyWith({
    String? type,
    int? startedOnDayIndex,
    int? totalContributedCents,
    int? totalSubsidyCents,
  }) => VorsorgeContractRow(
    type: type ?? this.type,
    startedOnDayIndex: startedOnDayIndex ?? this.startedOnDayIndex,
    totalContributedCents: totalContributedCents ?? this.totalContributedCents,
    totalSubsidyCents: totalSubsidyCents ?? this.totalSubsidyCents,
  );
  VorsorgeContractRow copyWithCompanion(VorsorgeContractsTableCompanion data) {
    return VorsorgeContractRow(
      type: data.type.present ? data.type.value : this.type,
      startedOnDayIndex: data.startedOnDayIndex.present
          ? data.startedOnDayIndex.value
          : this.startedOnDayIndex,
      totalContributedCents: data.totalContributedCents.present
          ? data.totalContributedCents.value
          : this.totalContributedCents,
      totalSubsidyCents: data.totalSubsidyCents.present
          ? data.totalSubsidyCents.value
          : this.totalSubsidyCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VorsorgeContractRow(')
          ..write('type: $type, ')
          ..write('startedOnDayIndex: $startedOnDayIndex, ')
          ..write('totalContributedCents: $totalContributedCents, ')
          ..write('totalSubsidyCents: $totalSubsidyCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    type,
    startedOnDayIndex,
    totalContributedCents,
    totalSubsidyCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VorsorgeContractRow &&
          other.type == this.type &&
          other.startedOnDayIndex == this.startedOnDayIndex &&
          other.totalContributedCents == this.totalContributedCents &&
          other.totalSubsidyCents == this.totalSubsidyCents);
}

class VorsorgeContractsTableCompanion
    extends UpdateCompanion<VorsorgeContractRow> {
  final Value<String> type;
  final Value<int> startedOnDayIndex;
  final Value<int> totalContributedCents;
  final Value<int> totalSubsidyCents;
  final Value<int> rowid;
  const VorsorgeContractsTableCompanion({
    this.type = const Value.absent(),
    this.startedOnDayIndex = const Value.absent(),
    this.totalContributedCents = const Value.absent(),
    this.totalSubsidyCents = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VorsorgeContractsTableCompanion.insert({
    required String type,
    required int startedOnDayIndex,
    required int totalContributedCents,
    required int totalSubsidyCents,
    this.rowid = const Value.absent(),
  }) : type = Value(type),
       startedOnDayIndex = Value(startedOnDayIndex),
       totalContributedCents = Value(totalContributedCents),
       totalSubsidyCents = Value(totalSubsidyCents);
  static Insertable<VorsorgeContractRow> custom({
    Expression<String>? type,
    Expression<int>? startedOnDayIndex,
    Expression<int>? totalContributedCents,
    Expression<int>? totalSubsidyCents,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (type != null) 'type': type,
      if (startedOnDayIndex != null) 'started_on_day_index': startedOnDayIndex,
      if (totalContributedCents != null)
        'total_contributed_cents': totalContributedCents,
      if (totalSubsidyCents != null) 'total_subsidy_cents': totalSubsidyCents,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VorsorgeContractsTableCompanion copyWith({
    Value<String>? type,
    Value<int>? startedOnDayIndex,
    Value<int>? totalContributedCents,
    Value<int>? totalSubsidyCents,
    Value<int>? rowid,
  }) {
    return VorsorgeContractsTableCompanion(
      type: type ?? this.type,
      startedOnDayIndex: startedOnDayIndex ?? this.startedOnDayIndex,
      totalContributedCents:
          totalContributedCents ?? this.totalContributedCents,
      totalSubsidyCents: totalSubsidyCents ?? this.totalSubsidyCents,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (startedOnDayIndex.present) {
      map['started_on_day_index'] = Variable<int>(startedOnDayIndex.value);
    }
    if (totalContributedCents.present) {
      map['total_contributed_cents'] = Variable<int>(
        totalContributedCents.value,
      );
    }
    if (totalSubsidyCents.present) {
      map['total_subsidy_cents'] = Variable<int>(totalSubsidyCents.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VorsorgeContractsTableCompanion(')
          ..write('type: $type, ')
          ..write('startedOnDayIndex: $startedOnDayIndex, ')
          ..write('totalContributedCents: $totalContributedCents, ')
          ..write('totalSubsidyCents: $totalSubsidyCents, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsPlansTableTable extends SavingsPlansTable
    with TableInfo<$SavingsPlansTableTable, SavingsPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsPlansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetClassMeta = const VerificationMeta(
    'assetClass',
  );
  @override
  late final GeneratedColumn<String> assetClass = GeneratedColumn<String>(
    'asset_class',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyCentsMeta = const VerificationMeta(
    'monthlyCents',
  );
  @override
  late final GeneratedColumn<int> monthlyCents = GeneratedColumn<int>(
    'monthly_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedOnDayIndexMeta = const VerificationMeta(
    'startedOnDayIndex',
  );
  @override
  late final GeneratedColumn<int> startedOnDayIndex = GeneratedColumn<int>(
    'started_on_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assetClass,
    assetId,
    monthlyCents,
    startedOnDayIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_plans_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsPlanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_class')) {
      context.handle(
        _assetClassMeta,
        assetClass.isAcceptableOrUnknown(data['asset_class']!, _assetClassMeta),
      );
    } else if (isInserting) {
      context.missing(_assetClassMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('monthly_cents')) {
      context.handle(
        _monthlyCentsMeta,
        monthlyCents.isAcceptableOrUnknown(
          data['monthly_cents']!,
          _monthlyCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyCentsMeta);
    }
    if (data.containsKey('started_on_day_index')) {
      context.handle(
        _startedOnDayIndexMeta,
        startedOnDayIndex.isAcceptableOrUnknown(
          data['started_on_day_index']!,
          _startedOnDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedOnDayIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsPlanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      assetClass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_class'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      monthlyCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_cents'],
      )!,
      startedOnDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_on_day_index'],
      )!,
    );
  }

  @override
  $SavingsPlansTableTable createAlias(String alias) {
    return $SavingsPlansTableTable(attachedDatabase, alias);
  }
}

class SavingsPlanRow extends DataClass implements Insertable<SavingsPlanRow> {
  /// Internal id (uuid-ish). Allows multiple plans per asset.
  final String id;
  final String assetClass;
  final String assetId;
  final int monthlyCents;
  final int startedOnDayIndex;
  const SavingsPlanRow({
    required this.id,
    required this.assetClass,
    required this.assetId,
    required this.monthlyCents,
    required this.startedOnDayIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_class'] = Variable<String>(assetClass);
    map['asset_id'] = Variable<String>(assetId);
    map['monthly_cents'] = Variable<int>(monthlyCents);
    map['started_on_day_index'] = Variable<int>(startedOnDayIndex);
    return map;
  }

  SavingsPlansTableCompanion toCompanion(bool nullToAbsent) {
    return SavingsPlansTableCompanion(
      id: Value(id),
      assetClass: Value(assetClass),
      assetId: Value(assetId),
      monthlyCents: Value(monthlyCents),
      startedOnDayIndex: Value(startedOnDayIndex),
    );
  }

  factory SavingsPlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsPlanRow(
      id: serializer.fromJson<String>(json['id']),
      assetClass: serializer.fromJson<String>(json['assetClass']),
      assetId: serializer.fromJson<String>(json['assetId']),
      monthlyCents: serializer.fromJson<int>(json['monthlyCents']),
      startedOnDayIndex: serializer.fromJson<int>(json['startedOnDayIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetClass': serializer.toJson<String>(assetClass),
      'assetId': serializer.toJson<String>(assetId),
      'monthlyCents': serializer.toJson<int>(monthlyCents),
      'startedOnDayIndex': serializer.toJson<int>(startedOnDayIndex),
    };
  }

  SavingsPlanRow copyWith({
    String? id,
    String? assetClass,
    String? assetId,
    int? monthlyCents,
    int? startedOnDayIndex,
  }) => SavingsPlanRow(
    id: id ?? this.id,
    assetClass: assetClass ?? this.assetClass,
    assetId: assetId ?? this.assetId,
    monthlyCents: monthlyCents ?? this.monthlyCents,
    startedOnDayIndex: startedOnDayIndex ?? this.startedOnDayIndex,
  );
  SavingsPlanRow copyWithCompanion(SavingsPlansTableCompanion data) {
    return SavingsPlanRow(
      id: data.id.present ? data.id.value : this.id,
      assetClass: data.assetClass.present
          ? data.assetClass.value
          : this.assetClass,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      monthlyCents: data.monthlyCents.present
          ? data.monthlyCents.value
          : this.monthlyCents,
      startedOnDayIndex: data.startedOnDayIndex.present
          ? data.startedOnDayIndex.value
          : this.startedOnDayIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsPlanRow(')
          ..write('id: $id, ')
          ..write('assetClass: $assetClass, ')
          ..write('assetId: $assetId, ')
          ..write('monthlyCents: $monthlyCents, ')
          ..write('startedOnDayIndex: $startedOnDayIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, assetClass, assetId, monthlyCents, startedOnDayIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsPlanRow &&
          other.id == this.id &&
          other.assetClass == this.assetClass &&
          other.assetId == this.assetId &&
          other.monthlyCents == this.monthlyCents &&
          other.startedOnDayIndex == this.startedOnDayIndex);
}

class SavingsPlansTableCompanion extends UpdateCompanion<SavingsPlanRow> {
  final Value<String> id;
  final Value<String> assetClass;
  final Value<String> assetId;
  final Value<int> monthlyCents;
  final Value<int> startedOnDayIndex;
  final Value<int> rowid;
  const SavingsPlansTableCompanion({
    this.id = const Value.absent(),
    this.assetClass = const Value.absent(),
    this.assetId = const Value.absent(),
    this.monthlyCents = const Value.absent(),
    this.startedOnDayIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavingsPlansTableCompanion.insert({
    required String id,
    required String assetClass,
    required String assetId,
    required int monthlyCents,
    required int startedOnDayIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assetClass = Value(assetClass),
       assetId = Value(assetId),
       monthlyCents = Value(monthlyCents),
       startedOnDayIndex = Value(startedOnDayIndex);
  static Insertable<SavingsPlanRow> custom({
    Expression<String>? id,
    Expression<String>? assetClass,
    Expression<String>? assetId,
    Expression<int>? monthlyCents,
    Expression<int>? startedOnDayIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetClass != null) 'asset_class': assetClass,
      if (assetId != null) 'asset_id': assetId,
      if (monthlyCents != null) 'monthly_cents': monthlyCents,
      if (startedOnDayIndex != null) 'started_on_day_index': startedOnDayIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavingsPlansTableCompanion copyWith({
    Value<String>? id,
    Value<String>? assetClass,
    Value<String>? assetId,
    Value<int>? monthlyCents,
    Value<int>? startedOnDayIndex,
    Value<int>? rowid,
  }) {
    return SavingsPlansTableCompanion(
      id: id ?? this.id,
      assetClass: assetClass ?? this.assetClass,
      assetId: assetId ?? this.assetId,
      monthlyCents: monthlyCents ?? this.monthlyCents,
      startedOnDayIndex: startedOnDayIndex ?? this.startedOnDayIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetClass.present) {
      map['asset_class'] = Variable<String>(assetClass.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (monthlyCents.present) {
      map['monthly_cents'] = Variable<int>(monthlyCents.value);
    }
    if (startedOnDayIndex.present) {
      map['started_on_day_index'] = Variable<int>(startedOnDayIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsPlansTableCompanion(')
          ..write('id: $id, ')
          ..write('assetClass: $assetClass, ')
          ..write('assetId: $assetId, ')
          ..write('monthlyCents: $monthlyCents, ')
          ..write('startedOnDayIndex: $startedOnDayIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WishItemsTableTable extends WishItemsTable
    with TableInfo<$WishItemsTableTable, WishItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WishItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentPriceCentsMeta = const VerificationMeta(
    'currentPriceCents',
  );
  @override
  late final GeneratedColumn<int> currentPriceCents = GeneratedColumn<int>(
    'current_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownedOnDayIndexMeta = const VerificationMeta(
    'ownedOnDayIndex',
  );
  @override
  late final GeneratedColumn<int> ownedOnDayIndex = GeneratedColumn<int>(
    'owned_on_day_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currentPriceCents,
    ownedOnDayIndex,
    photoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wish_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WishItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('current_price_cents')) {
      context.handle(
        _currentPriceCentsMeta,
        currentPriceCents.isAcceptableOrUnknown(
          data['current_price_cents']!,
          _currentPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentPriceCentsMeta);
    }
    if (data.containsKey('owned_on_day_index')) {
      context.handle(
        _ownedOnDayIndexMeta,
        ownedOnDayIndex.isAcceptableOrUnknown(
          data['owned_on_day_index']!,
          _ownedOnDayIndexMeta,
        ),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WishItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WishItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      currentPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_price_cents'],
      )!,
      ownedOnDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owned_on_day_index'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
    );
  }

  @override
  $WishItemsTableTable createAlias(String alias) {
    return $WishItemsTableTable(attachedDatabase, alias);
  }
}

class WishItemRow extends DataClass implements Insertable<WishItemRow> {
  final String id;
  final int currentPriceCents;
  final int? ownedOnDayIndex;

  /// Welle-8 Round 16: optional User-Foto-Pfad (absolute Datei-Pfad im
  /// app-support dir). Null = Default-Emoji rendern.
  final String? photoPath;
  const WishItemRow({
    required this.id,
    required this.currentPriceCents,
    this.ownedOnDayIndex,
    this.photoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['current_price_cents'] = Variable<int>(currentPriceCents);
    if (!nullToAbsent || ownedOnDayIndex != null) {
      map['owned_on_day_index'] = Variable<int>(ownedOnDayIndex);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  WishItemsTableCompanion toCompanion(bool nullToAbsent) {
    return WishItemsTableCompanion(
      id: Value(id),
      currentPriceCents: Value(currentPriceCents),
      ownedOnDayIndex: ownedOnDayIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(ownedOnDayIndex),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory WishItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WishItemRow(
      id: serializer.fromJson<String>(json['id']),
      currentPriceCents: serializer.fromJson<int>(json['currentPriceCents']),
      ownedOnDayIndex: serializer.fromJson<int?>(json['ownedOnDayIndex']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'currentPriceCents': serializer.toJson<int>(currentPriceCents),
      'ownedOnDayIndex': serializer.toJson<int?>(ownedOnDayIndex),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  WishItemRow copyWith({
    String? id,
    int? currentPriceCents,
    Value<int?> ownedOnDayIndex = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
  }) => WishItemRow(
    id: id ?? this.id,
    currentPriceCents: currentPriceCents ?? this.currentPriceCents,
    ownedOnDayIndex: ownedOnDayIndex.present
        ? ownedOnDayIndex.value
        : this.ownedOnDayIndex,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
  );
  WishItemRow copyWithCompanion(WishItemsTableCompanion data) {
    return WishItemRow(
      id: data.id.present ? data.id.value : this.id,
      currentPriceCents: data.currentPriceCents.present
          ? data.currentPriceCents.value
          : this.currentPriceCents,
      ownedOnDayIndex: data.ownedOnDayIndex.present
          ? data.ownedOnDayIndex.value
          : this.ownedOnDayIndex,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WishItemRow(')
          ..write('id: $id, ')
          ..write('currentPriceCents: $currentPriceCents, ')
          ..write('ownedOnDayIndex: $ownedOnDayIndex, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, currentPriceCents, ownedOnDayIndex, photoPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WishItemRow &&
          other.id == this.id &&
          other.currentPriceCents == this.currentPriceCents &&
          other.ownedOnDayIndex == this.ownedOnDayIndex &&
          other.photoPath == this.photoPath);
}

class WishItemsTableCompanion extends UpdateCompanion<WishItemRow> {
  final Value<String> id;
  final Value<int> currentPriceCents;
  final Value<int?> ownedOnDayIndex;
  final Value<String?> photoPath;
  final Value<int> rowid;
  const WishItemsTableCompanion({
    this.id = const Value.absent(),
    this.currentPriceCents = const Value.absent(),
    this.ownedOnDayIndex = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WishItemsTableCompanion.insert({
    required String id,
    required int currentPriceCents,
    this.ownedOnDayIndex = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       currentPriceCents = Value(currentPriceCents);
  static Insertable<WishItemRow> custom({
    Expression<String>? id,
    Expression<int>? currentPriceCents,
    Expression<int>? ownedOnDayIndex,
    Expression<String>? photoPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentPriceCents != null) 'current_price_cents': currentPriceCents,
      if (ownedOnDayIndex != null) 'owned_on_day_index': ownedOnDayIndex,
      if (photoPath != null) 'photo_path': photoPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WishItemsTableCompanion copyWith({
    Value<String>? id,
    Value<int>? currentPriceCents,
    Value<int?>? ownedOnDayIndex,
    Value<String?>? photoPath,
    Value<int>? rowid,
  }) {
    return WishItemsTableCompanion(
      id: id ?? this.id,
      currentPriceCents: currentPriceCents ?? this.currentPriceCents,
      ownedOnDayIndex: ownedOnDayIndex ?? this.ownedOnDayIndex,
      photoPath: photoPath ?? this.photoPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (currentPriceCents.present) {
      map['current_price_cents'] = Variable<int>(currentPriceCents.value);
    }
    if (ownedOnDayIndex.present) {
      map['owned_on_day_index'] = Variable<int>(ownedOnDayIndex.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WishItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('currentPriceCents: $currentPriceCents, ')
          ..write('ownedOnDayIndex: $ownedOnDayIndex, ')
          ..write('photoPath: $photoPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceHistoryTableTable extends PriceHistoryTable
    with TableInfo<$PriceHistoryTableTable, PriceHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [assetId, dayIndex, priceCents];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PriceHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_priceCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assetId, dayIndex};
  @override
  PriceHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceHistoryRow(
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      )!,
    );
  }

  @override
  $PriceHistoryTableTable createAlias(String alias) {
    return $PriceHistoryTableTable(attachedDatabase, alias);
  }
}

class PriceHistoryRow extends DataClass implements Insertable<PriceHistoryRow> {
  final String assetId;
  final int dayIndex;
  final int priceCents;
  const PriceHistoryRow({
    required this.assetId,
    required this.dayIndex,
    required this.priceCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['asset_id'] = Variable<String>(assetId);
    map['day_index'] = Variable<int>(dayIndex);
    map['price_cents'] = Variable<int>(priceCents);
    return map;
  }

  PriceHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return PriceHistoryTableCompanion(
      assetId: Value(assetId),
      dayIndex: Value(dayIndex),
      priceCents: Value(priceCents),
    );
  }

  factory PriceHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceHistoryRow(
      assetId: serializer.fromJson<String>(json['assetId']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      priceCents: serializer.fromJson<int>(json['priceCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'assetId': serializer.toJson<String>(assetId),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'priceCents': serializer.toJson<int>(priceCents),
    };
  }

  PriceHistoryRow copyWith({String? assetId, int? dayIndex, int? priceCents}) =>
      PriceHistoryRow(
        assetId: assetId ?? this.assetId,
        dayIndex: dayIndex ?? this.dayIndex,
        priceCents: priceCents ?? this.priceCents,
      );
  PriceHistoryRow copyWithCompanion(PriceHistoryTableCompanion data) {
    return PriceHistoryRow(
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryRow(')
          ..write('assetId: $assetId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('priceCents: $priceCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(assetId, dayIndex, priceCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceHistoryRow &&
          other.assetId == this.assetId &&
          other.dayIndex == this.dayIndex &&
          other.priceCents == this.priceCents);
}

class PriceHistoryTableCompanion extends UpdateCompanion<PriceHistoryRow> {
  final Value<String> assetId;
  final Value<int> dayIndex;
  final Value<int> priceCents;
  final Value<int> rowid;
  const PriceHistoryTableCompanion({
    this.assetId = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PriceHistoryTableCompanion.insert({
    required String assetId,
    required int dayIndex,
    required int priceCents,
    this.rowid = const Value.absent(),
  }) : assetId = Value(assetId),
       dayIndex = Value(dayIndex),
       priceCents = Value(priceCents);
  static Insertable<PriceHistoryRow> custom({
    Expression<String>? assetId,
    Expression<int>? dayIndex,
    Expression<int>? priceCents,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (assetId != null) 'asset_id': assetId,
      if (dayIndex != null) 'day_index': dayIndex,
      if (priceCents != null) 'price_cents': priceCents,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PriceHistoryTableCompanion copyWith({
    Value<String>? assetId,
    Value<int>? dayIndex,
    Value<int>? priceCents,
    Value<int>? rowid,
  }) {
    return PriceHistoryTableCompanion(
      assetId: assetId ?? this.assetId,
      dayIndex: dayIndex ?? this.dayIndex,
      priceCents: priceCents ?? this.priceCents,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryTableCompanion(')
          ..write('assetId: $assetId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('priceCents: $priceCents, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnlockedIslandsTableTable extends UnlockedIslandsTable
    with TableInfo<$UnlockedIslandsTableTable, UnlockedIslandRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnlockedIslandsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _islandIdMeta = const VerificationMeta(
    'islandId',
  );
  @override
  late final GeneratedColumn<String> islandId = GeneratedColumn<String>(
    'island_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [islandId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unlocked_islands_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnlockedIslandRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('island_id')) {
      context.handle(
        _islandIdMeta,
        islandId.isAcceptableOrUnknown(data['island_id']!, _islandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_islandIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {islandId};
  @override
  UnlockedIslandRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnlockedIslandRow(
      islandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}island_id'],
      )!,
    );
  }

  @override
  $UnlockedIslandsTableTable createAlias(String alias) {
    return $UnlockedIslandsTableTable(attachedDatabase, alias);
  }
}

class UnlockedIslandRow extends DataClass
    implements Insertable<UnlockedIslandRow> {
  final String islandId;
  const UnlockedIslandRow({required this.islandId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['island_id'] = Variable<String>(islandId);
    return map;
  }

  UnlockedIslandsTableCompanion toCompanion(bool nullToAbsent) {
    return UnlockedIslandsTableCompanion(islandId: Value(islandId));
  }

  factory UnlockedIslandRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnlockedIslandRow(
      islandId: serializer.fromJson<String>(json['islandId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'islandId': serializer.toJson<String>(islandId)};
  }

  UnlockedIslandRow copyWith({String? islandId}) =>
      UnlockedIslandRow(islandId: islandId ?? this.islandId);
  UnlockedIslandRow copyWithCompanion(UnlockedIslandsTableCompanion data) {
    return UnlockedIslandRow(
      islandId: data.islandId.present ? data.islandId.value : this.islandId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedIslandRow(')
          ..write('islandId: $islandId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => islandId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnlockedIslandRow && other.islandId == this.islandId);
}

class UnlockedIslandsTableCompanion extends UpdateCompanion<UnlockedIslandRow> {
  final Value<String> islandId;
  final Value<int> rowid;
  const UnlockedIslandsTableCompanion({
    this.islandId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnlockedIslandsTableCompanion.insert({
    required String islandId,
    this.rowid = const Value.absent(),
  }) : islandId = Value(islandId);
  static Insertable<UnlockedIslandRow> custom({
    Expression<String>? islandId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (islandId != null) 'island_id': islandId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnlockedIslandsTableCompanion copyWith({
    Value<String>? islandId,
    Value<int>? rowid,
  }) {
    return UnlockedIslandsTableCompanion(
      islandId: islandId ?? this.islandId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (islandId.present) {
      map['island_id'] = Variable<String>(islandId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedIslandsTableCompanion(')
          ..write('islandId: $islandId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestProgressTableTable extends QuestProgressTable
    with TableInfo<$QuestProgressTableTable, QuestProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questIdMeta = const VerificationMeta(
    'questId',
  );
  @override
  late final GeneratedColumn<String> questId = GeneratedColumn<String>(
    'quest_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStepIndexMeta = const VerificationMeta(
    'currentStepIndex',
  );
  @override
  late final GeneratedColumn<int> currentStepIndex = GeneratedColumn<int>(
    'current_step_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _startedOnDayIndexMeta = const VerificationMeta(
    'startedOnDayIndex',
  );
  @override
  late final GeneratedColumn<int> startedOnDayIndex = GeneratedColumn<int>(
    'started_on_day_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedOnDayIndexMeta =
      const VerificationMeta('completedOnDayIndex');
  @override
  late final GeneratedColumn<int> completedOnDayIndex = GeneratedColumn<int>(
    'completed_on_day_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    questId,
    currentStepIndex,
    status,
    startedOnDayIndex,
    completedOnDayIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quest_progress_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('quest_id')) {
      context.handle(
        _questIdMeta,
        questId.isAcceptableOrUnknown(data['quest_id']!, _questIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questIdMeta);
    }
    if (data.containsKey('current_step_index')) {
      context.handle(
        _currentStepIndexMeta,
        currentStepIndex.isAcceptableOrUnknown(
          data['current_step_index']!,
          _currentStepIndexMeta,
        ),
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
    if (data.containsKey('started_on_day_index')) {
      context.handle(
        _startedOnDayIndexMeta,
        startedOnDayIndex.isAcceptableOrUnknown(
          data['started_on_day_index']!,
          _startedOnDayIndexMeta,
        ),
      );
    }
    if (data.containsKey('completed_on_day_index')) {
      context.handle(
        _completedOnDayIndexMeta,
        completedOnDayIndex.isAcceptableOrUnknown(
          data['completed_on_day_index']!,
          _completedOnDayIndexMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questId};
  @override
  QuestProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestProgressRow(
      questId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quest_id'],
      )!,
      currentStepIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_step_index'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedOnDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_on_day_index'],
      ),
      completedOnDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_on_day_index'],
      ),
    );
  }

  @override
  $QuestProgressTableTable createAlias(String alias) {
    return $QuestProgressTableTable(attachedDatabase, alias);
  }
}

class QuestProgressRow extends DataClass
    implements Insertable<QuestProgressRow> {
  final String questId;
  final int currentStepIndex;
  final String status;
  final int? startedOnDayIndex;
  final int? completedOnDayIndex;
  const QuestProgressRow({
    required this.questId,
    required this.currentStepIndex,
    required this.status,
    this.startedOnDayIndex,
    this.completedOnDayIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['quest_id'] = Variable<String>(questId);
    map['current_step_index'] = Variable<int>(currentStepIndex);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || startedOnDayIndex != null) {
      map['started_on_day_index'] = Variable<int>(startedOnDayIndex);
    }
    if (!nullToAbsent || completedOnDayIndex != null) {
      map['completed_on_day_index'] = Variable<int>(completedOnDayIndex);
    }
    return map;
  }

  QuestProgressTableCompanion toCompanion(bool nullToAbsent) {
    return QuestProgressTableCompanion(
      questId: Value(questId),
      currentStepIndex: Value(currentStepIndex),
      status: Value(status),
      startedOnDayIndex: startedOnDayIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(startedOnDayIndex),
      completedOnDayIndex: completedOnDayIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(completedOnDayIndex),
    );
  }

  factory QuestProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestProgressRow(
      questId: serializer.fromJson<String>(json['questId']),
      currentStepIndex: serializer.fromJson<int>(json['currentStepIndex']),
      status: serializer.fromJson<String>(json['status']),
      startedOnDayIndex: serializer.fromJson<int?>(json['startedOnDayIndex']),
      completedOnDayIndex: serializer.fromJson<int?>(
        json['completedOnDayIndex'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questId': serializer.toJson<String>(questId),
      'currentStepIndex': serializer.toJson<int>(currentStepIndex),
      'status': serializer.toJson<String>(status),
      'startedOnDayIndex': serializer.toJson<int?>(startedOnDayIndex),
      'completedOnDayIndex': serializer.toJson<int?>(completedOnDayIndex),
    };
  }

  QuestProgressRow copyWith({
    String? questId,
    int? currentStepIndex,
    String? status,
    Value<int?> startedOnDayIndex = const Value.absent(),
    Value<int?> completedOnDayIndex = const Value.absent(),
  }) => QuestProgressRow(
    questId: questId ?? this.questId,
    currentStepIndex: currentStepIndex ?? this.currentStepIndex,
    status: status ?? this.status,
    startedOnDayIndex: startedOnDayIndex.present
        ? startedOnDayIndex.value
        : this.startedOnDayIndex,
    completedOnDayIndex: completedOnDayIndex.present
        ? completedOnDayIndex.value
        : this.completedOnDayIndex,
  );
  QuestProgressRow copyWithCompanion(QuestProgressTableCompanion data) {
    return QuestProgressRow(
      questId: data.questId.present ? data.questId.value : this.questId,
      currentStepIndex: data.currentStepIndex.present
          ? data.currentStepIndex.value
          : this.currentStepIndex,
      status: data.status.present ? data.status.value : this.status,
      startedOnDayIndex: data.startedOnDayIndex.present
          ? data.startedOnDayIndex.value
          : this.startedOnDayIndex,
      completedOnDayIndex: data.completedOnDayIndex.present
          ? data.completedOnDayIndex.value
          : this.completedOnDayIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestProgressRow(')
          ..write('questId: $questId, ')
          ..write('currentStepIndex: $currentStepIndex, ')
          ..write('status: $status, ')
          ..write('startedOnDayIndex: $startedOnDayIndex, ')
          ..write('completedOnDayIndex: $completedOnDayIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    questId,
    currentStepIndex,
    status,
    startedOnDayIndex,
    completedOnDayIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestProgressRow &&
          other.questId == this.questId &&
          other.currentStepIndex == this.currentStepIndex &&
          other.status == this.status &&
          other.startedOnDayIndex == this.startedOnDayIndex &&
          other.completedOnDayIndex == this.completedOnDayIndex);
}

class QuestProgressTableCompanion extends UpdateCompanion<QuestProgressRow> {
  final Value<String> questId;
  final Value<int> currentStepIndex;
  final Value<String> status;
  final Value<int?> startedOnDayIndex;
  final Value<int?> completedOnDayIndex;
  final Value<int> rowid;
  const QuestProgressTableCompanion({
    this.questId = const Value.absent(),
    this.currentStepIndex = const Value.absent(),
    this.status = const Value.absent(),
    this.startedOnDayIndex = const Value.absent(),
    this.completedOnDayIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestProgressTableCompanion.insert({
    required String questId,
    this.currentStepIndex = const Value.absent(),
    required String status,
    this.startedOnDayIndex = const Value.absent(),
    this.completedOnDayIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : questId = Value(questId),
       status = Value(status);
  static Insertable<QuestProgressRow> custom({
    Expression<String>? questId,
    Expression<int>? currentStepIndex,
    Expression<String>? status,
    Expression<int>? startedOnDayIndex,
    Expression<int>? completedOnDayIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questId != null) 'quest_id': questId,
      if (currentStepIndex != null) 'current_step_index': currentStepIndex,
      if (status != null) 'status': status,
      if (startedOnDayIndex != null) 'started_on_day_index': startedOnDayIndex,
      if (completedOnDayIndex != null)
        'completed_on_day_index': completedOnDayIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestProgressTableCompanion copyWith({
    Value<String>? questId,
    Value<int>? currentStepIndex,
    Value<String>? status,
    Value<int?>? startedOnDayIndex,
    Value<int?>? completedOnDayIndex,
    Value<int>? rowid,
  }) {
    return QuestProgressTableCompanion(
      questId: questId ?? this.questId,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      status: status ?? this.status,
      startedOnDayIndex: startedOnDayIndex ?? this.startedOnDayIndex,
      completedOnDayIndex: completedOnDayIndex ?? this.completedOnDayIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questId.present) {
      map['quest_id'] = Variable<String>(questId.value);
    }
    if (currentStepIndex.present) {
      map['current_step_index'] = Variable<int>(currentStepIndex.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedOnDayIndex.present) {
      map['started_on_day_index'] = Variable<int>(startedOnDayIndex.value);
    }
    if (completedOnDayIndex.present) {
      map['completed_on_day_index'] = Variable<int>(completedOnDayIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestProgressTableCompanion(')
          ..write('questId: $questId, ')
          ..write('currentStepIndex: $currentStepIndex, ')
          ..write('status: $status, ')
          ..write('startedOnDayIndex: $startedOnDayIndex, ')
          ..write('completedOnDayIndex: $completedOnDayIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestChatEntriesTableTable extends QuestChatEntriesTable
    with TableInfo<$QuestChatEntriesTableTable, QuestChatEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestChatEntriesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _questIdMeta = const VerificationMeta(
    'questId',
  );
  @override
  late final GeneratedColumn<String> questId = GeneratedColumn<String>(
    'quest_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    questId,
    orderIndex,
    kind,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quest_chat_entries_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestChatEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quest_id')) {
      context.handle(
        _questIdMeta,
        questId.isAcceptableOrUnknown(data['quest_id']!, _questIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestChatEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestChatEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      questId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quest_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $QuestChatEntriesTableTable createAlias(String alias) {
    return $QuestChatEntriesTableTable(attachedDatabase, alias);
  }
}

class QuestChatEntryRow extends DataClass
    implements Insertable<QuestChatEntryRow> {
  final int id;
  final String questId;
  final int orderIndex;
  final String kind;
  final String payloadJson;
  const QuestChatEntryRow({
    required this.id,
    required this.questId,
    required this.orderIndex,
    required this.kind,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['quest_id'] = Variable<String>(questId);
    map['order_index'] = Variable<int>(orderIndex);
    map['kind'] = Variable<String>(kind);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  QuestChatEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return QuestChatEntriesTableCompanion(
      id: Value(id),
      questId: Value(questId),
      orderIndex: Value(orderIndex),
      kind: Value(kind),
      payloadJson: Value(payloadJson),
    );
  }

  factory QuestChatEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestChatEntryRow(
      id: serializer.fromJson<int>(json['id']),
      questId: serializer.fromJson<String>(json['questId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      kind: serializer.fromJson<String>(json['kind']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'questId': serializer.toJson<String>(questId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'kind': serializer.toJson<String>(kind),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  QuestChatEntryRow copyWith({
    int? id,
    String? questId,
    int? orderIndex,
    String? kind,
    String? payloadJson,
  }) => QuestChatEntryRow(
    id: id ?? this.id,
    questId: questId ?? this.questId,
    orderIndex: orderIndex ?? this.orderIndex,
    kind: kind ?? this.kind,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  QuestChatEntryRow copyWithCompanion(QuestChatEntriesTableCompanion data) {
    return QuestChatEntryRow(
      id: data.id.present ? data.id.value : this.id,
      questId: data.questId.present ? data.questId.value : this.questId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      kind: data.kind.present ? data.kind.value : this.kind,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestChatEntryRow(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('kind: $kind, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, questId, orderIndex, kind, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestChatEntryRow &&
          other.id == this.id &&
          other.questId == this.questId &&
          other.orderIndex == this.orderIndex &&
          other.kind == this.kind &&
          other.payloadJson == this.payloadJson);
}

class QuestChatEntriesTableCompanion
    extends UpdateCompanion<QuestChatEntryRow> {
  final Value<int> id;
  final Value<String> questId;
  final Value<int> orderIndex;
  final Value<String> kind;
  final Value<String> payloadJson;
  const QuestChatEntriesTableCompanion({
    this.id = const Value.absent(),
    this.questId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.kind = const Value.absent(),
    this.payloadJson = const Value.absent(),
  });
  QuestChatEntriesTableCompanion.insert({
    this.id = const Value.absent(),
    required String questId,
    required int orderIndex,
    required String kind,
    required String payloadJson,
  }) : questId = Value(questId),
       orderIndex = Value(orderIndex),
       kind = Value(kind),
       payloadJson = Value(payloadJson);
  static Insertable<QuestChatEntryRow> custom({
    Expression<int>? id,
    Expression<String>? questId,
    Expression<int>? orderIndex,
    Expression<String>? kind,
    Expression<String>? payloadJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questId != null) 'quest_id': questId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (kind != null) 'kind': kind,
      if (payloadJson != null) 'payload_json': payloadJson,
    });
  }

  QuestChatEntriesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? questId,
    Value<int>? orderIndex,
    Value<String>? kind,
    Value<String>? payloadJson,
  }) {
    return QuestChatEntriesTableCompanion(
      id: id ?? this.id,
      questId: questId ?? this.questId,
      orderIndex: orderIndex ?? this.orderIndex,
      kind: kind ?? this.kind,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questId.present) {
      map['quest_id'] = Variable<String>(questId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestChatEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('kind: $kind, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _allowanceCentsMeta = const VerificationMeta(
    'allowanceCents',
  );
  @override
  late final GeneratedColumn<int> allowanceCents = GeneratedColumn<int>(
    'allowance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8000),
  );
  static const VerificationMeta _allowanceWeekdayMeta = const VerificationMeta(
    'allowanceWeekday',
  );
  @override
  late final GeneratedColumn<String> allowanceWeekday = GeneratedColumn<String>(
    'allowance_weekday',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mon'),
  );
  static const VerificationMeta _playerNameMeta = const VerificationMeta(
    'playerName',
  );
  @override
  late final GeneratedColumn<String> playerName = GeneratedColumn<String>(
    'player_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Spieler'),
  );
  static const VerificationMeta _soundEnabledMeta = const VerificationMeta(
    'soundEnabled',
  );
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
    'sound_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastQuizDayIndexMeta = const VerificationMeta(
    'lastQuizDayIndex',
  );
  @override
  late final GeneratedColumn<int> lastQuizDayIndex = GeneratedColumn<int>(
    'last_quiz_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _zeitreiseTutorialSeenMeta =
      const VerificationMeta('zeitreiseTutorialSeen');
  @override
  late final GeneratedColumn<bool> zeitreiseTutorialSeen =
      GeneratedColumn<bool>(
        'zeitreise_tutorial_seen',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("zeitreise_tutorial_seen" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _musicVolumeMeta = const VerificationMeta(
    'musicVolume',
  );
  @override
  late final GeneratedColumn<int> musicVolume = GeneratedColumn<int>(
    'music_volume',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _masterVolumeMeta = const VerificationMeta(
    'masterVolume',
  );
  @override
  late final GeneratedColumn<int> masterVolume = GeneratedColumn<int>(
    'master_volume',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _sfxVolumeMeta = const VerificationMeta(
    'sfxVolume',
  );
  @override
  late final GeneratedColumn<int> sfxVolume = GeneratedColumn<int>(
    'sfx_volume',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(40),
  );
  static const VerificationMeta _lastSleepEpochMsMeta = const VerificationMeta(
    'lastSleepEpochMs',
  );
  @override
  late final GeneratedColumn<int> lastSleepEpochMs = GeneratedColumn<int>(
    'last_sleep_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sleepCountInWindowMeta =
      const VerificationMeta('sleepCountInWindow');
  @override
  late final GeneratedColumn<int> sleepCountInWindow = GeneratedColumn<int>(
    'sleep_count_in_window',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _avatarEmojiMeta = const VerificationMeta(
    'avatarEmoji',
  );
  @override
  late final GeneratedColumn<String> avatarEmoji = GeneratedColumn<String>(
    'avatar_emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('🧒'),
  );
  static const VerificationMeta _streakCountMeta = const VerificationMeta(
    'streakCount',
  );
  @override
  late final GeneratedColumn<int> streakCount = GeneratedColumn<int>(
    'streak_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSleepDateIsoMeta = const VerificationMeta(
    'lastSleepDateIso',
  );
  @override
  late final GeneratedColumn<String> lastSleepDateIso = GeneratedColumn<String>(
    'last_sleep_date_iso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _unlockedAvatarsMeta = const VerificationMeta(
    'unlockedAvatars',
  );
  @override
  late final GeneratedColumn<String> unlockedAvatars = GeneratedColumn<String>(
    'unlocked_avatars',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _unlockedDecorMeta = const VerificationMeta(
    'unlockedDecor',
  );
  @override
  late final GeneratedColumn<String> unlockedDecor = GeneratedColumn<String>(
    'unlocked_decor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _unlockedSkillsMeta = const VerificationMeta(
    'unlockedSkills',
  );
  @override
  late final GeneratedColumn<String> unlockedSkills = GeneratedColumn<String>(
    'unlocked_skills',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _weeklyChallengeClaimedWeekMeta =
      const VerificationMeta('weeklyChallengeClaimedWeek');
  @override
  late final GeneratedColumn<int> weeklyChallengeClaimedWeek =
      GeneratedColumn<int>(
        'weekly_challenge_claimed_week',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(-1),
      );
  static const VerificationMeta _weeklyChallengeStreakMeta =
      const VerificationMeta('weeklyChallengeStreak');
  @override
  late final GeneratedColumn<int> weeklyChallengeStreak = GeneratedColumn<int>(
    'weekly_challenge_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _claimedStreakMilestoneMeta =
      const VerificationMeta('claimedStreakMilestone');
  @override
  late final GeneratedColumn<int> claimedStreakMilestone = GeneratedColumn<int>(
    'claimed_streak_milestone',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _autoSaveDisabledMeta = const VerificationMeta(
    'autoSaveDisabled',
  );
  @override
  late final GeneratedColumn<bool> autoSaveDisabled = GeneratedColumn<bool>(
    'auto_save_disabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_save_disabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _backupFolderUriMeta = const VerificationMeta(
    'backupFolderUri',
  );
  @override
  late final GeneratedColumn<String> backupFolderUri = GeneratedColumn<String>(
    'backup_folder_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthYearMeta = const VerificationMeta(
    'birthYear',
  );
  @override
  late final GeneratedColumn<int> birthYear = GeneratedColumn<int>(
    'birth_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthYearAskedMeta = const VerificationMeta(
    'birthYearAsked',
  );
  @override
  late final GeneratedColumn<bool> birthYearAsked = GeneratedColumn<bool>(
    'birth_year_asked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("birth_year_asked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _parentGateLockedUntilMsMeta =
      const VerificationMeta('parentGateLockedUntilMs');
  @override
  late final GeneratedColumn<int> parentGateLockedUntilMs =
      GeneratedColumn<int>(
        'parent_gate_locked_until_ms',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _sparPlotCountMeta = const VerificationMeta(
    'sparPlotCount',
  );
  @override
  late final GeneratedColumn<int> sparPlotCount = GeneratedColumn<int>(
    'spar_plot_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _quizLearnedTopicsMeta = const VerificationMeta(
    'quizLearnedTopics',
  );
  @override
  late final GeneratedColumn<String> quizLearnedTopics =
      GeneratedColumn<String>(
        'quiz_learned_topics',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _seenCoachesMeta = const VerificationMeta(
    'seenCoaches',
  );
  @override
  late final GeneratedColumn<String> seenCoaches = GeneratedColumn<String>(
    'seen_coaches',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _lastWeekNetWorthCentsMeta =
      const VerificationMeta('lastWeekNetWorthCents');
  @override
  late final GeneratedColumn<int> lastWeekNetWorthCents = GeneratedColumn<int>(
    'last_week_net_worth_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastWeeklyReviewDayMeta =
      const VerificationMeta('lastWeeklyReviewDay');
  @override
  late final GeneratedColumn<int> lastWeeklyReviewDay = GeneratedColumn<int>(
    'last_weekly_review_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _recentQuizTextsMeta = const VerificationMeta(
    'recentQuizTexts',
  );
  @override
  late final GeneratedColumn<String> recentQuizTexts = GeneratedColumn<String>(
    'recent_quiz_texts',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _startAgeYearsMeta = const VerificationMeta(
    'startAgeYears',
  );
  @override
  late final GeneratedColumn<int> startAgeYears = GeneratedColumn<int>(
    'start_age_years',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(13),
  );
  static const VerificationMeta _savingsRatePctMeta = const VerificationMeta(
    'savingsRatePct',
  );
  @override
  late final GeneratedColumn<int> savingsRatePct = GeneratedColumn<int>(
    'savings_rate_pct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastClaimedGoalDayMeta =
      const VerificationMeta('lastClaimedGoalDay');
  @override
  late final GeneratedColumn<int> lastClaimedGoalDay = GeneratedColumn<int>(
    'last_claimed_goal_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _parentPinMeta = const VerificationMeta(
    'parentPin',
  );
  @override
  late final GeneratedColumn<String> parentPin = GeneratedColumn<String>(
    'parent_pin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    allowanceCents,
    allowanceWeekday,
    playerName,
    soundEnabled,
    lastQuizDayIndex,
    zeitreiseTutorialSeen,
    musicVolume,
    masterVolume,
    sfxVolume,
    lastSleepEpochMs,
    sleepCountInWindow,
    onboardingComplete,
    avatarEmoji,
    streakCount,
    lastSleepDateIso,
    unlockedAvatars,
    unlockedDecor,
    unlockedSkills,
    weeklyChallengeClaimedWeek,
    weeklyChallengeStreak,
    claimedStreakMilestone,
    autoSaveDisabled,
    backupFolderUri,
    birthYear,
    birthYearAsked,
    parentGateLockedUntilMs,
    sparPlotCount,
    quizLearnedTopics,
    seenCoaches,
    lastWeekNetWorthCents,
    lastWeeklyReviewDay,
    recentQuizTexts,
    startAgeYears,
    savingsRatePct,
    lastClaimedGoalDay,
    parentPin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('allowance_cents')) {
      context.handle(
        _allowanceCentsMeta,
        allowanceCents.isAcceptableOrUnknown(
          data['allowance_cents']!,
          _allowanceCentsMeta,
        ),
      );
    }
    if (data.containsKey('allowance_weekday')) {
      context.handle(
        _allowanceWeekdayMeta,
        allowanceWeekday.isAcceptableOrUnknown(
          data['allowance_weekday']!,
          _allowanceWeekdayMeta,
        ),
      );
    }
    if (data.containsKey('player_name')) {
      context.handle(
        _playerNameMeta,
        playerName.isAcceptableOrUnknown(data['player_name']!, _playerNameMeta),
      );
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
        _soundEnabledMeta,
        soundEnabled.isAcceptableOrUnknown(
          data['sound_enabled']!,
          _soundEnabledMeta,
        ),
      );
    }
    if (data.containsKey('last_quiz_day_index')) {
      context.handle(
        _lastQuizDayIndexMeta,
        lastQuizDayIndex.isAcceptableOrUnknown(
          data['last_quiz_day_index']!,
          _lastQuizDayIndexMeta,
        ),
      );
    }
    if (data.containsKey('zeitreise_tutorial_seen')) {
      context.handle(
        _zeitreiseTutorialSeenMeta,
        zeitreiseTutorialSeen.isAcceptableOrUnknown(
          data['zeitreise_tutorial_seen']!,
          _zeitreiseTutorialSeenMeta,
        ),
      );
    }
    if (data.containsKey('music_volume')) {
      context.handle(
        _musicVolumeMeta,
        musicVolume.isAcceptableOrUnknown(
          data['music_volume']!,
          _musicVolumeMeta,
        ),
      );
    }
    if (data.containsKey('master_volume')) {
      context.handle(
        _masterVolumeMeta,
        masterVolume.isAcceptableOrUnknown(
          data['master_volume']!,
          _masterVolumeMeta,
        ),
      );
    }
    if (data.containsKey('sfx_volume')) {
      context.handle(
        _sfxVolumeMeta,
        sfxVolume.isAcceptableOrUnknown(data['sfx_volume']!, _sfxVolumeMeta),
      );
    }
    if (data.containsKey('last_sleep_epoch_ms')) {
      context.handle(
        _lastSleepEpochMsMeta,
        lastSleepEpochMs.isAcceptableOrUnknown(
          data['last_sleep_epoch_ms']!,
          _lastSleepEpochMsMeta,
        ),
      );
    }
    if (data.containsKey('sleep_count_in_window')) {
      context.handle(
        _sleepCountInWindowMeta,
        sleepCountInWindow.isAcceptableOrUnknown(
          data['sleep_count_in_window']!,
          _sleepCountInWindowMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    if (data.containsKey('avatar_emoji')) {
      context.handle(
        _avatarEmojiMeta,
        avatarEmoji.isAcceptableOrUnknown(
          data['avatar_emoji']!,
          _avatarEmojiMeta,
        ),
      );
    }
    if (data.containsKey('streak_count')) {
      context.handle(
        _streakCountMeta,
        streakCount.isAcceptableOrUnknown(
          data['streak_count']!,
          _streakCountMeta,
        ),
      );
    }
    if (data.containsKey('last_sleep_date_iso')) {
      context.handle(
        _lastSleepDateIsoMeta,
        lastSleepDateIso.isAcceptableOrUnknown(
          data['last_sleep_date_iso']!,
          _lastSleepDateIsoMeta,
        ),
      );
    }
    if (data.containsKey('unlocked_avatars')) {
      context.handle(
        _unlockedAvatarsMeta,
        unlockedAvatars.isAcceptableOrUnknown(
          data['unlocked_avatars']!,
          _unlockedAvatarsMeta,
        ),
      );
    }
    if (data.containsKey('unlocked_decor')) {
      context.handle(
        _unlockedDecorMeta,
        unlockedDecor.isAcceptableOrUnknown(
          data['unlocked_decor']!,
          _unlockedDecorMeta,
        ),
      );
    }
    if (data.containsKey('unlocked_skills')) {
      context.handle(
        _unlockedSkillsMeta,
        unlockedSkills.isAcceptableOrUnknown(
          data['unlocked_skills']!,
          _unlockedSkillsMeta,
        ),
      );
    }
    if (data.containsKey('weekly_challenge_claimed_week')) {
      context.handle(
        _weeklyChallengeClaimedWeekMeta,
        weeklyChallengeClaimedWeek.isAcceptableOrUnknown(
          data['weekly_challenge_claimed_week']!,
          _weeklyChallengeClaimedWeekMeta,
        ),
      );
    }
    if (data.containsKey('weekly_challenge_streak')) {
      context.handle(
        _weeklyChallengeStreakMeta,
        weeklyChallengeStreak.isAcceptableOrUnknown(
          data['weekly_challenge_streak']!,
          _weeklyChallengeStreakMeta,
        ),
      );
    }
    if (data.containsKey('claimed_streak_milestone')) {
      context.handle(
        _claimedStreakMilestoneMeta,
        claimedStreakMilestone.isAcceptableOrUnknown(
          data['claimed_streak_milestone']!,
          _claimedStreakMilestoneMeta,
        ),
      );
    }
    if (data.containsKey('auto_save_disabled')) {
      context.handle(
        _autoSaveDisabledMeta,
        autoSaveDisabled.isAcceptableOrUnknown(
          data['auto_save_disabled']!,
          _autoSaveDisabledMeta,
        ),
      );
    }
    if (data.containsKey('backup_folder_uri')) {
      context.handle(
        _backupFolderUriMeta,
        backupFolderUri.isAcceptableOrUnknown(
          data['backup_folder_uri']!,
          _backupFolderUriMeta,
        ),
      );
    }
    if (data.containsKey('birth_year')) {
      context.handle(
        _birthYearMeta,
        birthYear.isAcceptableOrUnknown(data['birth_year']!, _birthYearMeta),
      );
    }
    if (data.containsKey('birth_year_asked')) {
      context.handle(
        _birthYearAskedMeta,
        birthYearAsked.isAcceptableOrUnknown(
          data['birth_year_asked']!,
          _birthYearAskedMeta,
        ),
      );
    }
    if (data.containsKey('parent_gate_locked_until_ms')) {
      context.handle(
        _parentGateLockedUntilMsMeta,
        parentGateLockedUntilMs.isAcceptableOrUnknown(
          data['parent_gate_locked_until_ms']!,
          _parentGateLockedUntilMsMeta,
        ),
      );
    }
    if (data.containsKey('spar_plot_count')) {
      context.handle(
        _sparPlotCountMeta,
        sparPlotCount.isAcceptableOrUnknown(
          data['spar_plot_count']!,
          _sparPlotCountMeta,
        ),
      );
    }
    if (data.containsKey('quiz_learned_topics')) {
      context.handle(
        _quizLearnedTopicsMeta,
        quizLearnedTopics.isAcceptableOrUnknown(
          data['quiz_learned_topics']!,
          _quizLearnedTopicsMeta,
        ),
      );
    }
    if (data.containsKey('seen_coaches')) {
      context.handle(
        _seenCoachesMeta,
        seenCoaches.isAcceptableOrUnknown(
          data['seen_coaches']!,
          _seenCoachesMeta,
        ),
      );
    }
    if (data.containsKey('last_week_net_worth_cents')) {
      context.handle(
        _lastWeekNetWorthCentsMeta,
        lastWeekNetWorthCents.isAcceptableOrUnknown(
          data['last_week_net_worth_cents']!,
          _lastWeekNetWorthCentsMeta,
        ),
      );
    }
    if (data.containsKey('last_weekly_review_day')) {
      context.handle(
        _lastWeeklyReviewDayMeta,
        lastWeeklyReviewDay.isAcceptableOrUnknown(
          data['last_weekly_review_day']!,
          _lastWeeklyReviewDayMeta,
        ),
      );
    }
    if (data.containsKey('recent_quiz_texts')) {
      context.handle(
        _recentQuizTextsMeta,
        recentQuizTexts.isAcceptableOrUnknown(
          data['recent_quiz_texts']!,
          _recentQuizTextsMeta,
        ),
      );
    }
    if (data.containsKey('start_age_years')) {
      context.handle(
        _startAgeYearsMeta,
        startAgeYears.isAcceptableOrUnknown(
          data['start_age_years']!,
          _startAgeYearsMeta,
        ),
      );
    }
    if (data.containsKey('savings_rate_pct')) {
      context.handle(
        _savingsRatePctMeta,
        savingsRatePct.isAcceptableOrUnknown(
          data['savings_rate_pct']!,
          _savingsRatePctMeta,
        ),
      );
    }
    if (data.containsKey('last_claimed_goal_day')) {
      context.handle(
        _lastClaimedGoalDayMeta,
        lastClaimedGoalDay.isAcceptableOrUnknown(
          data['last_claimed_goal_day']!,
          _lastClaimedGoalDayMeta,
        ),
      );
    }
    if (data.containsKey('parent_pin')) {
      context.handle(
        _parentPinMeta,
        parentPin.isAcceptableOrUnknown(data['parent_pin']!, _parentPinMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      allowanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allowance_cents'],
      )!,
      allowanceWeekday: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allowance_weekday'],
      )!,
      playerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_name'],
      )!,
      soundEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_enabled'],
      )!,
      lastQuizDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_quiz_day_index'],
      )!,
      zeitreiseTutorialSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}zeitreise_tutorial_seen'],
      )!,
      musicVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}music_volume'],
      )!,
      masterVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}master_volume'],
      )!,
      sfxVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sfx_volume'],
      )!,
      lastSleepEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sleep_epoch_ms'],
      )!,
      sleepCountInWindow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_count_in_window'],
      )!,
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      avatarEmoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_emoji'],
      )!,
      streakCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_count'],
      )!,
      lastSleepDateIso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sleep_date_iso'],
      )!,
      unlockedAvatars: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unlocked_avatars'],
      )!,
      unlockedDecor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unlocked_decor'],
      )!,
      unlockedSkills: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unlocked_skills'],
      )!,
      weeklyChallengeClaimedWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_challenge_claimed_week'],
      )!,
      weeklyChallengeStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_challenge_streak'],
      )!,
      claimedStreakMilestone: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}claimed_streak_milestone'],
      )!,
      autoSaveDisabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_save_disabled'],
      )!,
      backupFolderUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backup_folder_uri'],
      ),
      birthYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birth_year'],
      ),
      birthYearAsked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}birth_year_asked'],
      )!,
      parentGateLockedUntilMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_gate_locked_until_ms'],
      )!,
      sparPlotCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spar_plot_count'],
      )!,
      quizLearnedTopics: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_learned_topics'],
      )!,
      seenCoaches: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seen_coaches'],
      )!,
      lastWeekNetWorthCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_week_net_worth_cents'],
      )!,
      lastWeeklyReviewDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_weekly_review_day'],
      )!,
      recentQuizTexts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recent_quiz_texts'],
      )!,
      startAgeYears: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_age_years'],
      )!,
      savingsRatePct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}savings_rate_pct'],
      )!,
      lastClaimedGoalDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_claimed_goal_day'],
      )!,
      parentPin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_pin'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final int allowanceCents;
  final String allowanceWeekday;
  final String playerName;
  final bool soundEnabled;

  /// Spec-17: index of the last GameClock day on which the daily quiz was
  /// shown. -1 = never shown. Used to gate the once-per-day overlay.
  final int lastQuizDayIndex;

  /// Spec-19: tracks whether the Zeitreise tutorial overlay has already
  /// been shown + dismissed. Default false = show on first open.
  final bool zeitreiseTutorialSeen;

  /// Spec-23: music volume in percent (0..100). Default 25 — Test-Tag-2
  /// feedback: music at full volume is "nervig". Applied to the
  /// AudioPlayer at startMusic + on slider change.
  final int musicVolume;

  /// Spec-27: master multiplier (0..100). Defaults to 60.
  final int masterVolume;

  /// Spec-27: SFX-category multiplier (0..100). Defaults to 40.
  final int sfxVolume;

  /// Spec-33: anti-glitch — millisecond epoch of the most recent
  /// real-world sleep action plus a counter of sleeps within the current
  /// 8-hour window. Used to escalate cost and enforce a cooldown.
  final int lastSleepEpochMs;
  final int sleepCountInWindow;

  /// Spec-34: onboarding flag + avatar emoji selected during first-run.
  final bool onboardingComplete;
  final String avatarEmoji;

  /// Spec-40 C: Daily-Streak — Anzahl konsekutiver Real-Tage mit
  /// mindestens einer Schlaf-Aktion.
  final int streakCount;

  /// Letzter Schlaf-Real-Tag als YYYY-MM-DD-String. Empty bei null.
  final String lastSleepDateIso;

  /// Spec-41 A: freigeschaltete Avatar-Glyphs als komma-separierte Liste
  /// (z.B. "🦸,🐱"). Default-Glyph 🧒 ist immer implicit-unlocked.
  final String unlockedAvatars;

  /// Spec-43 Stage 1: freigeschaltete Decor-Items als CSV (decorId).
  final String unlockedDecor;

  /// Round 28: freigeschaltete Skill-Baum-Knoten als CSV (skillId). Pro
  /// Level 1 Skill-Punkt; verfügbar = Level − Anzahl freigeschaltet.
  final String unlockedSkills;

  /// Round 28 v4: Wochen-Herausforderung. Zuletzt eingelöste Spielwoche
  /// (`dayIndex ~/ 7`); -1 = noch keine. + Streak aufeinanderfolgender
  /// eingelöster Wochen.
  final int weeklyChallengeClaimedWeek;
  final int weeklyChallengeStreak;

  /// Optionen-Backlog #2 (Drift v34): höchste bereits ausgezahlte Streak-
  /// Meilenstein-Schwelle (7/14/30/100). 0 = noch keine. Lifetime-Guard
  /// gegen Farming (Streak brechen + neu aufbauen zahlt nicht erneut).
  final int claimedStreakMilestone;

  /// Drift v36: Auto-Sicherung nach Download/Finanzgame/ ist standardmäßig
  /// AN. Diese Spalte speichert das manuelle Ausschalten (opt-out) → `false`
  /// = AN (Default), `true` = vom Nutzer deaktiviert.
  final bool autoSaveDisabled;

  /// Drift v37: Storage-Access-Framework Tree-URI des vom Nutzer gewählten
  /// Backup-Ordners. Null = kein Ordner gewählt (dann Legacy-Pfad über
  /// MANAGE_EXTERNAL_STORAGE). Überlebt App-Neustart, NICHT Deinstall (die
  /// DB wird mit deinstalliert) — nach Reinstall wählt der Nutzer neu.
  final String? backupFolderUri;

  /// Drift v38 — Altersstatus für den Unterstützen-Bereich.
  ///
  /// Gespeichert wird AUSSCHLIESSLICH das Geburtsjahr, kein volles Datum und
  /// kein Name. Das reicht für die Unterscheidung volljährig/minderjährig und
  /// ist das Minimum an Angabe, das die Google-Familienrichtlinie für einen
  /// Weg aus der App zu einem Zahlungsanbieter verlangt. Null = noch nicht
  /// angegeben (der Nutzer darf die Frage überspringen).
  ///
  /// NICHT zu verwechseln mit `startAgeYears`: das ist das Start-Alter der
  /// SPIELFIGUR (steuert Job-Level, Lebenskosten, Versicherungsprämien).
  /// Hier geht es um die echte Person am Gerät.
  final int? birthYear;

  /// Ob die Geburtsjahr-Frage schon einmal gestellt wurde. Sie wird pro
  /// Installation genau einmal gezeigt — wer sie überspringt, wird nicht bei
  /// jedem Start erneut gefragt.
  final bool birthYearAsked;

  /// Zeitstempel (ms seit Epoch), bis zu dem die Eltern-Rechenaufgabe
  /// gesperrt ist. Persistiert, damit die Sperre einen App-Neustart übersteht
  /// — sonst wäre sie mit einem Wisch aus dem Task-Switcher weg.
  final int parentGateLockedUntilMs;

  /// Spec-43 follow-up: Anzahl Pflanz-Plots auf der Sparinsel.
  /// Default 4, kaufbar bis max 10 via XP.
  final int sparPlotCount;

  /// Welle-8 Round 14: Quiz-Topics die der Spieler korrekt beantwortet
  /// hat (1. Versuch). Komma-separiert. Erweitert learnedTopicsProvider
  /// — Glossar markiert auch via Quiz gelernte Begriffe als gelernt.
  final String quizLearnedTopics;

  /// Welle-8 Round 15: First-Steps-Coach gesehen-IDs (CSV). Pro Screen
  /// ein Eintrag (z.B. "bank,etf,krypto") — Overlay verschwindet
  /// dauerhaft sobald getippt.
  final String seenCoaches;

  /// Welle-8 Round 15: Wochen-Rückblick — Vermögen vor 7 Spieltagen +
  /// letzter dayIndex bei dem Review angezeigt wurde.
  final int lastWeekNetWorthCents;
  final int lastWeeklyReviewDay;

  /// Welle-8 Round 15: zuletzt gezeigte Quiz-Frage-Texte. Pipe-separiert
  /// (Quiz-Texte enthalten Kommas → Separator '|'). Anti-Repeat-Fenster.
  final String recentQuizTexts;

  /// Spec-38 follow-up: Start-Alter aus dem Onboarding. Default 13.
  /// Drift v21: bisher in-memory-only — ging bei jedem App-Neustart
  /// verloren (Alter fiel auf 13 zurück, verfälschte Job/Lebenskosten/
  /// age-gated Vorsorge). Jetzt persistent.
  final int startAgeYears;

  /// Spec-44 E3 (Pay-yourself-first): Slider-Wert 0..100. Drift v23:
  /// vorher in-memory-only — Slider sprang bei App-Restart auf 0.
  final int savingsRatePct;

  /// Welle-8 Round 22 / B7: Tag an dem das Tagesziel zuletzt gecaimt
  /// wurde. -1 = noch nie. Drift v24: war in-memory-only → Banner kam
  /// nach App-Restart wieder + claimbar.
  final int lastClaimedGoalDay;

  /// Welle-8 Round 23: Eltern-PIN (4-stellig). Leer = kein Lock.
  /// Schützt Reset, Import, Auto-Save-Erzwingen vor versehentlichem
  /// Wipe durch Kind. Plain-Text — keine Security-Critical-Daten,
  /// nur UX-Schutz. Drift v25.
  final String parentPin;
  const SettingsRow({
    required this.id,
    required this.allowanceCents,
    required this.allowanceWeekday,
    required this.playerName,
    required this.soundEnabled,
    required this.lastQuizDayIndex,
    required this.zeitreiseTutorialSeen,
    required this.musicVolume,
    required this.masterVolume,
    required this.sfxVolume,
    required this.lastSleepEpochMs,
    required this.sleepCountInWindow,
    required this.onboardingComplete,
    required this.avatarEmoji,
    required this.streakCount,
    required this.lastSleepDateIso,
    required this.unlockedAvatars,
    required this.unlockedDecor,
    required this.unlockedSkills,
    required this.weeklyChallengeClaimedWeek,
    required this.weeklyChallengeStreak,
    required this.claimedStreakMilestone,
    required this.autoSaveDisabled,
    this.backupFolderUri,
    this.birthYear,
    required this.birthYearAsked,
    required this.parentGateLockedUntilMs,
    required this.sparPlotCount,
    required this.quizLearnedTopics,
    required this.seenCoaches,
    required this.lastWeekNetWorthCents,
    required this.lastWeeklyReviewDay,
    required this.recentQuizTexts,
    required this.startAgeYears,
    required this.savingsRatePct,
    required this.lastClaimedGoalDay,
    required this.parentPin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['allowance_cents'] = Variable<int>(allowanceCents);
    map['allowance_weekday'] = Variable<String>(allowanceWeekday);
    map['player_name'] = Variable<String>(playerName);
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['last_quiz_day_index'] = Variable<int>(lastQuizDayIndex);
    map['zeitreise_tutorial_seen'] = Variable<bool>(zeitreiseTutorialSeen);
    map['music_volume'] = Variable<int>(musicVolume);
    map['master_volume'] = Variable<int>(masterVolume);
    map['sfx_volume'] = Variable<int>(sfxVolume);
    map['last_sleep_epoch_ms'] = Variable<int>(lastSleepEpochMs);
    map['sleep_count_in_window'] = Variable<int>(sleepCountInWindow);
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    map['avatar_emoji'] = Variable<String>(avatarEmoji);
    map['streak_count'] = Variable<int>(streakCount);
    map['last_sleep_date_iso'] = Variable<String>(lastSleepDateIso);
    map['unlocked_avatars'] = Variable<String>(unlockedAvatars);
    map['unlocked_decor'] = Variable<String>(unlockedDecor);
    map['unlocked_skills'] = Variable<String>(unlockedSkills);
    map['weekly_challenge_claimed_week'] = Variable<int>(
      weeklyChallengeClaimedWeek,
    );
    map['weekly_challenge_streak'] = Variable<int>(weeklyChallengeStreak);
    map['claimed_streak_milestone'] = Variable<int>(claimedStreakMilestone);
    map['auto_save_disabled'] = Variable<bool>(autoSaveDisabled);
    if (!nullToAbsent || backupFolderUri != null) {
      map['backup_folder_uri'] = Variable<String>(backupFolderUri);
    }
    if (!nullToAbsent || birthYear != null) {
      map['birth_year'] = Variable<int>(birthYear);
    }
    map['birth_year_asked'] = Variable<bool>(birthYearAsked);
    map['parent_gate_locked_until_ms'] = Variable<int>(parentGateLockedUntilMs);
    map['spar_plot_count'] = Variable<int>(sparPlotCount);
    map['quiz_learned_topics'] = Variable<String>(quizLearnedTopics);
    map['seen_coaches'] = Variable<String>(seenCoaches);
    map['last_week_net_worth_cents'] = Variable<int>(lastWeekNetWorthCents);
    map['last_weekly_review_day'] = Variable<int>(lastWeeklyReviewDay);
    map['recent_quiz_texts'] = Variable<String>(recentQuizTexts);
    map['start_age_years'] = Variable<int>(startAgeYears);
    map['savings_rate_pct'] = Variable<int>(savingsRatePct);
    map['last_claimed_goal_day'] = Variable<int>(lastClaimedGoalDay);
    map['parent_pin'] = Variable<String>(parentPin);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      id: Value(id),
      allowanceCents: Value(allowanceCents),
      allowanceWeekday: Value(allowanceWeekday),
      playerName: Value(playerName),
      soundEnabled: Value(soundEnabled),
      lastQuizDayIndex: Value(lastQuizDayIndex),
      zeitreiseTutorialSeen: Value(zeitreiseTutorialSeen),
      musicVolume: Value(musicVolume),
      masterVolume: Value(masterVolume),
      sfxVolume: Value(sfxVolume),
      lastSleepEpochMs: Value(lastSleepEpochMs),
      sleepCountInWindow: Value(sleepCountInWindow),
      onboardingComplete: Value(onboardingComplete),
      avatarEmoji: Value(avatarEmoji),
      streakCount: Value(streakCount),
      lastSleepDateIso: Value(lastSleepDateIso),
      unlockedAvatars: Value(unlockedAvatars),
      unlockedDecor: Value(unlockedDecor),
      unlockedSkills: Value(unlockedSkills),
      weeklyChallengeClaimedWeek: Value(weeklyChallengeClaimedWeek),
      weeklyChallengeStreak: Value(weeklyChallengeStreak),
      claimedStreakMilestone: Value(claimedStreakMilestone),
      autoSaveDisabled: Value(autoSaveDisabled),
      backupFolderUri: backupFolderUri == null && nullToAbsent
          ? const Value.absent()
          : Value(backupFolderUri),
      birthYear: birthYear == null && nullToAbsent
          ? const Value.absent()
          : Value(birthYear),
      birthYearAsked: Value(birthYearAsked),
      parentGateLockedUntilMs: Value(parentGateLockedUntilMs),
      sparPlotCount: Value(sparPlotCount),
      quizLearnedTopics: Value(quizLearnedTopics),
      seenCoaches: Value(seenCoaches),
      lastWeekNetWorthCents: Value(lastWeekNetWorthCents),
      lastWeeklyReviewDay: Value(lastWeeklyReviewDay),
      recentQuizTexts: Value(recentQuizTexts),
      startAgeYears: Value(startAgeYears),
      savingsRatePct: Value(savingsRatePct),
      lastClaimedGoalDay: Value(lastClaimedGoalDay),
      parentPin: Value(parentPin),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      allowanceCents: serializer.fromJson<int>(json['allowanceCents']),
      allowanceWeekday: serializer.fromJson<String>(json['allowanceWeekday']),
      playerName: serializer.fromJson<String>(json['playerName']),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      lastQuizDayIndex: serializer.fromJson<int>(json['lastQuizDayIndex']),
      zeitreiseTutorialSeen: serializer.fromJson<bool>(
        json['zeitreiseTutorialSeen'],
      ),
      musicVolume: serializer.fromJson<int>(json['musicVolume']),
      masterVolume: serializer.fromJson<int>(json['masterVolume']),
      sfxVolume: serializer.fromJson<int>(json['sfxVolume']),
      lastSleepEpochMs: serializer.fromJson<int>(json['lastSleepEpochMs']),
      sleepCountInWindow: serializer.fromJson<int>(json['sleepCountInWindow']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      avatarEmoji: serializer.fromJson<String>(json['avatarEmoji']),
      streakCount: serializer.fromJson<int>(json['streakCount']),
      lastSleepDateIso: serializer.fromJson<String>(json['lastSleepDateIso']),
      unlockedAvatars: serializer.fromJson<String>(json['unlockedAvatars']),
      unlockedDecor: serializer.fromJson<String>(json['unlockedDecor']),
      unlockedSkills: serializer.fromJson<String>(json['unlockedSkills']),
      weeklyChallengeClaimedWeek: serializer.fromJson<int>(
        json['weeklyChallengeClaimedWeek'],
      ),
      weeklyChallengeStreak: serializer.fromJson<int>(
        json['weeklyChallengeStreak'],
      ),
      claimedStreakMilestone: serializer.fromJson<int>(
        json['claimedStreakMilestone'],
      ),
      autoSaveDisabled: serializer.fromJson<bool>(json['autoSaveDisabled']),
      backupFolderUri: serializer.fromJson<String?>(json['backupFolderUri']),
      birthYear: serializer.fromJson<int?>(json['birthYear']),
      birthYearAsked: serializer.fromJson<bool>(json['birthYearAsked']),
      parentGateLockedUntilMs: serializer.fromJson<int>(
        json['parentGateLockedUntilMs'],
      ),
      sparPlotCount: serializer.fromJson<int>(json['sparPlotCount']),
      quizLearnedTopics: serializer.fromJson<String>(json['quizLearnedTopics']),
      seenCoaches: serializer.fromJson<String>(json['seenCoaches']),
      lastWeekNetWorthCents: serializer.fromJson<int>(
        json['lastWeekNetWorthCents'],
      ),
      lastWeeklyReviewDay: serializer.fromJson<int>(
        json['lastWeeklyReviewDay'],
      ),
      recentQuizTexts: serializer.fromJson<String>(json['recentQuizTexts']),
      startAgeYears: serializer.fromJson<int>(json['startAgeYears']),
      savingsRatePct: serializer.fromJson<int>(json['savingsRatePct']),
      lastClaimedGoalDay: serializer.fromJson<int>(json['lastClaimedGoalDay']),
      parentPin: serializer.fromJson<String>(json['parentPin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'allowanceCents': serializer.toJson<int>(allowanceCents),
      'allowanceWeekday': serializer.toJson<String>(allowanceWeekday),
      'playerName': serializer.toJson<String>(playerName),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'lastQuizDayIndex': serializer.toJson<int>(lastQuizDayIndex),
      'zeitreiseTutorialSeen': serializer.toJson<bool>(zeitreiseTutorialSeen),
      'musicVolume': serializer.toJson<int>(musicVolume),
      'masterVolume': serializer.toJson<int>(masterVolume),
      'sfxVolume': serializer.toJson<int>(sfxVolume),
      'lastSleepEpochMs': serializer.toJson<int>(lastSleepEpochMs),
      'sleepCountInWindow': serializer.toJson<int>(sleepCountInWindow),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'avatarEmoji': serializer.toJson<String>(avatarEmoji),
      'streakCount': serializer.toJson<int>(streakCount),
      'lastSleepDateIso': serializer.toJson<String>(lastSleepDateIso),
      'unlockedAvatars': serializer.toJson<String>(unlockedAvatars),
      'unlockedDecor': serializer.toJson<String>(unlockedDecor),
      'unlockedSkills': serializer.toJson<String>(unlockedSkills),
      'weeklyChallengeClaimedWeek': serializer.toJson<int>(
        weeklyChallengeClaimedWeek,
      ),
      'weeklyChallengeStreak': serializer.toJson<int>(weeklyChallengeStreak),
      'claimedStreakMilestone': serializer.toJson<int>(claimedStreakMilestone),
      'autoSaveDisabled': serializer.toJson<bool>(autoSaveDisabled),
      'backupFolderUri': serializer.toJson<String?>(backupFolderUri),
      'birthYear': serializer.toJson<int?>(birthYear),
      'birthYearAsked': serializer.toJson<bool>(birthYearAsked),
      'parentGateLockedUntilMs': serializer.toJson<int>(
        parentGateLockedUntilMs,
      ),
      'sparPlotCount': serializer.toJson<int>(sparPlotCount),
      'quizLearnedTopics': serializer.toJson<String>(quizLearnedTopics),
      'seenCoaches': serializer.toJson<String>(seenCoaches),
      'lastWeekNetWorthCents': serializer.toJson<int>(lastWeekNetWorthCents),
      'lastWeeklyReviewDay': serializer.toJson<int>(lastWeeklyReviewDay),
      'recentQuizTexts': serializer.toJson<String>(recentQuizTexts),
      'startAgeYears': serializer.toJson<int>(startAgeYears),
      'savingsRatePct': serializer.toJson<int>(savingsRatePct),
      'lastClaimedGoalDay': serializer.toJson<int>(lastClaimedGoalDay),
      'parentPin': serializer.toJson<String>(parentPin),
    };
  }

  SettingsRow copyWith({
    int? id,
    int? allowanceCents,
    String? allowanceWeekday,
    String? playerName,
    bool? soundEnabled,
    int? lastQuizDayIndex,
    bool? zeitreiseTutorialSeen,
    int? musicVolume,
    int? masterVolume,
    int? sfxVolume,
    int? lastSleepEpochMs,
    int? sleepCountInWindow,
    bool? onboardingComplete,
    String? avatarEmoji,
    int? streakCount,
    String? lastSleepDateIso,
    String? unlockedAvatars,
    String? unlockedDecor,
    String? unlockedSkills,
    int? weeklyChallengeClaimedWeek,
    int? weeklyChallengeStreak,
    int? claimedStreakMilestone,
    bool? autoSaveDisabled,
    Value<String?> backupFolderUri = const Value.absent(),
    Value<int?> birthYear = const Value.absent(),
    bool? birthYearAsked,
    int? parentGateLockedUntilMs,
    int? sparPlotCount,
    String? quizLearnedTopics,
    String? seenCoaches,
    int? lastWeekNetWorthCents,
    int? lastWeeklyReviewDay,
    String? recentQuizTexts,
    int? startAgeYears,
    int? savingsRatePct,
    int? lastClaimedGoalDay,
    String? parentPin,
  }) => SettingsRow(
    id: id ?? this.id,
    allowanceCents: allowanceCents ?? this.allowanceCents,
    allowanceWeekday: allowanceWeekday ?? this.allowanceWeekday,
    playerName: playerName ?? this.playerName,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    lastQuizDayIndex: lastQuizDayIndex ?? this.lastQuizDayIndex,
    zeitreiseTutorialSeen: zeitreiseTutorialSeen ?? this.zeitreiseTutorialSeen,
    musicVolume: musicVolume ?? this.musicVolume,
    masterVolume: masterVolume ?? this.masterVolume,
    sfxVolume: sfxVolume ?? this.sfxVolume,
    lastSleepEpochMs: lastSleepEpochMs ?? this.lastSleepEpochMs,
    sleepCountInWindow: sleepCountInWindow ?? this.sleepCountInWindow,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    streakCount: streakCount ?? this.streakCount,
    lastSleepDateIso: lastSleepDateIso ?? this.lastSleepDateIso,
    unlockedAvatars: unlockedAvatars ?? this.unlockedAvatars,
    unlockedDecor: unlockedDecor ?? this.unlockedDecor,
    unlockedSkills: unlockedSkills ?? this.unlockedSkills,
    weeklyChallengeClaimedWeek:
        weeklyChallengeClaimedWeek ?? this.weeklyChallengeClaimedWeek,
    weeklyChallengeStreak: weeklyChallengeStreak ?? this.weeklyChallengeStreak,
    claimedStreakMilestone:
        claimedStreakMilestone ?? this.claimedStreakMilestone,
    autoSaveDisabled: autoSaveDisabled ?? this.autoSaveDisabled,
    backupFolderUri: backupFolderUri.present
        ? backupFolderUri.value
        : this.backupFolderUri,
    birthYear: birthYear.present ? birthYear.value : this.birthYear,
    birthYearAsked: birthYearAsked ?? this.birthYearAsked,
    parentGateLockedUntilMs:
        parentGateLockedUntilMs ?? this.parentGateLockedUntilMs,
    sparPlotCount: sparPlotCount ?? this.sparPlotCount,
    quizLearnedTopics: quizLearnedTopics ?? this.quizLearnedTopics,
    seenCoaches: seenCoaches ?? this.seenCoaches,
    lastWeekNetWorthCents: lastWeekNetWorthCents ?? this.lastWeekNetWorthCents,
    lastWeeklyReviewDay: lastWeeklyReviewDay ?? this.lastWeeklyReviewDay,
    recentQuizTexts: recentQuizTexts ?? this.recentQuizTexts,
    startAgeYears: startAgeYears ?? this.startAgeYears,
    savingsRatePct: savingsRatePct ?? this.savingsRatePct,
    lastClaimedGoalDay: lastClaimedGoalDay ?? this.lastClaimedGoalDay,
    parentPin: parentPin ?? this.parentPin,
  );
  SettingsRow copyWithCompanion(SettingsTableCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      allowanceCents: data.allowanceCents.present
          ? data.allowanceCents.value
          : this.allowanceCents,
      allowanceWeekday: data.allowanceWeekday.present
          ? data.allowanceWeekday.value
          : this.allowanceWeekday,
      playerName: data.playerName.present
          ? data.playerName.value
          : this.playerName,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      lastQuizDayIndex: data.lastQuizDayIndex.present
          ? data.lastQuizDayIndex.value
          : this.lastQuizDayIndex,
      zeitreiseTutorialSeen: data.zeitreiseTutorialSeen.present
          ? data.zeitreiseTutorialSeen.value
          : this.zeitreiseTutorialSeen,
      musicVolume: data.musicVolume.present
          ? data.musicVolume.value
          : this.musicVolume,
      masterVolume: data.masterVolume.present
          ? data.masterVolume.value
          : this.masterVolume,
      sfxVolume: data.sfxVolume.present ? data.sfxVolume.value : this.sfxVolume,
      lastSleepEpochMs: data.lastSleepEpochMs.present
          ? data.lastSleepEpochMs.value
          : this.lastSleepEpochMs,
      sleepCountInWindow: data.sleepCountInWindow.present
          ? data.sleepCountInWindow.value
          : this.sleepCountInWindow,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      avatarEmoji: data.avatarEmoji.present
          ? data.avatarEmoji.value
          : this.avatarEmoji,
      streakCount: data.streakCount.present
          ? data.streakCount.value
          : this.streakCount,
      lastSleepDateIso: data.lastSleepDateIso.present
          ? data.lastSleepDateIso.value
          : this.lastSleepDateIso,
      unlockedAvatars: data.unlockedAvatars.present
          ? data.unlockedAvatars.value
          : this.unlockedAvatars,
      unlockedDecor: data.unlockedDecor.present
          ? data.unlockedDecor.value
          : this.unlockedDecor,
      unlockedSkills: data.unlockedSkills.present
          ? data.unlockedSkills.value
          : this.unlockedSkills,
      weeklyChallengeClaimedWeek: data.weeklyChallengeClaimedWeek.present
          ? data.weeklyChallengeClaimedWeek.value
          : this.weeklyChallengeClaimedWeek,
      weeklyChallengeStreak: data.weeklyChallengeStreak.present
          ? data.weeklyChallengeStreak.value
          : this.weeklyChallengeStreak,
      claimedStreakMilestone: data.claimedStreakMilestone.present
          ? data.claimedStreakMilestone.value
          : this.claimedStreakMilestone,
      autoSaveDisabled: data.autoSaveDisabled.present
          ? data.autoSaveDisabled.value
          : this.autoSaveDisabled,
      backupFolderUri: data.backupFolderUri.present
          ? data.backupFolderUri.value
          : this.backupFolderUri,
      birthYear: data.birthYear.present ? data.birthYear.value : this.birthYear,
      birthYearAsked: data.birthYearAsked.present
          ? data.birthYearAsked.value
          : this.birthYearAsked,
      parentGateLockedUntilMs: data.parentGateLockedUntilMs.present
          ? data.parentGateLockedUntilMs.value
          : this.parentGateLockedUntilMs,
      sparPlotCount: data.sparPlotCount.present
          ? data.sparPlotCount.value
          : this.sparPlotCount,
      quizLearnedTopics: data.quizLearnedTopics.present
          ? data.quizLearnedTopics.value
          : this.quizLearnedTopics,
      seenCoaches: data.seenCoaches.present
          ? data.seenCoaches.value
          : this.seenCoaches,
      lastWeekNetWorthCents: data.lastWeekNetWorthCents.present
          ? data.lastWeekNetWorthCents.value
          : this.lastWeekNetWorthCents,
      lastWeeklyReviewDay: data.lastWeeklyReviewDay.present
          ? data.lastWeeklyReviewDay.value
          : this.lastWeeklyReviewDay,
      recentQuizTexts: data.recentQuizTexts.present
          ? data.recentQuizTexts.value
          : this.recentQuizTexts,
      startAgeYears: data.startAgeYears.present
          ? data.startAgeYears.value
          : this.startAgeYears,
      savingsRatePct: data.savingsRatePct.present
          ? data.savingsRatePct.value
          : this.savingsRatePct,
      lastClaimedGoalDay: data.lastClaimedGoalDay.present
          ? data.lastClaimedGoalDay.value
          : this.lastClaimedGoalDay,
      parentPin: data.parentPin.present ? data.parentPin.value : this.parentPin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('allowanceCents: $allowanceCents, ')
          ..write('allowanceWeekday: $allowanceWeekday, ')
          ..write('playerName: $playerName, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('lastQuizDayIndex: $lastQuizDayIndex, ')
          ..write('zeitreiseTutorialSeen: $zeitreiseTutorialSeen, ')
          ..write('musicVolume: $musicVolume, ')
          ..write('masterVolume: $masterVolume, ')
          ..write('sfxVolume: $sfxVolume, ')
          ..write('lastSleepEpochMs: $lastSleepEpochMs, ')
          ..write('sleepCountInWindow: $sleepCountInWindow, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('avatarEmoji: $avatarEmoji, ')
          ..write('streakCount: $streakCount, ')
          ..write('lastSleepDateIso: $lastSleepDateIso, ')
          ..write('unlockedAvatars: $unlockedAvatars, ')
          ..write('unlockedDecor: $unlockedDecor, ')
          ..write('unlockedSkills: $unlockedSkills, ')
          ..write('weeklyChallengeClaimedWeek: $weeklyChallengeClaimedWeek, ')
          ..write('weeklyChallengeStreak: $weeklyChallengeStreak, ')
          ..write('claimedStreakMilestone: $claimedStreakMilestone, ')
          ..write('autoSaveDisabled: $autoSaveDisabled, ')
          ..write('backupFolderUri: $backupFolderUri, ')
          ..write('birthYear: $birthYear, ')
          ..write('birthYearAsked: $birthYearAsked, ')
          ..write('parentGateLockedUntilMs: $parentGateLockedUntilMs, ')
          ..write('sparPlotCount: $sparPlotCount, ')
          ..write('quizLearnedTopics: $quizLearnedTopics, ')
          ..write('seenCoaches: $seenCoaches, ')
          ..write('lastWeekNetWorthCents: $lastWeekNetWorthCents, ')
          ..write('lastWeeklyReviewDay: $lastWeeklyReviewDay, ')
          ..write('recentQuizTexts: $recentQuizTexts, ')
          ..write('startAgeYears: $startAgeYears, ')
          ..write('savingsRatePct: $savingsRatePct, ')
          ..write('lastClaimedGoalDay: $lastClaimedGoalDay, ')
          ..write('parentPin: $parentPin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    allowanceCents,
    allowanceWeekday,
    playerName,
    soundEnabled,
    lastQuizDayIndex,
    zeitreiseTutorialSeen,
    musicVolume,
    masterVolume,
    sfxVolume,
    lastSleepEpochMs,
    sleepCountInWindow,
    onboardingComplete,
    avatarEmoji,
    streakCount,
    lastSleepDateIso,
    unlockedAvatars,
    unlockedDecor,
    unlockedSkills,
    weeklyChallengeClaimedWeek,
    weeklyChallengeStreak,
    claimedStreakMilestone,
    autoSaveDisabled,
    backupFolderUri,
    birthYear,
    birthYearAsked,
    parentGateLockedUntilMs,
    sparPlotCount,
    quizLearnedTopics,
    seenCoaches,
    lastWeekNetWorthCents,
    lastWeeklyReviewDay,
    recentQuizTexts,
    startAgeYears,
    savingsRatePct,
    lastClaimedGoalDay,
    parentPin,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.allowanceCents == this.allowanceCents &&
          other.allowanceWeekday == this.allowanceWeekday &&
          other.playerName == this.playerName &&
          other.soundEnabled == this.soundEnabled &&
          other.lastQuizDayIndex == this.lastQuizDayIndex &&
          other.zeitreiseTutorialSeen == this.zeitreiseTutorialSeen &&
          other.musicVolume == this.musicVolume &&
          other.masterVolume == this.masterVolume &&
          other.sfxVolume == this.sfxVolume &&
          other.lastSleepEpochMs == this.lastSleepEpochMs &&
          other.sleepCountInWindow == this.sleepCountInWindow &&
          other.onboardingComplete == this.onboardingComplete &&
          other.avatarEmoji == this.avatarEmoji &&
          other.streakCount == this.streakCount &&
          other.lastSleepDateIso == this.lastSleepDateIso &&
          other.unlockedAvatars == this.unlockedAvatars &&
          other.unlockedDecor == this.unlockedDecor &&
          other.unlockedSkills == this.unlockedSkills &&
          other.weeklyChallengeClaimedWeek == this.weeklyChallengeClaimedWeek &&
          other.weeklyChallengeStreak == this.weeklyChallengeStreak &&
          other.claimedStreakMilestone == this.claimedStreakMilestone &&
          other.autoSaveDisabled == this.autoSaveDisabled &&
          other.backupFolderUri == this.backupFolderUri &&
          other.birthYear == this.birthYear &&
          other.birthYearAsked == this.birthYearAsked &&
          other.parentGateLockedUntilMs == this.parentGateLockedUntilMs &&
          other.sparPlotCount == this.sparPlotCount &&
          other.quizLearnedTopics == this.quizLearnedTopics &&
          other.seenCoaches == this.seenCoaches &&
          other.lastWeekNetWorthCents == this.lastWeekNetWorthCents &&
          other.lastWeeklyReviewDay == this.lastWeeklyReviewDay &&
          other.recentQuizTexts == this.recentQuizTexts &&
          other.startAgeYears == this.startAgeYears &&
          other.savingsRatePct == this.savingsRatePct &&
          other.lastClaimedGoalDay == this.lastClaimedGoalDay &&
          other.parentPin == this.parentPin);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<int> allowanceCents;
  final Value<String> allowanceWeekday;
  final Value<String> playerName;
  final Value<bool> soundEnabled;
  final Value<int> lastQuizDayIndex;
  final Value<bool> zeitreiseTutorialSeen;
  final Value<int> musicVolume;
  final Value<int> masterVolume;
  final Value<int> sfxVolume;
  final Value<int> lastSleepEpochMs;
  final Value<int> sleepCountInWindow;
  final Value<bool> onboardingComplete;
  final Value<String> avatarEmoji;
  final Value<int> streakCount;
  final Value<String> lastSleepDateIso;
  final Value<String> unlockedAvatars;
  final Value<String> unlockedDecor;
  final Value<String> unlockedSkills;
  final Value<int> weeklyChallengeClaimedWeek;
  final Value<int> weeklyChallengeStreak;
  final Value<int> claimedStreakMilestone;
  final Value<bool> autoSaveDisabled;
  final Value<String?> backupFolderUri;
  final Value<int?> birthYear;
  final Value<bool> birthYearAsked;
  final Value<int> parentGateLockedUntilMs;
  final Value<int> sparPlotCount;
  final Value<String> quizLearnedTopics;
  final Value<String> seenCoaches;
  final Value<int> lastWeekNetWorthCents;
  final Value<int> lastWeeklyReviewDay;
  final Value<String> recentQuizTexts;
  final Value<int> startAgeYears;
  final Value<int> savingsRatePct;
  final Value<int> lastClaimedGoalDay;
  final Value<String> parentPin;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.allowanceCents = const Value.absent(),
    this.allowanceWeekday = const Value.absent(),
    this.playerName = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.lastQuizDayIndex = const Value.absent(),
    this.zeitreiseTutorialSeen = const Value.absent(),
    this.musicVolume = const Value.absent(),
    this.masterVolume = const Value.absent(),
    this.sfxVolume = const Value.absent(),
    this.lastSleepEpochMs = const Value.absent(),
    this.sleepCountInWindow = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.avatarEmoji = const Value.absent(),
    this.streakCount = const Value.absent(),
    this.lastSleepDateIso = const Value.absent(),
    this.unlockedAvatars = const Value.absent(),
    this.unlockedDecor = const Value.absent(),
    this.unlockedSkills = const Value.absent(),
    this.weeklyChallengeClaimedWeek = const Value.absent(),
    this.weeklyChallengeStreak = const Value.absent(),
    this.claimedStreakMilestone = const Value.absent(),
    this.autoSaveDisabled = const Value.absent(),
    this.backupFolderUri = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.birthYearAsked = const Value.absent(),
    this.parentGateLockedUntilMs = const Value.absent(),
    this.sparPlotCount = const Value.absent(),
    this.quizLearnedTopics = const Value.absent(),
    this.seenCoaches = const Value.absent(),
    this.lastWeekNetWorthCents = const Value.absent(),
    this.lastWeeklyReviewDay = const Value.absent(),
    this.recentQuizTexts = const Value.absent(),
    this.startAgeYears = const Value.absent(),
    this.savingsRatePct = const Value.absent(),
    this.lastClaimedGoalDay = const Value.absent(),
    this.parentPin = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.allowanceCents = const Value.absent(),
    this.allowanceWeekday = const Value.absent(),
    this.playerName = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.lastQuizDayIndex = const Value.absent(),
    this.zeitreiseTutorialSeen = const Value.absent(),
    this.musicVolume = const Value.absent(),
    this.masterVolume = const Value.absent(),
    this.sfxVolume = const Value.absent(),
    this.lastSleepEpochMs = const Value.absent(),
    this.sleepCountInWindow = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.avatarEmoji = const Value.absent(),
    this.streakCount = const Value.absent(),
    this.lastSleepDateIso = const Value.absent(),
    this.unlockedAvatars = const Value.absent(),
    this.unlockedDecor = const Value.absent(),
    this.unlockedSkills = const Value.absent(),
    this.weeklyChallengeClaimedWeek = const Value.absent(),
    this.weeklyChallengeStreak = const Value.absent(),
    this.claimedStreakMilestone = const Value.absent(),
    this.autoSaveDisabled = const Value.absent(),
    this.backupFolderUri = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.birthYearAsked = const Value.absent(),
    this.parentGateLockedUntilMs = const Value.absent(),
    this.sparPlotCount = const Value.absent(),
    this.quizLearnedTopics = const Value.absent(),
    this.seenCoaches = const Value.absent(),
    this.lastWeekNetWorthCents = const Value.absent(),
    this.lastWeeklyReviewDay = const Value.absent(),
    this.recentQuizTexts = const Value.absent(),
    this.startAgeYears = const Value.absent(),
    this.savingsRatePct = const Value.absent(),
    this.lastClaimedGoalDay = const Value.absent(),
    this.parentPin = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<int>? allowanceCents,
    Expression<String>? allowanceWeekday,
    Expression<String>? playerName,
    Expression<bool>? soundEnabled,
    Expression<int>? lastQuizDayIndex,
    Expression<bool>? zeitreiseTutorialSeen,
    Expression<int>? musicVolume,
    Expression<int>? masterVolume,
    Expression<int>? sfxVolume,
    Expression<int>? lastSleepEpochMs,
    Expression<int>? sleepCountInWindow,
    Expression<bool>? onboardingComplete,
    Expression<String>? avatarEmoji,
    Expression<int>? streakCount,
    Expression<String>? lastSleepDateIso,
    Expression<String>? unlockedAvatars,
    Expression<String>? unlockedDecor,
    Expression<String>? unlockedSkills,
    Expression<int>? weeklyChallengeClaimedWeek,
    Expression<int>? weeklyChallengeStreak,
    Expression<int>? claimedStreakMilestone,
    Expression<bool>? autoSaveDisabled,
    Expression<String>? backupFolderUri,
    Expression<int>? birthYear,
    Expression<bool>? birthYearAsked,
    Expression<int>? parentGateLockedUntilMs,
    Expression<int>? sparPlotCount,
    Expression<String>? quizLearnedTopics,
    Expression<String>? seenCoaches,
    Expression<int>? lastWeekNetWorthCents,
    Expression<int>? lastWeeklyReviewDay,
    Expression<String>? recentQuizTexts,
    Expression<int>? startAgeYears,
    Expression<int>? savingsRatePct,
    Expression<int>? lastClaimedGoalDay,
    Expression<String>? parentPin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (allowanceCents != null) 'allowance_cents': allowanceCents,
      if (allowanceWeekday != null) 'allowance_weekday': allowanceWeekday,
      if (playerName != null) 'player_name': playerName,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (lastQuizDayIndex != null) 'last_quiz_day_index': lastQuizDayIndex,
      if (zeitreiseTutorialSeen != null)
        'zeitreise_tutorial_seen': zeitreiseTutorialSeen,
      if (musicVolume != null) 'music_volume': musicVolume,
      if (masterVolume != null) 'master_volume': masterVolume,
      if (sfxVolume != null) 'sfx_volume': sfxVolume,
      if (lastSleepEpochMs != null) 'last_sleep_epoch_ms': lastSleepEpochMs,
      if (sleepCountInWindow != null)
        'sleep_count_in_window': sleepCountInWindow,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (avatarEmoji != null) 'avatar_emoji': avatarEmoji,
      if (streakCount != null) 'streak_count': streakCount,
      if (lastSleepDateIso != null) 'last_sleep_date_iso': lastSleepDateIso,
      if (unlockedAvatars != null) 'unlocked_avatars': unlockedAvatars,
      if (unlockedDecor != null) 'unlocked_decor': unlockedDecor,
      if (unlockedSkills != null) 'unlocked_skills': unlockedSkills,
      if (weeklyChallengeClaimedWeek != null)
        'weekly_challenge_claimed_week': weeklyChallengeClaimedWeek,
      if (weeklyChallengeStreak != null)
        'weekly_challenge_streak': weeklyChallengeStreak,
      if (claimedStreakMilestone != null)
        'claimed_streak_milestone': claimedStreakMilestone,
      if (autoSaveDisabled != null) 'auto_save_disabled': autoSaveDisabled,
      if (backupFolderUri != null) 'backup_folder_uri': backupFolderUri,
      if (birthYear != null) 'birth_year': birthYear,
      if (birthYearAsked != null) 'birth_year_asked': birthYearAsked,
      if (parentGateLockedUntilMs != null)
        'parent_gate_locked_until_ms': parentGateLockedUntilMs,
      if (sparPlotCount != null) 'spar_plot_count': sparPlotCount,
      if (quizLearnedTopics != null) 'quiz_learned_topics': quizLearnedTopics,
      if (seenCoaches != null) 'seen_coaches': seenCoaches,
      if (lastWeekNetWorthCents != null)
        'last_week_net_worth_cents': lastWeekNetWorthCents,
      if (lastWeeklyReviewDay != null)
        'last_weekly_review_day': lastWeeklyReviewDay,
      if (recentQuizTexts != null) 'recent_quiz_texts': recentQuizTexts,
      if (startAgeYears != null) 'start_age_years': startAgeYears,
      if (savingsRatePct != null) 'savings_rate_pct': savingsRatePct,
      if (lastClaimedGoalDay != null)
        'last_claimed_goal_day': lastClaimedGoalDay,
      if (parentPin != null) 'parent_pin': parentPin,
    });
  }

  SettingsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? allowanceCents,
    Value<String>? allowanceWeekday,
    Value<String>? playerName,
    Value<bool>? soundEnabled,
    Value<int>? lastQuizDayIndex,
    Value<bool>? zeitreiseTutorialSeen,
    Value<int>? musicVolume,
    Value<int>? masterVolume,
    Value<int>? sfxVolume,
    Value<int>? lastSleepEpochMs,
    Value<int>? sleepCountInWindow,
    Value<bool>? onboardingComplete,
    Value<String>? avatarEmoji,
    Value<int>? streakCount,
    Value<String>? lastSleepDateIso,
    Value<String>? unlockedAvatars,
    Value<String>? unlockedDecor,
    Value<String>? unlockedSkills,
    Value<int>? weeklyChallengeClaimedWeek,
    Value<int>? weeklyChallengeStreak,
    Value<int>? claimedStreakMilestone,
    Value<bool>? autoSaveDisabled,
    Value<String?>? backupFolderUri,
    Value<int?>? birthYear,
    Value<bool>? birthYearAsked,
    Value<int>? parentGateLockedUntilMs,
    Value<int>? sparPlotCount,
    Value<String>? quizLearnedTopics,
    Value<String>? seenCoaches,
    Value<int>? lastWeekNetWorthCents,
    Value<int>? lastWeeklyReviewDay,
    Value<String>? recentQuizTexts,
    Value<int>? startAgeYears,
    Value<int>? savingsRatePct,
    Value<int>? lastClaimedGoalDay,
    Value<String>? parentPin,
  }) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      allowanceCents: allowanceCents ?? this.allowanceCents,
      allowanceWeekday: allowanceWeekday ?? this.allowanceWeekday,
      playerName: playerName ?? this.playerName,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      lastQuizDayIndex: lastQuizDayIndex ?? this.lastQuizDayIndex,
      zeitreiseTutorialSeen:
          zeitreiseTutorialSeen ?? this.zeitreiseTutorialSeen,
      musicVolume: musicVolume ?? this.musicVolume,
      masterVolume: masterVolume ?? this.masterVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
      lastSleepEpochMs: lastSleepEpochMs ?? this.lastSleepEpochMs,
      sleepCountInWindow: sleepCountInWindow ?? this.sleepCountInWindow,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      streakCount: streakCount ?? this.streakCount,
      lastSleepDateIso: lastSleepDateIso ?? this.lastSleepDateIso,
      unlockedAvatars: unlockedAvatars ?? this.unlockedAvatars,
      unlockedDecor: unlockedDecor ?? this.unlockedDecor,
      unlockedSkills: unlockedSkills ?? this.unlockedSkills,
      weeklyChallengeClaimedWeek:
          weeklyChallengeClaimedWeek ?? this.weeklyChallengeClaimedWeek,
      weeklyChallengeStreak:
          weeklyChallengeStreak ?? this.weeklyChallengeStreak,
      claimedStreakMilestone:
          claimedStreakMilestone ?? this.claimedStreakMilestone,
      autoSaveDisabled: autoSaveDisabled ?? this.autoSaveDisabled,
      backupFolderUri: backupFolderUri ?? this.backupFolderUri,
      birthYear: birthYear ?? this.birthYear,
      birthYearAsked: birthYearAsked ?? this.birthYearAsked,
      parentGateLockedUntilMs:
          parentGateLockedUntilMs ?? this.parentGateLockedUntilMs,
      sparPlotCount: sparPlotCount ?? this.sparPlotCount,
      quizLearnedTopics: quizLearnedTopics ?? this.quizLearnedTopics,
      seenCoaches: seenCoaches ?? this.seenCoaches,
      lastWeekNetWorthCents:
          lastWeekNetWorthCents ?? this.lastWeekNetWorthCents,
      lastWeeklyReviewDay: lastWeeklyReviewDay ?? this.lastWeeklyReviewDay,
      recentQuizTexts: recentQuizTexts ?? this.recentQuizTexts,
      startAgeYears: startAgeYears ?? this.startAgeYears,
      savingsRatePct: savingsRatePct ?? this.savingsRatePct,
      lastClaimedGoalDay: lastClaimedGoalDay ?? this.lastClaimedGoalDay,
      parentPin: parentPin ?? this.parentPin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (allowanceCents.present) {
      map['allowance_cents'] = Variable<int>(allowanceCents.value);
    }
    if (allowanceWeekday.present) {
      map['allowance_weekday'] = Variable<String>(allowanceWeekday.value);
    }
    if (playerName.present) {
      map['player_name'] = Variable<String>(playerName.value);
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (lastQuizDayIndex.present) {
      map['last_quiz_day_index'] = Variable<int>(lastQuizDayIndex.value);
    }
    if (zeitreiseTutorialSeen.present) {
      map['zeitreise_tutorial_seen'] = Variable<bool>(
        zeitreiseTutorialSeen.value,
      );
    }
    if (musicVolume.present) {
      map['music_volume'] = Variable<int>(musicVolume.value);
    }
    if (masterVolume.present) {
      map['master_volume'] = Variable<int>(masterVolume.value);
    }
    if (sfxVolume.present) {
      map['sfx_volume'] = Variable<int>(sfxVolume.value);
    }
    if (lastSleepEpochMs.present) {
      map['last_sleep_epoch_ms'] = Variable<int>(lastSleepEpochMs.value);
    }
    if (sleepCountInWindow.present) {
      map['sleep_count_in_window'] = Variable<int>(sleepCountInWindow.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (avatarEmoji.present) {
      map['avatar_emoji'] = Variable<String>(avatarEmoji.value);
    }
    if (streakCount.present) {
      map['streak_count'] = Variable<int>(streakCount.value);
    }
    if (lastSleepDateIso.present) {
      map['last_sleep_date_iso'] = Variable<String>(lastSleepDateIso.value);
    }
    if (unlockedAvatars.present) {
      map['unlocked_avatars'] = Variable<String>(unlockedAvatars.value);
    }
    if (unlockedDecor.present) {
      map['unlocked_decor'] = Variable<String>(unlockedDecor.value);
    }
    if (unlockedSkills.present) {
      map['unlocked_skills'] = Variable<String>(unlockedSkills.value);
    }
    if (weeklyChallengeClaimedWeek.present) {
      map['weekly_challenge_claimed_week'] = Variable<int>(
        weeklyChallengeClaimedWeek.value,
      );
    }
    if (weeklyChallengeStreak.present) {
      map['weekly_challenge_streak'] = Variable<int>(
        weeklyChallengeStreak.value,
      );
    }
    if (claimedStreakMilestone.present) {
      map['claimed_streak_milestone'] = Variable<int>(
        claimedStreakMilestone.value,
      );
    }
    if (autoSaveDisabled.present) {
      map['auto_save_disabled'] = Variable<bool>(autoSaveDisabled.value);
    }
    if (backupFolderUri.present) {
      map['backup_folder_uri'] = Variable<String>(backupFolderUri.value);
    }
    if (birthYear.present) {
      map['birth_year'] = Variable<int>(birthYear.value);
    }
    if (birthYearAsked.present) {
      map['birth_year_asked'] = Variable<bool>(birthYearAsked.value);
    }
    if (parentGateLockedUntilMs.present) {
      map['parent_gate_locked_until_ms'] = Variable<int>(
        parentGateLockedUntilMs.value,
      );
    }
    if (sparPlotCount.present) {
      map['spar_plot_count'] = Variable<int>(sparPlotCount.value);
    }
    if (quizLearnedTopics.present) {
      map['quiz_learned_topics'] = Variable<String>(quizLearnedTopics.value);
    }
    if (seenCoaches.present) {
      map['seen_coaches'] = Variable<String>(seenCoaches.value);
    }
    if (lastWeekNetWorthCents.present) {
      map['last_week_net_worth_cents'] = Variable<int>(
        lastWeekNetWorthCents.value,
      );
    }
    if (lastWeeklyReviewDay.present) {
      map['last_weekly_review_day'] = Variable<int>(lastWeeklyReviewDay.value);
    }
    if (recentQuizTexts.present) {
      map['recent_quiz_texts'] = Variable<String>(recentQuizTexts.value);
    }
    if (startAgeYears.present) {
      map['start_age_years'] = Variable<int>(startAgeYears.value);
    }
    if (savingsRatePct.present) {
      map['savings_rate_pct'] = Variable<int>(savingsRatePct.value);
    }
    if (lastClaimedGoalDay.present) {
      map['last_claimed_goal_day'] = Variable<int>(lastClaimedGoalDay.value);
    }
    if (parentPin.present) {
      map['parent_pin'] = Variable<String>(parentPin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('allowanceCents: $allowanceCents, ')
          ..write('allowanceWeekday: $allowanceWeekday, ')
          ..write('playerName: $playerName, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('lastQuizDayIndex: $lastQuizDayIndex, ')
          ..write('zeitreiseTutorialSeen: $zeitreiseTutorialSeen, ')
          ..write('musicVolume: $musicVolume, ')
          ..write('masterVolume: $masterVolume, ')
          ..write('sfxVolume: $sfxVolume, ')
          ..write('lastSleepEpochMs: $lastSleepEpochMs, ')
          ..write('sleepCountInWindow: $sleepCountInWindow, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('avatarEmoji: $avatarEmoji, ')
          ..write('streakCount: $streakCount, ')
          ..write('lastSleepDateIso: $lastSleepDateIso, ')
          ..write('unlockedAvatars: $unlockedAvatars, ')
          ..write('unlockedDecor: $unlockedDecor, ')
          ..write('unlockedSkills: $unlockedSkills, ')
          ..write('weeklyChallengeClaimedWeek: $weeklyChallengeClaimedWeek, ')
          ..write('weeklyChallengeStreak: $weeklyChallengeStreak, ')
          ..write('claimedStreakMilestone: $claimedStreakMilestone, ')
          ..write('autoSaveDisabled: $autoSaveDisabled, ')
          ..write('backupFolderUri: $backupFolderUri, ')
          ..write('birthYear: $birthYear, ')
          ..write('birthYearAsked: $birthYearAsked, ')
          ..write('parentGateLockedUntilMs: $parentGateLockedUntilMs, ')
          ..write('sparPlotCount: $sparPlotCount, ')
          ..write('quizLearnedTopics: $quizLearnedTopics, ')
          ..write('seenCoaches: $seenCoaches, ')
          ..write('lastWeekNetWorthCents: $lastWeekNetWorthCents, ')
          ..write('lastWeeklyReviewDay: $lastWeeklyReviewDay, ')
          ..write('recentQuizTexts: $recentQuizTexts, ')
          ..write('startAgeYears: $startAgeYears, ')
          ..write('savingsRatePct: $savingsRatePct, ')
          ..write('lastClaimedGoalDay: $lastClaimedGoalDay, ')
          ..write('parentPin: $parentPin')
          ..write(')'))
        .toString();
  }
}

class $XpTableTable extends XpTable with TableInfo<$XpTableTable, XpRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $XpTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, total];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'xp_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<XpRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  XpRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return XpRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
    );
  }

  @override
  $XpTableTable createAlias(String alias) {
    return $XpTableTable(attachedDatabase, alias);
  }
}

class XpRow extends DataClass implements Insertable<XpRow> {
  final int id;
  final int total;
  const XpRow({required this.id, required this.total});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total'] = Variable<int>(total);
    return map;
  }

  XpTableCompanion toCompanion(bool nullToAbsent) {
    return XpTableCompanion(id: Value(id), total: Value(total));
  }

  factory XpRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return XpRow(
      id: serializer.fromJson<int>(json['id']),
      total: serializer.fromJson<int>(json['total']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'total': serializer.toJson<int>(total),
    };
  }

  XpRow copyWith({int? id, int? total}) =>
      XpRow(id: id ?? this.id, total: total ?? this.total);
  XpRow copyWithCompanion(XpTableCompanion data) {
    return XpRow(
      id: data.id.present ? data.id.value : this.id,
      total: data.total.present ? data.total.value : this.total,
    );
  }

  @override
  String toString() {
    return (StringBuffer('XpRow(')
          ..write('id: $id, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, total);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XpRow && other.id == this.id && other.total == this.total);
}

class XpTableCompanion extends UpdateCompanion<XpRow> {
  final Value<int> id;
  final Value<int> total;
  const XpTableCompanion({
    this.id = const Value.absent(),
    this.total = const Value.absent(),
  });
  XpTableCompanion.insert({
    this.id = const Value.absent(),
    this.total = const Value.absent(),
  });
  static Insertable<XpRow> custom({
    Expression<int>? id,
    Expression<int>? total,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (total != null) 'total': total,
    });
  }

  XpTableCompanion copyWith({Value<int>? id, Value<int>? total}) {
    return XpTableCompanion(id: id ?? this.id, total: total ?? this.total);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('XpTableCompanion(')
          ..write('id: $id, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }
}

class $SavingsTableTable extends SavingsTable
    with TableInfo<$SavingsTableTable, SavingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _centsMeta = const VerificationMeta('cents');
  @override
  late final GeneratedColumn<int> cents = GeneratedColumn<int>(
    'cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, cents];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cents')) {
      context.handle(
        _centsMeta,
        cents.isAcceptableOrUnknown(data['cents']!, _centsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cents'],
      )!,
    );
  }

  @override
  $SavingsTableTable createAlias(String alias) {
    return $SavingsTableTable(attachedDatabase, alias);
  }
}

class SavingsRow extends DataClass implements Insertable<SavingsRow> {
  final int id;
  final int cents;
  const SavingsRow({required this.id, required this.cents});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cents'] = Variable<int>(cents);
    return map;
  }

  SavingsTableCompanion toCompanion(bool nullToAbsent) {
    return SavingsTableCompanion(id: Value(id), cents: Value(cents));
  }

  factory SavingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsRow(
      id: serializer.fromJson<int>(json['id']),
      cents: serializer.fromJson<int>(json['cents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cents': serializer.toJson<int>(cents),
    };
  }

  SavingsRow copyWith({int? id, int? cents}) =>
      SavingsRow(id: id ?? this.id, cents: cents ?? this.cents);
  SavingsRow copyWithCompanion(SavingsTableCompanion data) {
    return SavingsRow(
      id: data.id.present ? data.id.value : this.id,
      cents: data.cents.present ? data.cents.value : this.cents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsRow(')
          ..write('id: $id, ')
          ..write('cents: $cents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsRow && other.id == this.id && other.cents == this.cents);
}

class SavingsTableCompanion extends UpdateCompanion<SavingsRow> {
  final Value<int> id;
  final Value<int> cents;
  const SavingsTableCompanion({
    this.id = const Value.absent(),
    this.cents = const Value.absent(),
  });
  SavingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.cents = const Value.absent(),
  });
  static Insertable<SavingsRow> custom({
    Expression<int>? id,
    Expression<int>? cents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cents != null) 'cents': cents,
    });
  }

  SavingsTableCompanion copyWith({Value<int>? id, Value<int>? cents}) {
    return SavingsTableCompanion(id: id ?? this.id, cents: cents ?? this.cents);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cents.present) {
      map['cents'] = Variable<int>(cents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsTableCompanion(')
          ..write('id: $id, ')
          ..write('cents: $cents')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTableTable extends AchievementsTable
    with TableInfo<$AchievementsTableTable, AchievementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedOnDayIndexMeta =
      const VerificationMeta('unlockedOnDayIndex');
  @override
  late final GeneratedColumn<int> unlockedOnDayIndex = GeneratedColumn<int>(
    'unlocked_on_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, unlockedOnDayIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AchievementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('unlocked_on_day_index')) {
      context.handle(
        _unlockedOnDayIndexMeta,
        unlockedOnDayIndex.isAcceptableOrUnknown(
          data['unlocked_on_day_index']!,
          _unlockedOnDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unlockedOnDayIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AchievementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      unlockedOnDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unlocked_on_day_index'],
      )!,
    );
  }

  @override
  $AchievementsTableTable createAlias(String alias) {
    return $AchievementsTableTable(attachedDatabase, alias);
  }
}

class AchievementRow extends DataClass implements Insertable<AchievementRow> {
  final String id;
  final int unlockedOnDayIndex;
  const AchievementRow({required this.id, required this.unlockedOnDayIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['unlocked_on_day_index'] = Variable<int>(unlockedOnDayIndex);
    return map;
  }

  AchievementsTableCompanion toCompanion(bool nullToAbsent) {
    return AchievementsTableCompanion(
      id: Value(id),
      unlockedOnDayIndex: Value(unlockedOnDayIndex),
    );
  }

  factory AchievementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementRow(
      id: serializer.fromJson<String>(json['id']),
      unlockedOnDayIndex: serializer.fromJson<int>(json['unlockedOnDayIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'unlockedOnDayIndex': serializer.toJson<int>(unlockedOnDayIndex),
    };
  }

  AchievementRow copyWith({String? id, int? unlockedOnDayIndex}) =>
      AchievementRow(
        id: id ?? this.id,
        unlockedOnDayIndex: unlockedOnDayIndex ?? this.unlockedOnDayIndex,
      );
  AchievementRow copyWithCompanion(AchievementsTableCompanion data) {
    return AchievementRow(
      id: data.id.present ? data.id.value : this.id,
      unlockedOnDayIndex: data.unlockedOnDayIndex.present
          ? data.unlockedOnDayIndex.value
          : this.unlockedOnDayIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementRow(')
          ..write('id: $id, ')
          ..write('unlockedOnDayIndex: $unlockedOnDayIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, unlockedOnDayIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementRow &&
          other.id == this.id &&
          other.unlockedOnDayIndex == this.unlockedOnDayIndex);
}

class AchievementsTableCompanion extends UpdateCompanion<AchievementRow> {
  final Value<String> id;
  final Value<int> unlockedOnDayIndex;
  final Value<int> rowid;
  const AchievementsTableCompanion({
    this.id = const Value.absent(),
    this.unlockedOnDayIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsTableCompanion.insert({
    required String id,
    required int unlockedOnDayIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       unlockedOnDayIndex = Value(unlockedOnDayIndex);
  static Insertable<AchievementRow> custom({
    Expression<String>? id,
    Expression<int>? unlockedOnDayIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unlockedOnDayIndex != null)
        'unlocked_on_day_index': unlockedOnDayIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsTableCompanion copyWith({
    Value<String>? id,
    Value<int>? unlockedOnDayIndex,
    Value<int>? rowid,
  }) {
    return AchievementsTableCompanion(
      id: id ?? this.id,
      unlockedOnDayIndex: unlockedOnDayIndex ?? this.unlockedOnDayIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (unlockedOnDayIndex.present) {
      map['unlocked_on_day_index'] = Variable<int>(unlockedOnDayIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsTableCompanion(')
          ..write('id: $id, ')
          ..write('unlockedOnDayIndex: $unlockedOnDayIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LuckyEventHistoryTableTable extends LuckyEventHistoryTable
    with TableInfo<$LuckyEventHistoryTableTable, LuckyEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LuckyEventHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxDeductedCentsMeta = const VerificationMeta(
    'taxDeductedCents',
  );
  @override
  late final GeneratedColumn<int> taxDeductedCents = GeneratedColumn<int>(
    'tax_deducted_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    dayIndex,
    title,
    description,
    amountCents,
    taxDeductedCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lucky_event_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LuckyEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
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
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('tax_deducted_cents')) {
      context.handle(
        _taxDeductedCentsMeta,
        taxDeductedCents.isAcceptableOrUnknown(
          data['tax_deducted_cents']!,
          _taxDeductedCentsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  LuckyEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LuckyEventRow(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      taxDeductedCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_deducted_cents'],
      )!,
    );
  }

  @override
  $LuckyEventHistoryTableTable createAlias(String alias) {
    return $LuckyEventHistoryTableTable(attachedDatabase, alias);
  }
}

class LuckyEventRow extends DataClass implements Insertable<LuckyEventRow> {
  final int rowId;
  final int dayIndex;
  final String title;
  final String description;

  /// Netto-Cash-Delta in Cents (positiv = Einnahme, negativ = Ausgabe).
  final int amountCents;

  /// Bei Schenkungen über Freibetrag: einbehaltene Schenkungsteuer.
  final int taxDeductedCents;
  const LuckyEventRow({
    required this.rowId,
    required this.dayIndex,
    required this.title,
    required this.description,
    required this.amountCents,
    required this.taxDeductedCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['day_index'] = Variable<int>(dayIndex);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['amount_cents'] = Variable<int>(amountCents);
    map['tax_deducted_cents'] = Variable<int>(taxDeductedCents);
    return map;
  }

  LuckyEventHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return LuckyEventHistoryTableCompanion(
      rowId: Value(rowId),
      dayIndex: Value(dayIndex),
      title: Value(title),
      description: Value(description),
      amountCents: Value(amountCents),
      taxDeductedCents: Value(taxDeductedCents),
    );
  }

  factory LuckyEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LuckyEventRow(
      rowId: serializer.fromJson<int>(json['rowId']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      taxDeductedCents: serializer.fromJson<int>(json['taxDeductedCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'amountCents': serializer.toJson<int>(amountCents),
      'taxDeductedCents': serializer.toJson<int>(taxDeductedCents),
    };
  }

  LuckyEventRow copyWith({
    int? rowId,
    int? dayIndex,
    String? title,
    String? description,
    int? amountCents,
    int? taxDeductedCents,
  }) => LuckyEventRow(
    rowId: rowId ?? this.rowId,
    dayIndex: dayIndex ?? this.dayIndex,
    title: title ?? this.title,
    description: description ?? this.description,
    amountCents: amountCents ?? this.amountCents,
    taxDeductedCents: taxDeductedCents ?? this.taxDeductedCents,
  );
  LuckyEventRow copyWithCompanion(LuckyEventHistoryTableCompanion data) {
    return LuckyEventRow(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      taxDeductedCents: data.taxDeductedCents.present
          ? data.taxDeductedCents.value
          : this.taxDeductedCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LuckyEventRow(')
          ..write('rowId: $rowId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('taxDeductedCents: $taxDeductedCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    dayIndex,
    title,
    description,
    amountCents,
    taxDeductedCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LuckyEventRow &&
          other.rowId == this.rowId &&
          other.dayIndex == this.dayIndex &&
          other.title == this.title &&
          other.description == this.description &&
          other.amountCents == this.amountCents &&
          other.taxDeductedCents == this.taxDeductedCents);
}

class LuckyEventHistoryTableCompanion extends UpdateCompanion<LuckyEventRow> {
  final Value<int> rowId;
  final Value<int> dayIndex;
  final Value<String> title;
  final Value<String> description;
  final Value<int> amountCents;
  final Value<int> taxDeductedCents;
  const LuckyEventHistoryTableCompanion({
    this.rowId = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.taxDeductedCents = const Value.absent(),
  });
  LuckyEventHistoryTableCompanion.insert({
    this.rowId = const Value.absent(),
    required int dayIndex,
    required String title,
    required String description,
    required int amountCents,
    this.taxDeductedCents = const Value.absent(),
  }) : dayIndex = Value(dayIndex),
       title = Value(title),
       description = Value(description),
       amountCents = Value(amountCents);
  static Insertable<LuckyEventRow> custom({
    Expression<int>? rowId,
    Expression<int>? dayIndex,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? amountCents,
    Expression<int>? taxDeductedCents,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (dayIndex != null) 'day_index': dayIndex,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (amountCents != null) 'amount_cents': amountCents,
      if (taxDeductedCents != null) 'tax_deducted_cents': taxDeductedCents,
    });
  }

  LuckyEventHistoryTableCompanion copyWith({
    Value<int>? rowId,
    Value<int>? dayIndex,
    Value<String>? title,
    Value<String>? description,
    Value<int>? amountCents,
    Value<int>? taxDeductedCents,
  }) {
    return LuckyEventHistoryTableCompanion(
      rowId: rowId ?? this.rowId,
      dayIndex: dayIndex ?? this.dayIndex,
      title: title ?? this.title,
      description: description ?? this.description,
      amountCents: amountCents ?? this.amountCents,
      taxDeductedCents: taxDeductedCents ?? this.taxDeductedCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (taxDeductedCents.present) {
      map['tax_deducted_cents'] = Variable<int>(taxDeductedCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LuckyEventHistoryTableCompanion(')
          ..write('rowId: $rowId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('taxDeductedCents: $taxDeductedCents')
          ..write(')'))
        .toString();
  }
}

class $NewGameStateTableTable extends NewGameStateTable
    with TableInfo<$NewGameStateTableTable, NewGameRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NewGameStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _runCountMeta = const VerificationMeta(
    'runCount',
  );
  @override
  late final GeneratedColumn<int> runCount = GeneratedColumn<int>(
    'run_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pendingInheritanceCentsMeta =
      const VerificationMeta('pendingInheritanceCents');
  @override
  late final GeneratedColumn<int> pendingInheritanceCents =
      GeneratedColumn<int>(
        'pending_inheritance_cents',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _pendingBonusXpMeta = const VerificationMeta(
    'pendingBonusXp',
  );
  @override
  late final GeneratedColumn<int> pendingBonusXp = GeneratedColumn<int>(
    'pending_bonus_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastRunNetWorthCentsMeta =
      const VerificationMeta('lastRunNetWorthCents');
  @override
  late final GeneratedColumn<int> lastRunNetWorthCents = GeneratedColumn<int>(
    'last_run_net_worth_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _legacyPointsMeta = const VerificationMeta(
    'legacyPoints',
  );
  @override
  late final GeneratedColumn<int> legacyPoints = GeneratedColumn<int>(
    'legacy_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _legacyUpgradesMeta = const VerificationMeta(
    'legacyUpgrades',
  );
  @override
  late final GeneratedColumn<String> legacyUpgrades = GeneratedColumn<String>(
    'legacy_upgrades',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    runCount,
    pendingInheritanceCents,
    pendingBonusXp,
    lastRunNetWorthCents,
    legacyPoints,
    legacyUpgrades,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'new_game_state_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NewGameRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('run_count')) {
      context.handle(
        _runCountMeta,
        runCount.isAcceptableOrUnknown(data['run_count']!, _runCountMeta),
      );
    }
    if (data.containsKey('pending_inheritance_cents')) {
      context.handle(
        _pendingInheritanceCentsMeta,
        pendingInheritanceCents.isAcceptableOrUnknown(
          data['pending_inheritance_cents']!,
          _pendingInheritanceCentsMeta,
        ),
      );
    }
    if (data.containsKey('pending_bonus_xp')) {
      context.handle(
        _pendingBonusXpMeta,
        pendingBonusXp.isAcceptableOrUnknown(
          data['pending_bonus_xp']!,
          _pendingBonusXpMeta,
        ),
      );
    }
    if (data.containsKey('last_run_net_worth_cents')) {
      context.handle(
        _lastRunNetWorthCentsMeta,
        lastRunNetWorthCents.isAcceptableOrUnknown(
          data['last_run_net_worth_cents']!,
          _lastRunNetWorthCentsMeta,
        ),
      );
    }
    if (data.containsKey('legacy_points')) {
      context.handle(
        _legacyPointsMeta,
        legacyPoints.isAcceptableOrUnknown(
          data['legacy_points']!,
          _legacyPointsMeta,
        ),
      );
    }
    if (data.containsKey('legacy_upgrades')) {
      context.handle(
        _legacyUpgradesMeta,
        legacyUpgrades.isAcceptableOrUnknown(
          data['legacy_upgrades']!,
          _legacyUpgradesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NewGameRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NewGameRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      runCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}run_count'],
      )!,
      pendingInheritanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pending_inheritance_cents'],
      )!,
      pendingBonusXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pending_bonus_xp'],
      )!,
      lastRunNetWorthCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_run_net_worth_cents'],
      )!,
      legacyPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}legacy_points'],
      )!,
      legacyUpgrades: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legacy_upgrades'],
      )!,
    );
  }

  @override
  $NewGameStateTableTable createAlias(String alias) {
    return $NewGameStateTableTable(attachedDatabase, alias);
  }
}

class NewGameRow extends DataClass implements Insertable<NewGameRow> {
  final int id;
  final int runCount;
  final int pendingInheritanceCents;
  final int pendingBonusXp;
  final int lastRunNetWorthCents;

  /// Welle B (Drift v32): Vermächtnis-Prestige. Über alle Runs gesammelte
  /// Legacy-Punkte (permanent) + gekaufte Vermächtnis-Upgrades (CSV).
  final int legacyPoints;
  final String legacyUpgrades;
  const NewGameRow({
    required this.id,
    required this.runCount,
    required this.pendingInheritanceCents,
    required this.pendingBonusXp,
    required this.lastRunNetWorthCents,
    required this.legacyPoints,
    required this.legacyUpgrades,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['run_count'] = Variable<int>(runCount);
    map['pending_inheritance_cents'] = Variable<int>(pendingInheritanceCents);
    map['pending_bonus_xp'] = Variable<int>(pendingBonusXp);
    map['last_run_net_worth_cents'] = Variable<int>(lastRunNetWorthCents);
    map['legacy_points'] = Variable<int>(legacyPoints);
    map['legacy_upgrades'] = Variable<String>(legacyUpgrades);
    return map;
  }

  NewGameStateTableCompanion toCompanion(bool nullToAbsent) {
    return NewGameStateTableCompanion(
      id: Value(id),
      runCount: Value(runCount),
      pendingInheritanceCents: Value(pendingInheritanceCents),
      pendingBonusXp: Value(pendingBonusXp),
      lastRunNetWorthCents: Value(lastRunNetWorthCents),
      legacyPoints: Value(legacyPoints),
      legacyUpgrades: Value(legacyUpgrades),
    );
  }

  factory NewGameRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NewGameRow(
      id: serializer.fromJson<int>(json['id']),
      runCount: serializer.fromJson<int>(json['runCount']),
      pendingInheritanceCents: serializer.fromJson<int>(
        json['pendingInheritanceCents'],
      ),
      pendingBonusXp: serializer.fromJson<int>(json['pendingBonusXp']),
      lastRunNetWorthCents: serializer.fromJson<int>(
        json['lastRunNetWorthCents'],
      ),
      legacyPoints: serializer.fromJson<int>(json['legacyPoints']),
      legacyUpgrades: serializer.fromJson<String>(json['legacyUpgrades']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'runCount': serializer.toJson<int>(runCount),
      'pendingInheritanceCents': serializer.toJson<int>(
        pendingInheritanceCents,
      ),
      'pendingBonusXp': serializer.toJson<int>(pendingBonusXp),
      'lastRunNetWorthCents': serializer.toJson<int>(lastRunNetWorthCents),
      'legacyPoints': serializer.toJson<int>(legacyPoints),
      'legacyUpgrades': serializer.toJson<String>(legacyUpgrades),
    };
  }

  NewGameRow copyWith({
    int? id,
    int? runCount,
    int? pendingInheritanceCents,
    int? pendingBonusXp,
    int? lastRunNetWorthCents,
    int? legacyPoints,
    String? legacyUpgrades,
  }) => NewGameRow(
    id: id ?? this.id,
    runCount: runCount ?? this.runCount,
    pendingInheritanceCents:
        pendingInheritanceCents ?? this.pendingInheritanceCents,
    pendingBonusXp: pendingBonusXp ?? this.pendingBonusXp,
    lastRunNetWorthCents: lastRunNetWorthCents ?? this.lastRunNetWorthCents,
    legacyPoints: legacyPoints ?? this.legacyPoints,
    legacyUpgrades: legacyUpgrades ?? this.legacyUpgrades,
  );
  NewGameRow copyWithCompanion(NewGameStateTableCompanion data) {
    return NewGameRow(
      id: data.id.present ? data.id.value : this.id,
      runCount: data.runCount.present ? data.runCount.value : this.runCount,
      pendingInheritanceCents: data.pendingInheritanceCents.present
          ? data.pendingInheritanceCents.value
          : this.pendingInheritanceCents,
      pendingBonusXp: data.pendingBonusXp.present
          ? data.pendingBonusXp.value
          : this.pendingBonusXp,
      lastRunNetWorthCents: data.lastRunNetWorthCents.present
          ? data.lastRunNetWorthCents.value
          : this.lastRunNetWorthCents,
      legacyPoints: data.legacyPoints.present
          ? data.legacyPoints.value
          : this.legacyPoints,
      legacyUpgrades: data.legacyUpgrades.present
          ? data.legacyUpgrades.value
          : this.legacyUpgrades,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NewGameRow(')
          ..write('id: $id, ')
          ..write('runCount: $runCount, ')
          ..write('pendingInheritanceCents: $pendingInheritanceCents, ')
          ..write('pendingBonusXp: $pendingBonusXp, ')
          ..write('lastRunNetWorthCents: $lastRunNetWorthCents, ')
          ..write('legacyPoints: $legacyPoints, ')
          ..write('legacyUpgrades: $legacyUpgrades')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    runCount,
    pendingInheritanceCents,
    pendingBonusXp,
    lastRunNetWorthCents,
    legacyPoints,
    legacyUpgrades,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NewGameRow &&
          other.id == this.id &&
          other.runCount == this.runCount &&
          other.pendingInheritanceCents == this.pendingInheritanceCents &&
          other.pendingBonusXp == this.pendingBonusXp &&
          other.lastRunNetWorthCents == this.lastRunNetWorthCents &&
          other.legacyPoints == this.legacyPoints &&
          other.legacyUpgrades == this.legacyUpgrades);
}

class NewGameStateTableCompanion extends UpdateCompanion<NewGameRow> {
  final Value<int> id;
  final Value<int> runCount;
  final Value<int> pendingInheritanceCents;
  final Value<int> pendingBonusXp;
  final Value<int> lastRunNetWorthCents;
  final Value<int> legacyPoints;
  final Value<String> legacyUpgrades;
  const NewGameStateTableCompanion({
    this.id = const Value.absent(),
    this.runCount = const Value.absent(),
    this.pendingInheritanceCents = const Value.absent(),
    this.pendingBonusXp = const Value.absent(),
    this.lastRunNetWorthCents = const Value.absent(),
    this.legacyPoints = const Value.absent(),
    this.legacyUpgrades = const Value.absent(),
  });
  NewGameStateTableCompanion.insert({
    this.id = const Value.absent(),
    this.runCount = const Value.absent(),
    this.pendingInheritanceCents = const Value.absent(),
    this.pendingBonusXp = const Value.absent(),
    this.lastRunNetWorthCents = const Value.absent(),
    this.legacyPoints = const Value.absent(),
    this.legacyUpgrades = const Value.absent(),
  });
  static Insertable<NewGameRow> custom({
    Expression<int>? id,
    Expression<int>? runCount,
    Expression<int>? pendingInheritanceCents,
    Expression<int>? pendingBonusXp,
    Expression<int>? lastRunNetWorthCents,
    Expression<int>? legacyPoints,
    Expression<String>? legacyUpgrades,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (runCount != null) 'run_count': runCount,
      if (pendingInheritanceCents != null)
        'pending_inheritance_cents': pendingInheritanceCents,
      if (pendingBonusXp != null) 'pending_bonus_xp': pendingBonusXp,
      if (lastRunNetWorthCents != null)
        'last_run_net_worth_cents': lastRunNetWorthCents,
      if (legacyPoints != null) 'legacy_points': legacyPoints,
      if (legacyUpgrades != null) 'legacy_upgrades': legacyUpgrades,
    });
  }

  NewGameStateTableCompanion copyWith({
    Value<int>? id,
    Value<int>? runCount,
    Value<int>? pendingInheritanceCents,
    Value<int>? pendingBonusXp,
    Value<int>? lastRunNetWorthCents,
    Value<int>? legacyPoints,
    Value<String>? legacyUpgrades,
  }) {
    return NewGameStateTableCompanion(
      id: id ?? this.id,
      runCount: runCount ?? this.runCount,
      pendingInheritanceCents:
          pendingInheritanceCents ?? this.pendingInheritanceCents,
      pendingBonusXp: pendingBonusXp ?? this.pendingBonusXp,
      lastRunNetWorthCents: lastRunNetWorthCents ?? this.lastRunNetWorthCents,
      legacyPoints: legacyPoints ?? this.legacyPoints,
      legacyUpgrades: legacyUpgrades ?? this.legacyUpgrades,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (runCount.present) {
      map['run_count'] = Variable<int>(runCount.value);
    }
    if (pendingInheritanceCents.present) {
      map['pending_inheritance_cents'] = Variable<int>(
        pendingInheritanceCents.value,
      );
    }
    if (pendingBonusXp.present) {
      map['pending_bonus_xp'] = Variable<int>(pendingBonusXp.value);
    }
    if (lastRunNetWorthCents.present) {
      map['last_run_net_worth_cents'] = Variable<int>(
        lastRunNetWorthCents.value,
      );
    }
    if (legacyPoints.present) {
      map['legacy_points'] = Variable<int>(legacyPoints.value);
    }
    if (legacyUpgrades.present) {
      map['legacy_upgrades'] = Variable<String>(legacyUpgrades.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NewGameStateTableCompanion(')
          ..write('id: $id, ')
          ..write('runCount: $runCount, ')
          ..write('pendingInheritanceCents: $pendingInheritanceCents, ')
          ..write('pendingBonusXp: $pendingBonusXp, ')
          ..write('lastRunNetWorthCents: $lastRunNetWorthCents, ')
          ..write('legacyPoints: $legacyPoints, ')
          ..write('legacyUpgrades: $legacyUpgrades')
          ..write(')'))
        .toString();
  }
}

class $TreeHoldingsTableTable extends TreeHoldingsTable
    with TableInfo<$TreeHoldingsTableTable, PlantedTreeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreeHoldingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plantedOnDayIndexMeta = const VerificationMeta(
    'plantedOnDayIndex',
  );
  @override
  late final GeneratedColumn<int> plantedOnDayIndex = GeneratedColumn<int>(
    'planted_on_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, plantedOnDayIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tree_holdings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlantedTreeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('planted_on_day_index')) {
      context.handle(
        _plantedOnDayIndexMeta,
        plantedOnDayIndex.isAcceptableOrUnknown(
          data['planted_on_day_index']!,
          _plantedOnDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plantedOnDayIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlantedTreeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlantedTreeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      plantedOnDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planted_on_day_index'],
      )!,
    );
  }

  @override
  $TreeHoldingsTableTable createAlias(String alias) {
    return $TreeHoldingsTableTable(attachedDatabase, alias);
  }
}

class PlantedTreeRow extends DataClass implements Insertable<PlantedTreeRow> {
  final String id;

  /// Stores TreeKind.name (birke/eiche/pinie).
  final String kind;
  final int plantedOnDayIndex;
  const PlantedTreeRow({
    required this.id,
    required this.kind,
    required this.plantedOnDayIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['planted_on_day_index'] = Variable<int>(plantedOnDayIndex);
    return map;
  }

  TreeHoldingsTableCompanion toCompanion(bool nullToAbsent) {
    return TreeHoldingsTableCompanion(
      id: Value(id),
      kind: Value(kind),
      plantedOnDayIndex: Value(plantedOnDayIndex),
    );
  }

  factory PlantedTreeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlantedTreeRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      plantedOnDayIndex: serializer.fromJson<int>(json['plantedOnDayIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'plantedOnDayIndex': serializer.toJson<int>(plantedOnDayIndex),
    };
  }

  PlantedTreeRow copyWith({String? id, String? kind, int? plantedOnDayIndex}) =>
      PlantedTreeRow(
        id: id ?? this.id,
        kind: kind ?? this.kind,
        plantedOnDayIndex: plantedOnDayIndex ?? this.plantedOnDayIndex,
      );
  PlantedTreeRow copyWithCompanion(TreeHoldingsTableCompanion data) {
    return PlantedTreeRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      plantedOnDayIndex: data.plantedOnDayIndex.present
          ? data.plantedOnDayIndex.value
          : this.plantedOnDayIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlantedTreeRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('plantedOnDayIndex: $plantedOnDayIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, plantedOnDayIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlantedTreeRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.plantedOnDayIndex == this.plantedOnDayIndex);
}

class TreeHoldingsTableCompanion extends UpdateCompanion<PlantedTreeRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<int> plantedOnDayIndex;
  final Value<int> rowid;
  const TreeHoldingsTableCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.plantedOnDayIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TreeHoldingsTableCompanion.insert({
    required String id,
    required String kind,
    required int plantedOnDayIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       plantedOnDayIndex = Value(plantedOnDayIndex);
  static Insertable<PlantedTreeRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<int>? plantedOnDayIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (plantedOnDayIndex != null) 'planted_on_day_index': plantedOnDayIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TreeHoldingsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<int>? plantedOnDayIndex,
    Value<int>? rowid,
  }) {
    return TreeHoldingsTableCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      plantedOnDayIndex: plantedOnDayIndex ?? this.plantedOnDayIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (plantedOnDayIndex.present) {
      map['planted_on_day_index'] = Variable<int>(plantedOnDayIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreeHoldingsTableCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('plantedOnDayIndex: $plantedOnDayIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JobActionStateTableTable extends JobActionStateTable
    with TableInfo<$JobActionStateTableTable, JobActionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JobActionStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _careerBonusPctMeta = const VerificationMeta(
    'careerBonusPct',
  );
  @override
  late final GeneratedColumn<int> careerBonusPct = GeneratedColumn<int>(
    'career_bonus_pct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pauseUntilDayMeta = const VerificationMeta(
    'pauseUntilDay',
  );
  @override
  late final GeneratedColumn<int> pauseUntilDay = GeneratedColumn<int>(
    'pause_until_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _nextSwitchAllowedDayMeta =
      const VerificationMeta('nextSwitchAllowedDay');
  @override
  late final GeneratedColumn<int> nextSwitchAllowedDay = GeneratedColumn<int>(
    'next_switch_allowed_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _jobVariantIndexMeta = const VerificationMeta(
    'jobVariantIndex',
  );
  @override
  late final GeneratedColumn<int> jobVariantIndex = GeneratedColumn<int>(
    'job_variant_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    careerBonusPct,
    pauseUntilDay,
    nextSwitchAllowedDay,
    jobVariantIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'job_action_state_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<JobActionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('career_bonus_pct')) {
      context.handle(
        _careerBonusPctMeta,
        careerBonusPct.isAcceptableOrUnknown(
          data['career_bonus_pct']!,
          _careerBonusPctMeta,
        ),
      );
    }
    if (data.containsKey('pause_until_day')) {
      context.handle(
        _pauseUntilDayMeta,
        pauseUntilDay.isAcceptableOrUnknown(
          data['pause_until_day']!,
          _pauseUntilDayMeta,
        ),
      );
    }
    if (data.containsKey('next_switch_allowed_day')) {
      context.handle(
        _nextSwitchAllowedDayMeta,
        nextSwitchAllowedDay.isAcceptableOrUnknown(
          data['next_switch_allowed_day']!,
          _nextSwitchAllowedDayMeta,
        ),
      );
    }
    if (data.containsKey('job_variant_index')) {
      context.handle(
        _jobVariantIndexMeta,
        jobVariantIndex.isAcceptableOrUnknown(
          data['job_variant_index']!,
          _jobVariantIndexMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JobActionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JobActionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      careerBonusPct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}career_bonus_pct'],
      )!,
      pauseUntilDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pause_until_day'],
      )!,
      nextSwitchAllowedDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_switch_allowed_day'],
      )!,
      jobVariantIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}job_variant_index'],
      )!,
    );
  }

  @override
  $JobActionStateTableTable createAlias(String alias) {
    return $JobActionStateTableTable(attachedDatabase, alias);
  }
}

class JobActionRow extends DataClass implements Insertable<JobActionRow> {
  final int id;
  final int careerBonusPct;
  final int pauseUntilDay;
  final int nextSwitchAllowedDay;
  final int jobVariantIndex;
  const JobActionRow({
    required this.id,
    required this.careerBonusPct,
    required this.pauseUntilDay,
    required this.nextSwitchAllowedDay,
    required this.jobVariantIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['career_bonus_pct'] = Variable<int>(careerBonusPct);
    map['pause_until_day'] = Variable<int>(pauseUntilDay);
    map['next_switch_allowed_day'] = Variable<int>(nextSwitchAllowedDay);
    map['job_variant_index'] = Variable<int>(jobVariantIndex);
    return map;
  }

  JobActionStateTableCompanion toCompanion(bool nullToAbsent) {
    return JobActionStateTableCompanion(
      id: Value(id),
      careerBonusPct: Value(careerBonusPct),
      pauseUntilDay: Value(pauseUntilDay),
      nextSwitchAllowedDay: Value(nextSwitchAllowedDay),
      jobVariantIndex: Value(jobVariantIndex),
    );
  }

  factory JobActionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JobActionRow(
      id: serializer.fromJson<int>(json['id']),
      careerBonusPct: serializer.fromJson<int>(json['careerBonusPct']),
      pauseUntilDay: serializer.fromJson<int>(json['pauseUntilDay']),
      nextSwitchAllowedDay: serializer.fromJson<int>(
        json['nextSwitchAllowedDay'],
      ),
      jobVariantIndex: serializer.fromJson<int>(json['jobVariantIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'careerBonusPct': serializer.toJson<int>(careerBonusPct),
      'pauseUntilDay': serializer.toJson<int>(pauseUntilDay),
      'nextSwitchAllowedDay': serializer.toJson<int>(nextSwitchAllowedDay),
      'jobVariantIndex': serializer.toJson<int>(jobVariantIndex),
    };
  }

  JobActionRow copyWith({
    int? id,
    int? careerBonusPct,
    int? pauseUntilDay,
    int? nextSwitchAllowedDay,
    int? jobVariantIndex,
  }) => JobActionRow(
    id: id ?? this.id,
    careerBonusPct: careerBonusPct ?? this.careerBonusPct,
    pauseUntilDay: pauseUntilDay ?? this.pauseUntilDay,
    nextSwitchAllowedDay: nextSwitchAllowedDay ?? this.nextSwitchAllowedDay,
    jobVariantIndex: jobVariantIndex ?? this.jobVariantIndex,
  );
  JobActionRow copyWithCompanion(JobActionStateTableCompanion data) {
    return JobActionRow(
      id: data.id.present ? data.id.value : this.id,
      careerBonusPct: data.careerBonusPct.present
          ? data.careerBonusPct.value
          : this.careerBonusPct,
      pauseUntilDay: data.pauseUntilDay.present
          ? data.pauseUntilDay.value
          : this.pauseUntilDay,
      nextSwitchAllowedDay: data.nextSwitchAllowedDay.present
          ? data.nextSwitchAllowedDay.value
          : this.nextSwitchAllowedDay,
      jobVariantIndex: data.jobVariantIndex.present
          ? data.jobVariantIndex.value
          : this.jobVariantIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JobActionRow(')
          ..write('id: $id, ')
          ..write('careerBonusPct: $careerBonusPct, ')
          ..write('pauseUntilDay: $pauseUntilDay, ')
          ..write('nextSwitchAllowedDay: $nextSwitchAllowedDay, ')
          ..write('jobVariantIndex: $jobVariantIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    careerBonusPct,
    pauseUntilDay,
    nextSwitchAllowedDay,
    jobVariantIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JobActionRow &&
          other.id == this.id &&
          other.careerBonusPct == this.careerBonusPct &&
          other.pauseUntilDay == this.pauseUntilDay &&
          other.nextSwitchAllowedDay == this.nextSwitchAllowedDay &&
          other.jobVariantIndex == this.jobVariantIndex);
}

class JobActionStateTableCompanion extends UpdateCompanion<JobActionRow> {
  final Value<int> id;
  final Value<int> careerBonusPct;
  final Value<int> pauseUntilDay;
  final Value<int> nextSwitchAllowedDay;
  final Value<int> jobVariantIndex;
  const JobActionStateTableCompanion({
    this.id = const Value.absent(),
    this.careerBonusPct = const Value.absent(),
    this.pauseUntilDay = const Value.absent(),
    this.nextSwitchAllowedDay = const Value.absent(),
    this.jobVariantIndex = const Value.absent(),
  });
  JobActionStateTableCompanion.insert({
    this.id = const Value.absent(),
    this.careerBonusPct = const Value.absent(),
    this.pauseUntilDay = const Value.absent(),
    this.nextSwitchAllowedDay = const Value.absent(),
    this.jobVariantIndex = const Value.absent(),
  });
  static Insertable<JobActionRow> custom({
    Expression<int>? id,
    Expression<int>? careerBonusPct,
    Expression<int>? pauseUntilDay,
    Expression<int>? nextSwitchAllowedDay,
    Expression<int>? jobVariantIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careerBonusPct != null) 'career_bonus_pct': careerBonusPct,
      if (pauseUntilDay != null) 'pause_until_day': pauseUntilDay,
      if (nextSwitchAllowedDay != null)
        'next_switch_allowed_day': nextSwitchAllowedDay,
      if (jobVariantIndex != null) 'job_variant_index': jobVariantIndex,
    });
  }

  JobActionStateTableCompanion copyWith({
    Value<int>? id,
    Value<int>? careerBonusPct,
    Value<int>? pauseUntilDay,
    Value<int>? nextSwitchAllowedDay,
    Value<int>? jobVariantIndex,
  }) {
    return JobActionStateTableCompanion(
      id: id ?? this.id,
      careerBonusPct: careerBonusPct ?? this.careerBonusPct,
      pauseUntilDay: pauseUntilDay ?? this.pauseUntilDay,
      nextSwitchAllowedDay: nextSwitchAllowedDay ?? this.nextSwitchAllowedDay,
      jobVariantIndex: jobVariantIndex ?? this.jobVariantIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (careerBonusPct.present) {
      map['career_bonus_pct'] = Variable<int>(careerBonusPct.value);
    }
    if (pauseUntilDay.present) {
      map['pause_until_day'] = Variable<int>(pauseUntilDay.value);
    }
    if (nextSwitchAllowedDay.present) {
      map['next_switch_allowed_day'] = Variable<int>(
        nextSwitchAllowedDay.value,
      );
    }
    if (jobVariantIndex.present) {
      map['job_variant_index'] = Variable<int>(jobVariantIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JobActionStateTableCompanion(')
          ..write('id: $id, ')
          ..write('careerBonusPct: $careerBonusPct, ')
          ..write('pauseUntilDay: $pauseUntilDay, ')
          ..write('nextSwitchAllowedDay: $nextSwitchAllowedDay, ')
          ..write('jobVariantIndex: $jobVariantIndex')
          ..write(')'))
        .toString();
  }
}

class $QuestFailureTableTable extends QuestFailureTable
    with TableInfo<$QuestFailureTableTable, QuestFailRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestFailureTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questIdMeta = const VerificationMeta(
    'questId',
  );
  @override
  late final GeneratedColumn<String> questId = GeneratedColumn<String>(
    'quest_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _failedOnDayIndexMeta = const VerificationMeta(
    'failedOnDayIndex',
  );
  @override
  late final GeneratedColumn<int> failedOnDayIndex = GeneratedColumn<int>(
    'failed_on_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [questId, failedOnDayIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quest_failure_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestFailRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('quest_id')) {
      context.handle(
        _questIdMeta,
        questId.isAcceptableOrUnknown(data['quest_id']!, _questIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questIdMeta);
    }
    if (data.containsKey('failed_on_day_index')) {
      context.handle(
        _failedOnDayIndexMeta,
        failedOnDayIndex.isAcceptableOrUnknown(
          data['failed_on_day_index']!,
          _failedOnDayIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_failedOnDayIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questId};
  @override
  QuestFailRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestFailRow(
      questId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quest_id'],
      )!,
      failedOnDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed_on_day_index'],
      )!,
    );
  }

  @override
  $QuestFailureTableTable createAlias(String alias) {
    return $QuestFailureTableTable(attachedDatabase, alias);
  }
}

class QuestFailRow extends DataClass implements Insertable<QuestFailRow> {
  final String questId;
  final int failedOnDayIndex;
  const QuestFailRow({required this.questId, required this.failedOnDayIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['quest_id'] = Variable<String>(questId);
    map['failed_on_day_index'] = Variable<int>(failedOnDayIndex);
    return map;
  }

  QuestFailureTableCompanion toCompanion(bool nullToAbsent) {
    return QuestFailureTableCompanion(
      questId: Value(questId),
      failedOnDayIndex: Value(failedOnDayIndex),
    );
  }

  factory QuestFailRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestFailRow(
      questId: serializer.fromJson<String>(json['questId']),
      failedOnDayIndex: serializer.fromJson<int>(json['failedOnDayIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questId': serializer.toJson<String>(questId),
      'failedOnDayIndex': serializer.toJson<int>(failedOnDayIndex),
    };
  }

  QuestFailRow copyWith({String? questId, int? failedOnDayIndex}) =>
      QuestFailRow(
        questId: questId ?? this.questId,
        failedOnDayIndex: failedOnDayIndex ?? this.failedOnDayIndex,
      );
  QuestFailRow copyWithCompanion(QuestFailureTableCompanion data) {
    return QuestFailRow(
      questId: data.questId.present ? data.questId.value : this.questId,
      failedOnDayIndex: data.failedOnDayIndex.present
          ? data.failedOnDayIndex.value
          : this.failedOnDayIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestFailRow(')
          ..write('questId: $questId, ')
          ..write('failedOnDayIndex: $failedOnDayIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(questId, failedOnDayIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestFailRow &&
          other.questId == this.questId &&
          other.failedOnDayIndex == this.failedOnDayIndex);
}

class QuestFailureTableCompanion extends UpdateCompanion<QuestFailRow> {
  final Value<String> questId;
  final Value<int> failedOnDayIndex;
  final Value<int> rowid;
  const QuestFailureTableCompanion({
    this.questId = const Value.absent(),
    this.failedOnDayIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestFailureTableCompanion.insert({
    required String questId,
    required int failedOnDayIndex,
    this.rowid = const Value.absent(),
  }) : questId = Value(questId),
       failedOnDayIndex = Value(failedOnDayIndex);
  static Insertable<QuestFailRow> custom({
    Expression<String>? questId,
    Expression<int>? failedOnDayIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questId != null) 'quest_id': questId,
      if (failedOnDayIndex != null) 'failed_on_day_index': failedOnDayIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestFailureTableCompanion copyWith({
    Value<String>? questId,
    Value<int>? failedOnDayIndex,
    Value<int>? rowid,
  }) {
    return QuestFailureTableCompanion(
      questId: questId ?? this.questId,
      failedOnDayIndex: failedOnDayIndex ?? this.failedOnDayIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questId.present) {
      map['quest_id'] = Variable<String>(questId.value);
    }
    if (failedOnDayIndex.present) {
      map['failed_on_day_index'] = Variable<int>(failedOnDayIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestFailureTableCompanion(')
          ..write('questId: $questId, ')
          ..write('failedOnDayIndex: $failedOnDayIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FurnitureTableTable extends FurnitureTable
    with TableInfo<$FurnitureTableTable, FurnitureRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FurnitureTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<String> slot = GeneratedColumn<String>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("hidden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _posXMeta = const VerificationMeta('posX');
  @override
  late final GeneratedColumn<double> posX = GeneratedColumn<double>(
    'pos_x',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posYMeta = const VerificationMeta('posY');
  @override
  late final GeneratedColumn<double> posY = GeneratedColumn<double>(
    'pos_y',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    slot,
    active,
    hidden,
    posX,
    posY,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'furniture_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FurnitureRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('hidden')) {
      context.handle(
        _hiddenMeta,
        hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta),
      );
    }
    if (data.containsKey('pos_x')) {
      context.handle(
        _posXMeta,
        posX.isAcceptableOrUnknown(data['pos_x']!, _posXMeta),
      );
    }
    if (data.containsKey('pos_y')) {
      context.handle(
        _posYMeta,
        posY.isAcceptableOrUnknown(data['pos_y']!, _posYMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  FurnitureRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FurnitureRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slot'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hidden'],
      )!,
      posX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pos_x'],
      ),
      posY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pos_y'],
      ),
    );
  }

  @override
  $FurnitureTableTable createAlias(String alias) {
    return $FurnitureTableTable(attachedDatabase, alias);
  }
}

class FurnitureRow extends DataClass implements Insertable<FurnitureRow> {
  final String itemId;
  final String slot;
  final bool active;
  final bool hidden;
  final double? posX;
  final double? posY;
  const FurnitureRow({
    required this.itemId,
    required this.slot,
    required this.active,
    required this.hidden,
    this.posX,
    this.posY,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['slot'] = Variable<String>(slot);
    map['active'] = Variable<bool>(active);
    map['hidden'] = Variable<bool>(hidden);
    if (!nullToAbsent || posX != null) {
      map['pos_x'] = Variable<double>(posX);
    }
    if (!nullToAbsent || posY != null) {
      map['pos_y'] = Variable<double>(posY);
    }
    return map;
  }

  FurnitureTableCompanion toCompanion(bool nullToAbsent) {
    return FurnitureTableCompanion(
      itemId: Value(itemId),
      slot: Value(slot),
      active: Value(active),
      hidden: Value(hidden),
      posX: posX == null && nullToAbsent ? const Value.absent() : Value(posX),
      posY: posY == null && nullToAbsent ? const Value.absent() : Value(posY),
    );
  }

  factory FurnitureRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FurnitureRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      slot: serializer.fromJson<String>(json['slot']),
      active: serializer.fromJson<bool>(json['active']),
      hidden: serializer.fromJson<bool>(json['hidden']),
      posX: serializer.fromJson<double?>(json['posX']),
      posY: serializer.fromJson<double?>(json['posY']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'slot': serializer.toJson<String>(slot),
      'active': serializer.toJson<bool>(active),
      'hidden': serializer.toJson<bool>(hidden),
      'posX': serializer.toJson<double?>(posX),
      'posY': serializer.toJson<double?>(posY),
    };
  }

  FurnitureRow copyWith({
    String? itemId,
    String? slot,
    bool? active,
    bool? hidden,
    Value<double?> posX = const Value.absent(),
    Value<double?> posY = const Value.absent(),
  }) => FurnitureRow(
    itemId: itemId ?? this.itemId,
    slot: slot ?? this.slot,
    active: active ?? this.active,
    hidden: hidden ?? this.hidden,
    posX: posX.present ? posX.value : this.posX,
    posY: posY.present ? posY.value : this.posY,
  );
  FurnitureRow copyWithCompanion(FurnitureTableCompanion data) {
    return FurnitureRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      slot: data.slot.present ? data.slot.value : this.slot,
      active: data.active.present ? data.active.value : this.active,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
      posX: data.posX.present ? data.posX.value : this.posX,
      posY: data.posY.present ? data.posY.value : this.posY,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FurnitureRow(')
          ..write('itemId: $itemId, ')
          ..write('slot: $slot, ')
          ..write('active: $active, ')
          ..write('hidden: $hidden, ')
          ..write('posX: $posX, ')
          ..write('posY: $posY')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, slot, active, hidden, posX, posY);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FurnitureRow &&
          other.itemId == this.itemId &&
          other.slot == this.slot &&
          other.active == this.active &&
          other.hidden == this.hidden &&
          other.posX == this.posX &&
          other.posY == this.posY);
}

class FurnitureTableCompanion extends UpdateCompanion<FurnitureRow> {
  final Value<String> itemId;
  final Value<String> slot;
  final Value<bool> active;
  final Value<bool> hidden;
  final Value<double?> posX;
  final Value<double?> posY;
  final Value<int> rowid;
  const FurnitureTableCompanion({
    this.itemId = const Value.absent(),
    this.slot = const Value.absent(),
    this.active = const Value.absent(),
    this.hidden = const Value.absent(),
    this.posX = const Value.absent(),
    this.posY = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FurnitureTableCompanion.insert({
    required String itemId,
    required String slot,
    this.active = const Value.absent(),
    this.hidden = const Value.absent(),
    this.posX = const Value.absent(),
    this.posY = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       slot = Value(slot);
  static Insertable<FurnitureRow> custom({
    Expression<String>? itemId,
    Expression<String>? slot,
    Expression<bool>? active,
    Expression<bool>? hidden,
    Expression<double>? posX,
    Expression<double>? posY,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (slot != null) 'slot': slot,
      if (active != null) 'active': active,
      if (hidden != null) 'hidden': hidden,
      if (posX != null) 'pos_x': posX,
      if (posY != null) 'pos_y': posY,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FurnitureTableCompanion copyWith({
    Value<String>? itemId,
    Value<String>? slot,
    Value<bool>? active,
    Value<bool>? hidden,
    Value<double?>? posX,
    Value<double?>? posY,
    Value<int>? rowid,
  }) {
    return FurnitureTableCompanion(
      itemId: itemId ?? this.itemId,
      slot: slot ?? this.slot,
      active: active ?? this.active,
      hidden: hidden ?? this.hidden,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (slot.present) {
      map['slot'] = Variable<String>(slot.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    if (posX.present) {
      map['pos_x'] = Variable<double>(posX.value);
    }
    if (posY.present) {
      map['pos_y'] = Variable<double>(posY.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FurnitureTableCompanion(')
          ..write('itemId: $itemId, ')
          ..write('slot: $slot, ')
          ..write('active: $active, ')
          ..write('hidden: $hidden, ')
          ..write('posX: $posX, ')
          ..write('posY: $posY, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RealMilestonesTableTable extends RealMilestonesTable
    with TableInfo<$RealMilestonesTableTable, RealMilestoneRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RealMilestonesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('💰'),
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
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateIsoMeta = const VerificationMeta(
    'dateIso',
  );
  @override
  late final GeneratedColumn<String> dateIso = GeneratedColumn<String>(
    'date_iso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    emoji,
    title,
    amountCents,
    dateIso,
    category,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'real_milestones_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RealMilestoneRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
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
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    }
    if (data.containsKey('date_iso')) {
      context.handle(
        _dateIsoMeta,
        dateIso.isAcceptableOrUnknown(data['date_iso']!, _dateIsoMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  RealMilestoneRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RealMilestoneRow(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      ),
      dateIso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_iso'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
    );
  }

  @override
  $RealMilestonesTableTable createAlias(String alias) {
    return $RealMilestonesTableTable(attachedDatabase, alias);
  }
}

class RealMilestoneRow extends DataClass
    implements Insertable<RealMilestoneRow> {
  final int rowId;
  final String emoji;
  final String title;

  /// Optionaler €-Betrag in Cents. Null = kein Betrag.
  final int? amountCents;

  /// Eintrags-Datum als DD.MM.YYYY-String.
  final String dateIso;

  /// Welle-8 Round 26: Kategorie (sparen/lernen/verzicht/sonstiges). Leer
  /// bei Alt-Einträgen. Drift v27.
  final String category;
  const RealMilestoneRow({
    required this.rowId,
    required this.emoji,
    required this.title,
    this.amountCents,
    required this.dateIso,
    required this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['emoji'] = Variable<String>(emoji);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || amountCents != null) {
      map['amount_cents'] = Variable<int>(amountCents);
    }
    map['date_iso'] = Variable<String>(dateIso);
    map['category'] = Variable<String>(category);
    return map;
  }

  RealMilestonesTableCompanion toCompanion(bool nullToAbsent) {
    return RealMilestonesTableCompanion(
      rowId: Value(rowId),
      emoji: Value(emoji),
      title: Value(title),
      amountCents: amountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(amountCents),
      dateIso: Value(dateIso),
      category: Value(category),
    );
  }

  factory RealMilestoneRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RealMilestoneRow(
      rowId: serializer.fromJson<int>(json['rowId']),
      emoji: serializer.fromJson<String>(json['emoji']),
      title: serializer.fromJson<String>(json['title']),
      amountCents: serializer.fromJson<int?>(json['amountCents']),
      dateIso: serializer.fromJson<String>(json['dateIso']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'emoji': serializer.toJson<String>(emoji),
      'title': serializer.toJson<String>(title),
      'amountCents': serializer.toJson<int?>(amountCents),
      'dateIso': serializer.toJson<String>(dateIso),
      'category': serializer.toJson<String>(category),
    };
  }

  RealMilestoneRow copyWith({
    int? rowId,
    String? emoji,
    String? title,
    Value<int?> amountCents = const Value.absent(),
    String? dateIso,
    String? category,
  }) => RealMilestoneRow(
    rowId: rowId ?? this.rowId,
    emoji: emoji ?? this.emoji,
    title: title ?? this.title,
    amountCents: amountCents.present ? amountCents.value : this.amountCents,
    dateIso: dateIso ?? this.dateIso,
    category: category ?? this.category,
  );
  RealMilestoneRow copyWithCompanion(RealMilestonesTableCompanion data) {
    return RealMilestoneRow(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      title: data.title.present ? data.title.value : this.title,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      dateIso: data.dateIso.present ? data.dateIso.value : this.dateIso,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RealMilestoneRow(')
          ..write('rowId: $rowId, ')
          ..write('emoji: $emoji, ')
          ..write('title: $title, ')
          ..write('amountCents: $amountCents, ')
          ..write('dateIso: $dateIso, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(rowId, emoji, title, amountCents, dateIso, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RealMilestoneRow &&
          other.rowId == this.rowId &&
          other.emoji == this.emoji &&
          other.title == this.title &&
          other.amountCents == this.amountCents &&
          other.dateIso == this.dateIso &&
          other.category == this.category);
}

class RealMilestonesTableCompanion extends UpdateCompanion<RealMilestoneRow> {
  final Value<int> rowId;
  final Value<String> emoji;
  final Value<String> title;
  final Value<int?> amountCents;
  final Value<String> dateIso;
  final Value<String> category;
  const RealMilestonesTableCompanion({
    this.rowId = const Value.absent(),
    this.emoji = const Value.absent(),
    this.title = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.dateIso = const Value.absent(),
    this.category = const Value.absent(),
  });
  RealMilestonesTableCompanion.insert({
    this.rowId = const Value.absent(),
    this.emoji = const Value.absent(),
    required String title,
    this.amountCents = const Value.absent(),
    this.dateIso = const Value.absent(),
    this.category = const Value.absent(),
  }) : title = Value(title);
  static Insertable<RealMilestoneRow> custom({
    Expression<int>? rowId,
    Expression<String>? emoji,
    Expression<String>? title,
    Expression<int>? amountCents,
    Expression<String>? dateIso,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (emoji != null) 'emoji': emoji,
      if (title != null) 'title': title,
      if (amountCents != null) 'amount_cents': amountCents,
      if (dateIso != null) 'date_iso': dateIso,
      if (category != null) 'category': category,
    });
  }

  RealMilestonesTableCompanion copyWith({
    Value<int>? rowId,
    Value<String>? emoji,
    Value<String>? title,
    Value<int?>? amountCents,
    Value<String>? dateIso,
    Value<String>? category,
  }) {
    return RealMilestonesTableCompanion(
      rowId: rowId ?? this.rowId,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      amountCents: amountCents ?? this.amountCents,
      dateIso: dateIso ?? this.dateIso,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (dateIso.present) {
      map['date_iso'] = Variable<String>(dateIso.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RealMilestonesTableCompanion(')
          ..write('rowId: $rowId, ')
          ..write('emoji: $emoji, ')
          ..write('title: $title, ')
          ..write('amountCents: $amountCents, ')
          ..write('dateIso: $dateIso, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $RealSavingsGoalsTableTable extends RealSavingsGoalsTable
    with TableInfo<$RealSavingsGoalsTableTable, RealSavingsGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RealSavingsGoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('🐷'),
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
  static const VerificationMeta _targetCentsMeta = const VerificationMeta(
    'targetCents',
  );
  @override
  late final GeneratedColumn<int> targetCents = GeneratedColumn<int>(
    'target_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedCentsMeta = const VerificationMeta(
    'savedCents',
  );
  @override
  late final GeneratedColumn<int> savedCents = GeneratedColumn<int>(
    'saved_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdIsoMeta = const VerificationMeta(
    'createdIso',
  );
  @override
  late final GeneratedColumn<String> createdIso = GeneratedColumn<String>(
    'created_iso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _confirmedIsoMeta = const VerificationMeta(
    'confirmedIso',
  );
  @override
  late final GeneratedColumn<String> confirmedIso = GeneratedColumn<String>(
    'confirmed_iso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    emoji,
    title,
    targetCents,
    savedCents,
    status,
    createdIso,
    confirmedIso,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'real_savings_goals_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RealSavingsGoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
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
    if (data.containsKey('target_cents')) {
      context.handle(
        _targetCentsMeta,
        targetCents.isAcceptableOrUnknown(
          data['target_cents']!,
          _targetCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetCentsMeta);
    }
    if (data.containsKey('saved_cents')) {
      context.handle(
        _savedCentsMeta,
        savedCents.isAcceptableOrUnknown(data['saved_cents']!, _savedCentsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_iso')) {
      context.handle(
        _createdIsoMeta,
        createdIso.isAcceptableOrUnknown(data['created_iso']!, _createdIsoMeta),
      );
    }
    if (data.containsKey('confirmed_iso')) {
      context.handle(
        _confirmedIsoMeta,
        confirmedIso.isAcceptableOrUnknown(
          data['confirmed_iso']!,
          _confirmedIsoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  RealSavingsGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RealSavingsGoalRow(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      targetCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_cents'],
      )!,
      savedCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saved_cents'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdIso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_iso'],
      )!,
      confirmedIso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmed_iso'],
      )!,
    );
  }

  @override
  $RealSavingsGoalsTableTable createAlias(String alias) {
    return $RealSavingsGoalsTableTable(attachedDatabase, alias);
  }
}

class RealSavingsGoalRow extends DataClass
    implements Insertable<RealSavingsGoalRow> {
  final int rowId;
  final String emoji;
  final String title;
  final int targetCents;
  final int savedCents;

  /// active | reached | confirmed.
  final String status;
  final String createdIso;
  final String confirmedIso;
  const RealSavingsGoalRow({
    required this.rowId,
    required this.emoji,
    required this.title,
    required this.targetCents,
    required this.savedCents,
    required this.status,
    required this.createdIso,
    required this.confirmedIso,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['emoji'] = Variable<String>(emoji);
    map['title'] = Variable<String>(title);
    map['target_cents'] = Variable<int>(targetCents);
    map['saved_cents'] = Variable<int>(savedCents);
    map['status'] = Variable<String>(status);
    map['created_iso'] = Variable<String>(createdIso);
    map['confirmed_iso'] = Variable<String>(confirmedIso);
    return map;
  }

  RealSavingsGoalsTableCompanion toCompanion(bool nullToAbsent) {
    return RealSavingsGoalsTableCompanion(
      rowId: Value(rowId),
      emoji: Value(emoji),
      title: Value(title),
      targetCents: Value(targetCents),
      savedCents: Value(savedCents),
      status: Value(status),
      createdIso: Value(createdIso),
      confirmedIso: Value(confirmedIso),
    );
  }

  factory RealSavingsGoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RealSavingsGoalRow(
      rowId: serializer.fromJson<int>(json['rowId']),
      emoji: serializer.fromJson<String>(json['emoji']),
      title: serializer.fromJson<String>(json['title']),
      targetCents: serializer.fromJson<int>(json['targetCents']),
      savedCents: serializer.fromJson<int>(json['savedCents']),
      status: serializer.fromJson<String>(json['status']),
      createdIso: serializer.fromJson<String>(json['createdIso']),
      confirmedIso: serializer.fromJson<String>(json['confirmedIso']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'emoji': serializer.toJson<String>(emoji),
      'title': serializer.toJson<String>(title),
      'targetCents': serializer.toJson<int>(targetCents),
      'savedCents': serializer.toJson<int>(savedCents),
      'status': serializer.toJson<String>(status),
      'createdIso': serializer.toJson<String>(createdIso),
      'confirmedIso': serializer.toJson<String>(confirmedIso),
    };
  }

  RealSavingsGoalRow copyWith({
    int? rowId,
    String? emoji,
    String? title,
    int? targetCents,
    int? savedCents,
    String? status,
    String? createdIso,
    String? confirmedIso,
  }) => RealSavingsGoalRow(
    rowId: rowId ?? this.rowId,
    emoji: emoji ?? this.emoji,
    title: title ?? this.title,
    targetCents: targetCents ?? this.targetCents,
    savedCents: savedCents ?? this.savedCents,
    status: status ?? this.status,
    createdIso: createdIso ?? this.createdIso,
    confirmedIso: confirmedIso ?? this.confirmedIso,
  );
  RealSavingsGoalRow copyWithCompanion(RealSavingsGoalsTableCompanion data) {
    return RealSavingsGoalRow(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      title: data.title.present ? data.title.value : this.title,
      targetCents: data.targetCents.present
          ? data.targetCents.value
          : this.targetCents,
      savedCents: data.savedCents.present
          ? data.savedCents.value
          : this.savedCents,
      status: data.status.present ? data.status.value : this.status,
      createdIso: data.createdIso.present
          ? data.createdIso.value
          : this.createdIso,
      confirmedIso: data.confirmedIso.present
          ? data.confirmedIso.value
          : this.confirmedIso,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RealSavingsGoalRow(')
          ..write('rowId: $rowId, ')
          ..write('emoji: $emoji, ')
          ..write('title: $title, ')
          ..write('targetCents: $targetCents, ')
          ..write('savedCents: $savedCents, ')
          ..write('status: $status, ')
          ..write('createdIso: $createdIso, ')
          ..write('confirmedIso: $confirmedIso')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    emoji,
    title,
    targetCents,
    savedCents,
    status,
    createdIso,
    confirmedIso,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RealSavingsGoalRow &&
          other.rowId == this.rowId &&
          other.emoji == this.emoji &&
          other.title == this.title &&
          other.targetCents == this.targetCents &&
          other.savedCents == this.savedCents &&
          other.status == this.status &&
          other.createdIso == this.createdIso &&
          other.confirmedIso == this.confirmedIso);
}

class RealSavingsGoalsTableCompanion
    extends UpdateCompanion<RealSavingsGoalRow> {
  final Value<int> rowId;
  final Value<String> emoji;
  final Value<String> title;
  final Value<int> targetCents;
  final Value<int> savedCents;
  final Value<String> status;
  final Value<String> createdIso;
  final Value<String> confirmedIso;
  const RealSavingsGoalsTableCompanion({
    this.rowId = const Value.absent(),
    this.emoji = const Value.absent(),
    this.title = const Value.absent(),
    this.targetCents = const Value.absent(),
    this.savedCents = const Value.absent(),
    this.status = const Value.absent(),
    this.createdIso = const Value.absent(),
    this.confirmedIso = const Value.absent(),
  });
  RealSavingsGoalsTableCompanion.insert({
    this.rowId = const Value.absent(),
    this.emoji = const Value.absent(),
    required String title,
    required int targetCents,
    this.savedCents = const Value.absent(),
    this.status = const Value.absent(),
    this.createdIso = const Value.absent(),
    this.confirmedIso = const Value.absent(),
  }) : title = Value(title),
       targetCents = Value(targetCents);
  static Insertable<RealSavingsGoalRow> custom({
    Expression<int>? rowId,
    Expression<String>? emoji,
    Expression<String>? title,
    Expression<int>? targetCents,
    Expression<int>? savedCents,
    Expression<String>? status,
    Expression<String>? createdIso,
    Expression<String>? confirmedIso,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (emoji != null) 'emoji': emoji,
      if (title != null) 'title': title,
      if (targetCents != null) 'target_cents': targetCents,
      if (savedCents != null) 'saved_cents': savedCents,
      if (status != null) 'status': status,
      if (createdIso != null) 'created_iso': createdIso,
      if (confirmedIso != null) 'confirmed_iso': confirmedIso,
    });
  }

  RealSavingsGoalsTableCompanion copyWith({
    Value<int>? rowId,
    Value<String>? emoji,
    Value<String>? title,
    Value<int>? targetCents,
    Value<int>? savedCents,
    Value<String>? status,
    Value<String>? createdIso,
    Value<String>? confirmedIso,
  }) {
    return RealSavingsGoalsTableCompanion(
      rowId: rowId ?? this.rowId,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      targetCents: targetCents ?? this.targetCents,
      savedCents: savedCents ?? this.savedCents,
      status: status ?? this.status,
      createdIso: createdIso ?? this.createdIso,
      confirmedIso: confirmedIso ?? this.confirmedIso,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (targetCents.present) {
      map['target_cents'] = Variable<int>(targetCents.value);
    }
    if (savedCents.present) {
      map['saved_cents'] = Variable<int>(savedCents.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdIso.present) {
      map['created_iso'] = Variable<String>(createdIso.value);
    }
    if (confirmedIso.present) {
      map['confirmed_iso'] = Variable<String>(confirmedIso.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RealSavingsGoalsTableCompanion(')
          ..write('rowId: $rowId, ')
          ..write('emoji: $emoji, ')
          ..write('title: $title, ')
          ..write('targetCents: $targetCents, ')
          ..write('savedCents: $savedCents, ')
          ..write('status: $status, ')
          ..write('createdIso: $createdIso, ')
          ..write('confirmedIso: $confirmedIso')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GameClockTableTable gameClockTable = $GameClockTableTable(this);
  late final $CashTableTable cashTable = $CashTableTable(this);
  late final $PlantsTableTable plantsTable = $PlantsTableTable(this);
  late final $EtfHoldingsTableTable etfHoldingsTable = $EtfHoldingsTableTable(
    this,
  );
  late final $EtfQuotesTableTable etfQuotesTable = $EtfQuotesTableTable(this);
  late final $StockHoldingsTableTable stockHoldingsTable =
      $StockHoldingsTableTable(this);
  late final $StockQuotesTableTable stockQuotesTable = $StockQuotesTableTable(
    this,
  );
  late final $CryptoHoldingsTableTable cryptoHoldingsTable =
      $CryptoHoldingsTableTable(this);
  late final $CryptoQuotesTableTable cryptoQuotesTable =
      $CryptoQuotesTableTable(this);
  late final $MetalHoldingsTableTable metalHoldingsTable =
      $MetalHoldingsTableTable(this);
  late final $MetalQuotesTableTable metalQuotesTable = $MetalQuotesTableTable(
    this,
  );
  late final $RealEstateHoldingsTableTable realEstateHoldingsTable =
      $RealEstateHoldingsTableTable(this);
  late final $CollectibleHoldingsTableTable collectibleHoldingsTable =
      $CollectibleHoldingsTableTable(this);
  late final $IslandDecorTableTable islandDecorTable = $IslandDecorTableTable(
    this,
  );
  late final $QuestPassivePaymentsTableTable questPassivePaymentsTable =
      $QuestPassivePaymentsTableTable(this);
  late final $VorsorgeContractsTableTable vorsorgeContractsTable =
      $VorsorgeContractsTableTable(this);
  late final $SavingsPlansTableTable savingsPlansTable =
      $SavingsPlansTableTable(this);
  late final $WishItemsTableTable wishItemsTable = $WishItemsTableTable(this);
  late final $PriceHistoryTableTable priceHistoryTable =
      $PriceHistoryTableTable(this);
  late final $UnlockedIslandsTableTable unlockedIslandsTable =
      $UnlockedIslandsTableTable(this);
  late final $QuestProgressTableTable questProgressTable =
      $QuestProgressTableTable(this);
  late final $QuestChatEntriesTableTable questChatEntriesTable =
      $QuestChatEntriesTableTable(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $XpTableTable xpTable = $XpTableTable(this);
  late final $SavingsTableTable savingsTable = $SavingsTableTable(this);
  late final $AchievementsTableTable achievementsTable =
      $AchievementsTableTable(this);
  late final $LuckyEventHistoryTableTable luckyEventHistoryTable =
      $LuckyEventHistoryTableTable(this);
  late final $NewGameStateTableTable newGameStateTable =
      $NewGameStateTableTable(this);
  late final $TreeHoldingsTableTable treeHoldingsTable =
      $TreeHoldingsTableTable(this);
  late final $JobActionStateTableTable jobActionStateTable =
      $JobActionStateTableTable(this);
  late final $QuestFailureTableTable questFailureTable =
      $QuestFailureTableTable(this);
  late final $FurnitureTableTable furnitureTable = $FurnitureTableTable(this);
  late final $RealMilestonesTableTable realMilestonesTable =
      $RealMilestonesTableTable(this);
  late final $RealSavingsGoalsTableTable realSavingsGoalsTable =
      $RealSavingsGoalsTableTable(this);
  late final GameClockDao gameClockDao = GameClockDao(this as AppDatabase);
  late final CashDao cashDao = CashDao(this as AppDatabase);
  late final PlantsDao plantsDao = PlantsDao(this as AppDatabase);
  late final EtfDao etfDao = EtfDao(this as AppDatabase);
  late final StockDao stockDao = StockDao(this as AppDatabase);
  late final CryptoDao cryptoDao = CryptoDao(this as AppDatabase);
  late final MetalDao metalDao = MetalDao(this as AppDatabase);
  late final RealEstateDao realEstateDao = RealEstateDao(this as AppDatabase);
  late final CollectibleDao collectibleDao = CollectibleDao(
    this as AppDatabase,
  );
  late final IslandDecorDao islandDecorDao = IslandDecorDao(
    this as AppDatabase,
  );
  late final QuestPassiveDao questPassiveDao = QuestPassiveDao(
    this as AppDatabase,
  );
  late final VorsorgeDao vorsorgeDao = VorsorgeDao(this as AppDatabase);
  late final SavingsPlansDao savingsPlansDao = SavingsPlansDao(
    this as AppDatabase,
  );
  late final WishItemsDao wishItemsDao = WishItemsDao(this as AppDatabase);
  late final PriceHistoryDao priceHistoryDao = PriceHistoryDao(
    this as AppDatabase,
  );
  late final UnlockedIslandsDao unlockedIslandsDao = UnlockedIslandsDao(
    this as AppDatabase,
  );
  late final QuestProgressDao questProgressDao = QuestProgressDao(
    this as AppDatabase,
  );
  late final QuestChatDao questChatDao = QuestChatDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final XpDao xpDao = XpDao(this as AppDatabase);
  late final SavingsDao savingsDao = SavingsDao(this as AppDatabase);
  late final AchievementsDao achievementsDao = AchievementsDao(
    this as AppDatabase,
  );
  late final LuckyEventHistoryDao luckyEventHistoryDao = LuckyEventHistoryDao(
    this as AppDatabase,
  );
  late final NewGameDao newGameDao = NewGameDao(this as AppDatabase);
  late final TreeHoldingsDao treeHoldingsDao = TreeHoldingsDao(
    this as AppDatabase,
  );
  late final JobActionDao jobActionDao = JobActionDao(this as AppDatabase);
  late final QuestFailureDao questFailureDao = QuestFailureDao(
    this as AppDatabase,
  );
  late final FurnitureDao furnitureDao = FurnitureDao(this as AppDatabase);
  late final RealMilestonesDao realMilestonesDao = RealMilestonesDao(
    this as AppDatabase,
  );
  late final RealSavingsGoalsDao realSavingsGoalsDao = RealSavingsGoalsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    gameClockTable,
    cashTable,
    plantsTable,
    etfHoldingsTable,
    etfQuotesTable,
    stockHoldingsTable,
    stockQuotesTable,
    cryptoHoldingsTable,
    cryptoQuotesTable,
    metalHoldingsTable,
    metalQuotesTable,
    realEstateHoldingsTable,
    collectibleHoldingsTable,
    islandDecorTable,
    questPassivePaymentsTable,
    vorsorgeContractsTable,
    savingsPlansTable,
    wishItemsTable,
    priceHistoryTable,
    unlockedIslandsTable,
    questProgressTable,
    questChatEntriesTable,
    settingsTable,
    xpTable,
    savingsTable,
    achievementsTable,
    luckyEventHistoryTable,
    newGameStateTable,
    treeHoldingsTable,
    jobActionStateTable,
    questFailureTable,
    furnitureTable,
    realMilestonesTable,
    realSavingsGoalsTable,
  ];
}

typedef $$GameClockTableTableCreateCompanionBuilder =
    GameClockTableCompanion Function({Value<int> id, Value<int> dayIndex});
typedef $$GameClockTableTableUpdateCompanionBuilder =
    GameClockTableCompanion Function({Value<int> id, Value<int> dayIndex});

class $$GameClockTableTableFilterComposer
    extends Composer<_$AppDatabase, $GameClockTableTable> {
  $$GameClockTableTableFilterComposer({
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

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GameClockTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GameClockTableTable> {
  $$GameClockTableTableOrderingComposer({
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

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameClockTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameClockTableTable> {
  $$GameClockTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);
}

class $$GameClockTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameClockTableTable,
          GameClockRow,
          $$GameClockTableTableFilterComposer,
          $$GameClockTableTableOrderingComposer,
          $$GameClockTableTableAnnotationComposer,
          $$GameClockTableTableCreateCompanionBuilder,
          $$GameClockTableTableUpdateCompanionBuilder,
          (
            GameClockRow,
            BaseReferences<_$AppDatabase, $GameClockTableTable, GameClockRow>,
          ),
          GameClockRow,
          PrefetchHooks Function()
        > {
  $$GameClockTableTableTableManager(
    _$AppDatabase db,
    $GameClockTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameClockTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameClockTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameClockTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
              }) => GameClockTableCompanion(id: id, dayIndex: dayIndex),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
              }) => GameClockTableCompanion.insert(id: id, dayIndex: dayIndex),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameClockTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameClockTableTable,
      GameClockRow,
      $$GameClockTableTableFilterComposer,
      $$GameClockTableTableOrderingComposer,
      $$GameClockTableTableAnnotationComposer,
      $$GameClockTableTableCreateCompanionBuilder,
      $$GameClockTableTableUpdateCompanionBuilder,
      (
        GameClockRow,
        BaseReferences<_$AppDatabase, $GameClockTableTable, GameClockRow>,
      ),
      GameClockRow,
      PrefetchHooks Function()
    >;
typedef $$CashTableTableCreateCompanionBuilder =
    CashTableCompanion Function({
      Value<int> id,
      Value<int> cents,
      Value<int> plantHarvestTotalCents,
    });
typedef $$CashTableTableUpdateCompanionBuilder =
    CashTableCompanion Function({
      Value<int> id,
      Value<int> cents,
      Value<int> plantHarvestTotalCents,
    });

class $$CashTableTableFilterComposer
    extends Composer<_$AppDatabase, $CashTableTable> {
  $$CashTableTableFilterComposer({
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

  ColumnFilters<int> get cents => $composableBuilder(
    column: $table.cents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plantHarvestTotalCents => $composableBuilder(
    column: $table.plantHarvestTotalCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CashTableTable> {
  $$CashTableTableOrderingComposer({
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

  ColumnOrderings<int> get cents => $composableBuilder(
    column: $table.cents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plantHarvestTotalCents => $composableBuilder(
    column: $table.plantHarvestTotalCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashTableTable> {
  $$CashTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cents =>
      $composableBuilder(column: $table.cents, builder: (column) => column);

  GeneratedColumn<int> get plantHarvestTotalCents => $composableBuilder(
    column: $table.plantHarvestTotalCents,
    builder: (column) => column,
  );
}

class $$CashTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashTableTable,
          CashRow,
          $$CashTableTableFilterComposer,
          $$CashTableTableOrderingComposer,
          $$CashTableTableAnnotationComposer,
          $$CashTableTableCreateCompanionBuilder,
          $$CashTableTableUpdateCompanionBuilder,
          (CashRow, BaseReferences<_$AppDatabase, $CashTableTable, CashRow>),
          CashRow,
          PrefetchHooks Function()
        > {
  $$CashTableTableTableManager(_$AppDatabase db, $CashTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cents = const Value.absent(),
                Value<int> plantHarvestTotalCents = const Value.absent(),
              }) => CashTableCompanion(
                id: id,
                cents: cents,
                plantHarvestTotalCents: plantHarvestTotalCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cents = const Value.absent(),
                Value<int> plantHarvestTotalCents = const Value.absent(),
              }) => CashTableCompanion.insert(
                id: id,
                cents: cents,
                plantHarvestTotalCents: plantHarvestTotalCents,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashTableTable,
      CashRow,
      $$CashTableTableFilterComposer,
      $$CashTableTableOrderingComposer,
      $$CashTableTableAnnotationComposer,
      $$CashTableTableCreateCompanionBuilder,
      $$CashTableTableUpdateCompanionBuilder,
      (CashRow, BaseReferences<_$AppDatabase, $CashTableTable, CashRow>),
      CashRow,
      PrefetchHooks Function()
    >;
typedef $$PlantsTableTableCreateCompanionBuilder =
    PlantsTableCompanion Function({
      required String id,
      required String islandId,
      required int plotIndex,
      required String kind,
      required int plantedOnDayIndex,
      Value<int> currentStage,
      Value<int> growthProgress,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$PlantsTableTableUpdateCompanionBuilder =
    PlantsTableCompanion Function({
      Value<String> id,
      Value<String> islandId,
      Value<int> plotIndex,
      Value<String> kind,
      Value<int> plantedOnDayIndex,
      Value<int> currentStage,
      Value<int> growthProgress,
      Value<String> status,
      Value<int> rowid,
    });

class $$PlantsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlantsTableTable> {
  $$PlantsTableTableFilterComposer({
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

  ColumnFilters<String> get islandId => $composableBuilder(
    column: $table.islandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plotIndex => $composableBuilder(
    column: $table.plotIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plantedOnDayIndex => $composableBuilder(
    column: $table.plantedOnDayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStage => $composableBuilder(
    column: $table.currentStage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get growthProgress => $composableBuilder(
    column: $table.growthProgress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlantsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlantsTableTable> {
  $$PlantsTableTableOrderingComposer({
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

  ColumnOrderings<String> get islandId => $composableBuilder(
    column: $table.islandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plotIndex => $composableBuilder(
    column: $table.plotIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plantedOnDayIndex => $composableBuilder(
    column: $table.plantedOnDayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStage => $composableBuilder(
    column: $table.currentStage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get growthProgress => $composableBuilder(
    column: $table.growthProgress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlantsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlantsTableTable> {
  $$PlantsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get islandId =>
      $composableBuilder(column: $table.islandId, builder: (column) => column);

  GeneratedColumn<int> get plotIndex =>
      $composableBuilder(column: $table.plotIndex, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get plantedOnDayIndex => $composableBuilder(
    column: $table.plantedOnDayIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStage => $composableBuilder(
    column: $table.currentStage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get growthProgress => $composableBuilder(
    column: $table.growthProgress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$PlantsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlantsTableTable,
          PlantRow,
          $$PlantsTableTableFilterComposer,
          $$PlantsTableTableOrderingComposer,
          $$PlantsTableTableAnnotationComposer,
          $$PlantsTableTableCreateCompanionBuilder,
          $$PlantsTableTableUpdateCompanionBuilder,
          (
            PlantRow,
            BaseReferences<_$AppDatabase, $PlantsTableTable, PlantRow>,
          ),
          PlantRow,
          PrefetchHooks Function()
        > {
  $$PlantsTableTableTableManager(_$AppDatabase db, $PlantsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlantsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlantsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlantsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> islandId = const Value.absent(),
                Value<int> plotIndex = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> plantedOnDayIndex = const Value.absent(),
                Value<int> currentStage = const Value.absent(),
                Value<int> growthProgress = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlantsTableCompanion(
                id: id,
                islandId: islandId,
                plotIndex: plotIndex,
                kind: kind,
                plantedOnDayIndex: plantedOnDayIndex,
                currentStage: currentStage,
                growthProgress: growthProgress,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String islandId,
                required int plotIndex,
                required String kind,
                required int plantedOnDayIndex,
                Value<int> currentStage = const Value.absent(),
                Value<int> growthProgress = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlantsTableCompanion.insert(
                id: id,
                islandId: islandId,
                plotIndex: plotIndex,
                kind: kind,
                plantedOnDayIndex: plantedOnDayIndex,
                currentStage: currentStage,
                growthProgress: growthProgress,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlantsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlantsTableTable,
      PlantRow,
      $$PlantsTableTableFilterComposer,
      $$PlantsTableTableOrderingComposer,
      $$PlantsTableTableAnnotationComposer,
      $$PlantsTableTableCreateCompanionBuilder,
      $$PlantsTableTableUpdateCompanionBuilder,
      (PlantRow, BaseReferences<_$AppDatabase, $PlantsTableTable, PlantRow>),
      PlantRow,
      PrefetchHooks Function()
    >;
typedef $$EtfHoldingsTableTableCreateCompanionBuilder =
    EtfHoldingsTableCompanion Function({
      required String etfId,
      required int shares,
      required int averageBuyPriceCents,
      Value<int> rowid,
    });
typedef $$EtfHoldingsTableTableUpdateCompanionBuilder =
    EtfHoldingsTableCompanion Function({
      Value<String> etfId,
      Value<int> shares,
      Value<int> averageBuyPriceCents,
      Value<int> rowid,
    });

class $$EtfHoldingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $EtfHoldingsTableTable> {
  $$EtfHoldingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get etfId => $composableBuilder(
    column: $table.etfId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EtfHoldingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EtfHoldingsTableTable> {
  $$EtfHoldingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get etfId => $composableBuilder(
    column: $table.etfId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EtfHoldingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EtfHoldingsTableTable> {
  $$EtfHoldingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get etfId =>
      $composableBuilder(column: $table.etfId, builder: (column) => column);

  GeneratedColumn<int> get shares =>
      $composableBuilder(column: $table.shares, builder: (column) => column);

  GeneratedColumn<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => column,
  );
}

class $$EtfHoldingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EtfHoldingsTableTable,
          EtfHoldingRow,
          $$EtfHoldingsTableTableFilterComposer,
          $$EtfHoldingsTableTableOrderingComposer,
          $$EtfHoldingsTableTableAnnotationComposer,
          $$EtfHoldingsTableTableCreateCompanionBuilder,
          $$EtfHoldingsTableTableUpdateCompanionBuilder,
          (
            EtfHoldingRow,
            BaseReferences<
              _$AppDatabase,
              $EtfHoldingsTableTable,
              EtfHoldingRow
            >,
          ),
          EtfHoldingRow,
          PrefetchHooks Function()
        > {
  $$EtfHoldingsTableTableTableManager(
    _$AppDatabase db,
    $EtfHoldingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EtfHoldingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EtfHoldingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EtfHoldingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> etfId = const Value.absent(),
                Value<int> shares = const Value.absent(),
                Value<int> averageBuyPriceCents = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EtfHoldingsTableCompanion(
                etfId: etfId,
                shares: shares,
                averageBuyPriceCents: averageBuyPriceCents,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String etfId,
                required int shares,
                required int averageBuyPriceCents,
                Value<int> rowid = const Value.absent(),
              }) => EtfHoldingsTableCompanion.insert(
                etfId: etfId,
                shares: shares,
                averageBuyPriceCents: averageBuyPriceCents,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EtfHoldingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EtfHoldingsTableTable,
      EtfHoldingRow,
      $$EtfHoldingsTableTableFilterComposer,
      $$EtfHoldingsTableTableOrderingComposer,
      $$EtfHoldingsTableTableAnnotationComposer,
      $$EtfHoldingsTableTableCreateCompanionBuilder,
      $$EtfHoldingsTableTableUpdateCompanionBuilder,
      (
        EtfHoldingRow,
        BaseReferences<_$AppDatabase, $EtfHoldingsTableTable, EtfHoldingRow>,
      ),
      EtfHoldingRow,
      PrefetchHooks Function()
    >;
typedef $$EtfQuotesTableTableCreateCompanionBuilder =
    EtfQuotesTableCompanion Function({
      required String etfId,
      required int pricePerShareCents,
      required int onDayIndex,
      Value<int> rowid,
    });
typedef $$EtfQuotesTableTableUpdateCompanionBuilder =
    EtfQuotesTableCompanion Function({
      Value<String> etfId,
      Value<int> pricePerShareCents,
      Value<int> onDayIndex,
      Value<int> rowid,
    });

class $$EtfQuotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $EtfQuotesTableTable> {
  $$EtfQuotesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get etfId => $composableBuilder(
    column: $table.etfId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EtfQuotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EtfQuotesTableTable> {
  $$EtfQuotesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get etfId => $composableBuilder(
    column: $table.etfId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EtfQuotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EtfQuotesTableTable> {
  $$EtfQuotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get etfId =>
      $composableBuilder(column: $table.etfId, builder: (column) => column);

  GeneratedColumn<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => column,
  );
}

class $$EtfQuotesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EtfQuotesTableTable,
          EtfQuoteRow,
          $$EtfQuotesTableTableFilterComposer,
          $$EtfQuotesTableTableOrderingComposer,
          $$EtfQuotesTableTableAnnotationComposer,
          $$EtfQuotesTableTableCreateCompanionBuilder,
          $$EtfQuotesTableTableUpdateCompanionBuilder,
          (
            EtfQuoteRow,
            BaseReferences<_$AppDatabase, $EtfQuotesTableTable, EtfQuoteRow>,
          ),
          EtfQuoteRow,
          PrefetchHooks Function()
        > {
  $$EtfQuotesTableTableTableManager(
    _$AppDatabase db,
    $EtfQuotesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EtfQuotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EtfQuotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EtfQuotesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> etfId = const Value.absent(),
                Value<int> pricePerShareCents = const Value.absent(),
                Value<int> onDayIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EtfQuotesTableCompanion(
                etfId: etfId,
                pricePerShareCents: pricePerShareCents,
                onDayIndex: onDayIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String etfId,
                required int pricePerShareCents,
                required int onDayIndex,
                Value<int> rowid = const Value.absent(),
              }) => EtfQuotesTableCompanion.insert(
                etfId: etfId,
                pricePerShareCents: pricePerShareCents,
                onDayIndex: onDayIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EtfQuotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EtfQuotesTableTable,
      EtfQuoteRow,
      $$EtfQuotesTableTableFilterComposer,
      $$EtfQuotesTableTableOrderingComposer,
      $$EtfQuotesTableTableAnnotationComposer,
      $$EtfQuotesTableTableCreateCompanionBuilder,
      $$EtfQuotesTableTableUpdateCompanionBuilder,
      (
        EtfQuoteRow,
        BaseReferences<_$AppDatabase, $EtfQuotesTableTable, EtfQuoteRow>,
      ),
      EtfQuoteRow,
      PrefetchHooks Function()
    >;
typedef $$StockHoldingsTableTableCreateCompanionBuilder =
    StockHoldingsTableCompanion Function({
      required String stockId,
      required int shares,
      required int averageBuyPriceCents,
      Value<int> rowid,
    });
typedef $$StockHoldingsTableTableUpdateCompanionBuilder =
    StockHoldingsTableCompanion Function({
      Value<String> stockId,
      Value<int> shares,
      Value<int> averageBuyPriceCents,
      Value<int> rowid,
    });

class $$StockHoldingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $StockHoldingsTableTable> {
  $$StockHoldingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get stockId => $composableBuilder(
    column: $table.stockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StockHoldingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StockHoldingsTableTable> {
  $$StockHoldingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get stockId => $composableBuilder(
    column: $table.stockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StockHoldingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockHoldingsTableTable> {
  $$StockHoldingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get stockId =>
      $composableBuilder(column: $table.stockId, builder: (column) => column);

  GeneratedColumn<int> get shares =>
      $composableBuilder(column: $table.shares, builder: (column) => column);

  GeneratedColumn<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => column,
  );
}

class $$StockHoldingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockHoldingsTableTable,
          StockHoldingRow,
          $$StockHoldingsTableTableFilterComposer,
          $$StockHoldingsTableTableOrderingComposer,
          $$StockHoldingsTableTableAnnotationComposer,
          $$StockHoldingsTableTableCreateCompanionBuilder,
          $$StockHoldingsTableTableUpdateCompanionBuilder,
          (
            StockHoldingRow,
            BaseReferences<
              _$AppDatabase,
              $StockHoldingsTableTable,
              StockHoldingRow
            >,
          ),
          StockHoldingRow,
          PrefetchHooks Function()
        > {
  $$StockHoldingsTableTableTableManager(
    _$AppDatabase db,
    $StockHoldingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockHoldingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockHoldingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockHoldingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> stockId = const Value.absent(),
                Value<int> shares = const Value.absent(),
                Value<int> averageBuyPriceCents = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockHoldingsTableCompanion(
                stockId: stockId,
                shares: shares,
                averageBuyPriceCents: averageBuyPriceCents,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String stockId,
                required int shares,
                required int averageBuyPriceCents,
                Value<int> rowid = const Value.absent(),
              }) => StockHoldingsTableCompanion.insert(
                stockId: stockId,
                shares: shares,
                averageBuyPriceCents: averageBuyPriceCents,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StockHoldingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockHoldingsTableTable,
      StockHoldingRow,
      $$StockHoldingsTableTableFilterComposer,
      $$StockHoldingsTableTableOrderingComposer,
      $$StockHoldingsTableTableAnnotationComposer,
      $$StockHoldingsTableTableCreateCompanionBuilder,
      $$StockHoldingsTableTableUpdateCompanionBuilder,
      (
        StockHoldingRow,
        BaseReferences<
          _$AppDatabase,
          $StockHoldingsTableTable,
          StockHoldingRow
        >,
      ),
      StockHoldingRow,
      PrefetchHooks Function()
    >;
typedef $$StockQuotesTableTableCreateCompanionBuilder =
    StockQuotesTableCompanion Function({
      required String stockId,
      required int pricePerShareCents,
      required int onDayIndex,
      Value<int> rowid,
    });
typedef $$StockQuotesTableTableUpdateCompanionBuilder =
    StockQuotesTableCompanion Function({
      Value<String> stockId,
      Value<int> pricePerShareCents,
      Value<int> onDayIndex,
      Value<int> rowid,
    });

class $$StockQuotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $StockQuotesTableTable> {
  $$StockQuotesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get stockId => $composableBuilder(
    column: $table.stockId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StockQuotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StockQuotesTableTable> {
  $$StockQuotesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get stockId => $composableBuilder(
    column: $table.stockId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StockQuotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockQuotesTableTable> {
  $$StockQuotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get stockId =>
      $composableBuilder(column: $table.stockId, builder: (column) => column);

  GeneratedColumn<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => column,
  );
}

class $$StockQuotesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockQuotesTableTable,
          StockQuoteRow,
          $$StockQuotesTableTableFilterComposer,
          $$StockQuotesTableTableOrderingComposer,
          $$StockQuotesTableTableAnnotationComposer,
          $$StockQuotesTableTableCreateCompanionBuilder,
          $$StockQuotesTableTableUpdateCompanionBuilder,
          (
            StockQuoteRow,
            BaseReferences<
              _$AppDatabase,
              $StockQuotesTableTable,
              StockQuoteRow
            >,
          ),
          StockQuoteRow,
          PrefetchHooks Function()
        > {
  $$StockQuotesTableTableTableManager(
    _$AppDatabase db,
    $StockQuotesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockQuotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockQuotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockQuotesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> stockId = const Value.absent(),
                Value<int> pricePerShareCents = const Value.absent(),
                Value<int> onDayIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockQuotesTableCompanion(
                stockId: stockId,
                pricePerShareCents: pricePerShareCents,
                onDayIndex: onDayIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String stockId,
                required int pricePerShareCents,
                required int onDayIndex,
                Value<int> rowid = const Value.absent(),
              }) => StockQuotesTableCompanion.insert(
                stockId: stockId,
                pricePerShareCents: pricePerShareCents,
                onDayIndex: onDayIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StockQuotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockQuotesTableTable,
      StockQuoteRow,
      $$StockQuotesTableTableFilterComposer,
      $$StockQuotesTableTableOrderingComposer,
      $$StockQuotesTableTableAnnotationComposer,
      $$StockQuotesTableTableCreateCompanionBuilder,
      $$StockQuotesTableTableUpdateCompanionBuilder,
      (
        StockQuoteRow,
        BaseReferences<_$AppDatabase, $StockQuotesTableTable, StockQuoteRow>,
      ),
      StockQuoteRow,
      PrefetchHooks Function()
    >;
typedef $$CryptoHoldingsTableTableCreateCompanionBuilder =
    CryptoHoldingsTableCompanion Function({
      required String assetId,
      required int shares,
      required int averageBuyPriceCents,
      Value<int> rowid,
    });
typedef $$CryptoHoldingsTableTableUpdateCompanionBuilder =
    CryptoHoldingsTableCompanion Function({
      Value<String> assetId,
      Value<int> shares,
      Value<int> averageBuyPriceCents,
      Value<int> rowid,
    });

class $$CryptoHoldingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CryptoHoldingsTableTable> {
  $$CryptoHoldingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CryptoHoldingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CryptoHoldingsTableTable> {
  $$CryptoHoldingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CryptoHoldingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CryptoHoldingsTableTable> {
  $$CryptoHoldingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<int> get shares =>
      $composableBuilder(column: $table.shares, builder: (column) => column);

  GeneratedColumn<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => column,
  );
}

class $$CryptoHoldingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CryptoHoldingsTableTable,
          CryptoHoldingRow,
          $$CryptoHoldingsTableTableFilterComposer,
          $$CryptoHoldingsTableTableOrderingComposer,
          $$CryptoHoldingsTableTableAnnotationComposer,
          $$CryptoHoldingsTableTableCreateCompanionBuilder,
          $$CryptoHoldingsTableTableUpdateCompanionBuilder,
          (
            CryptoHoldingRow,
            BaseReferences<
              _$AppDatabase,
              $CryptoHoldingsTableTable,
              CryptoHoldingRow
            >,
          ),
          CryptoHoldingRow,
          PrefetchHooks Function()
        > {
  $$CryptoHoldingsTableTableTableManager(
    _$AppDatabase db,
    $CryptoHoldingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CryptoHoldingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CryptoHoldingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CryptoHoldingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> assetId = const Value.absent(),
                Value<int> shares = const Value.absent(),
                Value<int> averageBuyPriceCents = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CryptoHoldingsTableCompanion(
                assetId: assetId,
                shares: shares,
                averageBuyPriceCents: averageBuyPriceCents,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String assetId,
                required int shares,
                required int averageBuyPriceCents,
                Value<int> rowid = const Value.absent(),
              }) => CryptoHoldingsTableCompanion.insert(
                assetId: assetId,
                shares: shares,
                averageBuyPriceCents: averageBuyPriceCents,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CryptoHoldingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CryptoHoldingsTableTable,
      CryptoHoldingRow,
      $$CryptoHoldingsTableTableFilterComposer,
      $$CryptoHoldingsTableTableOrderingComposer,
      $$CryptoHoldingsTableTableAnnotationComposer,
      $$CryptoHoldingsTableTableCreateCompanionBuilder,
      $$CryptoHoldingsTableTableUpdateCompanionBuilder,
      (
        CryptoHoldingRow,
        BaseReferences<
          _$AppDatabase,
          $CryptoHoldingsTableTable,
          CryptoHoldingRow
        >,
      ),
      CryptoHoldingRow,
      PrefetchHooks Function()
    >;
typedef $$CryptoQuotesTableTableCreateCompanionBuilder =
    CryptoQuotesTableCompanion Function({
      required String assetId,
      required int pricePerShareCents,
      required int onDayIndex,
      Value<int> rowid,
    });
typedef $$CryptoQuotesTableTableUpdateCompanionBuilder =
    CryptoQuotesTableCompanion Function({
      Value<String> assetId,
      Value<int> pricePerShareCents,
      Value<int> onDayIndex,
      Value<int> rowid,
    });

class $$CryptoQuotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CryptoQuotesTableTable> {
  $$CryptoQuotesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CryptoQuotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CryptoQuotesTableTable> {
  $$CryptoQuotesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CryptoQuotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CryptoQuotesTableTable> {
  $$CryptoQuotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => column,
  );
}

class $$CryptoQuotesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CryptoQuotesTableTable,
          CryptoQuoteRow,
          $$CryptoQuotesTableTableFilterComposer,
          $$CryptoQuotesTableTableOrderingComposer,
          $$CryptoQuotesTableTableAnnotationComposer,
          $$CryptoQuotesTableTableCreateCompanionBuilder,
          $$CryptoQuotesTableTableUpdateCompanionBuilder,
          (
            CryptoQuoteRow,
            BaseReferences<
              _$AppDatabase,
              $CryptoQuotesTableTable,
              CryptoQuoteRow
            >,
          ),
          CryptoQuoteRow,
          PrefetchHooks Function()
        > {
  $$CryptoQuotesTableTableTableManager(
    _$AppDatabase db,
    $CryptoQuotesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CryptoQuotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CryptoQuotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CryptoQuotesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> assetId = const Value.absent(),
                Value<int> pricePerShareCents = const Value.absent(),
                Value<int> onDayIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CryptoQuotesTableCompanion(
                assetId: assetId,
                pricePerShareCents: pricePerShareCents,
                onDayIndex: onDayIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String assetId,
                required int pricePerShareCents,
                required int onDayIndex,
                Value<int> rowid = const Value.absent(),
              }) => CryptoQuotesTableCompanion.insert(
                assetId: assetId,
                pricePerShareCents: pricePerShareCents,
                onDayIndex: onDayIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CryptoQuotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CryptoQuotesTableTable,
      CryptoQuoteRow,
      $$CryptoQuotesTableTableFilterComposer,
      $$CryptoQuotesTableTableOrderingComposer,
      $$CryptoQuotesTableTableAnnotationComposer,
      $$CryptoQuotesTableTableCreateCompanionBuilder,
      $$CryptoQuotesTableTableUpdateCompanionBuilder,
      (
        CryptoQuoteRow,
        BaseReferences<_$AppDatabase, $CryptoQuotesTableTable, CryptoQuoteRow>,
      ),
      CryptoQuoteRow,
      PrefetchHooks Function()
    >;
typedef $$MetalHoldingsTableTableCreateCompanionBuilder =
    MetalHoldingsTableCompanion Function({
      required String assetId,
      required int shares,
      required int averageBuyPriceCents,
      Value<int> rowid,
    });
typedef $$MetalHoldingsTableTableUpdateCompanionBuilder =
    MetalHoldingsTableCompanion Function({
      Value<String> assetId,
      Value<int> shares,
      Value<int> averageBuyPriceCents,
      Value<int> rowid,
    });

class $$MetalHoldingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MetalHoldingsTableTable> {
  $$MetalHoldingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetalHoldingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MetalHoldingsTableTable> {
  $$MetalHoldingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shares => $composableBuilder(
    column: $table.shares,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetalHoldingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetalHoldingsTableTable> {
  $$MetalHoldingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<int> get shares =>
      $composableBuilder(column: $table.shares, builder: (column) => column);

  GeneratedColumn<int> get averageBuyPriceCents => $composableBuilder(
    column: $table.averageBuyPriceCents,
    builder: (column) => column,
  );
}

class $$MetalHoldingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetalHoldingsTableTable,
          MetalHoldingRow,
          $$MetalHoldingsTableTableFilterComposer,
          $$MetalHoldingsTableTableOrderingComposer,
          $$MetalHoldingsTableTableAnnotationComposer,
          $$MetalHoldingsTableTableCreateCompanionBuilder,
          $$MetalHoldingsTableTableUpdateCompanionBuilder,
          (
            MetalHoldingRow,
            BaseReferences<
              _$AppDatabase,
              $MetalHoldingsTableTable,
              MetalHoldingRow
            >,
          ),
          MetalHoldingRow,
          PrefetchHooks Function()
        > {
  $$MetalHoldingsTableTableTableManager(
    _$AppDatabase db,
    $MetalHoldingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetalHoldingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetalHoldingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetalHoldingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> assetId = const Value.absent(),
                Value<int> shares = const Value.absent(),
                Value<int> averageBuyPriceCents = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetalHoldingsTableCompanion(
                assetId: assetId,
                shares: shares,
                averageBuyPriceCents: averageBuyPriceCents,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String assetId,
                required int shares,
                required int averageBuyPriceCents,
                Value<int> rowid = const Value.absent(),
              }) => MetalHoldingsTableCompanion.insert(
                assetId: assetId,
                shares: shares,
                averageBuyPriceCents: averageBuyPriceCents,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetalHoldingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetalHoldingsTableTable,
      MetalHoldingRow,
      $$MetalHoldingsTableTableFilterComposer,
      $$MetalHoldingsTableTableOrderingComposer,
      $$MetalHoldingsTableTableAnnotationComposer,
      $$MetalHoldingsTableTableCreateCompanionBuilder,
      $$MetalHoldingsTableTableUpdateCompanionBuilder,
      (
        MetalHoldingRow,
        BaseReferences<
          _$AppDatabase,
          $MetalHoldingsTableTable,
          MetalHoldingRow
        >,
      ),
      MetalHoldingRow,
      PrefetchHooks Function()
    >;
typedef $$MetalQuotesTableTableCreateCompanionBuilder =
    MetalQuotesTableCompanion Function({
      required String assetId,
      required int pricePerShareCents,
      required int onDayIndex,
      Value<int> rowid,
    });
typedef $$MetalQuotesTableTableUpdateCompanionBuilder =
    MetalQuotesTableCompanion Function({
      Value<String> assetId,
      Value<int> pricePerShareCents,
      Value<int> onDayIndex,
      Value<int> rowid,
    });

class $$MetalQuotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MetalQuotesTableTable> {
  $$MetalQuotesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetalQuotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MetalQuotesTableTable> {
  $$MetalQuotesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetalQuotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetalQuotesTableTable> {
  $$MetalQuotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<int> get pricePerShareCents => $composableBuilder(
    column: $table.pricePerShareCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get onDayIndex => $composableBuilder(
    column: $table.onDayIndex,
    builder: (column) => column,
  );
}

class $$MetalQuotesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetalQuotesTableTable,
          MetalQuoteRow,
          $$MetalQuotesTableTableFilterComposer,
          $$MetalQuotesTableTableOrderingComposer,
          $$MetalQuotesTableTableAnnotationComposer,
          $$MetalQuotesTableTableCreateCompanionBuilder,
          $$MetalQuotesTableTableUpdateCompanionBuilder,
          (
            MetalQuoteRow,
            BaseReferences<
              _$AppDatabase,
              $MetalQuotesTableTable,
              MetalQuoteRow
            >,
          ),
          MetalQuoteRow,
          PrefetchHooks Function()
        > {
  $$MetalQuotesTableTableTableManager(
    _$AppDatabase db,
    $MetalQuotesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetalQuotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetalQuotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetalQuotesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> assetId = const Value.absent(),
                Value<int> pricePerShareCents = const Value.absent(),
                Value<int> onDayIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetalQuotesTableCompanion(
                assetId: assetId,
                pricePerShareCents: pricePerShareCents,
                onDayIndex: onDayIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String assetId,
                required int pricePerShareCents,
                required int onDayIndex,
                Value<int> rowid = const Value.absent(),
              }) => MetalQuotesTableCompanion.insert(
                assetId: assetId,
                pricePerShareCents: pricePerShareCents,
                onDayIndex: onDayIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetalQuotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetalQuotesTableTable,
      MetalQuoteRow,
      $$MetalQuotesTableTableFilterComposer,
      $$MetalQuotesTableTableOrderingComposer,
      $$MetalQuotesTableTableAnnotationComposer,
      $$MetalQuotesTableTableCreateCompanionBuilder,
      $$MetalQuotesTableTableUpdateCompanionBuilder,
      (
        MetalQuoteRow,
        BaseReferences<_$AppDatabase, $MetalQuotesTableTable, MetalQuoteRow>,
      ),
      MetalQuoteRow,
      PrefetchHooks Function()
    >;
typedef $$RealEstateHoldingsTableTableCreateCompanionBuilder =
    RealEstateHoldingsTableCompanion Function({
      required String specId,
      required int ownedSinceDayIndex,
      required int purchasePriceCents,
      Value<String> usage,
      Value<int> rowid,
    });
typedef $$RealEstateHoldingsTableTableUpdateCompanionBuilder =
    RealEstateHoldingsTableCompanion Function({
      Value<String> specId,
      Value<int> ownedSinceDayIndex,
      Value<int> purchasePriceCents,
      Value<String> usage,
      Value<int> rowid,
    });

class $$RealEstateHoldingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RealEstateHoldingsTableTable> {
  $$RealEstateHoldingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get specId => $composableBuilder(
    column: $table.specId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ownedSinceDayIndex => $composableBuilder(
    column: $table.ownedSinceDayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchasePriceCents => $composableBuilder(
    column: $table.purchasePriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usage => $composableBuilder(
    column: $table.usage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RealEstateHoldingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RealEstateHoldingsTableTable> {
  $$RealEstateHoldingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get specId => $composableBuilder(
    column: $table.specId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownedSinceDayIndex => $composableBuilder(
    column: $table.ownedSinceDayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchasePriceCents => $composableBuilder(
    column: $table.purchasePriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usage => $composableBuilder(
    column: $table.usage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RealEstateHoldingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RealEstateHoldingsTableTable> {
  $$RealEstateHoldingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get specId =>
      $composableBuilder(column: $table.specId, builder: (column) => column);

  GeneratedColumn<int> get ownedSinceDayIndex => $composableBuilder(
    column: $table.ownedSinceDayIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get purchasePriceCents => $composableBuilder(
    column: $table.purchasePriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get usage =>
      $composableBuilder(column: $table.usage, builder: (column) => column);
}

class $$RealEstateHoldingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RealEstateHoldingsTableTable,
          RealEstateHoldingRow,
          $$RealEstateHoldingsTableTableFilterComposer,
          $$RealEstateHoldingsTableTableOrderingComposer,
          $$RealEstateHoldingsTableTableAnnotationComposer,
          $$RealEstateHoldingsTableTableCreateCompanionBuilder,
          $$RealEstateHoldingsTableTableUpdateCompanionBuilder,
          (
            RealEstateHoldingRow,
            BaseReferences<
              _$AppDatabase,
              $RealEstateHoldingsTableTable,
              RealEstateHoldingRow
            >,
          ),
          RealEstateHoldingRow,
          PrefetchHooks Function()
        > {
  $$RealEstateHoldingsTableTableTableManager(
    _$AppDatabase db,
    $RealEstateHoldingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RealEstateHoldingsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RealEstateHoldingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RealEstateHoldingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> specId = const Value.absent(),
                Value<int> ownedSinceDayIndex = const Value.absent(),
                Value<int> purchasePriceCents = const Value.absent(),
                Value<String> usage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RealEstateHoldingsTableCompanion(
                specId: specId,
                ownedSinceDayIndex: ownedSinceDayIndex,
                purchasePriceCents: purchasePriceCents,
                usage: usage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String specId,
                required int ownedSinceDayIndex,
                required int purchasePriceCents,
                Value<String> usage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RealEstateHoldingsTableCompanion.insert(
                specId: specId,
                ownedSinceDayIndex: ownedSinceDayIndex,
                purchasePriceCents: purchasePriceCents,
                usage: usage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RealEstateHoldingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RealEstateHoldingsTableTable,
      RealEstateHoldingRow,
      $$RealEstateHoldingsTableTableFilterComposer,
      $$RealEstateHoldingsTableTableOrderingComposer,
      $$RealEstateHoldingsTableTableAnnotationComposer,
      $$RealEstateHoldingsTableTableCreateCompanionBuilder,
      $$RealEstateHoldingsTableTableUpdateCompanionBuilder,
      (
        RealEstateHoldingRow,
        BaseReferences<
          _$AppDatabase,
          $RealEstateHoldingsTableTable,
          RealEstateHoldingRow
        >,
      ),
      RealEstateHoldingRow,
      PrefetchHooks Function()
    >;
typedef $$CollectibleHoldingsTableTableCreateCompanionBuilder =
    CollectibleHoldingsTableCompanion Function({
      Value<int> rowId,
      required String specId,
      required int boughtAtDayIndex,
      required int boughtPriceCents,
    });
typedef $$CollectibleHoldingsTableTableUpdateCompanionBuilder =
    CollectibleHoldingsTableCompanion Function({
      Value<int> rowId,
      Value<String> specId,
      Value<int> boughtAtDayIndex,
      Value<int> boughtPriceCents,
    });

class $$CollectibleHoldingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CollectibleHoldingsTableTable> {
  $$CollectibleHoldingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specId => $composableBuilder(
    column: $table.specId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get boughtAtDayIndex => $composableBuilder(
    column: $table.boughtAtDayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get boughtPriceCents => $composableBuilder(
    column: $table.boughtPriceCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CollectibleHoldingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectibleHoldingsTableTable> {
  $$CollectibleHoldingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specId => $composableBuilder(
    column: $table.specId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get boughtAtDayIndex => $composableBuilder(
    column: $table.boughtAtDayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get boughtPriceCents => $composableBuilder(
    column: $table.boughtPriceCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollectibleHoldingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectibleHoldingsTableTable> {
  $$CollectibleHoldingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get specId =>
      $composableBuilder(column: $table.specId, builder: (column) => column);

  GeneratedColumn<int> get boughtAtDayIndex => $composableBuilder(
    column: $table.boughtAtDayIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get boughtPriceCents => $composableBuilder(
    column: $table.boughtPriceCents,
    builder: (column) => column,
  );
}

class $$CollectibleHoldingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectibleHoldingsTableTable,
          CollectibleHoldingRow,
          $$CollectibleHoldingsTableTableFilterComposer,
          $$CollectibleHoldingsTableTableOrderingComposer,
          $$CollectibleHoldingsTableTableAnnotationComposer,
          $$CollectibleHoldingsTableTableCreateCompanionBuilder,
          $$CollectibleHoldingsTableTableUpdateCompanionBuilder,
          (
            CollectibleHoldingRow,
            BaseReferences<
              _$AppDatabase,
              $CollectibleHoldingsTableTable,
              CollectibleHoldingRow
            >,
          ),
          CollectibleHoldingRow,
          PrefetchHooks Function()
        > {
  $$CollectibleHoldingsTableTableTableManager(
    _$AppDatabase db,
    $CollectibleHoldingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectibleHoldingsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CollectibleHoldingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CollectibleHoldingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> specId = const Value.absent(),
                Value<int> boughtAtDayIndex = const Value.absent(),
                Value<int> boughtPriceCents = const Value.absent(),
              }) => CollectibleHoldingsTableCompanion(
                rowId: rowId,
                specId: specId,
                boughtAtDayIndex: boughtAtDayIndex,
                boughtPriceCents: boughtPriceCents,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String specId,
                required int boughtAtDayIndex,
                required int boughtPriceCents,
              }) => CollectibleHoldingsTableCompanion.insert(
                rowId: rowId,
                specId: specId,
                boughtAtDayIndex: boughtAtDayIndex,
                boughtPriceCents: boughtPriceCents,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CollectibleHoldingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectibleHoldingsTableTable,
      CollectibleHoldingRow,
      $$CollectibleHoldingsTableTableFilterComposer,
      $$CollectibleHoldingsTableTableOrderingComposer,
      $$CollectibleHoldingsTableTableAnnotationComposer,
      $$CollectibleHoldingsTableTableCreateCompanionBuilder,
      $$CollectibleHoldingsTableTableUpdateCompanionBuilder,
      (
        CollectibleHoldingRow,
        BaseReferences<
          _$AppDatabase,
          $CollectibleHoldingsTableTable,
          CollectibleHoldingRow
        >,
      ),
      CollectibleHoldingRow,
      PrefetchHooks Function()
    >;
typedef $$IslandDecorTableTableCreateCompanionBuilder =
    IslandDecorTableCompanion Function({
      Value<int> rowId,
      required String islandId,
      required String decorId,
      required double x,
      required double y,
      Value<int> rotation,
    });
typedef $$IslandDecorTableTableUpdateCompanionBuilder =
    IslandDecorTableCompanion Function({
      Value<int> rowId,
      Value<String> islandId,
      Value<String> decorId,
      Value<double> x,
      Value<double> y,
      Value<int> rotation,
    });

class $$IslandDecorTableTableFilterComposer
    extends Composer<_$AppDatabase, $IslandDecorTableTable> {
  $$IslandDecorTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get islandId => $composableBuilder(
    column: $table.islandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decorId => $composableBuilder(
    column: $table.decorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IslandDecorTableTableOrderingComposer
    extends Composer<_$AppDatabase, $IslandDecorTableTable> {
  $$IslandDecorTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get islandId => $composableBuilder(
    column: $table.islandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decorId => $composableBuilder(
    column: $table.decorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IslandDecorTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $IslandDecorTableTable> {
  $$IslandDecorTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get islandId =>
      $composableBuilder(column: $table.islandId, builder: (column) => column);

  GeneratedColumn<String> get decorId =>
      $composableBuilder(column: $table.decorId, builder: (column) => column);

  GeneratedColumn<double> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<int> get rotation =>
      $composableBuilder(column: $table.rotation, builder: (column) => column);
}

class $$IslandDecorTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IslandDecorTableTable,
          IslandDecorRow,
          $$IslandDecorTableTableFilterComposer,
          $$IslandDecorTableTableOrderingComposer,
          $$IslandDecorTableTableAnnotationComposer,
          $$IslandDecorTableTableCreateCompanionBuilder,
          $$IslandDecorTableTableUpdateCompanionBuilder,
          (
            IslandDecorRow,
            BaseReferences<
              _$AppDatabase,
              $IslandDecorTableTable,
              IslandDecorRow
            >,
          ),
          IslandDecorRow,
          PrefetchHooks Function()
        > {
  $$IslandDecorTableTableTableManager(
    _$AppDatabase db,
    $IslandDecorTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IslandDecorTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IslandDecorTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IslandDecorTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> islandId = const Value.absent(),
                Value<String> decorId = const Value.absent(),
                Value<double> x = const Value.absent(),
                Value<double> y = const Value.absent(),
                Value<int> rotation = const Value.absent(),
              }) => IslandDecorTableCompanion(
                rowId: rowId,
                islandId: islandId,
                decorId: decorId,
                x: x,
                y: y,
                rotation: rotation,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String islandId,
                required String decorId,
                required double x,
                required double y,
                Value<int> rotation = const Value.absent(),
              }) => IslandDecorTableCompanion.insert(
                rowId: rowId,
                islandId: islandId,
                decorId: decorId,
                x: x,
                y: y,
                rotation: rotation,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IslandDecorTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IslandDecorTableTable,
      IslandDecorRow,
      $$IslandDecorTableTableFilterComposer,
      $$IslandDecorTableTableOrderingComposer,
      $$IslandDecorTableTableAnnotationComposer,
      $$IslandDecorTableTableCreateCompanionBuilder,
      $$IslandDecorTableTableUpdateCompanionBuilder,
      (
        IslandDecorRow,
        BaseReferences<_$AppDatabase, $IslandDecorTableTable, IslandDecorRow>,
      ),
      IslandDecorRow,
      PrefetchHooks Function()
    >;
typedef $$QuestPassivePaymentsTableTableCreateCompanionBuilder =
    QuestPassivePaymentsTableCompanion Function({
      Value<int> rowId,
      required String questId,
      required int monthsRemaining,
      required int monthlyCents,
      required int lastPaidDayIndex,
    });
typedef $$QuestPassivePaymentsTableTableUpdateCompanionBuilder =
    QuestPassivePaymentsTableCompanion Function({
      Value<int> rowId,
      Value<String> questId,
      Value<int> monthsRemaining,
      Value<int> monthlyCents,
      Value<int> lastPaidDayIndex,
    });

class $$QuestPassivePaymentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuestPassivePaymentsTableTable> {
  $$QuestPassivePaymentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthsRemaining => $composableBuilder(
    column: $table.monthsRemaining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyCents => $composableBuilder(
    column: $table.monthlyCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPaidDayIndex => $composableBuilder(
    column: $table.lastPaidDayIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestPassivePaymentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestPassivePaymentsTableTable> {
  $$QuestPassivePaymentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthsRemaining => $composableBuilder(
    column: $table.monthsRemaining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyCents => $composableBuilder(
    column: $table.monthlyCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPaidDayIndex => $composableBuilder(
    column: $table.lastPaidDayIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestPassivePaymentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestPassivePaymentsTableTable> {
  $$QuestPassivePaymentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get questId =>
      $composableBuilder(column: $table.questId, builder: (column) => column);

  GeneratedColumn<int> get monthsRemaining => $composableBuilder(
    column: $table.monthsRemaining,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyCents => $composableBuilder(
    column: $table.monthlyCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastPaidDayIndex => $composableBuilder(
    column: $table.lastPaidDayIndex,
    builder: (column) => column,
  );
}

class $$QuestPassivePaymentsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestPassivePaymentsTableTable,
          QuestPassiveRow,
          $$QuestPassivePaymentsTableTableFilterComposer,
          $$QuestPassivePaymentsTableTableOrderingComposer,
          $$QuestPassivePaymentsTableTableAnnotationComposer,
          $$QuestPassivePaymentsTableTableCreateCompanionBuilder,
          $$QuestPassivePaymentsTableTableUpdateCompanionBuilder,
          (
            QuestPassiveRow,
            BaseReferences<
              _$AppDatabase,
              $QuestPassivePaymentsTableTable,
              QuestPassiveRow
            >,
          ),
          QuestPassiveRow,
          PrefetchHooks Function()
        > {
  $$QuestPassivePaymentsTableTableTableManager(
    _$AppDatabase db,
    $QuestPassivePaymentsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestPassivePaymentsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$QuestPassivePaymentsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$QuestPassivePaymentsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> questId = const Value.absent(),
                Value<int> monthsRemaining = const Value.absent(),
                Value<int> monthlyCents = const Value.absent(),
                Value<int> lastPaidDayIndex = const Value.absent(),
              }) => QuestPassivePaymentsTableCompanion(
                rowId: rowId,
                questId: questId,
                monthsRemaining: monthsRemaining,
                monthlyCents: monthlyCents,
                lastPaidDayIndex: lastPaidDayIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String questId,
                required int monthsRemaining,
                required int monthlyCents,
                required int lastPaidDayIndex,
              }) => QuestPassivePaymentsTableCompanion.insert(
                rowId: rowId,
                questId: questId,
                monthsRemaining: monthsRemaining,
                monthlyCents: monthlyCents,
                lastPaidDayIndex: lastPaidDayIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestPassivePaymentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestPassivePaymentsTableTable,
      QuestPassiveRow,
      $$QuestPassivePaymentsTableTableFilterComposer,
      $$QuestPassivePaymentsTableTableOrderingComposer,
      $$QuestPassivePaymentsTableTableAnnotationComposer,
      $$QuestPassivePaymentsTableTableCreateCompanionBuilder,
      $$QuestPassivePaymentsTableTableUpdateCompanionBuilder,
      (
        QuestPassiveRow,
        BaseReferences<
          _$AppDatabase,
          $QuestPassivePaymentsTableTable,
          QuestPassiveRow
        >,
      ),
      QuestPassiveRow,
      PrefetchHooks Function()
    >;
typedef $$VorsorgeContractsTableTableCreateCompanionBuilder =
    VorsorgeContractsTableCompanion Function({
      required String type,
      required int startedOnDayIndex,
      required int totalContributedCents,
      required int totalSubsidyCents,
      Value<int> rowid,
    });
typedef $$VorsorgeContractsTableTableUpdateCompanionBuilder =
    VorsorgeContractsTableCompanion Function({
      Value<String> type,
      Value<int> startedOnDayIndex,
      Value<int> totalContributedCents,
      Value<int> totalSubsidyCents,
      Value<int> rowid,
    });

class $$VorsorgeContractsTableTableFilterComposer
    extends Composer<_$AppDatabase, $VorsorgeContractsTableTable> {
  $$VorsorgeContractsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedOnDayIndex => $composableBuilder(
    column: $table.startedOnDayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalContributedCents => $composableBuilder(
    column: $table.totalContributedCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSubsidyCents => $composableBuilder(
    column: $table.totalSubsidyCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VorsorgeContractsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VorsorgeContractsTableTable> {
  $$VorsorgeContractsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedOnDayIndex => $composableBuilder(
    column: $table.startedOnDayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalContributedCents => $composableBuilder(
    column: $table.totalContributedCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSubsidyCents => $composableBuilder(
    column: $table.totalSubsidyCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VorsorgeContractsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VorsorgeContractsTableTable> {
  $$VorsorgeContractsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get startedOnDayIndex => $composableBuilder(
    column: $table.startedOnDayIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalContributedCents => $composableBuilder(
    column: $table.totalContributedCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalSubsidyCents => $composableBuilder(
    column: $table.totalSubsidyCents,
    builder: (column) => column,
  );
}

class $$VorsorgeContractsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VorsorgeContractsTableTable,
          VorsorgeContractRow,
          $$VorsorgeContractsTableTableFilterComposer,
          $$VorsorgeContractsTableTableOrderingComposer,
          $$VorsorgeContractsTableTableAnnotationComposer,
          $$VorsorgeContractsTableTableCreateCompanionBuilder,
          $$VorsorgeContractsTableTableUpdateCompanionBuilder,
          (
            VorsorgeContractRow,
            BaseReferences<
              _$AppDatabase,
              $VorsorgeContractsTableTable,
              VorsorgeContractRow
            >,
          ),
          VorsorgeContractRow,
          PrefetchHooks Function()
        > {
  $$VorsorgeContractsTableTableTableManager(
    _$AppDatabase db,
    $VorsorgeContractsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VorsorgeContractsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$VorsorgeContractsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$VorsorgeContractsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> type = const Value.absent(),
                Value<int> startedOnDayIndex = const Value.absent(),
                Value<int> totalContributedCents = const Value.absent(),
                Value<int> totalSubsidyCents = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VorsorgeContractsTableCompanion(
                type: type,
                startedOnDayIndex: startedOnDayIndex,
                totalContributedCents: totalContributedCents,
                totalSubsidyCents: totalSubsidyCents,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String type,
                required int startedOnDayIndex,
                required int totalContributedCents,
                required int totalSubsidyCents,
                Value<int> rowid = const Value.absent(),
              }) => VorsorgeContractsTableCompanion.insert(
                type: type,
                startedOnDayIndex: startedOnDayIndex,
                totalContributedCents: totalContributedCents,
                totalSubsidyCents: totalSubsidyCents,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VorsorgeContractsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VorsorgeContractsTableTable,
      VorsorgeContractRow,
      $$VorsorgeContractsTableTableFilterComposer,
      $$VorsorgeContractsTableTableOrderingComposer,
      $$VorsorgeContractsTableTableAnnotationComposer,
      $$VorsorgeContractsTableTableCreateCompanionBuilder,
      $$VorsorgeContractsTableTableUpdateCompanionBuilder,
      (
        VorsorgeContractRow,
        BaseReferences<
          _$AppDatabase,
          $VorsorgeContractsTableTable,
          VorsorgeContractRow
        >,
      ),
      VorsorgeContractRow,
      PrefetchHooks Function()
    >;
typedef $$SavingsPlansTableTableCreateCompanionBuilder =
    SavingsPlansTableCompanion Function({
      required String id,
      required String assetClass,
      required String assetId,
      required int monthlyCents,
      required int startedOnDayIndex,
      Value<int> rowid,
    });
typedef $$SavingsPlansTableTableUpdateCompanionBuilder =
    SavingsPlansTableCompanion Function({
      Value<String> id,
      Value<String> assetClass,
      Value<String> assetId,
      Value<int> monthlyCents,
      Value<int> startedOnDayIndex,
      Value<int> rowid,
    });

class $$SavingsPlansTableTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsPlansTableTable> {
  $$SavingsPlansTableTableFilterComposer({
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

  ColumnFilters<String> get assetClass => $composableBuilder(
    column: $table.assetClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyCents => $composableBuilder(
    column: $table.monthlyCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedOnDayIndex => $composableBuilder(
    column: $table.startedOnDayIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsPlansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsPlansTableTable> {
  $$SavingsPlansTableTableOrderingComposer({
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

  ColumnOrderings<String> get assetClass => $composableBuilder(
    column: $table.assetClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyCents => $composableBuilder(
    column: $table.monthlyCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedOnDayIndex => $composableBuilder(
    column: $table.startedOnDayIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsPlansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsPlansTableTable> {
  $$SavingsPlansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assetClass => $composableBuilder(
    column: $table.assetClass,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<int> get monthlyCents => $composableBuilder(
    column: $table.monthlyCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startedOnDayIndex => $composableBuilder(
    column: $table.startedOnDayIndex,
    builder: (column) => column,
  );
}

class $$SavingsPlansTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsPlansTableTable,
          SavingsPlanRow,
          $$SavingsPlansTableTableFilterComposer,
          $$SavingsPlansTableTableOrderingComposer,
          $$SavingsPlansTableTableAnnotationComposer,
          $$SavingsPlansTableTableCreateCompanionBuilder,
          $$SavingsPlansTableTableUpdateCompanionBuilder,
          (
            SavingsPlanRow,
            BaseReferences<
              _$AppDatabase,
              $SavingsPlansTableTable,
              SavingsPlanRow
            >,
          ),
          SavingsPlanRow,
          PrefetchHooks Function()
        > {
  $$SavingsPlansTableTableTableManager(
    _$AppDatabase db,
    $SavingsPlansTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsPlansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsPlansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsPlansTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> assetClass = const Value.absent(),
                Value<String> assetId = const Value.absent(),
                Value<int> monthlyCents = const Value.absent(),
                Value<int> startedOnDayIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavingsPlansTableCompanion(
                id: id,
                assetClass: assetClass,
                assetId: assetId,
                monthlyCents: monthlyCents,
                startedOnDayIndex: startedOnDayIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String assetClass,
                required String assetId,
                required int monthlyCents,
                required int startedOnDayIndex,
                Value<int> rowid = const Value.absent(),
              }) => SavingsPlansTableCompanion.insert(
                id: id,
                assetClass: assetClass,
                assetId: assetId,
                monthlyCents: monthlyCents,
                startedOnDayIndex: startedOnDayIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsPlansTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsPlansTableTable,
      SavingsPlanRow,
      $$SavingsPlansTableTableFilterComposer,
      $$SavingsPlansTableTableOrderingComposer,
      $$SavingsPlansTableTableAnnotationComposer,
      $$SavingsPlansTableTableCreateCompanionBuilder,
      $$SavingsPlansTableTableUpdateCompanionBuilder,
      (
        SavingsPlanRow,
        BaseReferences<_$AppDatabase, $SavingsPlansTableTable, SavingsPlanRow>,
      ),
      SavingsPlanRow,
      PrefetchHooks Function()
    >;
typedef $$WishItemsTableTableCreateCompanionBuilder =
    WishItemsTableCompanion Function({
      required String id,
      required int currentPriceCents,
      Value<int?> ownedOnDayIndex,
      Value<String?> photoPath,
      Value<int> rowid,
    });
typedef $$WishItemsTableTableUpdateCompanionBuilder =
    WishItemsTableCompanion Function({
      Value<String> id,
      Value<int> currentPriceCents,
      Value<int?> ownedOnDayIndex,
      Value<String?> photoPath,
      Value<int> rowid,
    });

class $$WishItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $WishItemsTableTable> {
  $$WishItemsTableTableFilterComposer({
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

  ColumnFilters<int> get currentPriceCents => $composableBuilder(
    column: $table.currentPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ownedOnDayIndex => $composableBuilder(
    column: $table.ownedOnDayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WishItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WishItemsTableTable> {
  $$WishItemsTableTableOrderingComposer({
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

  ColumnOrderings<int> get currentPriceCents => $composableBuilder(
    column: $table.currentPriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownedOnDayIndex => $composableBuilder(
    column: $table.ownedOnDayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WishItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WishItemsTableTable> {
  $$WishItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentPriceCents => $composableBuilder(
    column: $table.currentPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ownedOnDayIndex => $composableBuilder(
    column: $table.ownedOnDayIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);
}

class $$WishItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WishItemsTableTable,
          WishItemRow,
          $$WishItemsTableTableFilterComposer,
          $$WishItemsTableTableOrderingComposer,
          $$WishItemsTableTableAnnotationComposer,
          $$WishItemsTableTableCreateCompanionBuilder,
          $$WishItemsTableTableUpdateCompanionBuilder,
          (
            WishItemRow,
            BaseReferences<_$AppDatabase, $WishItemsTableTable, WishItemRow>,
          ),
          WishItemRow,
          PrefetchHooks Function()
        > {
  $$WishItemsTableTableTableManager(
    _$AppDatabase db,
    $WishItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WishItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WishItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WishItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> currentPriceCents = const Value.absent(),
                Value<int?> ownedOnDayIndex = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WishItemsTableCompanion(
                id: id,
                currentPriceCents: currentPriceCents,
                ownedOnDayIndex: ownedOnDayIndex,
                photoPath: photoPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int currentPriceCents,
                Value<int?> ownedOnDayIndex = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WishItemsTableCompanion.insert(
                id: id,
                currentPriceCents: currentPriceCents,
                ownedOnDayIndex: ownedOnDayIndex,
                photoPath: photoPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WishItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WishItemsTableTable,
      WishItemRow,
      $$WishItemsTableTableFilterComposer,
      $$WishItemsTableTableOrderingComposer,
      $$WishItemsTableTableAnnotationComposer,
      $$WishItemsTableTableCreateCompanionBuilder,
      $$WishItemsTableTableUpdateCompanionBuilder,
      (
        WishItemRow,
        BaseReferences<_$AppDatabase, $WishItemsTableTable, WishItemRow>,
      ),
      WishItemRow,
      PrefetchHooks Function()
    >;
typedef $$PriceHistoryTableTableCreateCompanionBuilder =
    PriceHistoryTableCompanion Function({
      required String assetId,
      required int dayIndex,
      required int priceCents,
      Value<int> rowid,
    });
typedef $$PriceHistoryTableTableUpdateCompanionBuilder =
    PriceHistoryTableCompanion Function({
      Value<String> assetId,
      Value<int> dayIndex,
      Value<int> priceCents,
      Value<int> rowid,
    });

class $$PriceHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $PriceHistoryTableTable> {
  $$PriceHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PriceHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceHistoryTableTable> {
  $$PriceHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PriceHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceHistoryTableTable> {
  $$PriceHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );
}

class $$PriceHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PriceHistoryTableTable,
          PriceHistoryRow,
          $$PriceHistoryTableTableFilterComposer,
          $$PriceHistoryTableTableOrderingComposer,
          $$PriceHistoryTableTableAnnotationComposer,
          $$PriceHistoryTableTableCreateCompanionBuilder,
          $$PriceHistoryTableTableUpdateCompanionBuilder,
          (
            PriceHistoryRow,
            BaseReferences<
              _$AppDatabase,
              $PriceHistoryTableTable,
              PriceHistoryRow
            >,
          ),
          PriceHistoryRow,
          PrefetchHooks Function()
        > {
  $$PriceHistoryTableTableTableManager(
    _$AppDatabase db,
    $PriceHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceHistoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> assetId = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<int> priceCents = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PriceHistoryTableCompanion(
                assetId: assetId,
                dayIndex: dayIndex,
                priceCents: priceCents,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String assetId,
                required int dayIndex,
                required int priceCents,
                Value<int> rowid = const Value.absent(),
              }) => PriceHistoryTableCompanion.insert(
                assetId: assetId,
                dayIndex: dayIndex,
                priceCents: priceCents,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PriceHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PriceHistoryTableTable,
      PriceHistoryRow,
      $$PriceHistoryTableTableFilterComposer,
      $$PriceHistoryTableTableOrderingComposer,
      $$PriceHistoryTableTableAnnotationComposer,
      $$PriceHistoryTableTableCreateCompanionBuilder,
      $$PriceHistoryTableTableUpdateCompanionBuilder,
      (
        PriceHistoryRow,
        BaseReferences<_$AppDatabase, $PriceHistoryTableTable, PriceHistoryRow>,
      ),
      PriceHistoryRow,
      PrefetchHooks Function()
    >;
typedef $$UnlockedIslandsTableTableCreateCompanionBuilder =
    UnlockedIslandsTableCompanion Function({
      required String islandId,
      Value<int> rowid,
    });
typedef $$UnlockedIslandsTableTableUpdateCompanionBuilder =
    UnlockedIslandsTableCompanion Function({
      Value<String> islandId,
      Value<int> rowid,
    });

class $$UnlockedIslandsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UnlockedIslandsTableTable> {
  $$UnlockedIslandsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get islandId => $composableBuilder(
    column: $table.islandId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnlockedIslandsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UnlockedIslandsTableTable> {
  $$UnlockedIslandsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get islandId => $composableBuilder(
    column: $table.islandId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnlockedIslandsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnlockedIslandsTableTable> {
  $$UnlockedIslandsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get islandId =>
      $composableBuilder(column: $table.islandId, builder: (column) => column);
}

class $$UnlockedIslandsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnlockedIslandsTableTable,
          UnlockedIslandRow,
          $$UnlockedIslandsTableTableFilterComposer,
          $$UnlockedIslandsTableTableOrderingComposer,
          $$UnlockedIslandsTableTableAnnotationComposer,
          $$UnlockedIslandsTableTableCreateCompanionBuilder,
          $$UnlockedIslandsTableTableUpdateCompanionBuilder,
          (
            UnlockedIslandRow,
            BaseReferences<
              _$AppDatabase,
              $UnlockedIslandsTableTable,
              UnlockedIslandRow
            >,
          ),
          UnlockedIslandRow,
          PrefetchHooks Function()
        > {
  $$UnlockedIslandsTableTableTableManager(
    _$AppDatabase db,
    $UnlockedIslandsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnlockedIslandsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnlockedIslandsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UnlockedIslandsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> islandId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnlockedIslandsTableCompanion(
                islandId: islandId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String islandId,
                Value<int> rowid = const Value.absent(),
              }) => UnlockedIslandsTableCompanion.insert(
                islandId: islandId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnlockedIslandsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnlockedIslandsTableTable,
      UnlockedIslandRow,
      $$UnlockedIslandsTableTableFilterComposer,
      $$UnlockedIslandsTableTableOrderingComposer,
      $$UnlockedIslandsTableTableAnnotationComposer,
      $$UnlockedIslandsTableTableCreateCompanionBuilder,
      $$UnlockedIslandsTableTableUpdateCompanionBuilder,
      (
        UnlockedIslandRow,
        BaseReferences<
          _$AppDatabase,
          $UnlockedIslandsTableTable,
          UnlockedIslandRow
        >,
      ),
      UnlockedIslandRow,
      PrefetchHooks Function()
    >;
typedef $$QuestProgressTableTableCreateCompanionBuilder =
    QuestProgressTableCompanion Function({
      required String questId,
      Value<int> currentStepIndex,
      required String status,
      Value<int?> startedOnDayIndex,
      Value<int?> completedOnDayIndex,
      Value<int> rowid,
    });
typedef $$QuestProgressTableTableUpdateCompanionBuilder =
    QuestProgressTableCompanion Function({
      Value<String> questId,
      Value<int> currentStepIndex,
      Value<String> status,
      Value<int?> startedOnDayIndex,
      Value<int?> completedOnDayIndex,
      Value<int> rowid,
    });

class $$QuestProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuestProgressTableTable> {
  $$QuestProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStepIndex => $composableBuilder(
    column: $table.currentStepIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedOnDayIndex => $composableBuilder(
    column: $table.startedOnDayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedOnDayIndex => $composableBuilder(
    column: $table.completedOnDayIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestProgressTableTable> {
  $$QuestProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStepIndex => $composableBuilder(
    column: $table.currentStepIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedOnDayIndex => $composableBuilder(
    column: $table.startedOnDayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedOnDayIndex => $composableBuilder(
    column: $table.completedOnDayIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestProgressTableTable> {
  $$QuestProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get questId =>
      $composableBuilder(column: $table.questId, builder: (column) => column);

  GeneratedColumn<int> get currentStepIndex => $composableBuilder(
    column: $table.currentStepIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get startedOnDayIndex => $composableBuilder(
    column: $table.startedOnDayIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedOnDayIndex => $composableBuilder(
    column: $table.completedOnDayIndex,
    builder: (column) => column,
  );
}

class $$QuestProgressTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestProgressTableTable,
          QuestProgressRow,
          $$QuestProgressTableTableFilterComposer,
          $$QuestProgressTableTableOrderingComposer,
          $$QuestProgressTableTableAnnotationComposer,
          $$QuestProgressTableTableCreateCompanionBuilder,
          $$QuestProgressTableTableUpdateCompanionBuilder,
          (
            QuestProgressRow,
            BaseReferences<
              _$AppDatabase,
              $QuestProgressTableTable,
              QuestProgressRow
            >,
          ),
          QuestProgressRow,
          PrefetchHooks Function()
        > {
  $$QuestProgressTableTableTableManager(
    _$AppDatabase db,
    $QuestProgressTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestProgressTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestProgressTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> questId = const Value.absent(),
                Value<int> currentStepIndex = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> startedOnDayIndex = const Value.absent(),
                Value<int?> completedOnDayIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestProgressTableCompanion(
                questId: questId,
                currentStepIndex: currentStepIndex,
                status: status,
                startedOnDayIndex: startedOnDayIndex,
                completedOnDayIndex: completedOnDayIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String questId,
                Value<int> currentStepIndex = const Value.absent(),
                required String status,
                Value<int?> startedOnDayIndex = const Value.absent(),
                Value<int?> completedOnDayIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestProgressTableCompanion.insert(
                questId: questId,
                currentStepIndex: currentStepIndex,
                status: status,
                startedOnDayIndex: startedOnDayIndex,
                completedOnDayIndex: completedOnDayIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestProgressTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestProgressTableTable,
      QuestProgressRow,
      $$QuestProgressTableTableFilterComposer,
      $$QuestProgressTableTableOrderingComposer,
      $$QuestProgressTableTableAnnotationComposer,
      $$QuestProgressTableTableCreateCompanionBuilder,
      $$QuestProgressTableTableUpdateCompanionBuilder,
      (
        QuestProgressRow,
        BaseReferences<
          _$AppDatabase,
          $QuestProgressTableTable,
          QuestProgressRow
        >,
      ),
      QuestProgressRow,
      PrefetchHooks Function()
    >;
typedef $$QuestChatEntriesTableTableCreateCompanionBuilder =
    QuestChatEntriesTableCompanion Function({
      Value<int> id,
      required String questId,
      required int orderIndex,
      required String kind,
      required String payloadJson,
    });
typedef $$QuestChatEntriesTableTableUpdateCompanionBuilder =
    QuestChatEntriesTableCompanion Function({
      Value<int> id,
      Value<String> questId,
      Value<int> orderIndex,
      Value<String> kind,
      Value<String> payloadJson,
    });

class $$QuestChatEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuestChatEntriesTableTable> {
  $$QuestChatEntriesTableTableFilterComposer({
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

  ColumnFilters<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestChatEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestChatEntriesTableTable> {
  $$QuestChatEntriesTableTableOrderingComposer({
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

  ColumnOrderings<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestChatEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestChatEntriesTableTable> {
  $$QuestChatEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questId =>
      $composableBuilder(column: $table.questId, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$QuestChatEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestChatEntriesTableTable,
          QuestChatEntryRow,
          $$QuestChatEntriesTableTableFilterComposer,
          $$QuestChatEntriesTableTableOrderingComposer,
          $$QuestChatEntriesTableTableAnnotationComposer,
          $$QuestChatEntriesTableTableCreateCompanionBuilder,
          $$QuestChatEntriesTableTableUpdateCompanionBuilder,
          (
            QuestChatEntryRow,
            BaseReferences<
              _$AppDatabase,
              $QuestChatEntriesTableTable,
              QuestChatEntryRow
            >,
          ),
          QuestChatEntryRow,
          PrefetchHooks Function()
        > {
  $$QuestChatEntriesTableTableTableManager(
    _$AppDatabase db,
    $QuestChatEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestChatEntriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$QuestChatEntriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$QuestChatEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> questId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
              }) => QuestChatEntriesTableCompanion(
                id: id,
                questId: questId,
                orderIndex: orderIndex,
                kind: kind,
                payloadJson: payloadJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String questId,
                required int orderIndex,
                required String kind,
                required String payloadJson,
              }) => QuestChatEntriesTableCompanion.insert(
                id: id,
                questId: questId,
                orderIndex: orderIndex,
                kind: kind,
                payloadJson: payloadJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestChatEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestChatEntriesTableTable,
      QuestChatEntryRow,
      $$QuestChatEntriesTableTableFilterComposer,
      $$QuestChatEntriesTableTableOrderingComposer,
      $$QuestChatEntriesTableTableAnnotationComposer,
      $$QuestChatEntriesTableTableCreateCompanionBuilder,
      $$QuestChatEntriesTableTableUpdateCompanionBuilder,
      (
        QuestChatEntryRow,
        BaseReferences<
          _$AppDatabase,
          $QuestChatEntriesTableTable,
          QuestChatEntryRow
        >,
      ),
      QuestChatEntryRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<int> allowanceCents,
      Value<String> allowanceWeekday,
      Value<String> playerName,
      Value<bool> soundEnabled,
      Value<int> lastQuizDayIndex,
      Value<bool> zeitreiseTutorialSeen,
      Value<int> musicVolume,
      Value<int> masterVolume,
      Value<int> sfxVolume,
      Value<int> lastSleepEpochMs,
      Value<int> sleepCountInWindow,
      Value<bool> onboardingComplete,
      Value<String> avatarEmoji,
      Value<int> streakCount,
      Value<String> lastSleepDateIso,
      Value<String> unlockedAvatars,
      Value<String> unlockedDecor,
      Value<String> unlockedSkills,
      Value<int> weeklyChallengeClaimedWeek,
      Value<int> weeklyChallengeStreak,
      Value<int> claimedStreakMilestone,
      Value<bool> autoSaveDisabled,
      Value<String?> backupFolderUri,
      Value<int?> birthYear,
      Value<bool> birthYearAsked,
      Value<int> parentGateLockedUntilMs,
      Value<int> sparPlotCount,
      Value<String> quizLearnedTopics,
      Value<String> seenCoaches,
      Value<int> lastWeekNetWorthCents,
      Value<int> lastWeeklyReviewDay,
      Value<String> recentQuizTexts,
      Value<int> startAgeYears,
      Value<int> savingsRatePct,
      Value<int> lastClaimedGoalDay,
      Value<String> parentPin,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<int> allowanceCents,
      Value<String> allowanceWeekday,
      Value<String> playerName,
      Value<bool> soundEnabled,
      Value<int> lastQuizDayIndex,
      Value<bool> zeitreiseTutorialSeen,
      Value<int> musicVolume,
      Value<int> masterVolume,
      Value<int> sfxVolume,
      Value<int> lastSleepEpochMs,
      Value<int> sleepCountInWindow,
      Value<bool> onboardingComplete,
      Value<String> avatarEmoji,
      Value<int> streakCount,
      Value<String> lastSleepDateIso,
      Value<String> unlockedAvatars,
      Value<String> unlockedDecor,
      Value<String> unlockedSkills,
      Value<int> weeklyChallengeClaimedWeek,
      Value<int> weeklyChallengeStreak,
      Value<int> claimedStreakMilestone,
      Value<bool> autoSaveDisabled,
      Value<String?> backupFolderUri,
      Value<int?> birthYear,
      Value<bool> birthYearAsked,
      Value<int> parentGateLockedUntilMs,
      Value<int> sparPlotCount,
      Value<String> quizLearnedTopics,
      Value<String> seenCoaches,
      Value<int> lastWeekNetWorthCents,
      Value<int> lastWeeklyReviewDay,
      Value<String> recentQuizTexts,
      Value<int> startAgeYears,
      Value<int> savingsRatePct,
      Value<int> lastClaimedGoalDay,
      Value<String> parentPin,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
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

  ColumnFilters<int> get allowanceCents => $composableBuilder(
    column: $table.allowanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allowanceWeekday => $composableBuilder(
    column: $table.allowanceWeekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playerName => $composableBuilder(
    column: $table.playerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastQuizDayIndex => $composableBuilder(
    column: $table.lastQuizDayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get zeitreiseTutorialSeen => $composableBuilder(
    column: $table.zeitreiseTutorialSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get musicVolume => $composableBuilder(
    column: $table.musicVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get masterVolume => $composableBuilder(
    column: $table.masterVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sfxVolume => $composableBuilder(
    column: $table.sfxVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSleepEpochMs => $composableBuilder(
    column: $table.lastSleepEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepCountInWindow => $composableBuilder(
    column: $table.sleepCountInWindow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarEmoji => $composableBuilder(
    column: $table.avatarEmoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakCount => $composableBuilder(
    column: $table.streakCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSleepDateIso => $composableBuilder(
    column: $table.lastSleepDateIso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unlockedAvatars => $composableBuilder(
    column: $table.unlockedAvatars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unlockedDecor => $composableBuilder(
    column: $table.unlockedDecor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unlockedSkills => $composableBuilder(
    column: $table.unlockedSkills,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyChallengeClaimedWeek => $composableBuilder(
    column: $table.weeklyChallengeClaimedWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyChallengeStreak => $composableBuilder(
    column: $table.weeklyChallengeStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get claimedStreakMilestone => $composableBuilder(
    column: $table.claimedStreakMilestone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoSaveDisabled => $composableBuilder(
    column: $table.autoSaveDisabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backupFolderUri => $composableBuilder(
    column: $table.backupFolderUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get birthYearAsked => $composableBuilder(
    column: $table.birthYearAsked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentGateLockedUntilMs => $composableBuilder(
    column: $table.parentGateLockedUntilMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sparPlotCount => $composableBuilder(
    column: $table.sparPlotCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quizLearnedTopics => $composableBuilder(
    column: $table.quizLearnedTopics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seenCoaches => $composableBuilder(
    column: $table.seenCoaches,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastWeekNetWorthCents => $composableBuilder(
    column: $table.lastWeekNetWorthCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastWeeklyReviewDay => $composableBuilder(
    column: $table.lastWeeklyReviewDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recentQuizTexts => $composableBuilder(
    column: $table.recentQuizTexts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startAgeYears => $composableBuilder(
    column: $table.startAgeYears,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savingsRatePct => $composableBuilder(
    column: $table.savingsRatePct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastClaimedGoalDay => $composableBuilder(
    column: $table.lastClaimedGoalDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentPin => $composableBuilder(
    column: $table.parentPin,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
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

  ColumnOrderings<int> get allowanceCents => $composableBuilder(
    column: $table.allowanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allowanceWeekday => $composableBuilder(
    column: $table.allowanceWeekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playerName => $composableBuilder(
    column: $table.playerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastQuizDayIndex => $composableBuilder(
    column: $table.lastQuizDayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get zeitreiseTutorialSeen => $composableBuilder(
    column: $table.zeitreiseTutorialSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get musicVolume => $composableBuilder(
    column: $table.musicVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get masterVolume => $composableBuilder(
    column: $table.masterVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sfxVolume => $composableBuilder(
    column: $table.sfxVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSleepEpochMs => $composableBuilder(
    column: $table.lastSleepEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepCountInWindow => $composableBuilder(
    column: $table.sleepCountInWindow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarEmoji => $composableBuilder(
    column: $table.avatarEmoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakCount => $composableBuilder(
    column: $table.streakCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSleepDateIso => $composableBuilder(
    column: $table.lastSleepDateIso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unlockedAvatars => $composableBuilder(
    column: $table.unlockedAvatars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unlockedDecor => $composableBuilder(
    column: $table.unlockedDecor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unlockedSkills => $composableBuilder(
    column: $table.unlockedSkills,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyChallengeClaimedWeek => $composableBuilder(
    column: $table.weeklyChallengeClaimedWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyChallengeStreak => $composableBuilder(
    column: $table.weeklyChallengeStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get claimedStreakMilestone => $composableBuilder(
    column: $table.claimedStreakMilestone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoSaveDisabled => $composableBuilder(
    column: $table.autoSaveDisabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backupFolderUri => $composableBuilder(
    column: $table.backupFolderUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get birthYearAsked => $composableBuilder(
    column: $table.birthYearAsked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentGateLockedUntilMs => $composableBuilder(
    column: $table.parentGateLockedUntilMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sparPlotCount => $composableBuilder(
    column: $table.sparPlotCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quizLearnedTopics => $composableBuilder(
    column: $table.quizLearnedTopics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seenCoaches => $composableBuilder(
    column: $table.seenCoaches,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastWeekNetWorthCents => $composableBuilder(
    column: $table.lastWeekNetWorthCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastWeeklyReviewDay => $composableBuilder(
    column: $table.lastWeeklyReviewDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recentQuizTexts => $composableBuilder(
    column: $table.recentQuizTexts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startAgeYears => $composableBuilder(
    column: $table.startAgeYears,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savingsRatePct => $composableBuilder(
    column: $table.savingsRatePct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastClaimedGoalDay => $composableBuilder(
    column: $table.lastClaimedGoalDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentPin => $composableBuilder(
    column: $table.parentPin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get allowanceCents => $composableBuilder(
    column: $table.allowanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allowanceWeekday => $composableBuilder(
    column: $table.allowanceWeekday,
    builder: (column) => column,
  );

  GeneratedColumn<String> get playerName => $composableBuilder(
    column: $table.playerName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastQuizDayIndex => $composableBuilder(
    column: $table.lastQuizDayIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get zeitreiseTutorialSeen => $composableBuilder(
    column: $table.zeitreiseTutorialSeen,
    builder: (column) => column,
  );

  GeneratedColumn<int> get musicVolume => $composableBuilder(
    column: $table.musicVolume,
    builder: (column) => column,
  );

  GeneratedColumn<int> get masterVolume => $composableBuilder(
    column: $table.masterVolume,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sfxVolume =>
      $composableBuilder(column: $table.sfxVolume, builder: (column) => column);

  GeneratedColumn<int> get lastSleepEpochMs => $composableBuilder(
    column: $table.lastSleepEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepCountInWindow => $composableBuilder(
    column: $table.sleepCountInWindow,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarEmoji => $composableBuilder(
    column: $table.avatarEmoji,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakCount => $composableBuilder(
    column: $table.streakCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSleepDateIso => $composableBuilder(
    column: $table.lastSleepDateIso,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unlockedAvatars => $composableBuilder(
    column: $table.unlockedAvatars,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unlockedDecor => $composableBuilder(
    column: $table.unlockedDecor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unlockedSkills => $composableBuilder(
    column: $table.unlockedSkills,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyChallengeClaimedWeek => $composableBuilder(
    column: $table.weeklyChallengeClaimedWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyChallengeStreak => $composableBuilder(
    column: $table.weeklyChallengeStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get claimedStreakMilestone => $composableBuilder(
    column: $table.claimedStreakMilestone,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoSaveDisabled => $composableBuilder(
    column: $table.autoSaveDisabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backupFolderUri => $composableBuilder(
    column: $table.backupFolderUri,
    builder: (column) => column,
  );

  GeneratedColumn<int> get birthYear =>
      $composableBuilder(column: $table.birthYear, builder: (column) => column);

  GeneratedColumn<bool> get birthYearAsked => $composableBuilder(
    column: $table.birthYearAsked,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parentGateLockedUntilMs => $composableBuilder(
    column: $table.parentGateLockedUntilMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sparPlotCount => $composableBuilder(
    column: $table.sparPlotCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quizLearnedTopics => $composableBuilder(
    column: $table.quizLearnedTopics,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seenCoaches => $composableBuilder(
    column: $table.seenCoaches,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastWeekNetWorthCents => $composableBuilder(
    column: $table.lastWeekNetWorthCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastWeeklyReviewDay => $composableBuilder(
    column: $table.lastWeeklyReviewDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recentQuizTexts => $composableBuilder(
    column: $table.recentQuizTexts,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startAgeYears => $composableBuilder(
    column: $table.startAgeYears,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savingsRatePct => $composableBuilder(
    column: $table.savingsRatePct,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastClaimedGoalDay => $composableBuilder(
    column: $table.lastClaimedGoalDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentPin =>
      $composableBuilder(column: $table.parentPin, builder: (column) => column);
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingsRow,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> allowanceCents = const Value.absent(),
                Value<String> allowanceWeekday = const Value.absent(),
                Value<String> playerName = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<int> lastQuizDayIndex = const Value.absent(),
                Value<bool> zeitreiseTutorialSeen = const Value.absent(),
                Value<int> musicVolume = const Value.absent(),
                Value<int> masterVolume = const Value.absent(),
                Value<int> sfxVolume = const Value.absent(),
                Value<int> lastSleepEpochMs = const Value.absent(),
                Value<int> sleepCountInWindow = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<String> avatarEmoji = const Value.absent(),
                Value<int> streakCount = const Value.absent(),
                Value<String> lastSleepDateIso = const Value.absent(),
                Value<String> unlockedAvatars = const Value.absent(),
                Value<String> unlockedDecor = const Value.absent(),
                Value<String> unlockedSkills = const Value.absent(),
                Value<int> weeklyChallengeClaimedWeek = const Value.absent(),
                Value<int> weeklyChallengeStreak = const Value.absent(),
                Value<int> claimedStreakMilestone = const Value.absent(),
                Value<bool> autoSaveDisabled = const Value.absent(),
                Value<String?> backupFolderUri = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<bool> birthYearAsked = const Value.absent(),
                Value<int> parentGateLockedUntilMs = const Value.absent(),
                Value<int> sparPlotCount = const Value.absent(),
                Value<String> quizLearnedTopics = const Value.absent(),
                Value<String> seenCoaches = const Value.absent(),
                Value<int> lastWeekNetWorthCents = const Value.absent(),
                Value<int> lastWeeklyReviewDay = const Value.absent(),
                Value<String> recentQuizTexts = const Value.absent(),
                Value<int> startAgeYears = const Value.absent(),
                Value<int> savingsRatePct = const Value.absent(),
                Value<int> lastClaimedGoalDay = const Value.absent(),
                Value<String> parentPin = const Value.absent(),
              }) => SettingsTableCompanion(
                id: id,
                allowanceCents: allowanceCents,
                allowanceWeekday: allowanceWeekday,
                playerName: playerName,
                soundEnabled: soundEnabled,
                lastQuizDayIndex: lastQuizDayIndex,
                zeitreiseTutorialSeen: zeitreiseTutorialSeen,
                musicVolume: musicVolume,
                masterVolume: masterVolume,
                sfxVolume: sfxVolume,
                lastSleepEpochMs: lastSleepEpochMs,
                sleepCountInWindow: sleepCountInWindow,
                onboardingComplete: onboardingComplete,
                avatarEmoji: avatarEmoji,
                streakCount: streakCount,
                lastSleepDateIso: lastSleepDateIso,
                unlockedAvatars: unlockedAvatars,
                unlockedDecor: unlockedDecor,
                unlockedSkills: unlockedSkills,
                weeklyChallengeClaimedWeek: weeklyChallengeClaimedWeek,
                weeklyChallengeStreak: weeklyChallengeStreak,
                claimedStreakMilestone: claimedStreakMilestone,
                autoSaveDisabled: autoSaveDisabled,
                backupFolderUri: backupFolderUri,
                birthYear: birthYear,
                birthYearAsked: birthYearAsked,
                parentGateLockedUntilMs: parentGateLockedUntilMs,
                sparPlotCount: sparPlotCount,
                quizLearnedTopics: quizLearnedTopics,
                seenCoaches: seenCoaches,
                lastWeekNetWorthCents: lastWeekNetWorthCents,
                lastWeeklyReviewDay: lastWeeklyReviewDay,
                recentQuizTexts: recentQuizTexts,
                startAgeYears: startAgeYears,
                savingsRatePct: savingsRatePct,
                lastClaimedGoalDay: lastClaimedGoalDay,
                parentPin: parentPin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> allowanceCents = const Value.absent(),
                Value<String> allowanceWeekday = const Value.absent(),
                Value<String> playerName = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<int> lastQuizDayIndex = const Value.absent(),
                Value<bool> zeitreiseTutorialSeen = const Value.absent(),
                Value<int> musicVolume = const Value.absent(),
                Value<int> masterVolume = const Value.absent(),
                Value<int> sfxVolume = const Value.absent(),
                Value<int> lastSleepEpochMs = const Value.absent(),
                Value<int> sleepCountInWindow = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<String> avatarEmoji = const Value.absent(),
                Value<int> streakCount = const Value.absent(),
                Value<String> lastSleepDateIso = const Value.absent(),
                Value<String> unlockedAvatars = const Value.absent(),
                Value<String> unlockedDecor = const Value.absent(),
                Value<String> unlockedSkills = const Value.absent(),
                Value<int> weeklyChallengeClaimedWeek = const Value.absent(),
                Value<int> weeklyChallengeStreak = const Value.absent(),
                Value<int> claimedStreakMilestone = const Value.absent(),
                Value<bool> autoSaveDisabled = const Value.absent(),
                Value<String?> backupFolderUri = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<bool> birthYearAsked = const Value.absent(),
                Value<int> parentGateLockedUntilMs = const Value.absent(),
                Value<int> sparPlotCount = const Value.absent(),
                Value<String> quizLearnedTopics = const Value.absent(),
                Value<String> seenCoaches = const Value.absent(),
                Value<int> lastWeekNetWorthCents = const Value.absent(),
                Value<int> lastWeeklyReviewDay = const Value.absent(),
                Value<String> recentQuizTexts = const Value.absent(),
                Value<int> startAgeYears = const Value.absent(),
                Value<int> savingsRatePct = const Value.absent(),
                Value<int> lastClaimedGoalDay = const Value.absent(),
                Value<String> parentPin = const Value.absent(),
              }) => SettingsTableCompanion.insert(
                id: id,
                allowanceCents: allowanceCents,
                allowanceWeekday: allowanceWeekday,
                playerName: playerName,
                soundEnabled: soundEnabled,
                lastQuizDayIndex: lastQuizDayIndex,
                zeitreiseTutorialSeen: zeitreiseTutorialSeen,
                musicVolume: musicVolume,
                masterVolume: masterVolume,
                sfxVolume: sfxVolume,
                lastSleepEpochMs: lastSleepEpochMs,
                sleepCountInWindow: sleepCountInWindow,
                onboardingComplete: onboardingComplete,
                avatarEmoji: avatarEmoji,
                streakCount: streakCount,
                lastSleepDateIso: lastSleepDateIso,
                unlockedAvatars: unlockedAvatars,
                unlockedDecor: unlockedDecor,
                unlockedSkills: unlockedSkills,
                weeklyChallengeClaimedWeek: weeklyChallengeClaimedWeek,
                weeklyChallengeStreak: weeklyChallengeStreak,
                claimedStreakMilestone: claimedStreakMilestone,
                autoSaveDisabled: autoSaveDisabled,
                backupFolderUri: backupFolderUri,
                birthYear: birthYear,
                birthYearAsked: birthYearAsked,
                parentGateLockedUntilMs: parentGateLockedUntilMs,
                sparPlotCount: sparPlotCount,
                quizLearnedTopics: quizLearnedTopics,
                seenCoaches: seenCoaches,
                lastWeekNetWorthCents: lastWeekNetWorthCents,
                lastWeeklyReviewDay: lastWeeklyReviewDay,
                recentQuizTexts: recentQuizTexts,
                startAgeYears: startAgeYears,
                savingsRatePct: savingsRatePct,
                lastClaimedGoalDay: lastClaimedGoalDay,
                parentPin: parentPin,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingsRow,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (
        SettingsRow,
        BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsRow>,
      ),
      SettingsRow,
      PrefetchHooks Function()
    >;
typedef $$XpTableTableCreateCompanionBuilder =
    XpTableCompanion Function({Value<int> id, Value<int> total});
typedef $$XpTableTableUpdateCompanionBuilder =
    XpTableCompanion Function({Value<int> id, Value<int> total});

class $$XpTableTableFilterComposer
    extends Composer<_$AppDatabase, $XpTableTable> {
  $$XpTableTableFilterComposer({
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

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );
}

class $$XpTableTableOrderingComposer
    extends Composer<_$AppDatabase, $XpTableTable> {
  $$XpTableTableOrderingComposer({
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

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$XpTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $XpTableTable> {
  $$XpTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);
}

class $$XpTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $XpTableTable,
          XpRow,
          $$XpTableTableFilterComposer,
          $$XpTableTableOrderingComposer,
          $$XpTableTableAnnotationComposer,
          $$XpTableTableCreateCompanionBuilder,
          $$XpTableTableUpdateCompanionBuilder,
          (XpRow, BaseReferences<_$AppDatabase, $XpTableTable, XpRow>),
          XpRow,
          PrefetchHooks Function()
        > {
  $$XpTableTableTableManager(_$AppDatabase db, $XpTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$XpTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$XpTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$XpTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> total = const Value.absent(),
              }) => XpTableCompanion(id: id, total: total),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> total = const Value.absent(),
              }) => XpTableCompanion.insert(id: id, total: total),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$XpTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $XpTableTable,
      XpRow,
      $$XpTableTableFilterComposer,
      $$XpTableTableOrderingComposer,
      $$XpTableTableAnnotationComposer,
      $$XpTableTableCreateCompanionBuilder,
      $$XpTableTableUpdateCompanionBuilder,
      (XpRow, BaseReferences<_$AppDatabase, $XpTableTable, XpRow>),
      XpRow,
      PrefetchHooks Function()
    >;
typedef $$SavingsTableTableCreateCompanionBuilder =
    SavingsTableCompanion Function({Value<int> id, Value<int> cents});
typedef $$SavingsTableTableUpdateCompanionBuilder =
    SavingsTableCompanion Function({Value<int> id, Value<int> cents});

class $$SavingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsTableTable> {
  $$SavingsTableTableFilterComposer({
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

  ColumnFilters<int> get cents => $composableBuilder(
    column: $table.cents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsTableTable> {
  $$SavingsTableTableOrderingComposer({
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

  ColumnOrderings<int> get cents => $composableBuilder(
    column: $table.cents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsTableTable> {
  $$SavingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cents =>
      $composableBuilder(column: $table.cents, builder: (column) => column);
}

class $$SavingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsTableTable,
          SavingsRow,
          $$SavingsTableTableFilterComposer,
          $$SavingsTableTableOrderingComposer,
          $$SavingsTableTableAnnotationComposer,
          $$SavingsTableTableCreateCompanionBuilder,
          $$SavingsTableTableUpdateCompanionBuilder,
          (
            SavingsRow,
            BaseReferences<_$AppDatabase, $SavingsTableTable, SavingsRow>,
          ),
          SavingsRow,
          PrefetchHooks Function()
        > {
  $$SavingsTableTableTableManager(_$AppDatabase db, $SavingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cents = const Value.absent(),
              }) => SavingsTableCompanion(id: id, cents: cents),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cents = const Value.absent(),
              }) => SavingsTableCompanion.insert(id: id, cents: cents),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsTableTable,
      SavingsRow,
      $$SavingsTableTableFilterComposer,
      $$SavingsTableTableOrderingComposer,
      $$SavingsTableTableAnnotationComposer,
      $$SavingsTableTableCreateCompanionBuilder,
      $$SavingsTableTableUpdateCompanionBuilder,
      (
        SavingsRow,
        BaseReferences<_$AppDatabase, $SavingsTableTable, SavingsRow>,
      ),
      SavingsRow,
      PrefetchHooks Function()
    >;
typedef $$AchievementsTableTableCreateCompanionBuilder =
    AchievementsTableCompanion Function({
      required String id,
      required int unlockedOnDayIndex,
      Value<int> rowid,
    });
typedef $$AchievementsTableTableUpdateCompanionBuilder =
    AchievementsTableCompanion Function({
      Value<String> id,
      Value<int> unlockedOnDayIndex,
      Value<int> rowid,
    });

class $$AchievementsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableFilterComposer({
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

  ColumnFilters<int> get unlockedOnDayIndex => $composableBuilder(
    column: $table.unlockedOnDayIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableOrderingComposer({
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

  ColumnOrderings<int> get unlockedOnDayIndex => $composableBuilder(
    column: $table.unlockedOnDayIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get unlockedOnDayIndex => $composableBuilder(
    column: $table.unlockedOnDayIndex,
    builder: (column) => column,
  );
}

class $$AchievementsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTableTable,
          AchievementRow,
          $$AchievementsTableTableFilterComposer,
          $$AchievementsTableTableOrderingComposer,
          $$AchievementsTableTableAnnotationComposer,
          $$AchievementsTableTableCreateCompanionBuilder,
          $$AchievementsTableTableUpdateCompanionBuilder,
          (
            AchievementRow,
            BaseReferences<
              _$AppDatabase,
              $AchievementsTableTable,
              AchievementRow
            >,
          ),
          AchievementRow,
          PrefetchHooks Function()
        > {
  $$AchievementsTableTableTableManager(
    _$AppDatabase db,
    $AchievementsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> unlockedOnDayIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsTableCompanion(
                id: id,
                unlockedOnDayIndex: unlockedOnDayIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int unlockedOnDayIndex,
                Value<int> rowid = const Value.absent(),
              }) => AchievementsTableCompanion.insert(
                id: id,
                unlockedOnDayIndex: unlockedOnDayIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTableTable,
      AchievementRow,
      $$AchievementsTableTableFilterComposer,
      $$AchievementsTableTableOrderingComposer,
      $$AchievementsTableTableAnnotationComposer,
      $$AchievementsTableTableCreateCompanionBuilder,
      $$AchievementsTableTableUpdateCompanionBuilder,
      (
        AchievementRow,
        BaseReferences<_$AppDatabase, $AchievementsTableTable, AchievementRow>,
      ),
      AchievementRow,
      PrefetchHooks Function()
    >;
typedef $$LuckyEventHistoryTableTableCreateCompanionBuilder =
    LuckyEventHistoryTableCompanion Function({
      Value<int> rowId,
      required int dayIndex,
      required String title,
      required String description,
      required int amountCents,
      Value<int> taxDeductedCents,
    });
typedef $$LuckyEventHistoryTableTableUpdateCompanionBuilder =
    LuckyEventHistoryTableCompanion Function({
      Value<int> rowId,
      Value<int> dayIndex,
      Value<String> title,
      Value<String> description,
      Value<int> amountCents,
      Value<int> taxDeductedCents,
    });

class $$LuckyEventHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $LuckyEventHistoryTableTable> {
  $$LuckyEventHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
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

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxDeductedCents => $composableBuilder(
    column: $table.taxDeductedCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LuckyEventHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LuckyEventHistoryTableTable> {
  $$LuckyEventHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
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

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxDeductedCents => $composableBuilder(
    column: $table.taxDeductedCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LuckyEventHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LuckyEventHistoryTableTable> {
  $$LuckyEventHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxDeductedCents => $composableBuilder(
    column: $table.taxDeductedCents,
    builder: (column) => column,
  );
}

class $$LuckyEventHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LuckyEventHistoryTableTable,
          LuckyEventRow,
          $$LuckyEventHistoryTableTableFilterComposer,
          $$LuckyEventHistoryTableTableOrderingComposer,
          $$LuckyEventHistoryTableTableAnnotationComposer,
          $$LuckyEventHistoryTableTableCreateCompanionBuilder,
          $$LuckyEventHistoryTableTableUpdateCompanionBuilder,
          (
            LuckyEventRow,
            BaseReferences<
              _$AppDatabase,
              $LuckyEventHistoryTableTable,
              LuckyEventRow
            >,
          ),
          LuckyEventRow,
          PrefetchHooks Function()
        > {
  $$LuckyEventHistoryTableTableTableManager(
    _$AppDatabase db,
    $LuckyEventHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LuckyEventHistoryTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LuckyEventHistoryTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LuckyEventHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int> taxDeductedCents = const Value.absent(),
              }) => LuckyEventHistoryTableCompanion(
                rowId: rowId,
                dayIndex: dayIndex,
                title: title,
                description: description,
                amountCents: amountCents,
                taxDeductedCents: taxDeductedCents,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required int dayIndex,
                required String title,
                required String description,
                required int amountCents,
                Value<int> taxDeductedCents = const Value.absent(),
              }) => LuckyEventHistoryTableCompanion.insert(
                rowId: rowId,
                dayIndex: dayIndex,
                title: title,
                description: description,
                amountCents: amountCents,
                taxDeductedCents: taxDeductedCents,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LuckyEventHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LuckyEventHistoryTableTable,
      LuckyEventRow,
      $$LuckyEventHistoryTableTableFilterComposer,
      $$LuckyEventHistoryTableTableOrderingComposer,
      $$LuckyEventHistoryTableTableAnnotationComposer,
      $$LuckyEventHistoryTableTableCreateCompanionBuilder,
      $$LuckyEventHistoryTableTableUpdateCompanionBuilder,
      (
        LuckyEventRow,
        BaseReferences<
          _$AppDatabase,
          $LuckyEventHistoryTableTable,
          LuckyEventRow
        >,
      ),
      LuckyEventRow,
      PrefetchHooks Function()
    >;
typedef $$NewGameStateTableTableCreateCompanionBuilder =
    NewGameStateTableCompanion Function({
      Value<int> id,
      Value<int> runCount,
      Value<int> pendingInheritanceCents,
      Value<int> pendingBonusXp,
      Value<int> lastRunNetWorthCents,
      Value<int> legacyPoints,
      Value<String> legacyUpgrades,
    });
typedef $$NewGameStateTableTableUpdateCompanionBuilder =
    NewGameStateTableCompanion Function({
      Value<int> id,
      Value<int> runCount,
      Value<int> pendingInheritanceCents,
      Value<int> pendingBonusXp,
      Value<int> lastRunNetWorthCents,
      Value<int> legacyPoints,
      Value<String> legacyUpgrades,
    });

class $$NewGameStateTableTableFilterComposer
    extends Composer<_$AppDatabase, $NewGameStateTableTable> {
  $$NewGameStateTableTableFilterComposer({
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

  ColumnFilters<int> get runCount => $composableBuilder(
    column: $table.runCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pendingInheritanceCents => $composableBuilder(
    column: $table.pendingInheritanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pendingBonusXp => $composableBuilder(
    column: $table.pendingBonusXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastRunNetWorthCents => $composableBuilder(
    column: $table.lastRunNetWorthCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get legacyPoints => $composableBuilder(
    column: $table.legacyPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get legacyUpgrades => $composableBuilder(
    column: $table.legacyUpgrades,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NewGameStateTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NewGameStateTableTable> {
  $$NewGameStateTableTableOrderingComposer({
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

  ColumnOrderings<int> get runCount => $composableBuilder(
    column: $table.runCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pendingInheritanceCents => $composableBuilder(
    column: $table.pendingInheritanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pendingBonusXp => $composableBuilder(
    column: $table.pendingBonusXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastRunNetWorthCents => $composableBuilder(
    column: $table.lastRunNetWorthCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get legacyPoints => $composableBuilder(
    column: $table.legacyPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legacyUpgrades => $composableBuilder(
    column: $table.legacyUpgrades,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NewGameStateTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NewGameStateTableTable> {
  $$NewGameStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get runCount =>
      $composableBuilder(column: $table.runCount, builder: (column) => column);

  GeneratedColumn<int> get pendingInheritanceCents => $composableBuilder(
    column: $table.pendingInheritanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pendingBonusXp => $composableBuilder(
    column: $table.pendingBonusXp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastRunNetWorthCents => $composableBuilder(
    column: $table.lastRunNetWorthCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get legacyPoints => $composableBuilder(
    column: $table.legacyPoints,
    builder: (column) => column,
  );

  GeneratedColumn<String> get legacyUpgrades => $composableBuilder(
    column: $table.legacyUpgrades,
    builder: (column) => column,
  );
}

class $$NewGameStateTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NewGameStateTableTable,
          NewGameRow,
          $$NewGameStateTableTableFilterComposer,
          $$NewGameStateTableTableOrderingComposer,
          $$NewGameStateTableTableAnnotationComposer,
          $$NewGameStateTableTableCreateCompanionBuilder,
          $$NewGameStateTableTableUpdateCompanionBuilder,
          (
            NewGameRow,
            BaseReferences<_$AppDatabase, $NewGameStateTableTable, NewGameRow>,
          ),
          NewGameRow,
          PrefetchHooks Function()
        > {
  $$NewGameStateTableTableTableManager(
    _$AppDatabase db,
    $NewGameStateTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NewGameStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NewGameStateTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NewGameStateTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> runCount = const Value.absent(),
                Value<int> pendingInheritanceCents = const Value.absent(),
                Value<int> pendingBonusXp = const Value.absent(),
                Value<int> lastRunNetWorthCents = const Value.absent(),
                Value<int> legacyPoints = const Value.absent(),
                Value<String> legacyUpgrades = const Value.absent(),
              }) => NewGameStateTableCompanion(
                id: id,
                runCount: runCount,
                pendingInheritanceCents: pendingInheritanceCents,
                pendingBonusXp: pendingBonusXp,
                lastRunNetWorthCents: lastRunNetWorthCents,
                legacyPoints: legacyPoints,
                legacyUpgrades: legacyUpgrades,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> runCount = const Value.absent(),
                Value<int> pendingInheritanceCents = const Value.absent(),
                Value<int> pendingBonusXp = const Value.absent(),
                Value<int> lastRunNetWorthCents = const Value.absent(),
                Value<int> legacyPoints = const Value.absent(),
                Value<String> legacyUpgrades = const Value.absent(),
              }) => NewGameStateTableCompanion.insert(
                id: id,
                runCount: runCount,
                pendingInheritanceCents: pendingInheritanceCents,
                pendingBonusXp: pendingBonusXp,
                lastRunNetWorthCents: lastRunNetWorthCents,
                legacyPoints: legacyPoints,
                legacyUpgrades: legacyUpgrades,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NewGameStateTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NewGameStateTableTable,
      NewGameRow,
      $$NewGameStateTableTableFilterComposer,
      $$NewGameStateTableTableOrderingComposer,
      $$NewGameStateTableTableAnnotationComposer,
      $$NewGameStateTableTableCreateCompanionBuilder,
      $$NewGameStateTableTableUpdateCompanionBuilder,
      (
        NewGameRow,
        BaseReferences<_$AppDatabase, $NewGameStateTableTable, NewGameRow>,
      ),
      NewGameRow,
      PrefetchHooks Function()
    >;
typedef $$TreeHoldingsTableTableCreateCompanionBuilder =
    TreeHoldingsTableCompanion Function({
      required String id,
      required String kind,
      required int plantedOnDayIndex,
      Value<int> rowid,
    });
typedef $$TreeHoldingsTableTableUpdateCompanionBuilder =
    TreeHoldingsTableCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<int> plantedOnDayIndex,
      Value<int> rowid,
    });

class $$TreeHoldingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TreeHoldingsTableTable> {
  $$TreeHoldingsTableTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plantedOnDayIndex => $composableBuilder(
    column: $table.plantedOnDayIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TreeHoldingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TreeHoldingsTableTable> {
  $$TreeHoldingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plantedOnDayIndex => $composableBuilder(
    column: $table.plantedOnDayIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TreeHoldingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreeHoldingsTableTable> {
  $$TreeHoldingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get plantedOnDayIndex => $composableBuilder(
    column: $table.plantedOnDayIndex,
    builder: (column) => column,
  );
}

class $$TreeHoldingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TreeHoldingsTableTable,
          PlantedTreeRow,
          $$TreeHoldingsTableTableFilterComposer,
          $$TreeHoldingsTableTableOrderingComposer,
          $$TreeHoldingsTableTableAnnotationComposer,
          $$TreeHoldingsTableTableCreateCompanionBuilder,
          $$TreeHoldingsTableTableUpdateCompanionBuilder,
          (
            PlantedTreeRow,
            BaseReferences<
              _$AppDatabase,
              $TreeHoldingsTableTable,
              PlantedTreeRow
            >,
          ),
          PlantedTreeRow,
          PrefetchHooks Function()
        > {
  $$TreeHoldingsTableTableTableManager(
    _$AppDatabase db,
    $TreeHoldingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreeHoldingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreeHoldingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreeHoldingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> plantedOnDayIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TreeHoldingsTableCompanion(
                id: id,
                kind: kind,
                plantedOnDayIndex: plantedOnDayIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required int plantedOnDayIndex,
                Value<int> rowid = const Value.absent(),
              }) => TreeHoldingsTableCompanion.insert(
                id: id,
                kind: kind,
                plantedOnDayIndex: plantedOnDayIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TreeHoldingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TreeHoldingsTableTable,
      PlantedTreeRow,
      $$TreeHoldingsTableTableFilterComposer,
      $$TreeHoldingsTableTableOrderingComposer,
      $$TreeHoldingsTableTableAnnotationComposer,
      $$TreeHoldingsTableTableCreateCompanionBuilder,
      $$TreeHoldingsTableTableUpdateCompanionBuilder,
      (
        PlantedTreeRow,
        BaseReferences<_$AppDatabase, $TreeHoldingsTableTable, PlantedTreeRow>,
      ),
      PlantedTreeRow,
      PrefetchHooks Function()
    >;
typedef $$JobActionStateTableTableCreateCompanionBuilder =
    JobActionStateTableCompanion Function({
      Value<int> id,
      Value<int> careerBonusPct,
      Value<int> pauseUntilDay,
      Value<int> nextSwitchAllowedDay,
      Value<int> jobVariantIndex,
    });
typedef $$JobActionStateTableTableUpdateCompanionBuilder =
    JobActionStateTableCompanion Function({
      Value<int> id,
      Value<int> careerBonusPct,
      Value<int> pauseUntilDay,
      Value<int> nextSwitchAllowedDay,
      Value<int> jobVariantIndex,
    });

class $$JobActionStateTableTableFilterComposer
    extends Composer<_$AppDatabase, $JobActionStateTableTable> {
  $$JobActionStateTableTableFilterComposer({
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

  ColumnFilters<int> get careerBonusPct => $composableBuilder(
    column: $table.careerBonusPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pauseUntilDay => $composableBuilder(
    column: $table.pauseUntilDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextSwitchAllowedDay => $composableBuilder(
    column: $table.nextSwitchAllowedDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jobVariantIndex => $composableBuilder(
    column: $table.jobVariantIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JobActionStateTableTableOrderingComposer
    extends Composer<_$AppDatabase, $JobActionStateTableTable> {
  $$JobActionStateTableTableOrderingComposer({
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

  ColumnOrderings<int> get careerBonusPct => $composableBuilder(
    column: $table.careerBonusPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pauseUntilDay => $composableBuilder(
    column: $table.pauseUntilDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextSwitchAllowedDay => $composableBuilder(
    column: $table.nextSwitchAllowedDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jobVariantIndex => $composableBuilder(
    column: $table.jobVariantIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JobActionStateTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $JobActionStateTableTable> {
  $$JobActionStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get careerBonusPct => $composableBuilder(
    column: $table.careerBonusPct,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pauseUntilDay => $composableBuilder(
    column: $table.pauseUntilDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextSwitchAllowedDay => $composableBuilder(
    column: $table.nextSwitchAllowedDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get jobVariantIndex => $composableBuilder(
    column: $table.jobVariantIndex,
    builder: (column) => column,
  );
}

class $$JobActionStateTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JobActionStateTableTable,
          JobActionRow,
          $$JobActionStateTableTableFilterComposer,
          $$JobActionStateTableTableOrderingComposer,
          $$JobActionStateTableTableAnnotationComposer,
          $$JobActionStateTableTableCreateCompanionBuilder,
          $$JobActionStateTableTableUpdateCompanionBuilder,
          (
            JobActionRow,
            BaseReferences<
              _$AppDatabase,
              $JobActionStateTableTable,
              JobActionRow
            >,
          ),
          JobActionRow,
          PrefetchHooks Function()
        > {
  $$JobActionStateTableTableTableManager(
    _$AppDatabase db,
    $JobActionStateTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JobActionStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JobActionStateTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$JobActionStateTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> careerBonusPct = const Value.absent(),
                Value<int> pauseUntilDay = const Value.absent(),
                Value<int> nextSwitchAllowedDay = const Value.absent(),
                Value<int> jobVariantIndex = const Value.absent(),
              }) => JobActionStateTableCompanion(
                id: id,
                careerBonusPct: careerBonusPct,
                pauseUntilDay: pauseUntilDay,
                nextSwitchAllowedDay: nextSwitchAllowedDay,
                jobVariantIndex: jobVariantIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> careerBonusPct = const Value.absent(),
                Value<int> pauseUntilDay = const Value.absent(),
                Value<int> nextSwitchAllowedDay = const Value.absent(),
                Value<int> jobVariantIndex = const Value.absent(),
              }) => JobActionStateTableCompanion.insert(
                id: id,
                careerBonusPct: careerBonusPct,
                pauseUntilDay: pauseUntilDay,
                nextSwitchAllowedDay: nextSwitchAllowedDay,
                jobVariantIndex: jobVariantIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JobActionStateTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JobActionStateTableTable,
      JobActionRow,
      $$JobActionStateTableTableFilterComposer,
      $$JobActionStateTableTableOrderingComposer,
      $$JobActionStateTableTableAnnotationComposer,
      $$JobActionStateTableTableCreateCompanionBuilder,
      $$JobActionStateTableTableUpdateCompanionBuilder,
      (
        JobActionRow,
        BaseReferences<_$AppDatabase, $JobActionStateTableTable, JobActionRow>,
      ),
      JobActionRow,
      PrefetchHooks Function()
    >;
typedef $$QuestFailureTableTableCreateCompanionBuilder =
    QuestFailureTableCompanion Function({
      required String questId,
      required int failedOnDayIndex,
      Value<int> rowid,
    });
typedef $$QuestFailureTableTableUpdateCompanionBuilder =
    QuestFailureTableCompanion Function({
      Value<String> questId,
      Value<int> failedOnDayIndex,
      Value<int> rowid,
    });

class $$QuestFailureTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuestFailureTableTable> {
  $$QuestFailureTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failedOnDayIndex => $composableBuilder(
    column: $table.failedOnDayIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestFailureTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestFailureTableTable> {
  $$QuestFailureTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get questId => $composableBuilder(
    column: $table.questId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failedOnDayIndex => $composableBuilder(
    column: $table.failedOnDayIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestFailureTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestFailureTableTable> {
  $$QuestFailureTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get questId =>
      $composableBuilder(column: $table.questId, builder: (column) => column);

  GeneratedColumn<int> get failedOnDayIndex => $composableBuilder(
    column: $table.failedOnDayIndex,
    builder: (column) => column,
  );
}

class $$QuestFailureTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestFailureTableTable,
          QuestFailRow,
          $$QuestFailureTableTableFilterComposer,
          $$QuestFailureTableTableOrderingComposer,
          $$QuestFailureTableTableAnnotationComposer,
          $$QuestFailureTableTableCreateCompanionBuilder,
          $$QuestFailureTableTableUpdateCompanionBuilder,
          (
            QuestFailRow,
            BaseReferences<
              _$AppDatabase,
              $QuestFailureTableTable,
              QuestFailRow
            >,
          ),
          QuestFailRow,
          PrefetchHooks Function()
        > {
  $$QuestFailureTableTableTableManager(
    _$AppDatabase db,
    $QuestFailureTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestFailureTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestFailureTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestFailureTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> questId = const Value.absent(),
                Value<int> failedOnDayIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestFailureTableCompanion(
                questId: questId,
                failedOnDayIndex: failedOnDayIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String questId,
                required int failedOnDayIndex,
                Value<int> rowid = const Value.absent(),
              }) => QuestFailureTableCompanion.insert(
                questId: questId,
                failedOnDayIndex: failedOnDayIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestFailureTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestFailureTableTable,
      QuestFailRow,
      $$QuestFailureTableTableFilterComposer,
      $$QuestFailureTableTableOrderingComposer,
      $$QuestFailureTableTableAnnotationComposer,
      $$QuestFailureTableTableCreateCompanionBuilder,
      $$QuestFailureTableTableUpdateCompanionBuilder,
      (
        QuestFailRow,
        BaseReferences<_$AppDatabase, $QuestFailureTableTable, QuestFailRow>,
      ),
      QuestFailRow,
      PrefetchHooks Function()
    >;
typedef $$FurnitureTableTableCreateCompanionBuilder =
    FurnitureTableCompanion Function({
      required String itemId,
      required String slot,
      Value<bool> active,
      Value<bool> hidden,
      Value<double?> posX,
      Value<double?> posY,
      Value<int> rowid,
    });
typedef $$FurnitureTableTableUpdateCompanionBuilder =
    FurnitureTableCompanion Function({
      Value<String> itemId,
      Value<String> slot,
      Value<bool> active,
      Value<bool> hidden,
      Value<double?> posX,
      Value<double?> posY,
      Value<int> rowid,
    });

class $$FurnitureTableTableFilterComposer
    extends Composer<_$AppDatabase, $FurnitureTableTable> {
  $$FurnitureTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get posX => $composableBuilder(
    column: $table.posX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get posY => $composableBuilder(
    column: $table.posY,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FurnitureTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FurnitureTableTable> {
  $$FurnitureTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get posX => $composableBuilder(
    column: $table.posX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get posY => $composableBuilder(
    column: $table.posY,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FurnitureTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FurnitureTableTable> {
  $$FurnitureTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<bool> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => column);

  GeneratedColumn<double> get posX =>
      $composableBuilder(column: $table.posX, builder: (column) => column);

  GeneratedColumn<double> get posY =>
      $composableBuilder(column: $table.posY, builder: (column) => column);
}

class $$FurnitureTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FurnitureTableTable,
          FurnitureRow,
          $$FurnitureTableTableFilterComposer,
          $$FurnitureTableTableOrderingComposer,
          $$FurnitureTableTableAnnotationComposer,
          $$FurnitureTableTableCreateCompanionBuilder,
          $$FurnitureTableTableUpdateCompanionBuilder,
          (
            FurnitureRow,
            BaseReferences<_$AppDatabase, $FurnitureTableTable, FurnitureRow>,
          ),
          FurnitureRow,
          PrefetchHooks Function()
        > {
  $$FurnitureTableTableTableManager(
    _$AppDatabase db,
    $FurnitureTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FurnitureTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FurnitureTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FurnitureTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> slot = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
                Value<double?> posX = const Value.absent(),
                Value<double?> posY = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FurnitureTableCompanion(
                itemId: itemId,
                slot: slot,
                active: active,
                hidden: hidden,
                posX: posX,
                posY: posY,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String slot,
                Value<bool> active = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
                Value<double?> posX = const Value.absent(),
                Value<double?> posY = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FurnitureTableCompanion.insert(
                itemId: itemId,
                slot: slot,
                active: active,
                hidden: hidden,
                posX: posX,
                posY: posY,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FurnitureTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FurnitureTableTable,
      FurnitureRow,
      $$FurnitureTableTableFilterComposer,
      $$FurnitureTableTableOrderingComposer,
      $$FurnitureTableTableAnnotationComposer,
      $$FurnitureTableTableCreateCompanionBuilder,
      $$FurnitureTableTableUpdateCompanionBuilder,
      (
        FurnitureRow,
        BaseReferences<_$AppDatabase, $FurnitureTableTable, FurnitureRow>,
      ),
      FurnitureRow,
      PrefetchHooks Function()
    >;
typedef $$RealMilestonesTableTableCreateCompanionBuilder =
    RealMilestonesTableCompanion Function({
      Value<int> rowId,
      Value<String> emoji,
      required String title,
      Value<int?> amountCents,
      Value<String> dateIso,
      Value<String> category,
    });
typedef $$RealMilestonesTableTableUpdateCompanionBuilder =
    RealMilestonesTableCompanion Function({
      Value<int> rowId,
      Value<String> emoji,
      Value<String> title,
      Value<int?> amountCents,
      Value<String> dateIso,
      Value<String> category,
    });

class $$RealMilestonesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RealMilestonesTableTable> {
  $$RealMilestonesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateIso => $composableBuilder(
    column: $table.dateIso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RealMilestonesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RealMilestonesTableTable> {
  $$RealMilestonesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateIso => $composableBuilder(
    column: $table.dateIso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RealMilestonesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RealMilestonesTableTable> {
  $$RealMilestonesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dateIso =>
      $composableBuilder(column: $table.dateIso, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$RealMilestonesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RealMilestonesTableTable,
          RealMilestoneRow,
          $$RealMilestonesTableTableFilterComposer,
          $$RealMilestonesTableTableOrderingComposer,
          $$RealMilestonesTableTableAnnotationComposer,
          $$RealMilestonesTableTableCreateCompanionBuilder,
          $$RealMilestonesTableTableUpdateCompanionBuilder,
          (
            RealMilestoneRow,
            BaseReferences<
              _$AppDatabase,
              $RealMilestonesTableTable,
              RealMilestoneRow
            >,
          ),
          RealMilestoneRow,
          PrefetchHooks Function()
        > {
  $$RealMilestonesTableTableTableManager(
    _$AppDatabase db,
    $RealMilestonesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RealMilestonesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RealMilestonesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RealMilestonesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> amountCents = const Value.absent(),
                Value<String> dateIso = const Value.absent(),
                Value<String> category = const Value.absent(),
              }) => RealMilestonesTableCompanion(
                rowId: rowId,
                emoji: emoji,
                title: title,
                amountCents: amountCents,
                dateIso: dateIso,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                required String title,
                Value<int?> amountCents = const Value.absent(),
                Value<String> dateIso = const Value.absent(),
                Value<String> category = const Value.absent(),
              }) => RealMilestonesTableCompanion.insert(
                rowId: rowId,
                emoji: emoji,
                title: title,
                amountCents: amountCents,
                dateIso: dateIso,
                category: category,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RealMilestonesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RealMilestonesTableTable,
      RealMilestoneRow,
      $$RealMilestonesTableTableFilterComposer,
      $$RealMilestonesTableTableOrderingComposer,
      $$RealMilestonesTableTableAnnotationComposer,
      $$RealMilestonesTableTableCreateCompanionBuilder,
      $$RealMilestonesTableTableUpdateCompanionBuilder,
      (
        RealMilestoneRow,
        BaseReferences<
          _$AppDatabase,
          $RealMilestonesTableTable,
          RealMilestoneRow
        >,
      ),
      RealMilestoneRow,
      PrefetchHooks Function()
    >;
typedef $$RealSavingsGoalsTableTableCreateCompanionBuilder =
    RealSavingsGoalsTableCompanion Function({
      Value<int> rowId,
      Value<String> emoji,
      required String title,
      required int targetCents,
      Value<int> savedCents,
      Value<String> status,
      Value<String> createdIso,
      Value<String> confirmedIso,
    });
typedef $$RealSavingsGoalsTableTableUpdateCompanionBuilder =
    RealSavingsGoalsTableCompanion Function({
      Value<int> rowId,
      Value<String> emoji,
      Value<String> title,
      Value<int> targetCents,
      Value<int> savedCents,
      Value<String> status,
      Value<String> createdIso,
      Value<String> confirmedIso,
    });

class $$RealSavingsGoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RealSavingsGoalsTableTable> {
  $$RealSavingsGoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savedCents => $composableBuilder(
    column: $table.savedCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdIso => $composableBuilder(
    column: $table.createdIso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmedIso => $composableBuilder(
    column: $table.confirmedIso,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RealSavingsGoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RealSavingsGoalsTableTable> {
  $$RealSavingsGoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savedCents => $composableBuilder(
    column: $table.savedCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdIso => $composableBuilder(
    column: $table.createdIso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmedIso => $composableBuilder(
    column: $table.confirmedIso,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RealSavingsGoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RealSavingsGoalsTableTable> {
  $$RealSavingsGoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savedCents => $composableBuilder(
    column: $table.savedCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdIso => $composableBuilder(
    column: $table.createdIso,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confirmedIso => $composableBuilder(
    column: $table.confirmedIso,
    builder: (column) => column,
  );
}

class $$RealSavingsGoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RealSavingsGoalsTableTable,
          RealSavingsGoalRow,
          $$RealSavingsGoalsTableTableFilterComposer,
          $$RealSavingsGoalsTableTableOrderingComposer,
          $$RealSavingsGoalsTableTableAnnotationComposer,
          $$RealSavingsGoalsTableTableCreateCompanionBuilder,
          $$RealSavingsGoalsTableTableUpdateCompanionBuilder,
          (
            RealSavingsGoalRow,
            BaseReferences<
              _$AppDatabase,
              $RealSavingsGoalsTableTable,
              RealSavingsGoalRow
            >,
          ),
          RealSavingsGoalRow,
          PrefetchHooks Function()
        > {
  $$RealSavingsGoalsTableTableTableManager(
    _$AppDatabase db,
    $RealSavingsGoalsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RealSavingsGoalsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RealSavingsGoalsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RealSavingsGoalsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> targetCents = const Value.absent(),
                Value<int> savedCents = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdIso = const Value.absent(),
                Value<String> confirmedIso = const Value.absent(),
              }) => RealSavingsGoalsTableCompanion(
                rowId: rowId,
                emoji: emoji,
                title: title,
                targetCents: targetCents,
                savedCents: savedCents,
                status: status,
                createdIso: createdIso,
                confirmedIso: confirmedIso,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                required String title,
                required int targetCents,
                Value<int> savedCents = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdIso = const Value.absent(),
                Value<String> confirmedIso = const Value.absent(),
              }) => RealSavingsGoalsTableCompanion.insert(
                rowId: rowId,
                emoji: emoji,
                title: title,
                targetCents: targetCents,
                savedCents: savedCents,
                status: status,
                createdIso: createdIso,
                confirmedIso: confirmedIso,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RealSavingsGoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RealSavingsGoalsTableTable,
      RealSavingsGoalRow,
      $$RealSavingsGoalsTableTableFilterComposer,
      $$RealSavingsGoalsTableTableOrderingComposer,
      $$RealSavingsGoalsTableTableAnnotationComposer,
      $$RealSavingsGoalsTableTableCreateCompanionBuilder,
      $$RealSavingsGoalsTableTableUpdateCompanionBuilder,
      (
        RealSavingsGoalRow,
        BaseReferences<
          _$AppDatabase,
          $RealSavingsGoalsTableTable,
          RealSavingsGoalRow
        >,
      ),
      RealSavingsGoalRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GameClockTableTableTableManager get gameClockTable =>
      $$GameClockTableTableTableManager(_db, _db.gameClockTable);
  $$CashTableTableTableManager get cashTable =>
      $$CashTableTableTableManager(_db, _db.cashTable);
  $$PlantsTableTableTableManager get plantsTable =>
      $$PlantsTableTableTableManager(_db, _db.plantsTable);
  $$EtfHoldingsTableTableTableManager get etfHoldingsTable =>
      $$EtfHoldingsTableTableTableManager(_db, _db.etfHoldingsTable);
  $$EtfQuotesTableTableTableManager get etfQuotesTable =>
      $$EtfQuotesTableTableTableManager(_db, _db.etfQuotesTable);
  $$StockHoldingsTableTableTableManager get stockHoldingsTable =>
      $$StockHoldingsTableTableTableManager(_db, _db.stockHoldingsTable);
  $$StockQuotesTableTableTableManager get stockQuotesTable =>
      $$StockQuotesTableTableTableManager(_db, _db.stockQuotesTable);
  $$CryptoHoldingsTableTableTableManager get cryptoHoldingsTable =>
      $$CryptoHoldingsTableTableTableManager(_db, _db.cryptoHoldingsTable);
  $$CryptoQuotesTableTableTableManager get cryptoQuotesTable =>
      $$CryptoQuotesTableTableTableManager(_db, _db.cryptoQuotesTable);
  $$MetalHoldingsTableTableTableManager get metalHoldingsTable =>
      $$MetalHoldingsTableTableTableManager(_db, _db.metalHoldingsTable);
  $$MetalQuotesTableTableTableManager get metalQuotesTable =>
      $$MetalQuotesTableTableTableManager(_db, _db.metalQuotesTable);
  $$RealEstateHoldingsTableTableTableManager get realEstateHoldingsTable =>
      $$RealEstateHoldingsTableTableTableManager(
        _db,
        _db.realEstateHoldingsTable,
      );
  $$CollectibleHoldingsTableTableTableManager get collectibleHoldingsTable =>
      $$CollectibleHoldingsTableTableTableManager(
        _db,
        _db.collectibleHoldingsTable,
      );
  $$IslandDecorTableTableTableManager get islandDecorTable =>
      $$IslandDecorTableTableTableManager(_db, _db.islandDecorTable);
  $$QuestPassivePaymentsTableTableTableManager get questPassivePaymentsTable =>
      $$QuestPassivePaymentsTableTableTableManager(
        _db,
        _db.questPassivePaymentsTable,
      );
  $$VorsorgeContractsTableTableTableManager get vorsorgeContractsTable =>
      $$VorsorgeContractsTableTableTableManager(
        _db,
        _db.vorsorgeContractsTable,
      );
  $$SavingsPlansTableTableTableManager get savingsPlansTable =>
      $$SavingsPlansTableTableTableManager(_db, _db.savingsPlansTable);
  $$WishItemsTableTableTableManager get wishItemsTable =>
      $$WishItemsTableTableTableManager(_db, _db.wishItemsTable);
  $$PriceHistoryTableTableTableManager get priceHistoryTable =>
      $$PriceHistoryTableTableTableManager(_db, _db.priceHistoryTable);
  $$UnlockedIslandsTableTableTableManager get unlockedIslandsTable =>
      $$UnlockedIslandsTableTableTableManager(_db, _db.unlockedIslandsTable);
  $$QuestProgressTableTableTableManager get questProgressTable =>
      $$QuestProgressTableTableTableManager(_db, _db.questProgressTable);
  $$QuestChatEntriesTableTableTableManager get questChatEntriesTable =>
      $$QuestChatEntriesTableTableTableManager(_db, _db.questChatEntriesTable);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$XpTableTableTableManager get xpTable =>
      $$XpTableTableTableManager(_db, _db.xpTable);
  $$SavingsTableTableTableManager get savingsTable =>
      $$SavingsTableTableTableManager(_db, _db.savingsTable);
  $$AchievementsTableTableTableManager get achievementsTable =>
      $$AchievementsTableTableTableManager(_db, _db.achievementsTable);
  $$LuckyEventHistoryTableTableTableManager get luckyEventHistoryTable =>
      $$LuckyEventHistoryTableTableTableManager(
        _db,
        _db.luckyEventHistoryTable,
      );
  $$NewGameStateTableTableTableManager get newGameStateTable =>
      $$NewGameStateTableTableTableManager(_db, _db.newGameStateTable);
  $$TreeHoldingsTableTableTableManager get treeHoldingsTable =>
      $$TreeHoldingsTableTableTableManager(_db, _db.treeHoldingsTable);
  $$JobActionStateTableTableTableManager get jobActionStateTable =>
      $$JobActionStateTableTableTableManager(_db, _db.jobActionStateTable);
  $$QuestFailureTableTableTableManager get questFailureTable =>
      $$QuestFailureTableTableTableManager(_db, _db.questFailureTable);
  $$FurnitureTableTableTableManager get furnitureTable =>
      $$FurnitureTableTableTableManager(_db, _db.furnitureTable);
  $$RealMilestonesTableTableTableManager get realMilestonesTable =>
      $$RealMilestonesTableTableTableManager(_db, _db.realMilestonesTable);
  $$RealSavingsGoalsTableTableTableManager get realSavingsGoalsTable =>
      $$RealSavingsGoalsTableTableTableManager(_db, _db.realSavingsGoalsTable);
}
