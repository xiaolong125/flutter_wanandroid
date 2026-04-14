import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_notifier.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_state.dart';
import 'package:flutter_wanandroid/features/startup/data/repository/startup_repository.dart';
import 'package:flutter_wanandroid/features/startup/presentation/startup_policy_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class StartupScreen extends ConsumerStatefulWidget {
  const StartupScreen({super.key});

  @override
  ConsumerState<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends ConsumerState<StartupScreen> {
  static const _backgroundColor = Color(0xFF2196F3);
  static const _actionColor = Color(0xFF1976D2);
  static const _welcomeTexts = ['唱', '跳', 'r a p'];
  static const _termsOfServiceUrl =
      'https://rule.tencent.com/rule/46a15f24-e42c-4cb6-a308-2347139b1201';
  static const _privacyPolicyUrl =
      'https://rule.tencent.com/rule/46a15f24-e42c-4cb6-a308-2347139b1201';

  late final PageController _pageController;
  Timer? _navigationTimer;

  bool? _isFirstOpen;
  bool _hasAgreedPolicy = false;
  bool _policyDialogShown = false;
  bool _shouldEnter = false;
  bool _hasNavigated = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Future.microtask(_loadStartupState);
  }

  Future<void> _loadStartupState() async {
    final repository = ref.read(startupRepositoryProvider);
    final hasSeenWelcome = await repository.hasSeenWelcome();
    final hasAgreedPolicy = await repository.hasAgreedPolicy();

    if (!mounted) {
      return;
    }

    setState(() {
      _isFirstOpen = !hasSeenWelcome;
      _hasAgreedPolicy = hasAgreedPolicy;
      _shouldEnter = hasSeenWelcome && hasAgreedPolicy;
    });

    if (!hasAgreedPolicy) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_showPolicyDialog());
        }
      });
    }

    _scheduleEnterIfReady();
  }

  void _scheduleEnterIfReady([AuthState? authState]) {
    if (!mounted ||
        _hasNavigated ||
        !_hasAgreedPolicy ||
        !_shouldEnter ||
        _isFirstOpen == null) {
      return;
    }

    final AuthState currentAuthState =
        authState ?? ref.read(authNotifierProvider);
    if (currentAuthState.isBusy || _navigationTimer != null) {
      return;
    }

    final delay = _isFirstOpen!
        ? Duration.zero
        : const Duration(milliseconds: 300);
    if (delay == Duration.zero) {
      _enterApp();
      return;
    }

    _navigationTimer = Timer(delay, () {
      _navigationTimer = null;
      _enterApp();
    });
  }

  void _enterApp() {
    if (!mounted || _hasNavigated) {
      return;
    }

    final authState = ref.read(authNotifierProvider);
    if (authState.isBusy) {
      return;
    }

    _hasNavigated = true;
    context.go(authState.isAuthenticated ? '/' : '/login');
  }

  void _onEnterPressed() {
    if (_shouldEnter) {
      return;
    }

    setState(() {
      _shouldEnter = true;
    });

    unawaited(ref.read(startupRepositoryProvider).markWelcomeSeen());
    _scheduleEnterIfReady();
  }

  Future<void> _showPolicyDialog() async {
    if (!mounted || _policyDialogShown) {
      return;
    }

    _policyDialogShown = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StartupPolicyDialog(
          onAgree: () async {
            await ref.read(startupRepositoryProvider).markPolicyAgreed();
            if (!dialogContext.mounted || !mounted) {
              return;
            }
            Navigator.of(dialogContext).pop();
            setState(() {
              _hasAgreedPolicy = true;
              if (_isFirstOpen == false) {
                _shouldEnter = true;
              }
            });
            _scheduleEnterIfReady();
          },
          onDecline: () async {
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
            await SystemNavigator.pop();
          },
          onOpenTerms: () =>
              _openPolicyLink(title: '用户授权协议', url: _termsOfServiceUrl),
          onOpenPrivacy: () =>
              _openPolicyLink(title: '隐私政策', url: _privacyPolicyUrl),
        );
      },
    );
    _policyDialogShown = false;
  }

  Future<void> _openPolicyLink({
    required String title,
    required String url,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showMessage('$title链接无效');
      return;
    }

    var launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } catch (_) {}

    if (!launched) {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    if (!launched && mounted) {
      _showMessage('$title打开失败');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      _scheduleEnterIfReady(next);
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: _backgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _StartupScreenState._backgroundColor,
        body: SafeArea(
          child: switch (_isFirstOpen) {
            null => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            true => Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _StartupScreenState._welcomeTexts.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) => Center(
                    child: Text(
                      _StartupScreenState._welcomeTexts[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _StartupScreenState._welcomeTexts.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? _StartupScreenState._actionColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 72,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity:
                        _currentPage ==
                            _StartupScreenState._welcomeTexts.length - 1
                        ? 1
                        : 0,
                    child: IgnorePointer(
                      ignoring:
                          _currentPage !=
                          _StartupScreenState._welcomeTexts.length - 1,
                      child: Center(
                        child: FilledButton(
                          onPressed: _onEnterPressed,
                          style: FilledButton.styleFrom(
                            backgroundColor: _StartupScreenState._actionColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(_shouldEnter ? '进入中...' : '立即进入'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            false => const Center(
              child: Image(
                image: AssetImage('assets/images/startup_logo.png'),
                width: 108,
                height: 108,
              ),
            ),
          },
        ),
      ),
    );
  }
}
