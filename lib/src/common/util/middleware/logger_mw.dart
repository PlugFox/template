import 'dart:developer' as developer;

import 'package:flutter_template_name/src/common/util/api_client.dart';
import 'package:meta/meta.dart';

@immutable
class ApiClient$LoggerMiddleware {
  const ApiClient$LoggerMiddleware({this.logRequest = false, this.logResponse = true, this.logError = true});

  final bool logRequest;
  final bool logResponse;
  final bool logError;

  ApiClientHandler call(ApiClientHandler innerHandler) => (request, context) async {
    final stopwatch = Stopwatch()..start();
    try {
      if (logRequest) {
        developer.log('[${request.method}] ${request.url.path}', name: 'http', time: DateTime.now(), level: 300);
      }
      final response = await innerHandler(request, context);
      if (logResponse) {
        developer.log(
          '[${request.method}] ${request.url.path} -> ok | ${stopwatch.elapsedMilliseconds}ms',
          name: 'http',
          time: DateTime.now(),
          level: 300,
        );
      }
      return response;
    } on APIClientException catch (error, stackTrace) {
      if (logError) {
        developer.log(
          '[${request.method}] ${request.url.path} -> ${switch (error.statusCode) {
            501 => 'unimplemented',
            500 => 'internalError',
            409 => 'aborted',
            404 => 'notFound',
            403 => 'permissionDenied',
            401 => 'unauthenticated',
            400 => 'failedPrecondition',
            < 400 => 'unknownError',
            int statusCode => '$statusCode',
          }} | ${stopwatch.elapsedMilliseconds}ms',
          name: 'http',
          time: DateTime.now(),
          level: 900,
          error: error.statusCode >= 400 ? null : error,
          stackTrace: error.statusCode >= 400 ? null : stackTrace,
        );
      }
      rethrow;
    } finally {
      stopwatch.stop();
    }
  };
}
