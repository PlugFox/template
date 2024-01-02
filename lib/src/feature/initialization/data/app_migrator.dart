// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
import 'dart:math';

import 'package:flutter_template_name/src/common/constant/config.dart';
import 'package:flutter_template_name/src/common/constant/pubspec.yaml.g.dart';
import 'package:flutter_template_name/src/common/database/database.dart';
import 'package:l/l.dart';

/// Migrate application when version is changed.
sealed class AppMigrator {
  static FutureOr<void> migrate(Database database) async {
    try {
      final prevMajor = database.getKey<int>(Config.versionMajorKey);
      final prevMinor = database.getKey<int>(Config.versionMinorKey);
      final prevPatch = database.getKey<int>(Config.versionPatchKey);
      if (prevMajor == null || prevMinor == null || prevPatch == null) {
        l.i('Initializing app for the first time');
        /* ... */
      } else if (Pubspec.version.major != prevMajor ||
          Pubspec.version.minor != prevMinor ||
          Pubspec.version.patch != prevPatch) {
        l.i('Migrating from $prevMajor.$prevMinor.$prevPatch to ${Pubspec.version.major}.${Pubspec.version.minor}.${Pubspec.version.patch}');
        /* ... */
      } else {
        l.i('App is up-to-date');
        return;
      }
      database.setAll(<String, int>{
        Config.versionMajorKey: Pubspec.version.major,
        Config.versionMinorKey: Pubspec.version.minor,
        Config.versionPatchKey: Pubspec.version.patch,
      });
    } on Object catch (error, stackTrace) {
      l.e('App migration failed: $e', stackTrace);
      rethrow;
    }
  }
}
