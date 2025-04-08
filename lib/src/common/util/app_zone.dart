import 'dart:async';

import 'package:l/l.dart';
import 'package:platform_info/platform_info.dart';

/// Catch all application errors and logs.
void appZone(Future<void> Function() fn) => l.capture<void>(
  () => runZonedGuarded<void>(() => fn(), l.e),
  LogOptions(
    messageFormatting: _messageFormatting,
    handlePrint: true,
    outputInRelease: false,
    printColors: !platform.iOS, //? Remove when iOS will supports ANSI colors in console.
  ),
);

/// Formats the log message.
Object _messageFormatting(LogMessage log) => '${_timeFormat(log.timestamp)} | ${log.message}';

/// Formats the time.
String _timeFormat(DateTime time) => '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
