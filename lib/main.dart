import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_template_name/src/common/util/app_zone.dart';
import 'package:flutter_template_name/src/common/util/error_util.dart';
import 'package:flutter_template_name/src/common/widget/app.dart';
import 'package:flutter_template_name/src/common/widget/app_error.dart';
import 'package:flutter_template_name/src/feature/initialization/data/initialization.dart';
import 'package:flutter_template_name/src/feature/initialization/widget/inherited_dependencies.dart';
import 'package:flutter_template_name/src/feature/settings/widget/settings_scope.dart';
import 'package:octopus/octopus.dart';
import 'package:platform_info/platform_info.dart';

void main() => appZone(
      () async {
        // Splash screen
        final initializationProgress = ValueNotifier<({int progress, String message})>((progress: 0, message: ''));
        /* runApp(SplashScreen(progress: initializationProgress)); */
        $initializeApp(
          onProgress: (progress, message) => initializationProgress.value = (progress: progress, message: message),
          onSuccess: (dependencies) => runApp(
            InheritedDependencies(
              dependencies: dependencies,
              child: SettingsScope(
                child: NoAnimationScope(
                  noAnimation: platform.isWeb || platform.isDesktop,
                  child: const App(),
                ),
              ),
            ),
          ),
          onError: (error, stackTrace) {
            runApp(AppError(error: error));
            ErrorUtil.logError(error, stackTrace).ignore();
          },
        ).ignore();
      },
    );
