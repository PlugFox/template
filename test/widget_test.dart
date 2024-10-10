import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() => group('Widget', () {
      testWidgets(
        'Placeholder',
        (tester) async {
          await tester.pumpWidget(const SizedBox());
          expect(find.byType(SizedBox), findsOneWidget);
        },
      );
    });
