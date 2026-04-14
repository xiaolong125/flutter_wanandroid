import 'package:flutter_wanandroid/features/auth/domain/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 这行表示：当前文件会和 freezed 自动生成的代码一起工作。
// 你写“状态定义”，生成器帮你补齐大量模板代码。
part 'auth_state.freezed.dart';

// @freezed 用来定义“不可变数据类 / 联合类型”。
// 这里的 AuthState 不是一个普通 class，而是一组“认证状态”的集合。
// 也可以理解成：用户认证流程在任意时刻，只会处于下面几种状态之一。
@freezed
sealed class AuthState with _$AuthState {
  // checking：应用启动后，正在检查本地是否已有登录信息。
  const factory AuthState.checking() = AuthStateChecking;

  // loading：正在执行登录或注册请求。
  const factory AuthState.loading() = AuthStateLoading;

  // authenticated：已登录，并携带当前登录用户信息。
  const factory AuthState.authenticated(User user) = AuthStateAuthenticated;

  // unauthenticated：未登录。
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;

  // failure：认证流程失败，并附带错误提示文案。
  const factory AuthState.failure(String message) = AuthStateFailure;
}

// extension 可以理解为：不给原类改定义的前提下，额外“挂载”一些方便使用的属性/方法。
// 这样 UI 或 Notifier 在读取 AuthState 时会更直观。
extension AuthStateX on AuthState {
  // 当前状态是否为“已登录”。
  bool get isAuthenticated => switch (this) {
    AuthStateAuthenticated() => true,
    _ => false,
  };

  // 当前状态是否处于“忙碌中”。
  // 一般 checking / loading 都可以让界面显示 loading 动画。
  bool get isBusy => switch (this) {
    AuthStateChecking() || AuthStateLoading() => true,
    _ => false,
  };

  // 如果当前已登录，就返回 User；否则返回 null。
  User? get user => switch (this) {
    AuthStateAuthenticated(:final user) => user,
    _ => null,
  };

  // 如果当前是失败状态，就返回错误信息；否则返回 null。
  String? get errorMessage => switch (this) {
    AuthStateFailure(:final message) => message,
    _ => null,
  };

  // 这是一个“适合打日志”的文本描述。
  // 以后如果你想观察状态变化，可以直接打印 state.debugLabel。
  String get debugLabel => switch (this) {
    AuthStateChecking() => 'AuthState: checking（正在检查本地登录状态）',
    AuthStateLoading() => 'AuthState: loading（正在请求登录/注册）',
    AuthStateAuthenticated(:final user) =>
      'AuthState: authenticated（已登录，user=${user.username}）',
    AuthStateUnauthenticated() => 'AuthState: unauthenticated（未登录）',
    AuthStateFailure(:final message) =>
      'AuthState: failure（认证失败，message=$message）',
  };
}
