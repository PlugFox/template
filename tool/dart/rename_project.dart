import 'dart:io' as io;

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;

const String _defaultName = 'flutter_template_name';
const String _defaultOrganization = 'dev.flutter.template';
const String _defaultDescription = 'flutter_template_description';

/// dart run tool/dart/rename_project.dart --name="qqq" --organization="www" --description="eee"
void main([List<String>? args]) {
  if (args == null || args.isEmpty) _throwArguments();
  String? extractArg(String key) {
    final value = args.firstWhereOrNull((e) => e.startsWith(key));
    if (value == null) return null;
    return RegExp(r'[\d\w\.\-\_ ]+')
        .allMatches(value.substring(key.length))
        .map((e) => e.group(0))
        .join()
        .trim();
  }

  final n = extractArg('--name');
  final o = extractArg('--organization');
  final d = extractArg('--description');
  if (n == null || o == null || d == null) _throwArguments();
  _renameDirectory(_defaultName, n);
  _changeContent([
    (from: _defaultName, to: n),
    (from: _defaultOrganization, to: o),
    (from: _defaultDescription, to: d),
  ]);
}

Never _throwArguments() {
  io.stderr.writeln('Pass arguments: '
      '--name="name" '
      '--organization="org.domain" '
      '--description="description"');
  io.exit(1);
}

void _renameDirectory(String from, String to) => io.Directory(from)
    .listSync(recursive: true)
    .whereType<io.Directory>()
    .where((dir) => p.basename(dir.path) == from)
    .forEach((dir) => dir.renameSync(p.join(p.dirname(dir.path), to)));

void _changeContent(List<({String from, String to})> pairs) =>
    io.Directory.current
        .listSync(recursive: true)
        .whereType<io.File>()
        .forEach((e) {
      var content = e.readAsStringSync();
      var changed = false;
      for (final pair in pairs) {
        if (!content.contains(pair.from)) continue;
        content = content.replaceAll(pair.from, pair.to);
        changed = true;
      }
      if (!changed) return;
      e.writeAsStringSync(content);
    });
