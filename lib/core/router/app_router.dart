import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
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

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref.onDispose(refreshNotifier.dispose);
  ref.listen<AuthState>(
    authNotifierProvider,
    (_, __) => refreshNotifier.refresh(),
  );

  return GoRouter(
    initialLocation: '/startup',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isStartupRoute = state.matchedLocation == '/startup';
      final isAuthRoute = switch (state.matchedLocation) {
        '/login' || '/register' => true,
        _ => false,
      };

      if (isStartupRoute) {
        return null;
      }

      if (authState.isBusy) {
        return null;
      }

      if (!authState.isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      if (authState.isAuthenticated && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/startup',
        builder: (context, state) => const StartupScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const MainScreen()),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/search/result',
        builder: (context, state) => SearchResultScreen(
          keyword: state.uri.queryParameters['keyword'] ?? '',
        ),
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final page = state.extra;
          if (page is! WebPage) {
            return const Scaffold(body: Center(child: Text('页面参数异常')));
          }
          return DetailScreen(page: page);
        },
      ),
    ],
    errorBuilder: (context, state) {
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
