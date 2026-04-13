import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wanandroid/app.dart';
import 'package:flutter_wanandroid/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('app renders with overridden router', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Test App'))),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appRouterProvider.overrideWith((ref) => router)],
        child: const FlutterWanandroidApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Test App'), findsOneWidget);
  });
}
