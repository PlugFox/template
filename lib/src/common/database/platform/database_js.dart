// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:drift/drift.dart';
import 'package:drift/web.dart' as web;
import 'package:flutter_template_name/src/common/constant/config.dart';
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
}) {
  if (dropDatabase) html.window.localStorage.clear();
  return Future<QueryExecutor>.value(
    web.WebDatabase(
      memoryDatabase ? ':memory:' : path ?? Config.databaseName,
      logStatements: logStatements,
      /* setup: (db) {}, */
    ),
  );
}
