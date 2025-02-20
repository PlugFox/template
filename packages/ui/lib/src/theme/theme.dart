import 'package:flutter/material.dart';
import 'package:ui/src/theme/extensions/colors.dart';

export 'package:ui/src/theme/extensions/colors.dart';

/// {@template theme}
/// App theme data.
/// {@endtemplate}
extension type AppThemeData._(ThemeData data) implements ThemeData {
  /// {@macro theme}
  factory AppThemeData.light() => AppThemeData._(_appLightTheme);

  /// {@macro theme}
  factory AppThemeData.dark() => AppThemeData._(_appDarkTheme);
}

/// Extension on [ThemeData] to provide App theme data.
extension AudoThemeExtension on ThemeData {
  /// Returns the App theme colors.
  AppColors get appColors =>
      extension<AppColors>() ??
      switch (brightness) {
        Brightness.light => AppColors.light,
        Brightness.dark => AppColors.dark,
      };
}

// --- Light Theme --- //

/// Light theme data for the App.
final ThemeData _appLightTheme = ThemeData.light().copyWith(
  colorScheme: AppColors.light.scheme,
  extensions: const <ThemeExtension>[AppColors.light],
);

// --- Dark Theme --- //

/// Dark theme data for the App.
final ThemeData _appDarkTheme = ThemeData.dark().copyWith(
  colorScheme: AppColors.dark.scheme,
  extensions: const <ThemeExtension>[AppColors.dark],
);
