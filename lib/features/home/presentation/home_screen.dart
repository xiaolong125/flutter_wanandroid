import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wanandroid/core/router/app_routes.dart';
import 'package:flutter_wanandroid/features/detail/domain/model/web_page.dart';
import 'package:flutter_wanandroid/features/home/domain/model/article.dart';
import 'package:flutter_wanandroid/features/home/domain/model/banner_item.dart';
import 'package:flutter_wanandroid/features/home/presentation/home_notifier.dart';
import 'package:flutter_wanandroid/features/home/presentation/home_ui_state.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _primaryColor = Color(0xFF2196F3);
  static const _backgroundColor = Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('首页'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              context.push(AppRoutes.search);
            },
            icon: const Icon(Icons.search),
            tooltip: '搜索',
          ),
        ],
      ),
      body: switch (state) {
        HomeUiStateLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        HomeUiStateData(:final banners, :final articles) => RefreshIndicator(
          onRefresh: () => ref.read(homeNotifierProvider.notifier).refresh(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            itemCount: articles.length + (banners.isEmpty ? 0 : 1),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (banners.isNotEmpty && index == 0) {
                return _BannerSection(banners: banners);
              }

              final articleIndex = banners.isNotEmpty ? index - 1 : index;
              final article = articles[articleIndex];
              return _ArticleCard(article: article);
            },
          ),
        ),
        HomeUiStateError(:final message) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () {
                    ref.read(homeNotifierProvider.notifier).refresh();
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      },
    );
  }
}

class _BannerSection extends StatefulWidget {
  const _BannerSection({required this.banners});

  final List<BannerItem> banners;

  @override
  State<_BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<_BannerSection> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(covariant _BannerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.banners.length != widget.banners.length) {
      _currentIndex = 0;
      _timer?.cancel();
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    if (widget.banners.length <= 1) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients || widget.banners.isEmpty) {
        return;
      }

      final nextIndex = (_currentIndex + 1) % widget.banners.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AspectRatio(
        aspectRatio: 2.4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.banners.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final banner = widget.banners[index];
                  return GestureDetector(
                    onTap: () {
                      context.push(
                        AppRoutes.detail,
                        extra: WebPage(
                          id: banner.id,
                          title: _plainText(banner.title),
                          url: banner.url,
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: banner.imagePath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.banners.length, (index) {
                    final selected = index == _currentIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: selected
                            ? HomeScreen._primaryColor
                            : Colors.white70,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            context.push(
              AppRoutes.detail,
              extra: WebPage(
                id: article.id,
                title: _plainText(article.title),
                url: article.link,
                isCollected: article.collect,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.zero,
            child: article.envelopePic.trim().isEmpty
                ? _ArticleTextLayout(article: article)
                : _ArticleProjectLayout(article: article),
          ),
        ),
      ),
    );
  }
}

class _ArticleTextLayout extends StatelessWidget {
  const _ArticleTextLayout({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CardTopRow(article: article),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
          child: Text(
            _plainText(article.title),
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _CardBottomRow(article: article),
      ],
    );
  }
}

class _ArticleProjectLayout extends StatelessWidget {
  const _ArticleProjectLayout({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CardTopRow(article: article),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: article.envelopePic,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 100,
                    height: 100,
                    color: const Color(0xFFFAFAFA),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 100,
                    height: 100,
                    color: const Color(0xFFFAFAFA),
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _plainText(article.title),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _plainText(article.desc),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0x8A000000),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _CardBottomRow(article: article),
      ],
    );
  }
}

class _CardTopRow extends StatelessWidget {
  const _CardTopRow({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                article.displayAuthor,
                style: const TextStyle(color: Color(0x8A000000), fontSize: 13),
              ),
            ),
          ),
          if (article.type == 1) ...[
            const SizedBox(width: 8),
            const _FlagChip(
              label: '置顶',
              backgroundColor: Color(0x11F44336),
              textColor: Colors.red,
            ),
          ],
          if (article.fresh) ...[
            const SizedBox(width: 8),
            const _FlagChip(
              label: '新',
              backgroundColor: Color(0x11F44336),
              textColor: Colors.red,
            ),
          ],
          if (article.primaryTag != null) ...[
            const SizedBox(width: 8),
            _FlagChip(
              label: article.primaryTag!,
              backgroundColor: const Color(0x114CAF50),
              textColor: Colors.green.shade700,
            ),
          ],
          const Spacer(),
          Text(
            article.niceDate,
            style: const TextStyle(color: Color(0x8A000000), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CardBottomRow extends StatelessWidget {
  const _CardBottomRow({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _plainText(article.displayCategory),
              style: const TextStyle(color: Color(0x8A000000), fontSize: 13),
            ),
          ),
          Icon(
            article.collect ? Icons.favorite : Icons.favorite_border,
            size: 22,
            color: article.collect ? Colors.redAccent : const Color(0x8A000000),
          ),
        ],
      ),
    );
  }
}

class _FlagChip extends StatelessWidget {
  const _FlagChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          _plainText(label),
          style: TextStyle(color: textColor, fontSize: 10),
        ),
      ),
    );
  }
}

String _plainText(String value) {
  return value
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');
}
