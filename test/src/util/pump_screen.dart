// ignore_for_file: use_setters_to_change_properties

import 'package:flutter/cupertino.dart' show DefaultCupertinoLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

@visibleForTesting
final class TestScreenController<W extends Widget> {
  TestScreenController._(
    this._screen,
    this._tester,
    this._flutterView,
    this._theme,
    this._size,
    this._navigatorObserver,
  );

  /// The [Widget] that is currently being tested.
  final W _screen;

  /// The [WidgetTester] that is currently being used.
  final WidgetTester _tester;

  /// The [TestFlutterView] that is currently being tested.
  final TestFlutterView _flutterView;

  /// The [ValueNotifier] that controls the theme mode of the screen.
  final ValueNotifier<ThemeMode> _theme;

  /// The [ValueNotifier] that controls the size of the screen.
  final ValueNotifier<Size> _size;

  /// The [NavigatorObserver] that is currently being used.
  final NavigatorObserver _navigatorObserver;

  /// The current theme mode of the app.
  ThemeMode get theme => _theme.value;

  /// Changes the theme mode of the app.
  void setTheme(ThemeMode theme) => _theme.value = theme;

  /// The current size of the app.
  Size get size => _size.value;

  /// Changes the size of the app.
  void setSize(Size size) => _size.value = size;

  /// Changes the device pixel ratio of the screen.
  void setDevicePixelRatio(double devicePixelRatio) => _flutterView.devicePixelRatio = devicePixelRatio;

  /// The [NavigatorState] of the current app.
  NavigatorState? get navigator => _navigatorObserver.navigator;

  /// Pumps the widget tree by the given duration.
  Future<void> pump([int ms = 1000]) => _tester.pump(Duration(milliseconds: ms));

  /// Pumps the widget tree until there are no more frames.
  Future<void> pumpAndSettle([int ms = 1000]) => _tester.pumpAndSettle(Duration(milliseconds: ms));

  /// Rebuilds the widget tree.
  Future<void> rebuild() {
    _size.notifyListeners();
    return _tester.pump();
  }

  /// The [BuildContext] of the provided Screen
  BuildContext get context => _tester.firstElement(find.byWidget(_screen));
}

@visibleForTesting
extension PumpScreenX on WidgetTester {
  /// Pumps the given [screen] and returns a [TestScreenController] to interact with it.
  /// The [duration] parameter can be used to pump the screen for a specific duration.
  /// The [phase] parameter can be used to control when the semantics update is sent.
  /// The [platformData] parameter can be used to provide custom [MediaQueryData].
  /// The [builder] parameter can be used to wrap the screen with a custom builder.
  /// The [title] parameter can be used to set the title of the [MaterialApp].
  Future<TestScreenController> pumpScreen<W extends Widget>(
    W screen, {
    Duration? duration,
    EnginePhase phase = EnginePhase.sendSemanticsUpdate,
    MediaQueryData? platformData,
    Widget Function(BuildContext context, Widget child)? builder,
    String? title,
  }) async {
    final flutterView = view;
    // Controllers for various app settings.
    final theme = ValueNotifier<ThemeMode>(ThemeMode.system);
    final size = ValueNotifier<Size>(flutterView.physicalSize / flutterView.devicePixelRatio);
    size.addListener(() => flutterView.physicalSize = size.value * flutterView.devicePixelRatio);
    final rebuild = Listenable.merge([theme, size]);
    final navigatorObserver = NavigatorObserver();
    final rootWidget = ListenableBuilder(
      listenable: rebuild,
      builder: (context, _) => View(
        view: platformDispatcher.implicitView!,
        child: MediaQuery(
          data: MediaQueryData.fromView(
            flutterView,
            platformData: (platformData ?? const MediaQueryData()).copyWith(size: size.value),
          ),
          // Thats a legacy theme provider, we should exclude it
          child: MaterialApp(
            title: title ?? 'Test',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const <LocalizationsDelegate<Object?>>[
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            themeMode: theme.value,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: KeyedSubtree(
              key: ValueKey<Type>(W),
              child: screen,
            ),
            builder: (context, navigator) => switch (builder) {
              null => navigator!,
              _ => builder(context, navigator!),
            },
            navigatorObservers: [navigatorObserver],
          ),
        ),
      ),
    );
    await pumpWidget(
      rootWidget,
      duration: duration,
      phase: phase,
      wrapWithView: false,
    );
    return TestScreenController._(
      screen,
      this,
      flutterView,
      theme,
      size,
      navigatorObserver,
    );
  }
}
