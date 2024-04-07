import 'package:flutter/material.dart';

/// {@template settings_scope}
/// SettingsScope widget.
/// {@endtemplate}
class SettingsScope extends StatefulWidget {
  /// {@macro settings_scope}
  const SettingsScope({
    required this.child,
    super.key, // ignore: unused_element
  });

  static ThemeData themeOf(BuildContext context, {bool listen = true}) =>
      _InheritedSettingsScope.of(context, listen: listen).scope._theme;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<SettingsScope> createState() => _SettingsScopeState();
}

/// State for widget SettingsScope.
class _SettingsScopeState extends State<SettingsScope> {
  ThemeData _theme = _$buildTheme(ThemeData.light());

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = View.maybeOf(context)?.platformDispatcher.platformBrightness;
    if (brightness != _theme.brightness) {
      _theme = _$buildTheme(brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light());
    }
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => _InheritedSettingsScope(
        scope: this,
        theme: _theme,
        child: widget.child,
      );
}

/// Inherited widget for quick access in the element tree.
class _InheritedSettingsScope extends InheritedWidget {
  const _InheritedSettingsScope({
    required this.scope,
    required this.theme,
    required super.child,
  });

  final _SettingsScopeState scope;
  final ThemeData theme;

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  /// For example: `SettingsScope.maybeOf(context)`.
  static _InheritedSettingsScope? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_InheritedSettingsScope>()
      : context.getInheritedWidgetOfExactType<_InheritedSettingsScope>();

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a _InheritedSettingsScope of the exact type',
        'out_of_scope',
      );

  /// The state from the closest instance of this class
  /// that encloses the given context.
  /// For example: `SettingsScope.of(context)`.
  static _InheritedSettingsScope of(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant _InheritedSettingsScope oldWidget) => !identical(oldWidget.theme, theme);
}

ThemeData _$buildTheme(ThemeData theme) {
  const borderSide = BorderSide(
    width: 1,
    color: Color.fromRGBO(0, 0, 0, 0.6), // Color.fromRGBO(43, 45, 39, 0.24)
    strokeAlign: BorderSide.strokeAlignInside,
  );
  const radius = BorderRadius.all(Radius.circular(8));
  return theme.copyWith(
    inputDecorationTheme: theme.inputDecorationTheme.copyWith(
      isCollapsed: false,
      isDense: false,
      filled: true,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      border: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(
          color: const Color.fromRGBO(0, 0, 0, 0.24),
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(
          color: const Color.fromRGBO(0, 0, 0, 0.24),
        ),
      ),
      outlineBorder: borderSide,
    ),
  );
}
