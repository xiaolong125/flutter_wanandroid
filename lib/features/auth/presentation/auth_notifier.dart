import 'package:flutter_wanandroid/core/utils/error_message.dart';
import 'package:flutter_wanandroid/features/auth/data/repository/auth_repository.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

// @Riverpod 会让 build_runner 自动生成对应的 Provider。
// keepAlive: true 表示这个认证状态会一直保留，不会因为页面切换而被销毁。
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // build() 是 Notifier 的初始化入口。
    // 这里先返回 checking 状态，让界面知道“正在检查登录状态”。
    // Future.microtask 会把真正的异步检查放到当前同步代码之后执行，
    // 避免在 build() 里直接 await。
    Future.microtask(_checkAuthState);
    return const AuthState.checking();
  }

  // 从本地安全存储中读取 token 和用户信息，
  // 判断用户之前是否已经登录过。
  Future<void> _checkAuthState() async {
    // ref.read(...) 用来读取另一个 Provider 暴露的对象。
    // 这里拿到 AuthRepository，所有登录相关的数据操作都交给它处理。
    final repository = ref.read(authRepositoryProvider);
    final token = await repository.readToken();
    final user = await repository.readUser();

    // token 和 user 都存在时，认为用户已登录。
    if (token != null && token.isNotEmpty && user != null) {
      state = AuthState.authenticated(user);
      return;
    }

    // 否则进入未登录状态，路由层会根据这个状态跳转到登录页。
    state = const AuthState.unauthenticated();
  }

  // 登录：页面把用户名和密码传进来，Notifier 负责更新认证状态。
  Future<void> login({
    required String username,
    required String password,
  }) async {
    // 请求开始前先切到 loading，方便 UI 显示加载中。
    state = const AuthState.loading();

    try {
      // 调用仓库层发起登录请求。
      // 登录成功后，仓库层通常会保存 token 和用户信息。
      final user = await ref
          .read(authRepositoryProvider)
          .login(username: username, password: password);
      // 登录成功：保存用户到状态里，UI 和路由会自动响应变化。
      state = AuthState.authenticated(user);
    } catch (error) {
      // 登录失败：把异常转换成适合展示给用户看的错误文案。
      state = AuthState.failure(readableMessage(error));
    }
  }

  // 注册：流程和登录类似，只是多了确认密码字段。
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
      // 注册成功后直接视为已登录。
      state = AuthState.authenticated(user);
    } catch (error) {
      state = AuthState.failure(readableMessage(error));
    }
  }

  // 退出登录：清除本地保存的登录信息，并把状态改回未登录。
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState.unauthenticated();
  }
}
