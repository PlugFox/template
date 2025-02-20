import 'package:flutter/material.dart';
import 'package:flutter_template_name/src/common/model/dependencies.dart';
import 'package:flutter_template_name/src/common/widget/app.dart';
import 'package:flutter_template_name/src/feature/authentication/controller/authentication_controller.dart';
import 'package:flutter_template_name/src/feature/authentication/data/authentication_repository.dart';
import 'package:flutter_template_name/src/feature/settings/widget/settings_scope.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octopus/octopus.dart';

void main() => group('Widget', () {
  testWidgets('Dependencies_are_injected', (tester) async {
    await tester.pumpWidget(FakeDependencies().inject(child: Container()));
    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(InheritedDependencies), findsOneWidget);
    final context = tester.element(find.byType(Container));
    expect(Dependencies.of(context), allOf(isNotNull, isA<Dependencies>(), isA<FakeDependencies>()));
  });

  testWidgets('App', (tester) async {
    final dependencies =
        FakeDependencies()
          ..authenticationController = AuthenticationController(repository: AuthenticationRepositoryFake());
    await tester.pumpWidget(
      dependencies.inject(child: const SettingsScope(child: NoAnimationScope(noAnimation: true, child: App()))),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(InheritedDependencies), findsOneWidget);
  });
});
