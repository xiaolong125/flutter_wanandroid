import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wanandroid/core/router/app_routes.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_notifier.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_state.dart';
import 'package:flutter_wanandroid/features/detail/domain/model/web_page.dart';
import 'package:flutter_wanandroid/features/profile/domain/model/profile_integral.dart';
import 'package:flutter_wanandroid/features/profile/presentation/profile_integral_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  static const _primaryColor = Color(0xFF2196F3);
  static const _backgroundColor = Colors.white;
  static const _wanAndroidUrl = 'https://www.wanandroid.com/';
  static const _qqGroupKey = '9n4i5sHt4189d4DvbotKiCHy-5jZtD4D';

  Future<void> _refreshProfile() async {
    final authState = ref.read(authNotifierProvider);
    if (!authState.isAuthenticated) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return;
    }

    ref.invalidate(profileIntegralProvider);
    try {
      await ref.read(profileIntegralProvider.future);
    } catch (_) {}
  }

  void _handleProtectedAction({required VoidCallback onAuthenticated}) {
    final authState = ref.read(authNotifierProvider);
    if (!authState.isAuthenticated) {
      context.push(AppRoutes.login);
      return;
    }
    onAuthenticated();
  }

  Future<void> _openWanAndroidSite() async {
    await context.push(
      AppRoutes.detail,
      extra: const WebPage(url: _wanAndroidUrl, title: '玩Android网站'),
    );
  }

  Future<void> _joinQQGroup() async {
    final uri = Uri.parse(
      'mqqopensdkapi://bizAgent/qm/qr?url='
      'http%3A%2F%2Fqm.qq.com%2Fcgi-bin%2Fqm%2Fqr%3Ffrom%3Dapp%26p%3Dandroid%26k%3D$_qqGroupKey',
    );
    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!success && mounted) {
      _showMessage('未安装手机QQ或安装的版本不支持');
    }
  }

  Future<void> _openSettingsSheet() async {
    final authState = ref.read(authNotifierProvider);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Flutter WanAndroid'),
                subtitle: Text('我的页面已对齐 JetpackMvvm 风格'),
              ),
              ListTile(
                leading: Icon(
                  authState.isAuthenticated
                      ? Icons.logout_outlined
                      : Icons.login_outlined,
                ),
                title: Text(authState.isAuthenticated ? '退出登录' : '前往登录'),
                onTap: () async {
                  Navigator.of(context).pop();
                  if (authState.isAuthenticated) {
                    await ref.read(authNotifierProvider.notifier).logout();
                  } else if (mounted) {
                    this.context.push(AppRoutes.login);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDevelopingMessage(String title) {
    _showMessage('$title功能待迁移');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(profileIntegralProvider, (previous, next) {
      if (next.hasError && previous?.hasError != true && mounted) {
        final error = next.error;
        _showMessage(
          error is Exception
              ? error.toString().replaceFirst('Exception: ', '')
              : '积分加载失败',
        );
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final integralAsync = ref.watch(profileIntegralProvider);
    final integral = integralAsync.valueOrNull;
    final displayName = user == null
        ? '请先登录~'
        : user.nickname.trim().isEmpty
        ? user.username
        : user.nickname;
    final userInfo = _buildUserInfo(user?.id, integral);
    final integralText = integral?.coinCount ?? '0';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: RefreshIndicator(
        color: _primaryColor,
        onRefresh: _refreshProfile,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            _ProfileHeroSection(
              name: displayName,
              info: userInfo,
              avatarUrl: user?.avatar,
              integralText: integralText,
              topInset: MediaQuery.paddingOf(context).top,
              onHeaderTap: () {
                if (!authState.isAuthenticated) {
                  context.push(AppRoutes.login);
                }
              },
              onIntegralTap: () => _handleProtectedAction(
                onAuthenticated: () => _showDevelopingMessage('积分页面'),
              ),
              onCollectTap: () => _handleProtectedAction(
                onAuthenticated: () => _showDevelopingMessage('收藏页面'),
              ),
              onArticleTap: () => _handleProtectedAction(
                onAuthenticated: () => _showDevelopingMessage('文章页面'),
              ),
              onWebsiteTap: _openWanAndroidSite,
              onJoinTap: _joinQQGroup,
              onSettingTap: _openSettingsSheet,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _buildUserInfo(int? fallbackUserId, ProfileIntegral? integral) {
    if (integral != null) {
      return 'id：${integral.userId}　排名：${integral.rank}';
    }

    if (fallbackUserId != null) {
      return 'id：$fallbackUserId　排名：--';
    }

    return 'id：--　排名：--';
  }
}

class _ProfileHeroSection extends StatelessWidget {
  const _ProfileHeroSection({
    required this.name,
    required this.info,
    required this.avatarUrl,
    required this.integralText,
    required this.topInset,
    required this.onHeaderTap,
    required this.onIntegralTap,
    required this.onCollectTap,
    required this.onArticleTap,
    required this.onWebsiteTap,
    required this.onJoinTap,
    required this.onSettingTap,
  });

  static const _headerHeight = 236.0;
  static const _cardTop = 180.0;
  static const _rowHeight = 50.0;
  static const _rowCount = 6;
  static const _cardHeight = _rowHeight * _rowCount;

  final String name;
  final String info;
  final String? avatarUrl;
  final String integralText;
  final double topInset;
  final VoidCallback onHeaderTap;
  final VoidCallback onIntegralTap;
  final VoidCallback onCollectTap;
  final VoidCallback onArticleTap;
  final VoidCallback onWebsiteTap;
  final VoidCallback onJoinTap;
  final VoidCallback onSettingTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardTop + _cardHeight + 16,
      child: Stack(
        children: [
          Container(
            height: _headerHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2196F3), Color(0xFFFFFFFF)],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onHeaderTap,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, topInset + 36, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileAvatar(avatarUrl: avatarUrl),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 72,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                info,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: _cardTop,
            left: 12,
            right: 12,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: _ProfileScreenState._backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.workspace_premium_outlined,
                    label: '我的积分',
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '当前积分:',
                          style: TextStyle(
                            color: Color(0x61000000),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          integralText,
                          style: const TextStyle(
                            color: Color(0xFF2196F3),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onTap: onIntegralTap,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.favorite_border,
                    label: '我的收藏',
                    onTap: onCollectTap,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.description_outlined,
                    label: '我的文章',
                    onTap: onArticleTap,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.language,
                    label: '开源网站',
                    onTap: onWebsiteTap,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.group_add_outlined,
                    label: '加入我们',
                    onTap: onJoinTap,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    label: '系统设置',
                    showDivider: false,
                    onTap: onSettingTap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = avatarUrl?.trim();

    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: normalizedUrl != null && normalizedUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: normalizedUrl,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Image.asset(
                  'assets/images/login_avatar.jpg',
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset('assets/images/login_avatar.jpg', fit: BoxFit.cover),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.suffix,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final Widget? suffix;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: showDivider
                ? const Border(bottom: BorderSide(color: Color(0x14000000)))
                : null,
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: const Color(0xDE000000)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xDE000000),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (suffix != null) ...[suffix!, const SizedBox(width: 8)],
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: Color(0x61000000),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
