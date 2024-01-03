import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template_name/src/common/constant/config.dart';
import 'package:flutter_template_name/src/common/localization/localization.dart';
import 'package:flutter_template_name/src/common/router/router_state_mixin.dart';
import 'package:flutter_template_name/src/common/widget/window_scope.dart';
import 'package:flutter_template_name/src/feature/authentication/widget/authentication_scope.dart';
import 'package:octopus/octopus.dart';

/// {@template app}
/// App widget.
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro app}
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with RouterStateMixin {
  final Key builderKey = GlobalKey(); // Disable recreate widget tree

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Application',
        debugShowCheckedModeBanner: !Config.environment.isProduction,

        // Router
        routerConfig: router.config,

        // Localizations
        localizationsDelegates: const <LocalizationsDelegate<Object?>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          Localization.delegate,
        ],
        supportedLocales: Localization.supportedLocales,
        /* locale: SettingsScope.localOf(context), */

        // Theme
        /* theme: SettingsScope.themeOf(context), */
        theme: ThemeData.dark(),

        // Scopes
        builder: (context, child) => MediaQuery(
          key: builderKey,
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: WindowScope(
            title: Localization.of(context).title,
            child: OctopusTools(
              enable: true,
              octopus: router,
              child: AuthenticationScope(
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      );
}
