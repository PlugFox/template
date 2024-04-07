// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart' as wasm;
import 'package:flutter_template_name/src/common/constant/config.dart';
import 'package:l/l.dart';
import 'package:meta/meta.dart';

/*
  IdbFactory.supported => WebDatabase.withStorage(await DriftWebStorage.indexedDbIfSupported(name));
  https://github.com/flutter/flutter/issues/44937
*/
@internal
Future<QueryExecutor> $createQueryExecutor({
  String? path,
  bool logStatements = false,
  bool dropDatabase = false,
  bool memoryDatabase = false,
}) async {
  // https://drift.simonbinder.eu/web
  /*
    if (memoryDatabase) {
      final sqlite3 = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
      sqlite3.registerVirtualFileSystem(InMemoryFileSystem(), makeDefault: true);
      WasmDatabase.inMemory(sqlite3);
    }
  */
  if (dropDatabase) html.window.indexedDB!.deleteDatabase(Config.databaseName);
  final result = await wasm.WasmDatabase.open(
    databaseName: memoryDatabase ? ':memory:' : path ?? Config.databaseName,
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
  );

  /*
    if (dropDatabase) html.window.localStorage.clear();
    return Future<QueryExecutor>.value(
      web.WebDatabase(
        memoryDatabase ? ':memory:' : path ?? Config.databaseName,
        logStatements: logStatements,
        /* setup: (db) {}, */
      ),
    );
  */

  if (result.missingFeatures.isNotEmpty) {
    // Depending how central local persistence is to your app, you may want
    // to show a warning to the user if only unrealiable implemetentations
    // are available.
    l.w('Using ${result.chosenImplementation} due to missing browser '
        'features: ${result.missingFeatures}');
  }

  return result.resolvedExecutor;
}
