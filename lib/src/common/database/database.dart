// ignore_for_file: prefer_foreach

import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart' show WidgetsBindingObserver, WidgetsBinding, AppLifecycleState;
import 'package:flutter_template_name/src/common/constant/config.dart';
import 'package:flutter_template_name/src/common/database/platform/database_vm.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'package:flutter_template_name/src/common/database/platform/database_js.dart';
import 'package:flutter_template_name/src/common/database/queries.dart';
import 'package:meta/meta.dart';

export 'package:drift/drift.dart' hide DatabaseOpener;
export 'package:drift/isolate.dart';

part 'database.g.dart';

/// Key-value storage interface for SQLite database
abstract interface class IKeyValueStorage {
  /// Refresh key-value storage from database
  Future<void> refresh();

  /// Get value by key
  T? getKey<T extends Object>(String key);

  /// Set value by key
  void setKey(String key, Object? value);

  /// Remove value by key
  void removeKey(String key);

  /// Get all values
  Map<String, Object?> getAll([Set<String>? keys]);

  /// Set all values
  void setAll(Map<String, Object?> data);

  /// Remove all values
  void removeAll([Set<String>? keys]);
}

@DriftDatabase(
  include: <String>{
    'ddl/kv.drift',
    'ddl/characteristic.drift',
    'ddl/log.drift',
    'ddl/settings.drift',
  },
  tables: <Type>[],
  daos: <Type>[],
  queries: $queries,
)
class Database extends _$Database
    with _DatabaseKeyValueMixin, WidgetsBindingObserver, _CloseOnDetachedAppLifecycleState
    implements GeneratedDatabase, DatabaseConnectionUser, QueryExecutorUser, IKeyValueStorage {
  /// Creates a database that will store its result in the [path], creating it
  /// if it doesn't exist.
  ///
  /// [path] - file path to database for native platforms and database name for web platform.
  ///
  /// If [logStatements] is true (defaults to `false`), generated sql statements
  /// will be printed before executing. This can be useful for debugging.
  /// The optional [setup] function can be used to perform a setup just after
  /// the database is opened, before moor is fully ready. This can be used to
  /// add custom user-defined sql functions or to provide encryption keys in
  /// SQLCipher implementations.
  Database.lazy({
    String? path,
    bool logStatements = false,
    bool dropDatabase = Config.dropDatabase,
  }) : super(
          LazyDatabase(
            () => $createQueryExecutor(
              path: path,
              logStatements: logStatements,
              dropDatabase: dropDatabase,
            ),
          ),
        ) {
    _init();
  }

  /// Creates a database from an existing [executor].
  Database.connect(super.connection);

  /// Creates an in-memory database won't persist its changes on disk.
  ///
  /// If [logStatements] is true (defaults to `false`), generated sql statements
  /// will be printed before executing. This can be useful for debugging.
  /// The optional [setup] function can be used to perform a setup just after
  /// the database is opened, before moor is fully ready. This can be used to
  /// add custom user-defined sql functions or to provide encryption keys in
  /// SQLCipher implementations.
  Database.memory({
    bool logStatements = false,
  }) : super(
          LazyDatabase(
            () => $createQueryExecutor(
              logStatements: logStatements,
              memoryDatabase: true,
            ),
          ),
        );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => DatabaseMigrationStrategy(
        database: this,
      );
}

/// Handles database migrations by delegating work to [OnCreate] and [OnUpgrade]
/// methods.
@immutable
class DatabaseMigrationStrategy implements MigrationStrategy {
  /// Construct a migration strategy from the provided [onCreate] and
  /// [onUpgrade] methods.
  const DatabaseMigrationStrategy({
    required Database database,
  }) : _db = database;

  /// Database to use for migrations.
  final Database _db;

  /// Executes when the database is opened for the first time.
  @override
  OnCreate get onCreate => (m) async {
        await m.createAll();
      };

  /// Executes when the database has been opened previously, but the last access
  /// happened at a different [GeneratedDatabase.schemaVersion].
  /// Schema version upgrades and downgrades will both be run here.
  @override
  OnUpgrade get onUpgrade => (m, from, to) async {
        await m.createAll();
        return _update(_db, m, from, to);
      };

  /// Executes after the database is ready to be used (ie. it has been opened
  /// and all migrations ran), but before any other queries will be sent. This
  /// makes it a suitable place to populate data after the database has been
  /// created or set sqlite `PRAGMAS` that you need.
  @override
  OnBeforeOpen get beforeOpen => (details) async {};

  /// https://moor.simonbinder.eu/docs/advanced-features/migrations/
  static Future<void> _update(Database db, Migrator m, int from, int to) async {
    await m.createAll();
    if (from >= to) return;
  }
}

mixin _DatabaseKeyValueMixin on _$Database implements IKeyValueStorage {
  bool _$isInitialized = false;
  final Map<String, Object> _$store = <String, Object>{};

  static KvTblCompanion? _kvCompanionFromKeyValue(String key, Object? value) => switch (value) {
        String vstring => KvTblCompanion.insert(k: key, vstring: Value(vstring)),
        int vint => KvTblCompanion.insert(k: key, vint: Value(vint)),
        double vdouble => KvTblCompanion.insert(k: key, vdouble: Value(vdouble)),
        bool vbool => KvTblCompanion.insert(k: key, vbool: Value(vbool ? 1 : 0)),
        _ => null,
      };

  @override
  Future<void> refresh() => select(kvTbl).get().then<void>((values) {
        _$isInitialized = true;
        _$store
          ..clear()
          ..addAll(<String, Object>{
            for (final kv in values) kv.k: kv.vstring ?? kv.vint ?? kv.vdouble ?? kv.vbool == 1,
          });
      });

  @override
  T? getKey<T extends Object>(String key) {
    assert(_$isInitialized, 'Database is not initialized');
    final v = _$store[key];
    if (v is T) {
      return v;
    } else if (v == null) {
      return null;
    } else {
      assert(false, 'Value is not of type $T');
      return null;
    }
  }

  @override
  void setKey(String key, Object? value) {
    if (value == null) return removeKey(key);
    assert(_$isInitialized, 'Database is not initialized');
    _$store[key] = value;
    final entity = _kvCompanionFromKeyValue(key, value);
    if (entity == null) {
      assert(false, 'Value type is not supported');
      return;
    }
    into(kvTbl).insertOnConflictUpdate(entity).ignore();
  }

  @override
  void removeKey(String key) {
    assert(_$isInitialized, 'Database is not initialized');
    _$store.remove(key);
    (delete(kvTbl)..where((tbl) => tbl.k.equals(key))).go().ignore();
  }

  @override
  Map<String, Object> getAll([Set<String>? keys]) {
    assert(_$isInitialized, 'Database is not initialized');
    return keys == null
        ? Map<String, Object>.of(_$store)
        : <String, Object>{
            for (final e in _$store.entries)
              if (keys.contains(e.key)) e.key: e.value,
          };
  }

  @override
  void setAll(Map<String, Object?> data) {
    assert(_$isInitialized, 'Database is not initialized');
    if (data.isEmpty) return;
    final entries = <(String, Object?, KvTblCompanion?)>[
      for (final e in data.entries) (e.key, e.value, _kvCompanionFromKeyValue(e.key, e.value)),
    ];
    final toDelete = entries.where((e) => e.$3 == null).map<String>((e) => e.$1).toSet();
    final toInsert = entries.expand<(String, Object, KvTblCompanion)>((e) sync* {
      final value = e.$2;
      final companion = e.$3;
      if (companion == null || value == null) return;
      yield (e.$1, value, companion);
    }).toList();
    for (final key in toDelete) _$store.remove(key);
    _$store.addAll(<String, Object>{for (final e in toInsert) e.$1: e.$2});
    batch(
      (b) => b
        ..deleteWhere(kvTbl, (tbl) => tbl.k.isIn(toDelete))
        ..insertAllOnConflictUpdate(kvTbl, toInsert.map((e) => e.$3).toList(growable: false)),
    ).ignore();
  }

  @override
  void removeAll([Set<String>? keys]) {
    assert(_$isInitialized, 'Database is not initialized');
    if (keys == null) {
      _$store.clear();
      delete(kvTbl).go().ignore();
    } else if (keys.isNotEmpty) {
      for (final key in keys) _$store.remove(key);
      (delete(kvTbl)..where((tbl) => tbl.k.isIn(keys))).go().ignore();
    }
  }
}

mixin _CloseOnDetachedAppLifecycleState on WidgetsBindingObserver, GeneratedDatabase {
  void _init() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) close();
    super.didChangeAppLifecycleState(state);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
