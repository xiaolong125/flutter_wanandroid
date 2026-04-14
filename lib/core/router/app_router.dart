import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_wanandroid/core/router/app_routes.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_notifier.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_state.dart';
import 'package:flutter_wanandroid/features/auth/presentation/login_screen.dart';
import 'package:flutter_wanandroid/features/auth/presentation/register_screen.dart';
import 'package:flutter_wanandroid/features/detail/domain/model/web_page.dart';
import 'package:flutter_wanandroid/features/detail/presentation/detail_screen.dart';
import 'package:flutter_wanandroid/features/main/presentation/main_screen.dart';
import 'package:flutter_wanandroid/features/search/presentation/search_result_screen.dart';
import 'package:flutter_wanandroid/features/search/presentation/search_screen.dart';
import 'package:flutter_wanandroid/features/startup/presentation/startup_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// 路由刷新通知器。
///
/// GoRouter 本身不会直接感知 Riverpod 状态变化，
/// 因此这里通过一个 `ChangeNotifier` 桥接认证状态变化，
/// 当 `authNotifierProvider` 更新时主动触发路由重新计算 redirect。
class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}

/// 全局路由配置。
///
/// - 使用 `keepAlive: true` 保持 Router 常驻
/// - 应用启动后先进入启动页
/// - 根据认证状态控制登录页/注册页的访问行为
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref.onDispose(refreshNotifier.dispose);
  // 监听认证状态；一旦登录状态变化，就让 GoRouter 重新执行 redirect。
  ref.listen<AuthState>(
    authNotifierProvider,
    (_, __) => refreshNotifier.refresh(),
  );

  return GoRouter(
    // 启动时先展示启动页，再由启动页决定何时进入首页。
    initialLocation: AppRoutes.startup,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isStartupRoute = state.matchedLocation == AppRoutes.startup;
      final isAuthRoute = switch (state.matchedLocation) {
        AppRoutes.login || AppRoutes.register => true,
        _ => false,
      };

      // 启动页的进入时机由 StartupScreen 自己控制，这里不拦截。
      if (isStartupRoute) {
        return null;
      }

      // 认证状态还在检查中时，先不要跳转，避免页面闪动。
      if (authState.isBusy) {
        return null;
      }

      // 已登录用户不应再停留在登录页或注册页，统一回到首页。
      if (authState.isAuthenticated && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // 启动页：负责欢迎页、协议确认、进入应用。
      GoRoute(
        path: AppRoutes.startup,
        builder: (context, state) => const StartupScreen(),
      ),
      // 登录页。
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // 注册页。
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      // 首页主容器：底部导航承载首页/书架/我的。
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainScreen(),
      ),
      // 搜索页。
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      // 搜索结果页：通过 query parameter 传递关键字。
      GoRoute(
        path: AppRoutes.searchResult,
        builder: (context, state) => SearchResultScreen(
          keyword:
              state.uri.queryParameters[AppRoutes.searchKeywordParam] ?? '',
        ),
      ),
      // 文章详情页：依赖 extra 传入 WebPage 对象。
      GoRoute(
        path: AppRoutes.detail,
        builder: (context, state) {
          final page = state.extra;
          // 参数不符合预期时，返回一个兜底错误页，避免运行时崩溃。
          if (page is! WebPage) {
            return const Scaffold(body: Center(child: Text('页面参数异常')));
          }
          return DetailScreen(page: page);
        },
      ),
    ],
    errorBuilder: (context, state) {
      // 统一处理未知路由或构建异常。
      return Scaffold(
        appBar: AppBar(title: const Text('页面异常')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('页面不存在：${state.error}', textAlign: TextAlign.center),
          ),
        ),
      );
    },
  );
}
