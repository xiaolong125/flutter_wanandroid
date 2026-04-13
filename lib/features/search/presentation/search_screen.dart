import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wanandroid/features/search/domain/model/search_hot_item.dart';
import 'package:flutter_wanandroid/features/search/presentation/search_notifier.dart';
import 'package:flutter_wanandroid/features/search/presentation/search_state.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  static const _primaryColor = Color(0xFF2196F3);
  static const _secondaryTextColor = Color(0x8A000000);

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitSearch([String? keyword]) async {
    final query = (keyword ?? _controller.text).trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入关键字搜索')));
      return;
    }

    await ref.read(searchNotifierProvider.notifier).saveKeyword(query);
    if (!mounted) {
      return;
    }

    final encodedKeyword = Uri.encodeQueryComponent(query);
    context.push('/search/result?keyword=$encodedKeyword');
  }

  Future<void> _confirmClearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('清空历史'),
          content: const Text('确定清空历史搜索吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('清空'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await ref.read(searchNotifierProvider.notifier).clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: _submitSearch,
            decoration: InputDecoration(
              hintText: '输入关键字搜索',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              suffixIcon: IconButton(
                onPressed: _submitSearch,
                icon: const Icon(Icons.search, color: _primaryColor),
              ),
            ),
          ),
        ),
      ),
      body: switch (state) {
        SearchStateLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        SearchStateError(:final message) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () {
                    ref.read(searchNotifierProvider.notifier).load();
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
        SearchStateData(:final hotKeywords, :final history) => ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                '热门搜索',
                style: TextStyle(color: _primaryColor, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
              child: _HotKeywordWrap(
                items: hotKeywords,
                onTap: (item) => _submitSearch(item.name),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      '搜索历史',
                      style: TextStyle(color: _primaryColor, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: history.isEmpty ? null : _confirmClearHistory,
                    child: const Text(
                      '清空',
                      style: TextStyle(color: _secondaryTextColor),
                    ),
                  ),
                ],
              ),
            ),
            if (history.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  '暂无搜索历史',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _secondaryTextColor),
                ),
              )
            else
              ...history.map(
                (keyword) => ListTile(
                  title: Text(keyword),
                  onTap: () => _submitSearch(keyword),
                  trailing: IconButton(
                    onPressed: () {
                      ref
                          .read(searchNotifierProvider.notifier)
                          .removeKeyword(keyword);
                    },
                    icon: const Icon(Icons.close, size: 18),
                  ),
                ),
              ),
          ],
        ),
      },
    );
  }
}

class _HotKeywordWrap extends StatelessWidget {
  const _HotKeywordWrap({required this.items, required this.onTap});

  final List<SearchHotItem> items;
  final ValueChanged<SearchHotItem> onTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text(
            '暂无热门搜索',
            style: TextStyle(color: _SearchScreenState._secondaryTextColor),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map((item) {
            return ActionChip(
              onPressed: () => onTap(item),
              backgroundColor: const Color(0xFFF5F5F5),
              label: Text(
                item.name,
                style: TextStyle(color: _tagColor(item.name)),
              ),
            );
          })
          .toList(growable: false),
    );
  }

  Color _tagColor(String value) {
    const colors = [
      Color(0xFF2196F3),
      Color(0xFF4CAF50),
      Color(0xFFFF9800),
      Color(0xFFE91E63),
      Color(0xFF9C27B0),
      Color(0xFF009688),
    ];
    return colors[value.hashCode.abs() % colors.length];
  }
}
