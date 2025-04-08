import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_template_name/src/feature/authentication/model/sign_in_data.dart';
import 'package:flutter_template_name/src/feature/authentication/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IAuthenticationRepository {
  Stream<User> userChanges();
  Future<User> getUser();
  Future<User> signIn(SignInData data);
  Future<User?> restore();
  Future<void> signOut();
}

class AuthenticationRepositoryImpl implements IAuthenticationRepository {
  AuthenticationRepositoryImpl({required SharedPreferences sharedPreferences}) : _sharedPreferences = sharedPreferences;

  static const String _sessionKey = 'authentication.session';
  final SharedPreferences _sharedPreferences;
  final StreamController<User> _userController = StreamController<User>.broadcast();
  User _user = const User.unauthenticated();

  @override
  Future<User> getUser() async => _user;

  @override
  Stream<User> userChanges() => _userController.stream;

  @override
  Future<User> signIn(SignInData data) => Future<User>.delayed(const Duration(seconds: 1), () {
    final user = User.authenticated(id: data.username);
    _sharedPreferences.setString(_sessionKey, jsonEncode(user.toJson())).ignore();
    _userController.add(_user = user);
    return user;
  });

  @override
  Future<User?> restore() async {
    final session = _sharedPreferences.getString(_sessionKey);
    if (session == null) return null;
    final json = jsonDecode(session);
    if (json case Map<String, Object?> jsonMap) {
      final user = User.fromJson(jsonMap);
      _userController.add(_user = user);
    }
    return _user;
  }

  @override
  Future<void> signOut() => Future<void>.delayed(Duration.zero, () {
    const user = User.unauthenticated();
    _sharedPreferences.remove(_sessionKey).ignore();
    _userController.add(_user = user);
  });
}

@visibleForTesting
class AuthenticationRepositoryFake implements IAuthenticationRepository {
  AuthenticationRepositoryFake({Map<String, Object?>? store}) : _store = store ?? <String, Object?>{};

  static const String _sessionKey = 'authentication.session';
  final Map<String, Object?> _store;
  final StreamController<User> _userController = StreamController<User>.broadcast();
  User _user = const User.unauthenticated();

  @override
  Future<User> getUser() async => _user;

  @override
  Stream<User> userChanges() => _userController.stream;

  @override
  Future<User> signIn(SignInData data) => Future<User>.delayed(const Duration(seconds: 1), () {
    final user = User.authenticated(id: data.username);
    _store[_sessionKey] = jsonEncode(user.toJson());
    _userController.add(_user = user);
    return user;
  });

  @override
  Future<User?> restore() async {
    final session = _store[_sessionKey];
    if (session is! String) return null;
    final json = jsonDecode(session);
    if (json case Map<String, Object?> jsonMap) {
      final user = User.fromJson(jsonMap);
      _userController.add(_user = user);
    }
    return _user;
  }

  @override
  Future<void> signOut() => Future<void>.delayed(Duration.zero, () {
    const user = User.unauthenticated();
    _store.remove(_sessionKey);
    _userController.add(_user = user);
  });
}
