import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_wanandroid/core/utils/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

const authTokenStorageKey = 'auth_token';
const authUserStorageKey = 'auth_user';
const _baseUrl = 'https://www.wanandroid.com';

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
        handler.next(options);
      },
      onError: (error, handler) {
        logger.e('HTTP error', error: error, stackTrace: error.stackTrace);
        handler.next(error);
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: false,
      logPrint: (message) => logger.d(message),
    ),
  );

  return dio;
}
