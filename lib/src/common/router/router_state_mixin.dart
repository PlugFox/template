import 'package:flutter/widgets.dart' show State, StatefulWidget, ValueNotifier;
import 'package:flutter_template_name/src/common/model/dependencies.dart';
import 'package:flutter_template_name/src/common/router/authentication_guard.dart';
import 'package:flutter_template_name/src/common/router/home_guard.dart';
import 'package:flutter_template_name/src/common/router/routes.dart';
import 'package:octopus/octopus.dart';

mixin RouterStateMixin<T extends StatefulWidget> on State<T> {
  late final Octopus router;
  late final ValueNotifier<List<({Object error, StackTrace stackTrace})>>
      errorsObserver;

  @override
  void initState() {
    final dependencies = Dependencies.of(context);
    // Observe all errors.
    errorsObserver =
        ValueNotifier<List<({Object error, StackTrace stackTrace})>>(
      <({Object error, StackTrace stackTrace})>[],
    );

    // Create router.
    router = Octopus(
      routes: Routes.values,
      defaultRoute: Routes.home,
      guards: <IOctopusGuard>[
        // Check authentication.
        AuthenticationGuard(
          // Get current user from authentication controller.
          getUser: () => dependencies.authenticationController.state.user,
          // Available routes for non authenticated user.
          routes: <String>{
            Routes.signin.name,
            Routes.signup.name,
          },
          // Default route for non authenticated user.
          signinNavigation: OctopusState.single(Routes.signin.node()),
          // Default route for authenticated user.
          homeNavigation: OctopusState.single(Routes.home.node()),
          // Check authentication on every authentication controller state change.
          refresh: dependencies.authenticationController,
        ),
        // Home route should be always on top.
        HomeGuard(),
      ],
      onError: (error, stackTrace) =>
          errorsObserver.value = <({Object error, StackTrace stackTrace})>[
        (error: error, stackTrace: stackTrace),
        ...errorsObserver.value,
      ],
      /* observers: <NavigatorObserver>[
        HeroController(),
      ], */
    );
    super.initState();
  }
}
