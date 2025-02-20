import 'package:flutter/widgets.dart';
import 'package:flutter_template_name/src/common/database/database.dart';
import 'package:flutter_template_name/src/common/model/app_metadata.dart';
import 'package:flutter_template_name/src/common/util/api_client.dart';
import 'package:flutter_template_name/src/feature/authentication/controller/authentication_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template dependencies}
/// Application dependencies.
/// {@endtemplate}
class Dependencies {
  /// {@macro dependencies}
  Dependencies();

  /// The state from the closest instance of this class.
  ///
  /// {@macro dependencies}
  factory Dependencies.of(BuildContext context) => InheritedDependencies.of(context);

  /// Injest dependencies to the widget tree.
  Widget inject({required Widget child, Key? key}) => InheritedDependencies(dependencies: this, key: key, child: child);

  /// App metadata
  late final AppMetadata metadata;

  /// Shared preferences
  late final SharedPreferences sharedPreferences;

  /// Database
  late final Database database;

  /// API Client
  late final ApiClient apiClient;

  /// Authentication controller
  late final AuthenticationController authenticationController;

  @override
  String toString() => 'Dependencies{}';
}

/// Fake Dependencies
@visibleForTesting
class FakeDependencies extends Dependencies {
  FakeDependencies();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    // ... implement fake dependencies
    throw UnimplementedError();
  }
}

/// {@template inherited_dependencies}
/// InheritedDependencies widget.
/// {@endtemplate}
class InheritedDependencies extends InheritedWidget {
  /// {@macro inherited_dependencies}
  const InheritedDependencies({required this.dependencies, required super.child, super.key});

  final Dependencies dependencies;

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  static Dependencies? maybeOf(BuildContext context) =>
      (context.getElementForInheritedWidgetOfExactType<InheritedDependencies>()?.widget as InheritedDependencies?)
          ?.dependencies;

  static Never _notFoundInheritedWidgetOfExactType() =>
      throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a InheritedDependencies of the exact type',
        'out_of_scope',
      );

  /// The state from the closest instance of this class
  /// that encloses the given context.
  static Dependencies of(BuildContext context) => maybeOf(context) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant InheritedDependencies oldWidget) => false;
}
