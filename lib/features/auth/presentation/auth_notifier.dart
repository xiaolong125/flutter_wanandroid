import 'package:flutter_wanandroid/core/utils/error_message.dart';
import 'package:flutter_wanandroid/features/auth/data/repository/auth_repository.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    Future.microtask(_checkAuthState);
    return const AuthState.checking();
  }

  Future<void> _checkAuthState() async {
    final repository = ref.read(authRepositoryProvider);
    final token = await repository.readToken();
    final user = await repository.readUser();

    if (token != null && token.isNotEmpty && user != null) {
      state = AuthState.authenticated(user);
      return;
    }

    state = const AuthState.unauthenticated();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AuthState.loading();

    try {
      final user = await ref
          .read(authRepositoryProvider)
          .login(username: username, password: password);
      state = AuthState.authenticated(user);
    } catch (error) {
      state = AuthState.failure(readableMessage(error));
    }
  }

  Future<void> register({
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AuthState.loading();

    try {
      final user = await ref
          .read(authRepositoryProvider)
          .register(
            username: username,
            password: password,
            confirmPassword: confirmPassword,
          );
      state = AuthState.authenticated(user);
    } catch (error) {
      state = AuthState.failure(readableMessage(error));
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState.unauthenticated();
  }
}
