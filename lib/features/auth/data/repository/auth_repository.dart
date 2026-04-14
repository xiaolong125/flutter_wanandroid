import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_wanandroid/core/network/dio_client.dart';
import 'package:flutter_wanandroid/core/utils/app_logger.dart';
import 'package:flutter_wanandroid/features/auth/data/remote/auth_api.dart';
import 'package:flutter_wanandroid/features/auth/domain/model/user.dart';
import 'package:logger/logger.dart';
import 'package:retrofit/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._api, this._storage, this._logger);

  final AuthApi _api;
  final FlutterSecureStorage _storage;
  final Logger _logger;

  Future<String?> readToken() async {
    final token = await _storage.read(key: authTokenStorageKey);
    _logger.d('Read auth token: exists=${token != null && token.isNotEmpty}');
    return token;
  }

  Future<User?> readUser() async {
    final rawUser = await _storage.read(key: authUserStorageKey);
    if (rawUser == null || rawUser.isEmpty) {
      _logger.d('Read auth user: empty');
      return null;
    }

    try {
      final user = User.fromJson(jsonDecode(rawUser) as Map<String, dynamic>);
      _logger.d('Read auth user: username=${user.username}');
      return user;
    } catch (error, stackTrace) {
      _logger.w(
        'Parse stored auth user failed, ignore local cache',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<User> login({
    required String username,
    required String password,
  }) async {
    final normalizedUsername = username.trim();
    final normalizedPassword = password.trim();

    if (normalizedUsername.isEmpty || normalizedPassword.isEmpty) {
      _logger.w('Login validation failed: username or password is empty');
      throw Exception('请输入用户名和密码');
    }

    _logger.i('Login requested: username=$normalizedUsername');

    try {
      final response = await _api.login(normalizedUsername, normalizedPassword);
      final user = await _persistSession(response);
      _logger.i('Login succeeded: username=${user.username}');
      return user;
    } catch (error, stackTrace) {
      _logger.e(
        'Login failed: username=$normalizedUsername',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<User> register({
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    final normalizedUsername = username.trim();
    final normalizedPassword = password.trim();
    final normalizedConfirmPassword = confirmPassword.trim();

    if (normalizedUsername.isEmpty) {
      _logger.w('Register validation failed: username is empty');
      throw Exception('请填写账号');
    }

    if (normalizedPassword.isEmpty) {
      _logger.w('Register validation failed: password is empty');
      throw Exception('请填写密码');
    }

    if (normalizedConfirmPassword.isEmpty) {
      _logger.w('Register validation failed: confirm password is empty');
      throw Exception('请填写确认密码');
    }

    if (normalizedPassword.length < 6) {
      _logger.w('Register validation failed: password too short');
      throw Exception('密码最少6位');
    }

    if (normalizedPassword != normalizedConfirmPassword) {
      _logger.w('Register validation failed: passwords do not match');
      throw Exception('密码不一致');
    }

    _logger.i('Register requested: username=$normalizedUsername');

    try {
      final response = await _api.register(
        normalizedUsername,
        normalizedPassword,
        normalizedConfirmPassword,
      );
      final user = await _persistSession(response);
      _logger.i('Register succeeded: username=${user.username}');
      return user;
    } catch (error, stackTrace) {
      _logger.e(
        'Register failed: username=$normalizedUsername',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    _logger.i('Logout requested');

    try {
      await _api.logout();
      _logger.d('Remote logout succeeded');
    } catch (error, stackTrace) {
      _logger.w(
        'Remote logout failed, continue clearing local session',
        error: error,
        stackTrace: stackTrace,
      );
    }

    await _storage.delete(key: authTokenStorageKey);
    await _storage.delete(key: authUserStorageKey);
    _logger.i('Local auth session cleared');
  }

  Future<User> _persistSession(HttpResponse<dynamic> response) async {
    final user = _normalizeUser(User.fromJson(_unwrapUserJson(response.data)));
    final authCookie = _extractAuthCookie(response);

    if (authCookie == null) {
      _logger.e('Persist auth session failed: auth cookie is missing');
      throw Exception('登录态保存失败，请稍后重试');
    }

    await _storage.write(key: authTokenStorageKey, value: authCookie);
    await _storage.write(
      key: authUserStorageKey,
      value: jsonEncode(user.toJson()),
    );
    _logger.d('Persist auth session succeeded: username=${user.username}');

    return user;
  }

  Map<String, dynamic> _unwrapUserJson(dynamic responseData) {
    if (responseData is! Map) {
      _logger.e(
        'Unwrap user json failed: response data is not a map',
        error: responseData,
      );
      throw Exception('服务返回异常，请稍后重试');
    }

    final payload = Map<String, dynamic>.from(responseData);
    final errorCode = payload['errorCode'];
    if (errorCode != 0) {
      final message = payload['errorMsg']?.toString().trim();
      _logger.w(
        'Auth api returned business error: code=$errorCode, '
        'message=${message == null || message.isEmpty ? 'empty' : message}',
      );
      throw Exception(
        message == null || message.isEmpty ? '请求失败，请稍后重试' : message,
      );
    }

    final data = payload['data'];
    if (data is! Map) {
      _logger.e(
        'Unwrap user json failed: data field is not a map',
        error: data,
      );
      throw Exception('用户数据解析失败');
    }

    _logger.d('Unwrap user json succeeded');
    return Map<String, dynamic>.from(data);
  }

  String? _extractAuthCookie(HttpResponse<dynamic> response) {
    final cookies = response.response.headers['set-cookie'];
    if (cookies == null || cookies.isEmpty) {
      _logger.w('Extract auth cookie failed: set-cookie header is empty');
      return null;
    }

    final pairs = <String>{};
    for (final cookie in cookies) {
      final pair = cookie.split(';').first.trim();
      if (pair.isNotEmpty) {
        pairs.add(pair);
      }
    }

    if (pairs.isEmpty) {
      _logger.w('Extract auth cookie failed: cookie pairs are empty');
      return null;
    }

    _logger.d('Extract auth cookie succeeded: pairCount=${pairs.length}');
    return pairs.join('; ');
  }

  User _normalizeUser(User user) {
    final nickname = user.nickname.trim().isEmpty
        ? user.username
        : user.nickname;
    final email = user.email?.trim();
    final avatar = user.avatar?.trim();

    _logger.d('Normalize user info: username=${user.username}');
    return user.copyWith(
      nickname: nickname,
      email: email == null || email.isEmpty ? null : email,
      avatar: avatar == null || avatar.isEmpty ? null : avatar,
    );
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(authApiProvider),
    ref.watch(secureStorageProvider),
    ref.watch(appLoggerProvider),
  );
}
