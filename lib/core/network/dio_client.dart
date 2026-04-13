import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_wanandroid/core/utils/app_logger.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

const authTokenStorageKey = 'auth_token';
const authUserStorageKey = 'auth_user';
const _baseUrl = 'https://www.wanandroid.com';
const _requestStopwatchKey = 'request_stopwatch';

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

@riverpod
Dio dioClient(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  final logger = ref.watch(appLoggerProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final authCookie = await storage.read(key: authTokenStorageKey);
        if (authCookie != null && authCookie.isNotEmpty) {
          options.headers['Cookie'] = authCookie;
        }
        options.extra[_requestStopwatchKey] = Stopwatch()..start();
        handler.next(options);
      },
    ),
  );

  dio.interceptors.add(_NetworkLogInterceptor(logger));

  return dio;
}

class _NetworkLogInterceptor extends Interceptor {
  _NetworkLogInterceptor(this._logger);

  static const _maxBodyLength = 2000;
  static const _sensitiveHeaderKeys = {'authorization', 'cookie', 'set-cookie'};

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('--> ${options.method} ${options.uri}');

    if (options.queryParameters.isNotEmpty) {
      _logger.d('Query: ${_stringify(options.queryParameters)}');
    }

    if (options.headers.isNotEmpty) {
      _logger.d('Headers: ${_stringify(_sanitizeHeaders(options.headers))}');
    }

    if (options.data != null) {
      _logger.d('Body: ${_stringify(options.data)}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final requestOptions = response.requestOptions;
    final duration = _takeElapsed(requestOptions);

    _logger.i(
      '<-- ${response.statusCode ?? '-'} ${requestOptions.method} '
      '${requestOptions.uri} (${duration}ms)',
    );

    if (response.data != null) {
      _logger.d('Response: ${_stringify(response.data)}');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestOptions = err.requestOptions;
    final duration = _takeElapsed(requestOptions);

    _logger.e(
      '<-- ERROR ${err.response?.statusCode ?? '-'} ${requestOptions.method} '
      '${requestOptions.uri} (${duration}ms)\n'
      'Message: ${err.message ?? err.error ?? 'unknown error'}\n'
      'Response: ${_stringify(err.response?.data)}',
      error: err,
      stackTrace: err.stackTrace,
    );

    super.onError(err, handler);
  }

  int _takeElapsed(RequestOptions options) {
    final stopwatch = options.extra.remove(_requestStopwatchKey);
    if (stopwatch is! Stopwatch) {
      return 0;
    }

    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    return {
      for (final entry in headers.entries)
        entry.key: _sensitiveHeaderKeys.contains(entry.key.toLowerCase())
            ? '***'
            : entry.value,
    };
  }

  String _stringify(dynamic data) {
    if (data == null) {
      return '-';
    }

    try {
      if (data is FormData) {
        return _truncate(
          jsonEncode({
            'fields': {for (final field in data.fields) field.key: field.value},
            'files': [for (final file in data.files) file.key],
          }),
        );
      }

      if (data is Map || data is List) {
        return _truncate(const JsonEncoder.withIndent('  ').convert(data));
      }

      return _truncate(data.toString());
    } catch (_) {
      return _truncate(data.toString());
    }
  }

  String _truncate(String text) {
    if (text.length <= _maxBodyLength) {
      return text;
    }

    return '${text.substring(0, _maxBodyLength)}...<truncated>';
  }
}
