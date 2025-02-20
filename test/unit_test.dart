import 'package:flutter_template_name/src/common/util/date_util.dart';
import 'package:test/test.dart';

void main() => group('Unit', () {
  group('DateUtil', () {
    test('DateTime_to_String', () {
      expect(
        DateTime(2024, 10, 27, 13, 45, 59).toLocalIso8601String(),
        allOf(isNotNull, isNotEmpty, startsWith('2024-10-27T13:45:59'), isNot(endsWith('59')), isNot(endsWith('Z'))),
      );

      expect(
        DateTime.utc(2024, 10, 27, 13, 45, 59).toUtcIso8601String(),
        allOf(isNotNull, isNotEmpty, equals('2024-10-27T13:45:59Z'), isNot(contains('+')), endsWith('Z')),
      );
    });

    test('String_to_DateTime', () {
      expect(
        DateTime.parse('2024-10-27T13:45:59+02:00'),
        isA<DateTime>()
            .having((it) => it.year, 'year', equals(2024))
            .having((it) => it.month, 'month', equals(10))
            .having((it) => it.minute, 'minute', equals(45))
            .having((it) => it.second, 'second', equals(59)),
      );

      expect(DateTime.parse('2024-10-27T13:45:59Z'), equals(DateTime.utc(2024, 10, 27, 13, 45, 59)));
    });
  });
});
