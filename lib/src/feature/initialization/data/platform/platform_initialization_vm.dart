import 'dart:io' as io;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

Future<void> $platformInitialization() =>
    io.Platform.isAndroid || io.Platform.isIOS ? _mobileInitialization() : _desktopInitialization();

Future<void> _mobileInitialization() async {
  // Set the app to be full-screen (no buttons, bar or notifications on top).
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Set the preferred orientation of the app to landscape only.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
}

Future<void> _desktopInitialization() async {
  final platform = ui.PlatformDispatcher.instance;
  // Must add this line.
  await windowManager.ensureInitialized();
  final windowOptions = WindowOptions(
    minimumSize: const Size(320, 480),
    size: const Size(960, 800),
    /* maximumSize: const Size(1440, 1080), */
    center: true,
    windowButtonVisibility: false,
    backgroundColor:
        platform.platformBrightness == Brightness.dark
            ? ThemeData.dark().colorScheme.surface
            : ThemeData.light().colorScheme.surface,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: false,
    fullScreen: false,
    title: 'Application',
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    if (io.Platform.isMacOS) {
      await windowManager.setMovable(true);
    }
    await windowManager.setMaximizable(true);
    await windowManager.show();
    await windowManager.focus();
  });
}
