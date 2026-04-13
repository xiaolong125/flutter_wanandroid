import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_notifier.dart';
import 'package:flutter_wanandroid/features/auth/presentation/auth_state.dart';
import 'package:flutter_wanandroid/features/home/presentation/home_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  late final List<_MainTab> _tabs = const [
    _MainTab(
      label: '首页',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      body: HomeScreen(),
    ),
    _MainTab(
      label: '书架',
      icon: Icons.book_outlined,
      selectedIcon: Icons.book,
      body: _BookshelfScreen(),
    ),
    _MainTab(
      label: '我的',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      body: _ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentTab = _tabs[_selectedIndex];
    final showAppBar = _selectedIndex != 0;

    return Scaffold(
      appBar: showAppBar ? AppBar(title: Text(currentTab.label)) : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs.map((tab) => tab.body).toList(growable: false),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: tab.label,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _MainTab {
  const _MainTab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.body,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget body;
}

class _BookshelfScreen extends StatelessWidget {
  const _BookshelfScreen();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 56,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('书架模块已预留', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '可以按 CLAUDE.md 的模块规范继续补数据层、仓库层和页面状态。',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileScreen extends ConsumerWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.nickname ?? '未登录',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '请先登录以同步个人信息',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: const [
              ListTile(
                leading: Icon(Icons.code_outlined),
                title: Text('当前架构'),
                subtitle: Text('Riverpod + GoRouter + Dio + Freezed'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.layers_outlined),
                title: Text('模块组织'),
                subtitle: Text('core + features，按 data/domain/presentation 分层'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: () {
            ref.read(authNotifierProvider.notifier).logout();
          },
          icon: const Icon(Icons.logout),
          label: const Text('退出登录'),
        ),
      ],
    );
  }
}
