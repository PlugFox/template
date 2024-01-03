import 'dart:async';

import 'package:control/control.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_template_name/src/common/constant/config.dart';
import 'package:flutter_template_name/src/common/constant/pubspec.yaml.g.dart';
import 'package:flutter_template_name/src/common/controller/controller_observer.dart';
import 'package:flutter_template_name/src/common/database/database.dart';
import 'package:flutter_template_name/src/common/model/app_metadata.dart';
import 'package:flutter_template_name/src/common/model/dependencies.dart';
import 'package:flutter_template_name/src/common/util/dio_proxy.dart';
import 'package:flutter_template_name/src/common/util/http_log_interceptor.dart';
import 'package:flutter_template_name/src/common/util/log_buffer.dart';
import 'package:flutter_template_name/src/common/util/screen_util.dart';
import 'package:flutter_template_name/src/feature/authentication/controller/authentication_controller.dart';
import 'package:flutter_template_name/src/feature/authentication/data/authentication_repository.dart';
import 'package:flutter_template_name/src/feature/initialization/data/app_migrator.dart';
import 'package:flutter_template_name/src/feature/initialization/data/platform/platform_initialization.dart';
import 'package:l/l.dart';
import 'package:platform_info/platform_info.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Initializes the app and returns a [Dependencies] object
Future<Dependencies> $initializeDependencies({
  void Function(int progress, String message)? onProgress,
}) async {
  final dependencies = Dependencies();
  final totalSteps = _initializationSteps.length;
  var currentStep = 0;
  for (final step in _initializationSteps.entries) {
    try {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      onProgress?.call(percent, step.key);
      l.v6('Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
      await step.value(dependencies);
    } on Object catch (error, stackTrace) {
      l.e('Initialization failed at step "${step.key}": $error', stackTrace);
      Error.throwWithStackTrace('Initialization failed at step "${step.key}": $error', stackTrace);
    }
  }
  return dependencies;
}

typedef _InitializationStep = FutureOr<void> Function(Dependencies dependencies);
final Map<String, _InitializationStep> _initializationSteps = <String, _InitializationStep>{
  'Platform pre-initialization': (_) => $platformInitialization(),
  'Creating app metadata': (dependencies) => dependencies.metadata = AppMetadata(
        isWeb: platform.isWeb,
        isRelease: platform.buildMode.isRelease,
        appName: Pubspec.name,
        appVersion: Pubspec.version.representation,
        appVersionMajor: Pubspec.version.major,
        appVersionMinor: Pubspec.version.minor,
        appVersionPatch: Pubspec.version.patch,
        appBuildTimestamp:
            Pubspec.version.build.isNotEmpty ? (int.tryParse(Pubspec.version.build.firstOrNull ?? '-1') ?? -1) : -1,
        operatingSystem: platform.operatingSystem.name,
        processorsCount: platform.numberOfProcessors,
        appLaunchedTimestamp: DateTime.now(),
        locale: platform.locale,
        deviceVersion: platform.version,
        deviceScreenSize: ScreenUtil.screenSize().representation,
      ),
  'Observer state managment': (_) => Controller.observer = ControllerObserver(),
  'Initializing analytics': (_) {},
  'Log app open': (_) {},
  'Get remote config': (_) {},
  'Restore settings': (_) {},
  'Initialize shared preferences': (dependencies) async =>
      dependencies.sharedPreferences = await SharedPreferences.getInstance(),
  'Connect to database': (dependencies) =>
      (dependencies.database = Config.inMemoryDatabase ? Database.memory() : Database.lazy()).refresh(),
  'Shrink database': (dependencies) async {
    await dependencies.database.customStatement('VACUUM;');
    await dependencies.database.transaction(() async {
      final log = await (dependencies.database.select<LogTbl, LogTblData>(dependencies.database.logTbl)
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.id, mode: OrderingMode.desc)])
            ..limit(1, offset: 1000))
          .getSingleOrNull();
      if (log != null) {
        await (dependencies.database.delete(dependencies.database.logTbl)
              ..where((tbl) => tbl.time.isSmallerOrEqualValue(log.time)))
            .go();
      }
    });
    if (DateTime.now().second % 10 == 0) await dependencies.database.customStatement('VACUUM;');
  },
  'Migrate app from previous version': (dependencies) => AppMigrator.migrate(dependencies.database),
  'API Client': (dependencies) => dependencies.dio = Dio(
        BaseOptions(
          baseUrl: Config.apiBaseUrl,
          connectTimeout: Config.apiConnectTimeout,
          receiveTimeout: Config.apiReceiveTimeout,
          headers: <String, String>{
            /* 'Connection': 'Close', */
            Headers.acceptHeader: Headers.jsonContentType,
          },
          receiveDataWhenStatusError: false, // Don't convert 4XX & 5XX to JSON
        ),
      )..useProxy(),
  'Add API interceptors': (dependencies) {
    dependencies.dio.interceptors.addAll(<Interceptor>[
      const HttpLogInterceptor(),
      // TODO(plugfox): add sentry interceptor
      // TODO(plugfox): save all requests to database
      // TODO(plugfox): add cache interceptor
      /* AuthenticationInterceptor(
        token: () => authenticator.user.sessionId ?? (throw StateError('User is not logged in')),
        logout: () => Future<void>.sync(authenticator.logOut),
        refresh: () => Future<void>.sync(authenticator.refresh),
        retry: (options) => apiClient.fetch(options),
      ), */
      RetryInterceptor(
        dio: dependencies.dio,
        logPrint: (message) => l.w('RetryInterceptor | API | $message'),
        retries: 3, // retry count (optional)
        retryDelays: const <Duration>[
          Duration(seconds: 1), // wait 1 sec before first retry
          Duration(seconds: 2), // wait 2 sec before second retry
          Duration(seconds: 10), // wait 3 sec before third retry
        ],
      ),
      // TODO(plugfox): add dedupe interceptor
    ]);
  },
  'Prepare authentication controller': (dependencies) =>
      dependencies.authenticationController = AuthenticationController(
        repository: AuthenticationRepositoryImpl(
          sharedPreferences: dependencies.sharedPreferences,
        ),
      ),
  'Restore last user': (dependencies) => dependencies.authenticationController.restore(),
  'Initialize localization': (_) {},
  'Collect logs': (dependencies) async {
    await (dependencies.database.select<LogTbl, LogTblData>(dependencies.database.logTbl)
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.time, mode: OrderingMode.desc)])
          ..limit(LogBuffer.bufferLimit))
        .get()
        .then<List<LogMessage>>((logs) => logs
            .map((l) => l.stack != null
                ? LogMessageWithStackTrace(
                    date: DateTime.fromMillisecondsSinceEpoch(l.time * 1000),
                    level: LogLevel.fromValue(l.level),
                    message: l.message,
                    stackTrace: StackTrace.fromString(l.stack!))
                : LogMessage(
                    date: DateTime.fromMillisecondsSinceEpoch(l.time * 1000),
                    level: LogLevel.fromValue(l.level),
                    message: l.message,
                  ))
            .toList())
        .then<void>(LogBuffer.instance.addAll);
    l.bufferTime(const Duration(seconds: 1)).where((logs) => logs.isNotEmpty).listen(LogBuffer.instance.addAll);
    l
        .map<LogTblCompanion>((log) => LogTblCompanion.insert(
              level: log.level.level,
              message: log.message.toString(),
              time: Value<int>(log.date.millisecondsSinceEpoch ~/ 1000),
              stack: Value<String?>(switch (log) { LogMessageWithStackTrace l => l.stackTrace.toString(), _ => null }),
            ))
        .bufferTime(const Duration(seconds: 5))
        .where((logs) => logs.isNotEmpty)
        .listen(
          (logs) =>
              dependencies.database.batch((batch) => batch.insertAll(dependencies.database.logTbl, logs)).ignore(),
          cancelOnError: false,
        );
  },
  'Log app initialized': (_) {},
};
