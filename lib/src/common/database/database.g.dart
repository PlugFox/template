// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class SettingsTbl extends Table with TableInfo<SettingsTbl, SettingsTblData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SettingsTbl(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL PRIMARY KEY');
  static const VerificationMeta _jsonDataMeta =
      const VerificationMeta('jsonData');
  late final GeneratedColumn<String> jsonData = GeneratedColumn<String>(
      'json_data', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL CHECK (length(json_data) > 2 AND json_valid(json_data))');
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
      'memo', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _metaCreatedAtMeta =
      const VerificationMeta('metaCreatedAt');
  late final GeneratedColumn<int> metaCreatedAt = GeneratedColumn<int>(
      'meta_created_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  static const VerificationMeta _metaUpdatedAtMeta =
      const VerificationMeta('metaUpdatedAt');
  late final GeneratedColumn<int> metaUpdatedAt = GeneratedColumn<int>(
      'meta_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT (strftime(\'%s\', \'now\')) CHECK (meta_updated_at >= meta_created_at)',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  @override
  List<GeneratedColumn> get $columns =>
      [userId, jsonData, memo, metaCreatedAt, metaUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_tbl';
  @override
  VerificationContext validateIntegrity(Insertable<SettingsTblData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('json_data')) {
      context.handle(_jsonDataMeta,
          jsonData.isAcceptableOrUnknown(data['json_data']!, _jsonDataMeta));
    } else if (isInserting) {
      context.missing(_jsonDataMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
          _memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    if (data.containsKey('meta_created_at')) {
      context.handle(
          _metaCreatedAtMeta,
          metaCreatedAt.isAcceptableOrUnknown(
              data['meta_created_at']!, _metaCreatedAtMeta));
    }
    if (data.containsKey('meta_updated_at')) {
      context.handle(
          _metaUpdatedAtMeta,
          metaUpdatedAt.isAcceptableOrUnknown(
              data['meta_updated_at']!, _metaUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  SettingsTblData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsTblData(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      jsonData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json_data'])!,
      memo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memo']),
      metaCreatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meta_created_at'])!,
      metaUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meta_updated_at'])!,
    );
  }

  @override
  SettingsTbl createAlias(String alias) {
    return SettingsTbl(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class SettingsTblData extends DataClass implements Insertable<SettingsTblData> {
  /// User ID
  final String userId;

  /// JSON data
  final String jsonData;

  /// Description
  final String? memo;

  /// Created date (unixtime in seconds)
  final int metaCreatedAt;

  /// Updated date (unixtime in seconds)
  final int metaUpdatedAt;
  const SettingsTblData(
      {required this.userId,
      required this.jsonData,
      this.memo,
      required this.metaCreatedAt,
      required this.metaUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['json_data'] = Variable<String>(jsonData);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['meta_created_at'] = Variable<int>(metaCreatedAt);
    map['meta_updated_at'] = Variable<int>(metaUpdatedAt);
    return map;
  }

  SettingsTblCompanion toCompanion(bool nullToAbsent) {
    return SettingsTblCompanion(
      userId: Value(userId),
      jsonData: Value(jsonData),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      metaCreatedAt: Value(metaCreatedAt),
      metaUpdatedAt: Value(metaUpdatedAt),
    );
  }

  factory SettingsTblData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsTblData(
      userId: serializer.fromJson<String>(json['user_id']),
      jsonData: serializer.fromJson<String>(json['json_data']),
      memo: serializer.fromJson<String?>(json['memo']),
      metaCreatedAt: serializer.fromJson<int>(json['meta_created_at']),
      metaUpdatedAt: serializer.fromJson<int>(json['meta_updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'user_id': serializer.toJson<String>(userId),
      'json_data': serializer.toJson<String>(jsonData),
      'memo': serializer.toJson<String?>(memo),
      'meta_created_at': serializer.toJson<int>(metaCreatedAt),
      'meta_updated_at': serializer.toJson<int>(metaUpdatedAt),
    };
  }

  SettingsTblData copyWith(
          {String? userId,
          String? jsonData,
          Value<String?> memo = const Value.absent(),
          int? metaCreatedAt,
          int? metaUpdatedAt}) =>
      SettingsTblData(
        userId: userId ?? this.userId,
        jsonData: jsonData ?? this.jsonData,
        memo: memo.present ? memo.value : this.memo,
        metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
        metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('SettingsTblData(')
          ..write('userId: $userId, ')
          ..write('jsonData: $jsonData, ')
          ..write('memo: $memo, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, jsonData, memo, metaCreatedAt, metaUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsTblData &&
          other.userId == this.userId &&
          other.jsonData == this.jsonData &&
          other.memo == this.memo &&
          other.metaCreatedAt == this.metaCreatedAt &&
          other.metaUpdatedAt == this.metaUpdatedAt);
}

class SettingsTblCompanion extends UpdateCompanion<SettingsTblData> {
  final Value<String> userId;
  final Value<String> jsonData;
  final Value<String?> memo;
  final Value<int> metaCreatedAt;
  final Value<int> metaUpdatedAt;
  final Value<int> rowid;
  const SettingsTblCompanion({
    this.userId = const Value.absent(),
    this.jsonData = const Value.absent(),
    this.memo = const Value.absent(),
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsTblCompanion.insert({
    required String userId,
    required String jsonData,
    this.memo = const Value.absent(),
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        jsonData = Value(jsonData);
  static Insertable<SettingsTblData> custom({
    Expression<String>? userId,
    Expression<String>? jsonData,
    Expression<String>? memo,
    Expression<int>? metaCreatedAt,
    Expression<int>? metaUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (jsonData != null) 'json_data': jsonData,
      if (memo != null) 'memo': memo,
      if (metaCreatedAt != null) 'meta_created_at': metaCreatedAt,
      if (metaUpdatedAt != null) 'meta_updated_at': metaUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsTblCompanion copyWith(
      {Value<String>? userId,
      Value<String>? jsonData,
      Value<String?>? memo,
      Value<int>? metaCreatedAt,
      Value<int>? metaUpdatedAt,
      Value<int>? rowid}) {
    return SettingsTblCompanion(
      userId: userId ?? this.userId,
      jsonData: jsonData ?? this.jsonData,
      memo: memo ?? this.memo,
      metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
      metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (jsonData.present) {
      map['json_data'] = Variable<String>(jsonData.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (metaCreatedAt.present) {
      map['meta_created_at'] = Variable<int>(metaCreatedAt.value);
    }
    if (metaUpdatedAt.present) {
      map['meta_updated_at'] = Variable<int>(metaUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTblCompanion(')
          ..write('userId: $userId, ')
          ..write('jsonData: $jsonData, ')
          ..write('memo: $memo, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class LogTbl extends Table with TableInfo<LogTbl, LogTblData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LogTbl(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
      'time', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _stackMeta = const VerificationMeta('stack');
  late final GeneratedColumn<String> stack = GeneratedColumn<String>(
      'stack', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [id, time, level, message, stack];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'log_tbl';
  @override
  VerificationContext validateIntegrity(Insertable<LogTblData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('stack')) {
      context.handle(
          _stackMeta, stack.isAcceptableOrUnknown(data['stack']!, _stackMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LogTblData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogTblData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      stack: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stack']),
    );
  }

  @override
  LogTbl createAlias(String alias) {
    return LogTbl(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class LogTblData extends DataClass implements Insertable<LogTblData> {
  /// req Unique identifier of the log
  final int id;

  /// Time is the timestamp (in seconds) of the log message
  final int time;

  /// Level is the severity level (a value between 0 and 6)
  final int level;

  /// req Message is the log message or error associated with this log event
  final String message;

  /// StackTrace a stack trace associated with this log event
  final String? stack;
  const LogTblData(
      {required this.id,
      required this.time,
      required this.level,
      required this.message,
      this.stack});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['time'] = Variable<int>(time);
    map['level'] = Variable<int>(level);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || stack != null) {
      map['stack'] = Variable<String>(stack);
    }
    return map;
  }

  LogTblCompanion toCompanion(bool nullToAbsent) {
    return LogTblCompanion(
      id: Value(id),
      time: Value(time),
      level: Value(level),
      message: Value(message),
      stack:
          stack == null && nullToAbsent ? const Value.absent() : Value(stack),
    );
  }

  factory LogTblData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogTblData(
      id: serializer.fromJson<int>(json['id']),
      time: serializer.fromJson<int>(json['time']),
      level: serializer.fromJson<int>(json['level']),
      message: serializer.fromJson<String>(json['message']),
      stack: serializer.fromJson<String?>(json['stack']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'time': serializer.toJson<int>(time),
      'level': serializer.toJson<int>(level),
      'message': serializer.toJson<String>(message),
      'stack': serializer.toJson<String?>(stack),
    };
  }

  LogTblData copyWith(
          {int? id,
          int? time,
          int? level,
          String? message,
          Value<String?> stack = const Value.absent()}) =>
      LogTblData(
        id: id ?? this.id,
        time: time ?? this.time,
        level: level ?? this.level,
        message: message ?? this.message,
        stack: stack.present ? stack.value : this.stack,
      );
  @override
  String toString() {
    return (StringBuffer('LogTblData(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('stack: $stack')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, time, level, message, stack);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogTblData &&
          other.id == this.id &&
          other.time == this.time &&
          other.level == this.level &&
          other.message == this.message &&
          other.stack == this.stack);
}

class LogTblCompanion extends UpdateCompanion<LogTblData> {
  final Value<int> id;
  final Value<int> time;
  final Value<int> level;
  final Value<String> message;
  final Value<String?> stack;
  const LogTblCompanion({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
    this.level = const Value.absent(),
    this.message = const Value.absent(),
    this.stack = const Value.absent(),
  });
  LogTblCompanion.insert({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
    required int level,
    required String message,
    this.stack = const Value.absent(),
  })  : level = Value(level),
        message = Value(message);
  static Insertable<LogTblData> custom({
    Expression<int>? id,
    Expression<int>? time,
    Expression<int>? level,
    Expression<String>? message,
    Expression<String>? stack,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (time != null) 'time': time,
      if (level != null) 'level': level,
      if (message != null) 'message': message,
      if (stack != null) 'stack': stack,
    });
  }

  LogTblCompanion copyWith(
      {Value<int>? id,
      Value<int>? time,
      Value<int>? level,
      Value<String>? message,
      Value<String?>? stack}) {
    return LogTblCompanion(
      id: id ?? this.id,
      time: time ?? this.time,
      level: level ?? this.level,
      message: message ?? this.message,
      stack: stack ?? this.stack,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (stack.present) {
      map['stack'] = Variable<String>(stack.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogTblCompanion(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('stack: $stack')
          ..write(')'))
        .toString();
  }
}

class LogPrefixTbl extends Table
    with TableInfo<LogPrefixTbl, LogPrefixTblData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LogPrefixTbl(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _prefixMeta = const VerificationMeta('prefix');
  late final GeneratedColumn<String> prefix = GeneratedColumn<String>(
      'prefix', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _logIdMeta = const VerificationMeta('logId');
  late final GeneratedColumn<int> logId = GeneratedColumn<int>(
      'log_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _lenMeta = const VerificationMeta('len');
  late final GeneratedColumn<int> len = GeneratedColumn<int>(
      'len', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [prefix, logId, word, len];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'log_prefix_tbl';
  @override
  VerificationContext validateIntegrity(Insertable<LogPrefixTblData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('prefix')) {
      context.handle(_prefixMeta,
          prefix.isAcceptableOrUnknown(data['prefix']!, _prefixMeta));
    } else if (isInserting) {
      context.missing(_prefixMeta);
    }
    if (data.containsKey('log_id')) {
      context.handle(
          _logIdMeta, logId.isAcceptableOrUnknown(data['log_id']!, _logIdMeta));
    } else if (isInserting) {
      context.missing(_logIdMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('len')) {
      context.handle(
          _lenMeta, len.isAcceptableOrUnknown(data['len']!, _lenMeta));
    } else if (isInserting) {
      context.missing(_lenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {prefix, logId, word};
  @override
  LogPrefixTblData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogPrefixTblData(
      prefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prefix'])!,
      logId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}log_id'])!,
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
      len: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}len'])!,
    );
  }

  @override
  LogPrefixTbl createAlias(String alias) {
    return LogPrefixTbl(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const [
        'PRIMARY KEY(prefix, log_id, word)',
        'FOREIGN KEY(log_id)REFERENCES log_tbl(id)ON UPDATE CASCADE ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class LogPrefixTblData extends DataClass
    implements Insertable<LogPrefixTblData> {
  /// req Prefix (first 3 chars of word, lowercased)
  final String prefix;

  /// req Unique identifier
  /// CHECK(length(prefix) = 3)
  final int logId;

  /// req Word (3 or more chars, lowercased)
  final String word;

  /// req Word's length
  final int len;
  const LogPrefixTblData(
      {required this.prefix,
      required this.logId,
      required this.word,
      required this.len});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['prefix'] = Variable<String>(prefix);
    map['log_id'] = Variable<int>(logId);
    map['word'] = Variable<String>(word);
    map['len'] = Variable<int>(len);
    return map;
  }

  LogPrefixTblCompanion toCompanion(bool nullToAbsent) {
    return LogPrefixTblCompanion(
      prefix: Value(prefix),
      logId: Value(logId),
      word: Value(word),
      len: Value(len),
    );
  }

  factory LogPrefixTblData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogPrefixTblData(
      prefix: serializer.fromJson<String>(json['prefix']),
      logId: serializer.fromJson<int>(json['log_id']),
      word: serializer.fromJson<String>(json['word']),
      len: serializer.fromJson<int>(json['len']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'prefix': serializer.toJson<String>(prefix),
      'log_id': serializer.toJson<int>(logId),
      'word': serializer.toJson<String>(word),
      'len': serializer.toJson<int>(len),
    };
  }

  LogPrefixTblData copyWith(
          {String? prefix, int? logId, String? word, int? len}) =>
      LogPrefixTblData(
        prefix: prefix ?? this.prefix,
        logId: logId ?? this.logId,
        word: word ?? this.word,
        len: len ?? this.len,
      );
  @override
  String toString() {
    return (StringBuffer('LogPrefixTblData(')
          ..write('prefix: $prefix, ')
          ..write('logId: $logId, ')
          ..write('word: $word, ')
          ..write('len: $len')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(prefix, logId, word, len);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogPrefixTblData &&
          other.prefix == this.prefix &&
          other.logId == this.logId &&
          other.word == this.word &&
          other.len == this.len);
}

class LogPrefixTblCompanion extends UpdateCompanion<LogPrefixTblData> {
  final Value<String> prefix;
  final Value<int> logId;
  final Value<String> word;
  final Value<int> len;
  final Value<int> rowid;
  const LogPrefixTblCompanion({
    this.prefix = const Value.absent(),
    this.logId = const Value.absent(),
    this.word = const Value.absent(),
    this.len = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LogPrefixTblCompanion.insert({
    required String prefix,
    required int logId,
    required String word,
    required int len,
    this.rowid = const Value.absent(),
  })  : prefix = Value(prefix),
        logId = Value(logId),
        word = Value(word),
        len = Value(len);
  static Insertable<LogPrefixTblData> custom({
    Expression<String>? prefix,
    Expression<int>? logId,
    Expression<String>? word,
    Expression<int>? len,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (prefix != null) 'prefix': prefix,
      if (logId != null) 'log_id': logId,
      if (word != null) 'word': word,
      if (len != null) 'len': len,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LogPrefixTblCompanion copyWith(
      {Value<String>? prefix,
      Value<int>? logId,
      Value<String>? word,
      Value<int>? len,
      Value<int>? rowid}) {
    return LogPrefixTblCompanion(
      prefix: prefix ?? this.prefix,
      logId: logId ?? this.logId,
      word: word ?? this.word,
      len: len ?? this.len,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (prefix.present) {
      map['prefix'] = Variable<String>(prefix.value);
    }
    if (logId.present) {
      map['log_id'] = Variable<int>(logId.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (len.present) {
      map['len'] = Variable<int>(len.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogPrefixTblCompanion(')
          ..write('prefix: $prefix, ')
          ..write('logId: $logId, ')
          ..write('word: $word, ')
          ..write('len: $len, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class CharacteristicTbl extends Table
    with TableInfo<CharacteristicTbl, CharacteristicTblData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CharacteristicTbl(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL CHECK (length(type) > 0 AND length(type) <= 255)');
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL CHECK (length(data) > 2 AND json_valid(data))');
  static const VerificationMeta _metaCreatedAtMeta =
      const VerificationMeta('metaCreatedAt');
  late final GeneratedColumn<int> metaCreatedAt = GeneratedColumn<int>(
      'meta_created_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  static const VerificationMeta _metaUpdatedAtMeta =
      const VerificationMeta('metaUpdatedAt');
  late final GeneratedColumn<int> metaUpdatedAt = GeneratedColumn<int>(
      'meta_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT (strftime(\'%s\', \'now\')) CHECK (meta_updated_at >= meta_created_at)',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  @override
  List<GeneratedColumn> get $columns =>
      [type, id, data, metaCreatedAt, metaUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characteristic_tbl';
  @override
  VerificationContext validateIntegrity(
      Insertable<CharacteristicTblData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('meta_created_at')) {
      context.handle(
          _metaCreatedAtMeta,
          metaCreatedAt.isAcceptableOrUnknown(
              data['meta_created_at']!, _metaCreatedAtMeta));
    }
    if (data.containsKey('meta_updated_at')) {
      context.handle(
          _metaUpdatedAtMeta,
          metaUpdatedAt.isAcceptableOrUnknown(
              data['meta_updated_at']!, _metaUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {type, id};
  @override
  CharacteristicTblData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacteristicTblData(
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      metaCreatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meta_created_at'])!,
      metaUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meta_updated_at'])!,
    );
  }

  @override
  CharacteristicTbl createAlias(String alias) {
    return CharacteristicTbl(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const ['PRIMARY KEY(type, id)'];
  @override
  bool get dontWriteConstraints => true;
}

class CharacteristicTblData extends DataClass
    implements Insertable<CharacteristicTblData> {
  /// req Type
  final String type;

  /// req ID
  final int id;

  /// JSON data
  final String data;

  /// Created date (unixtime in seconds)
  final int metaCreatedAt;

  /// Updated date (unixtime in seconds)
  final int metaUpdatedAt;
  const CharacteristicTblData(
      {required this.type,
      required this.id,
      required this.data,
      required this.metaCreatedAt,
      required this.metaUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['type'] = Variable<String>(type);
    map['id'] = Variable<int>(id);
    map['data'] = Variable<String>(data);
    map['meta_created_at'] = Variable<int>(metaCreatedAt);
    map['meta_updated_at'] = Variable<int>(metaUpdatedAt);
    return map;
  }

  CharacteristicTblCompanion toCompanion(bool nullToAbsent) {
    return CharacteristicTblCompanion(
      type: Value(type),
      id: Value(id),
      data: Value(data),
      metaCreatedAt: Value(metaCreatedAt),
      metaUpdatedAt: Value(metaUpdatedAt),
    );
  }

  factory CharacteristicTblData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacteristicTblData(
      type: serializer.fromJson<String>(json['type']),
      id: serializer.fromJson<int>(json['id']),
      data: serializer.fromJson<String>(json['data']),
      metaCreatedAt: serializer.fromJson<int>(json['meta_created_at']),
      metaUpdatedAt: serializer.fromJson<int>(json['meta_updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'type': serializer.toJson<String>(type),
      'id': serializer.toJson<int>(id),
      'data': serializer.toJson<String>(data),
      'meta_created_at': serializer.toJson<int>(metaCreatedAt),
      'meta_updated_at': serializer.toJson<int>(metaUpdatedAt),
    };
  }

  CharacteristicTblData copyWith(
          {String? type,
          int? id,
          String? data,
          int? metaCreatedAt,
          int? metaUpdatedAt}) =>
      CharacteristicTblData(
        type: type ?? this.type,
        id: id ?? this.id,
        data: data ?? this.data,
        metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
        metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('CharacteristicTblData(')
          ..write('type: $type, ')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(type, id, data, metaCreatedAt, metaUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacteristicTblData &&
          other.type == this.type &&
          other.id == this.id &&
          other.data == this.data &&
          other.metaCreatedAt == this.metaCreatedAt &&
          other.metaUpdatedAt == this.metaUpdatedAt);
}

class CharacteristicTblCompanion
    extends UpdateCompanion<CharacteristicTblData> {
  final Value<String> type;
  final Value<int> id;
  final Value<String> data;
  final Value<int> metaCreatedAt;
  final Value<int> metaUpdatedAt;
  final Value<int> rowid;
  const CharacteristicTblCompanion({
    this.type = const Value.absent(),
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacteristicTblCompanion.insert({
    required String type,
    required int id,
    required String data,
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : type = Value(type),
        id = Value(id),
        data = Value(data);
  static Insertable<CharacteristicTblData> custom({
    Expression<String>? type,
    Expression<int>? id,
    Expression<String>? data,
    Expression<int>? metaCreatedAt,
    Expression<int>? metaUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (type != null) 'type': type,
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (metaCreatedAt != null) 'meta_created_at': metaCreatedAt,
      if (metaUpdatedAt != null) 'meta_updated_at': metaUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacteristicTblCompanion copyWith(
      {Value<String>? type,
      Value<int>? id,
      Value<String>? data,
      Value<int>? metaCreatedAt,
      Value<int>? metaUpdatedAt,
      Value<int>? rowid}) {
    return CharacteristicTblCompanion(
      type: type ?? this.type,
      id: id ?? this.id,
      data: data ?? this.data,
      metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
      metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (metaCreatedAt.present) {
      map['meta_created_at'] = Variable<int>(metaCreatedAt.value);
    }
    if (metaUpdatedAt.present) {
      map['meta_updated_at'] = Variable<int>(metaUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacteristicTblCompanion(')
          ..write('type: $type, ')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class KvTbl extends Table with TableInfo<KvTbl, KvTblData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  KvTbl(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kMeta = const VerificationMeta('k');
  late final GeneratedColumn<String> k = GeneratedColumn<String>(
      'k', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL PRIMARY KEY');
  static const VerificationMeta _vstringMeta =
      const VerificationMeta('vstring');
  late final GeneratedColumn<String> vstring = GeneratedColumn<String>(
      'vstring', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _vintMeta = const VerificationMeta('vint');
  late final GeneratedColumn<int> vint = GeneratedColumn<int>(
      'vint', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _vdoubleMeta =
      const VerificationMeta('vdouble');
  late final GeneratedColumn<double> vdouble = GeneratedColumn<double>(
      'vdouble', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _vboolMeta = const VerificationMeta('vbool');
  late final GeneratedColumn<int> vbool = GeneratedColumn<int>(
      'vbool', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _metaCreatedAtMeta =
      const VerificationMeta('metaCreatedAt');
  late final GeneratedColumn<int> metaCreatedAt = GeneratedColumn<int>(
      'meta_created_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  static const VerificationMeta _metaUpdatedAtMeta =
      const VerificationMeta('metaUpdatedAt');
  late final GeneratedColumn<int> metaUpdatedAt = GeneratedColumn<int>(
      'meta_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT (strftime(\'%s\', \'now\')) CHECK (meta_updated_at >= meta_created_at)',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  @override
  List<GeneratedColumn> get $columns =>
      [k, vstring, vint, vdouble, vbool, metaCreatedAt, metaUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kv_tbl';
  @override
  VerificationContext validateIntegrity(Insertable<KvTblData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('k')) {
      context.handle(_kMeta, k.isAcceptableOrUnknown(data['k']!, _kMeta));
    } else if (isInserting) {
      context.missing(_kMeta);
    }
    if (data.containsKey('vstring')) {
      context.handle(_vstringMeta,
          vstring.isAcceptableOrUnknown(data['vstring']!, _vstringMeta));
    }
    if (data.containsKey('vint')) {
      context.handle(
          _vintMeta, vint.isAcceptableOrUnknown(data['vint']!, _vintMeta));
    }
    if (data.containsKey('vdouble')) {
      context.handle(_vdoubleMeta,
          vdouble.isAcceptableOrUnknown(data['vdouble']!, _vdoubleMeta));
    }
    if (data.containsKey('vbool')) {
      context.handle(
          _vboolMeta, vbool.isAcceptableOrUnknown(data['vbool']!, _vboolMeta));
    }
    if (data.containsKey('meta_created_at')) {
      context.handle(
          _metaCreatedAtMeta,
          metaCreatedAt.isAcceptableOrUnknown(
              data['meta_created_at']!, _metaCreatedAtMeta));
    }
    if (data.containsKey('meta_updated_at')) {
      context.handle(
          _metaUpdatedAtMeta,
          metaUpdatedAt.isAcceptableOrUnknown(
              data['meta_updated_at']!, _metaUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {k};
  @override
  KvTblData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KvTblData(
      k: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}k'])!,
      vstring: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vstring']),
      vint: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vint']),
      vdouble: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vdouble']),
      vbool: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vbool']),
      metaCreatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meta_created_at'])!,
      metaUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meta_updated_at'])!,
    );
  }

  @override
  KvTbl createAlias(String alias) {
    return KvTbl(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class KvTblData extends DataClass implements Insertable<KvTblData> {
  /// req Key
  final String k;

  /// string
  final String? vstring;

  /// Integer
  final int? vint;

  /// Float
  final double? vdouble;

  /// Boolean
  final int? vbool;

  /// req Created date (unixtime in seconds)
  ///vblob BLOB,
  /// Binary
  final int metaCreatedAt;

  /// req Updated date (unixtime in seconds)
  final int metaUpdatedAt;
  const KvTblData(
      {required this.k,
      this.vstring,
      this.vint,
      this.vdouble,
      this.vbool,
      required this.metaCreatedAt,
      required this.metaUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['k'] = Variable<String>(k);
    if (!nullToAbsent || vstring != null) {
      map['vstring'] = Variable<String>(vstring);
    }
    if (!nullToAbsent || vint != null) {
      map['vint'] = Variable<int>(vint);
    }
    if (!nullToAbsent || vdouble != null) {
      map['vdouble'] = Variable<double>(vdouble);
    }
    if (!nullToAbsent || vbool != null) {
      map['vbool'] = Variable<int>(vbool);
    }
    map['meta_created_at'] = Variable<int>(metaCreatedAt);
    map['meta_updated_at'] = Variable<int>(metaUpdatedAt);
    return map;
  }

  KvTblCompanion toCompanion(bool nullToAbsent) {
    return KvTblCompanion(
      k: Value(k),
      vstring: vstring == null && nullToAbsent
          ? const Value.absent()
          : Value(vstring),
      vint: vint == null && nullToAbsent ? const Value.absent() : Value(vint),
      vdouble: vdouble == null && nullToAbsent
          ? const Value.absent()
          : Value(vdouble),
      vbool:
          vbool == null && nullToAbsent ? const Value.absent() : Value(vbool),
      metaCreatedAt: Value(metaCreatedAt),
      metaUpdatedAt: Value(metaUpdatedAt),
    );
  }

  factory KvTblData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KvTblData(
      k: serializer.fromJson<String>(json['k']),
      vstring: serializer.fromJson<String?>(json['vstring']),
      vint: serializer.fromJson<int?>(json['vint']),
      vdouble: serializer.fromJson<double?>(json['vdouble']),
      vbool: serializer.fromJson<int?>(json['vbool']),
      metaCreatedAt: serializer.fromJson<int>(json['meta_created_at']),
      metaUpdatedAt: serializer.fromJson<int>(json['meta_updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'k': serializer.toJson<String>(k),
      'vstring': serializer.toJson<String?>(vstring),
      'vint': serializer.toJson<int?>(vint),
      'vdouble': serializer.toJson<double?>(vdouble),
      'vbool': serializer.toJson<int?>(vbool),
      'meta_created_at': serializer.toJson<int>(metaCreatedAt),
      'meta_updated_at': serializer.toJson<int>(metaUpdatedAt),
    };
  }

  KvTblData copyWith(
          {String? k,
          Value<String?> vstring = const Value.absent(),
          Value<int?> vint = const Value.absent(),
          Value<double?> vdouble = const Value.absent(),
          Value<int?> vbool = const Value.absent(),
          int? metaCreatedAt,
          int? metaUpdatedAt}) =>
      KvTblData(
        k: k ?? this.k,
        vstring: vstring.present ? vstring.value : this.vstring,
        vint: vint.present ? vint.value : this.vint,
        vdouble: vdouble.present ? vdouble.value : this.vdouble,
        vbool: vbool.present ? vbool.value : this.vbool,
        metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
        metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('KvTblData(')
          ..write('k: $k, ')
          ..write('vstring: $vstring, ')
          ..write('vint: $vint, ')
          ..write('vdouble: $vdouble, ')
          ..write('vbool: $vbool, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      k, vstring, vint, vdouble, vbool, metaCreatedAt, metaUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KvTblData &&
          other.k == this.k &&
          other.vstring == this.vstring &&
          other.vint == this.vint &&
          other.vdouble == this.vdouble &&
          other.vbool == this.vbool &&
          other.metaCreatedAt == this.metaCreatedAt &&
          other.metaUpdatedAt == this.metaUpdatedAt);
}

class KvTblCompanion extends UpdateCompanion<KvTblData> {
  final Value<String> k;
  final Value<String?> vstring;
  final Value<int?> vint;
  final Value<double?> vdouble;
  final Value<int?> vbool;
  final Value<int> metaCreatedAt;
  final Value<int> metaUpdatedAt;
  final Value<int> rowid;
  const KvTblCompanion({
    this.k = const Value.absent(),
    this.vstring = const Value.absent(),
    this.vint = const Value.absent(),
    this.vdouble = const Value.absent(),
    this.vbool = const Value.absent(),
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KvTblCompanion.insert({
    required String k,
    this.vstring = const Value.absent(),
    this.vint = const Value.absent(),
    this.vdouble = const Value.absent(),
    this.vbool = const Value.absent(),
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : k = Value(k);
  static Insertable<KvTblData> custom({
    Expression<String>? k,
    Expression<String>? vstring,
    Expression<int>? vint,
    Expression<double>? vdouble,
    Expression<int>? vbool,
    Expression<int>? metaCreatedAt,
    Expression<int>? metaUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (k != null) 'k': k,
      if (vstring != null) 'vstring': vstring,
      if (vint != null) 'vint': vint,
      if (vdouble != null) 'vdouble': vdouble,
      if (vbool != null) 'vbool': vbool,
      if (metaCreatedAt != null) 'meta_created_at': metaCreatedAt,
      if (metaUpdatedAt != null) 'meta_updated_at': metaUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KvTblCompanion copyWith(
      {Value<String>? k,
      Value<String?>? vstring,
      Value<int?>? vint,
      Value<double?>? vdouble,
      Value<int?>? vbool,
      Value<int>? metaCreatedAt,
      Value<int>? metaUpdatedAt,
      Value<int>? rowid}) {
    return KvTblCompanion(
      k: k ?? this.k,
      vstring: vstring ?? this.vstring,
      vint: vint ?? this.vint,
      vdouble: vdouble ?? this.vdouble,
      vbool: vbool ?? this.vbool,
      metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
      metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (k.present) {
      map['k'] = Variable<String>(k.value);
    }
    if (vstring.present) {
      map['vstring'] = Variable<String>(vstring.value);
    }
    if (vint.present) {
      map['vint'] = Variable<int>(vint.value);
    }
    if (vdouble.present) {
      map['vdouble'] = Variable<double>(vdouble.value);
    }
    if (vbool.present) {
      map['vbool'] = Variable<int>(vbool.value);
    }
    if (metaCreatedAt.present) {
      map['meta_created_at'] = Variable<int>(metaCreatedAt.value);
    }
    if (metaUpdatedAt.present) {
      map['meta_updated_at'] = Variable<int>(metaUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KvTblCompanion(')
          ..write('k: $k, ')
          ..write('vstring: $vstring, ')
          ..write('vint: $vint, ')
          ..write('vdouble: $vdouble, ')
          ..write('vbool: $vbool, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  late final SettingsTbl settingsTbl = SettingsTbl(this);
  late final Trigger settingsMetaUpdatedAtTrig = Trigger(
      'CREATE TRIGGER IF NOT EXISTS settings_meta_updated_at_trig AFTER UPDATE ON settings_tbl BEGIN UPDATE settings_tbl SET meta_updated_at = strftime(\'%s\', \'now\') WHERE user_id = NEW.user_id;END',
      'settings_meta_updated_at_trig');
  late final LogTbl logTbl = LogTbl(this);
  late final Index logTimeIdx = Index('log_time_idx',
      'CREATE INDEX IF NOT EXISTS log_time_idx ON log_tbl (time)');
  late final Index logLevelIdx = Index('log_level_idx',
      'CREATE INDEX IF NOT EXISTS log_level_idx ON log_tbl (level)');
  late final LogPrefixTbl logPrefixTbl = LogPrefixTbl(this);
  late final Index logPrefixPrefixIdx = Index('log_prefix_prefix_idx',
      'CREATE INDEX IF NOT EXISTS log_prefix_prefix_idx ON log_prefix_tbl (prefix)');
  late final Index logPrefixLogIdIdx = Index('log_prefix_log_id_idx',
      'CREATE INDEX IF NOT EXISTS log_prefix_log_id_idx ON log_prefix_tbl (log_id)');
  late final Index logPrefixLenIdx = Index('log_prefix_len_idx',
      'CREATE INDEX IF NOT EXISTS log_prefix_len_idx ON log_prefix_tbl (len)');
  late final CharacteristicTbl characteristicTbl = CharacteristicTbl(this);
  late final Index characteristicMetaCreatedAtIdx = Index(
      'characteristic_meta_created_at_idx',
      'CREATE INDEX IF NOT EXISTS characteristic_meta_created_at_idx ON characteristic_tbl (meta_created_at)');
  late final Index characteristicMetaUpdatedAtIdx = Index(
      'characteristic_meta_updated_at_idx',
      'CREATE INDEX IF NOT EXISTS characteristic_meta_updated_at_idx ON characteristic_tbl (meta_updated_at)');
  late final Trigger characteristicMetaUpdatedAtTrig = Trigger(
      'CREATE TRIGGER IF NOT EXISTS characteristic_meta_updated_at_trig AFTER UPDATE ON characteristic_tbl BEGIN UPDATE characteristic_tbl SET meta_updated_at = strftime(\'%s\', \'now\') WHERE type = NEW.type AND id = NEW.id;END',
      'characteristic_meta_updated_at_trig');
  late final KvTbl kvTbl = KvTbl(this);
  late final Index kvMetaCreatedAtIdx = Index('kv_meta_created_at_idx',
      'CREATE INDEX IF NOT EXISTS kv_meta_created_at_idx ON kv_tbl (meta_created_at)');
  late final Index kvMetaUpdatedAtIdx = Index('kv_meta_updated_at_idx',
      'CREATE INDEX IF NOT EXISTS kv_meta_updated_at_idx ON kv_tbl (meta_updated_at)');
  late final Trigger kvMetaUpdatedAtTrig = Trigger(
      'CREATE TRIGGER IF NOT EXISTS kv_meta_updated_at_trig AFTER UPDATE ON kv_tbl BEGIN UPDATE kv_tbl SET meta_updated_at = strftime(\'%s\', \'now\') WHERE k = NEW.k;END',
      'kv_meta_updated_at_trig');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        settingsTbl,
        settingsMetaUpdatedAtTrig,
        logTbl,
        logTimeIdx,
        logLevelIdx,
        logPrefixTbl,
        logPrefixPrefixIdx,
        logPrefixLogIdIdx,
        logPrefixLenIdx,
        characteristicTbl,
        characteristicMetaCreatedAtIdx,
        characteristicMetaUpdatedAtIdx,
        characteristicMetaUpdatedAtTrig,
        kvTbl,
        kvMetaCreatedAtIdx,
        kvMetaUpdatedAtIdx,
        kvMetaUpdatedAtTrig
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('settings_tbl',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('settings_tbl', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('log_tbl',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('log_prefix_tbl', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('log_tbl',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('log_prefix_tbl', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('characteristic_tbl',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('characteristic_tbl', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('kv_tbl',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('kv_tbl', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}
