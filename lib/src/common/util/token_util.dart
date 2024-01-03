// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';
import 'dart:math' as math;

sealed class TokenUtil {
  static final math.Random _random = math.Random.secure();

  /// Generate a random token.
  static String generate([int length = 64]) {
    var byteLength = (length * 6 + 7) ~/ 8;
    var values = List<int>.generate(byteLength, (i) => _random.nextInt(256));
    var token = base64Url.encode(values);
    assert(token.length >= length, 'Token length to short');
    return token.length > length ? token.substring(0, length) : token;
  }
}
