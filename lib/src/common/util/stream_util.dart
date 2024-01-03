import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data' as td;

import 'package:meta/meta.dart';

/// Stream extension methods.
///
/// {@macro stream.relieve_stream_transformer}
extension StreamExtension<Input> on Stream<Input> {
  /// {@macro stream.relieve_stream_transformer}
  Stream<Input> relieve([
    Duration duration = const Duration(milliseconds: 4),
  ]) =>
      transform<Input>(_RelieveStreamTransformer<Input>(duration));
}

/// Chunker extension methods.
///
/// {@macro stream.chunker}
extension ChunkerExtension on Stream<List<int>> {
  /// {@macro stream.chunker}
  Stream<td.Uint8List> chunker(int size) => transform<td.Uint8List>(Chunker(size));
}

/// {@template stream.relieve_stream_transformer}
/// Allow relieve impact on event loop on large collections.
/// Parallelize the event queue and free up time for processing animation,
/// user gestures without using isolates.
///
/// Thats transformer makes stream low priority.
///
/// [duration] - elapsed time of iterations before releasing
/// the event queue and microtasks.
/// {@endtemplate}
@immutable
class _RelieveStreamTransformer<T> extends StreamTransformerBase<T, T> {
  /// {@macro stream.relieve_stream_transformer}
  const _RelieveStreamTransformer([
    this.duration = const Duration(milliseconds: 4),
  ]);

  /// Elapsed time of iterations before releasing
  /// the event queue and microtasks.
  final Duration duration;

  @override
  Stream<T> bind(Stream<T> stream) {
    final controller = stream.isBroadcast ? StreamController<T>.broadcast(sync: true) : StreamController<T>(sync: true);
    return (controller..onListen = () => _onListen(stream, controller)).stream;
  }

  void _onListen(
    Stream<T> stream,
    StreamController<T> controller,
  ) {
    final stopwatch = Stopwatch()..start();
    final sink = controller.sink;
    final subscription = stream.listen(null, cancelOnError: false);
    controller.onCancel = subscription.cancel;
    if (!stream.isBroadcast) {
      controller
        ..onPause = subscription.pause
        ..onResume = subscription.resume;
    }
    final scaffold = _scaffold(sink, subscription.pause, subscription.resume);
    subscription
      ..onData((data) => scaffold(stopwatch, data))
      ..onError(sink.addError)
      ..onDone(() {
        stopwatch.stop();
        sink.close();
      });
  }

  void Function(Stopwatch stopwatch, T data) _scaffold(
    StreamSink<T> sink,
    void Function([Future<void>? resumeSignal]) pause,
    void Function() resume,
  ) =>
      (stopwatch, data) {
        if (stopwatch.elapsed > duration) {
          pause();
          Timer.run(() {
            try {
              sink.add(data);
              stopwatch.reset();
              resume();
            } on Object catch (error, stackTrace) {
              sink.addError(error, stackTrace);
            }
          });
        } else {
          try {
            sink.add(data);
          } on Object catch (error, stackTrace) {
            sink.addError(error, stackTrace);
          }
        }
      };
}

/// {@template stream.chunker}
/// Chunker stream transformer.
///
/// e.g.:
/// ```dart
/// stream.chunker(1024);
/// ```
/// {@endtemplate}
@immutable
class Chunker extends StreamTransformerBase<List<int>, td.Uint8List> {
  /// {@macro stream.chunker}
  const Chunker(this.chunkSize);

  /// Chunk size.
  final int chunkSize;

  @override
  Stream<td.Uint8List> bind(Stream<List<int>> stream) {
    final controller = stream.isBroadcast
        ? StreamController<td.Uint8List>.broadcast(sync: true)
        : StreamController<td.Uint8List>(sync: true);
    return (controller..onListen = () => _onListen(stream, controller)).stream;
  }

  void _onListen(
    Stream<List<int>> stream,
    StreamController<td.Uint8List> controller,
  ) {
    final sink = controller.sink;
    final subscription = stream.listen(null, cancelOnError: false);
    controller.onCancel = subscription.cancel;
    if (!stream.isBroadcast) {
      controller
        ..onPause = subscription.pause
        ..onResume = subscription.resume;
    }
    final bytes = td.BytesBuilder();
    final onData = _$onData(bytes, sink);
    subscription
      ..onData(onData)
      ..onError(sink.addError)
      ..onDone(() {
        if (bytes.isNotEmpty) sink.add(bytes.takeBytes());
        sink.close().ignore();
      });
  }

  void Function(List<int> data) _$onData(
    td.BytesBuilder bytes,
    StreamSink<td.Uint8List> sink,
  ) =>
      (data) {
        try {
          final dataLength = data.length;
          for (var offset = 0; offset < data.length; offset += chunkSize) {
            final end = math.min<int>(offset + chunkSize, dataLength);
            final to = math.min<int>(end, offset + chunkSize - bytes.length);
            bytes.add(data.sublist(offset, to));
            if (to != end) {
              sink.add(bytes.takeBytes());
              bytes.add(data.sublist(to, end));
            }
            if (bytes.length == chunkSize) {
              sink.add(bytes.takeBytes());
            }
          }
        } on Object catch (error, stackTrace) {
          sink.addError(error, stackTrace);
        }
      };
}
