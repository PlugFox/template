import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template_name/src/common/util/platform/keyboard_observer_interface.dart';
import 'package:meta/meta.dart';

IKeyboardObserver $getKeyboardObserver() => _KeyboardObserver$JS();

@sealed
class _KeyboardObserver$JS with _IsKeyPressed$JS, ChangeNotifier implements IKeyboardObserver {
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

mixin _IsKeyPressed$JS {
  /// Returns true if the given [KeyboardKey] is pressed.
  bool isKeyPressed(LogicalKeyboardKey key) => HardwareKeyboard.instance.logicalKeysPressed.contains(key);
}
