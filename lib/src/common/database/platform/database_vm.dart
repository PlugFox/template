import 'dart:developer';
import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:drift/native.dart' as ffi;
import 'package:flutter_template_name/src/common/constant/config.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

@internal
Future<QueryExecutor> $createQueryExecutor({
  String? path,
  bool logStatements = false,
  bool dropDatabase = false,
  bool memoryDatabase = false,
}) async {
  if (memoryDatabase) {
    return ffi.NativeDatabase.memory(
      logStatements: logStatements,
      /* setup: (db) {}, */
    );
  }
  io.File file;
  if (path == null) {
    try {
      final dbFolder = await pp.getApplicationDocumentsDirectory();
      file = io.File(p.join(dbFolder.path, '${Config.databaseName}.db'));
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(
          'Failed to get application documents directory "$error"', stackTrace);
    }
  } else {
    file = io.File(path);
  }
  try {
    if (dropDatabase && file.existsSync()) {
      await file.delete();
    }
  } on Object catch (e, st) {
    log(
      "Can't delete database file: $file",
      level: 900,
      name: 'database',
      error: e,
      stackTrace: st,
    );
    rethrow;
  }
  return ffi.NativeDatabase.createInBackground(
    file,
    logStatements: logStatements,
    /* setup: (db) {}, */
  );
}
