import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_wanandroid/core/network/dio_client.dart';
import 'package:flutter_wanandroid/features/auth/data/remote/auth_api.dart';
import 'package:flutter_wanandroid/features/auth/domain/model/user.dart';
import 'package:retrofit/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._api, this._storage);

  final AuthApi _api;
  final FlutterSecureStorage _storage;

  Future<String?> readToken() {
    return _storage.read(key: authTokenStorageKey);
  }

  Future<User?> readUser() async {
    final rawUser = await _storage.read(key: authUserStorageKey);
    if (rawUser == null || rawUser.isEmpty) {
      return null;
    }

    try {
      return User.fromJson(jsonDecode(rawUser) as Map<String, dynamic>);
    } catch (_) {
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
      throw Exception('请输入用户名和密码');
    }

    final response = await _api.login(normalizedUsername, normalizedPassword);
    return _persistSession(response);
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
      throw Exception('请填写账号');
    }

    if (normalizedPassword.isEmpty) {
      throw Exception('请填写密码');
    }

    if (normalizedConfirmPassword.isEmpty) {
      throw Exception('请填写确认密码');
    }

    if (normalizedPassword.length < 6) {
      throw Exception('密码最少6位');
    }

    if (normalizedPassword != normalizedConfirmPassword) {
      throw Exception('密码不一致');
    }

    final response = await _api.register(
      normalizedUsername,
      normalizedPassword,
      normalizedConfirmPassword,
    );

    return _persistSession(response);
  }

  Future<void> logout() async {
    try {
      await _api.logout();
    } catch (_) {}

    await _storage.delete(key: authTokenStorageKey);
    await _storage.delete(key: authUserStorageKey);
  }

  Future<User> _persistSession(HttpResponse<dynamic> response) async {
    final user = _normalizeUser(User.fromJson(_unwrapUserJson(response.data)));
    final authCookie = _extractAuthCookie(response);

    if (authCookie == null) {
      throw Exception('登录态保存失败，请稍后重试');
    }

    await _storage.write(key: authTokenStorageKey, value: authCookie);
    await _storage.write(
      key: authUserStorageKey,
      value: jsonEncode(user.toJson()),
    );

    return user;
  }

  Map<String, dynamic> _unwrapUserJson(dynamic responseData) {
    if (responseData is! Map) {
      throw Exception('服务返回异常，请稍后重试');
    }

    final payload = Map<String, dynamic>.from(responseData);
    final errorCode = payload['errorCode'];
    if (errorCode != 0) {
      final message = payload['errorMsg']?.toString().trim();
      throw Exception(
        message == null || message.isEmpty ? '请求失败，请稍后重试' : message,
      );
    }

    final data = payload['data'];
    if (data is! Map) {
      throw Exception('用户数据解析失败');
    }

    return Map<String, dynamic>.from(data);
  }

  String? _extractAuthCookie(HttpResponse<dynamic> response) {
    final cookies = response.response.headers['set-cookie'];
    if (cookies == null || cookies.isEmpty) {
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
      return null;
    }

    return pairs.join('; ');
  }

  User _normalizeUser(User user) {
    final nickname = user.nickname.trim().isEmpty
        ? user.username
        : user.nickname;
    final email = user.email?.trim();
    final avatar = user.avatar?.trim();

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
  );
}
