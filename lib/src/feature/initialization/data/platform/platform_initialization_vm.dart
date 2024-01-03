import 'dart:io' as io;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> $platformInitialization() =>
    io.Platform.isAndroid || io.Platform.isIOS ? _mobileInitialization() : _desktopInitialization();

Future<void> _mobileInitialization() async {}

Future<void> _desktopInitialization() async {
  // Must add this line.
  await windowManager.ensureInitialized();
  final windowOptions = WindowOptions(
    minimumSize: const Size(360, 480),
    size: const Size(960, 800),
    maximumSize: const Size(1440, 1080),
    center: true,
    backgroundColor: PlatformDispatcher.instance.platformBrightness == Brightness.dark
        ? ThemeData.dark().colorScheme.background
        : ThemeData.light().colorScheme.background,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    /* alwaysOnTop: true, */
    fullScreen: false,
    title: 'Vexus',
  );
  await windowManager.waitUntilReadyToShow(
    windowOptions,
    () async {
      if (io.Platform.isMacOS) {
        await windowManager.setMovable(true);
      }
      await windowManager.setMaximizable(false);
      await windowManager.show();
      await windowManager.focus();
    },
  );
}
