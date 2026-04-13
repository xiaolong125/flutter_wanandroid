import 'package:flutter_wanandroid/features/auth/domain/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.checking() = AuthStateChecking;
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.authenticated(User user) = AuthStateAuthenticated;
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  const factory AuthState.failure(String message) = AuthStateFailure;
}

extension AuthStateX on AuthState {
  bool get isAuthenticated => switch (this) {
    AuthStateAuthenticated() => true,
    _ => false,
  };

  bool get isBusy => switch (this) {
    AuthStateChecking() || AuthStateLoading() => true,
    _ => false,
  };

  User? get user => switch (this) {
    AuthStateAuthenticated(:final user) => user,
    _ => null,
  };

  String? get errorMessage => switch (this) {
    AuthStateFailure(:final message) => message,
    _ => null,
  };
}
