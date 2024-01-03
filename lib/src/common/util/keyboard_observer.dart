import 'package:flutter_template_name/src/common/util/platform/keyboard_observer_interface.dart';
import 'package:flutter_template_name/src/common/util/platform/keyboard_observer_vm.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'package:flutter_template_name/src/common/util/platform/keyboard_observer_js.dart';

sealed class KeyboardObserver {
  KeyboardObserver._();
  static IKeyboardObserver? _keyboardObserver;
  static IKeyboardObserver get instance => _keyboardObserver ??= $getKeyboardObserver();
  static IKeyboardObserver get I => instance;
}
