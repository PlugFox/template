import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_template_name/src/common/util/app_zone.dart';
import 'package:flutter_template_name/src/common/util/error_util.dart';
import 'package:flutter_template_name/src/common/widget/app.dart';
import 'package:flutter_template_name/src/common/widget/app_error.dart' deferred as app_error;
import 'package:flutter_template_name/src/feature/initialization/data/initialization.dart' deferred as initialization;
import 'package:flutter_template_name/src/feature/settings/widget/settings_scope.dart';
import 'package:octopus/octopus.dart';
import 'package:platform_info/platform_info.dart';

void main() => appZone(() async {
  // Splash screen
  final initializationProgress = ValueNotifier<({int progress, String message})>((progress: 0, message: ''));
  /* runApp(SplashScreen(progress: initializationProgress)); */
  await initialization.loadLibrary();
  initialization
      .$initializeApp(
        onProgress: (progress, message) => initializationProgress.value = (progress: progress, message: message),
        onSuccess:
            (dependencies) => runApp(
              dependencies.inject(
                child: SettingsScope(
                  child: NoAnimationScope(noAnimation: platform.js || platform.desktop, child: const App()),
                ),
              ),
            ),
        onError: (error, stackTrace) async {
          await app_error.loadLibrary();
          runApp(app_error.AppError(error: error));
          ErrorUtil.logError(error, stackTrace).ignore();
        },
      )
      .ignore();
});
