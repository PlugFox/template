// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import 'package:intl/intl.dart' as intl;
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

/// A [JsonConverter] that converts between a [DateTime] and a [String] in the
/// ISO 8601 format.
///
/// Use it as an annotation, like so: `@dateTimeJsonConverter`.
const JsonConverter<DateTime, String> dateTimeJsonConverter = DateTimeJsonCodec();

/// Convert a [DateTime] to a JSON value.
String toJsonDateTime(DateTime value) => dateTimeJsonConverter.toJson(value);

/// Convert a [DateTime] to a JSON value or return `null` if the value is `null`.
String? toJsonDateTimeOrNull(DateTime? value) => value == null ? null : dateTimeJsonConverter.toJson(value);

/// Restore the [DateTime] from a JSON value.
DateTime fromJsonDateTime(Object json) =>
    fromJsonDateTimeOrNull(json) ?? (throw ArgumentError.value(json, 'json', 'Invalid DateTime value'));

/// Restore the [DateTime] from a JSON value or return `null` if the value is `null`.
DateTime? fromJsonDateTimeOrNull(Object? json) => switch (json) {
      String s => DateTime.tryParse(s),
      null => null,
      int ms => DateTime.fromMillisecondsSinceEpoch(ms),
      DateTime dt => dt,
      _ => throw ArgumentError.value(json, 'json', 'Invalid DateTime value'),
    };

/// A [Converter] that converts between a [DateTime] and a [String] in the
/// ISO 8601 format.
///
/// You should prefer using this codec instead of [DateTime.toIso8601String].
class DateTimeJsonCodec extends Codec<DateTime, String> implements JsonConverter<DateTime, String> {
  @literal
  const DateTimeJsonCodec();

  @override
  Converter<DateTime, String> get encoder => const DateTimeToJsonEncoder();

  @override
  Converter<String, DateTime> get decoder => const DateTimeFromJsonDecoder();

  @override
  String toJson(DateTime object) => encoder.convert(object);

  @override
  DateTime fromJson(String json) => decoder.convert(json);
}

/// A [DateTime] -> [String] converter.
class DateTimeToJsonEncoder extends Converter<DateTime, String> {
  @literal
  const DateTimeToJsonEncoder();

  @override
  String convert(DateTime input) => input.isUtc ? input.toUtcIso8601String() : input.toLocalIso8601String();
}

/// A [String] -> [DateTime] converter.
class DateTimeFromJsonDecoder extends Converter<String, DateTime> {
  @literal
  const DateTimeFromJsonDecoder();

  @override
  DateTime convert(String input) {
    final dateTime = DateTime.parse(input);
    return input.endsWith('Z') ? dateTime.toUtc() : dateTime.toLocal();
  }
}

/// Extension methods for the DateTime class.
extension DateTimeExtension on DateTime {
  static final intl.DateFormat _isoFormat = intl.DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  /// Format date
  String format({intl.DateFormat? format}) {
    if (format != null) return format.format(this);
    final now = DateTime.now();
    final today = now.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    if (isAfter(today)) return intl.DateFormat.Hms().format(this);
    if (isAfter(today.subtract(const Duration(days: 7)))) {
      return intl.DateFormat(intl.DateFormat.WEEKDAY).format(this);
    }
    return intl.DateFormat.yMd().format(this);
  }

  /// Returns a DateTime representation as a String in the UTC timezone.
  String toUtcIso8601String() => '${_isoFormat.format(toUtc())}Z';

  /// Returns a DateTime representation as a String in the local timezone.
  String toLocalIso8601String() {
    final dateTime = toLocal();
    final tz = dateTime.timeZoneOffset;

    final buffer = StringBuffer()
      ..write(_isoFormat.format(dateTime))
      ..write(tz.isNegative ? '-' : '+')
      ..write(tz.inHours.abs().toString().padLeft(2, '0'))
      ..write(':')
      ..write((tz.inMinutes.abs() % 60).toString().padLeft(2, '0'));

    return buffer.toString();
  }
}
