import 'dart:async';

import 'package:l/l.dart';

/// Catch all application errors and logs.
void appZone(FutureOr<void> Function() fn) => l.capture<void>(
      () => runZonedGuarded<void>(
        () => fn(),
        l.e,
      ),
      const LogOptions(
        handlePrint: true,
        messageFormatting: _messageFormatting,
        outputInRelease: false,
        printColors: true,
      ),
    );

/// Formats the log message.
Object _messageFormatting(Object message, LogLevel logLevel, DateTime now) =>
    '${_timeFormat(now)} | $message';

/// Formats the time.
String _timeFormat(DateTime time) =>
    '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
