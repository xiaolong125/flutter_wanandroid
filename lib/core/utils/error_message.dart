import 'package:dio/dio.dart';

String readableMessage(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['errorMsg'] is String) {
      final message = (data['errorMsg'] as String).trim();
      if (message.isNotEmpty) {
        return message;
      }
    }

    final message = error.message?.trim();
    if (message != null && message.isNotEmpty) {
      return message;
    }

    return '网络请求失败，请稍后重试';
  }

  final message = error.toString();
  return message.startsWith('Exception: ')
      ? message.substring('Exception: '.length)
      : message;
}
