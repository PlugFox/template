// Generator of random words, sentences and paragraphs.

import 'dart:convert';
import 'dart:math' as math;

final _$rnd = math.Random();
const _$nbsp = '\u00A0';

/// Generate a random word with a length between [min] and [max] (inclusive).
String generateWord([int min = 1, int max = 8]) => utf8.decode(
      List<int>.generate(_$rnd.nextInt(max - min + 1) + min, (_) => _$rnd.nextInt(26) + 97),
      allowMalformed: false,
    );

/// Generate a random sentence with a length between [min] and [max] (inclusive).
String generateSentence([int min = 2, int max = 8]) => (StringBuffer()
      ..write(() {
        final word = generateWord();
        return '${word[0].toUpperCase()}${word.substring(1)}';
      }())
      ..writeAll(
        List<String>.generate(_$rnd.nextInt(max - min + 1) + min, (_) => generateWord()),
        _$nbsp,
      )
      ..write('.'))
    .toString();

/// Generate a random paragraph with a length between [min] and [max] (inclusive).
String generateParagraph([int min = 15, int max = 30]) =>
    Iterable.generate(_$rnd.nextInt(15) + 15, (_) => generateSentence()).join(' ');
