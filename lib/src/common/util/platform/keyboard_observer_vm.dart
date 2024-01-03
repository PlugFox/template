import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template_name/src/common/util/platform/keyboard_observer_interface.dart';
import 'package:flutter_template_name/src/common/util/platform/keyboard_observer_windows.dart';
import 'package:meta/meta.dart';

IKeyboardObserver $getKeyboardObserver() =>
    io.Platform.isWindows ? $getKeyboardObserver$Windows() : _KeyboardObserver$VM();

@sealed
class _KeyboardObserver$VM with _IsKeyPressed$IO, ChangeNotifier implements IKeyboardObserver {
  @override
  bool get isControlPressed =>
      isKeyPressed(LogicalKeyboardKey.controlLeft) || isKeyPressed(LogicalKeyboardKey.controlRight);

  @override
  bool get isShiftPressed => isKeyPressed(LogicalKeyboardKey.shiftLeft) || isKeyPressed(LogicalKeyboardKey.shiftRight);

  @override
  bool get isAltPressed => isKeyPressed(LogicalKeyboardKey.altLeft) || isKeyPressed(LogicalKeyboardKey.altRight);

  @override
  bool get isMetaPressed => isKeyPressed(LogicalKeyboardKey.metaLeft) || isKeyPressed(LogicalKeyboardKey.metaRight);
}

mixin _IsKeyPressed$IO {
  /// Returns true if the given [KeyboardKey] is pressed.
  bool isKeyPressed(LogicalKeyboardKey key) => HardwareKeyboard.instance.logicalKeysPressed.contains(key);
}
