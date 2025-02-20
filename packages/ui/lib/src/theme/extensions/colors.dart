import 'package:flutter/material.dart';

/// {@template app_colors}
/// Emphasis class
/// {@endtemplate}
@immutable
class AppColors implements ThemeExtension<AppColors> {
  /// {@macro app_colors}
  const AppColors({required this.scheme});

  factory AppColors.of(BuildContext context) {
    try {
      final theme = Theme.of(context);
      return theme.extension<AppColors>() ??
          switch (theme.brightness) {
            Brightness.light => AppColors.light,
            Brightness.dark => AppColors.dark,
          };
    } on Object {
      return AppColors.light;
    }
  }

  /// The default light theme colors.
  ///
  /// {@macro app_colors}
  static const AppColors light = AppColors(scheme: ColorScheme.light());

  /// The default dark theme colors.
  ///
  /// {@macro app_colors}
  static const AppColors dark = AppColors(scheme: ColorScheme.dark());

  /// The color scheme of the [AppColors].
  final ColorScheme scheme;

  @override
  Object get type => AppColors;

  /// Returns `true` if the brightness is [Brightness.light].
  bool get isLight => scheme.brightness == Brightness.light;

  /// Returns `true` if the brightness is [Brightness.dark].
  bool get isDark => scheme.brightness == Brightness.dark;

  /// Returns [ThemeMode] of the closest [Theme] ancestor.
  ///
  /// {@macro app_colors}
  static ThemeMode themeModeOf(BuildContext context) {
    final theme = Theme.of(context);
    return switch (theme.brightness) {
      Brightness.light => ThemeMode.light,
      Brightness.dark => ThemeMode.dark,
    };
  }

  /// Pattern matching on the brightness of the [AppColors].
  T map<T>({required T Function() light, required T Function() dark}) => isLight ? light() : dark();

  @override
  ThemeExtension<AppColors> copyWith({ColorScheme? scheme}) => AppColors(scheme: scheme ?? this.scheme);

  @override
  ThemeExtension<AppColors> lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(scheme: ColorScheme.lerp(scheme, other.scheme, t));
  }

  @override
  String toString() => 'AppColors{}';
}
