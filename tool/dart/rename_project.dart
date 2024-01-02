import 'dart:io' as io;

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;

const String _defaultName = 'flutter_template_name';
const String _defaultOrganization = 'dev.flutter.template';
const String _defaultDescription = 'flutter_template_description';
const Set<String> _extensions = {
  '.dart',
  '.yaml',
  '.gradle',
  '.xml',
  '.kt',
  '.plist',
  '.txt',
  '.cc',
  '.cpp',
  '.rc',
  '.xcconfig',
  '.pbxproj',
  '.xcscheme',
  '.html',
  '.json',
};

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

  final name = extractArg('--name');
  final org = extractArg('--organization');
  final desc = extractArg('--description');
  if (name == null || org == null || desc == null) _throwArguments();
  _renameDirectory(_defaultName, name);
  _changeContent([
    (from: _defaultName, to: name),
    (from: _defaultOrganization, to: org),
    (from: _defaultDescription, to: desc),
  ]);
}

Never _throwArguments() {
  io.stderr.writeln('Pass arguments: '
      '--name="name" '
      '--organization="org.domain" '
      '--description="description"');
  io.exit(1);
}

Iterable<io.FileSystemEntity> _recursiveDirectories(
    io.Directory directory) sync* {
  for (final e in directory.listSync(recursive: false, followLinks: false)) {
    if (e is io.File) {
      if (!_extensions.contains(p.extension(e.path))) continue;
      yield e;
    } else if (e is io.Directory) {
      if (p.basename(e.path).startsWith('.')) continue;
      yield e;
      yield* _recursiveDirectories(e);
    }
  }
}

void _renameDirectory(String from, String to) =>
    _recursiveDirectories(io.Directory.current)
        .whereType<io.Directory>()
        .toList(growable: false)
        .where((dir) => p.basename(dir.path) == from)
        .forEach((dir) => dir.renameSync(p.join(p.dirname(dir.path), to)));

void _changeContent(List<({String from, String to})> pairs) =>
    _recursiveDirectories(io.Directory.current)
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
