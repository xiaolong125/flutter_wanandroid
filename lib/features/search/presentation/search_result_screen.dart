import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wanandroid/core/router/app_routes.dart';
import 'package:flutter_wanandroid/features/detail/domain/model/web_page.dart';
import 'package:flutter_wanandroid/features/home/domain/model/article.dart';
import 'package:flutter_wanandroid/features/search/presentation/search_result_notifier.dart';
import 'package:flutter_wanandroid/features/search/presentation/search_result_state.dart';
import 'package:go_router/go_router.dart';

class SearchResultScreen extends ConsumerWidget {
  const SearchResultScreen({super.key, required this.keyword});

  final String keyword;

  static const _primaryColor = Color(0xFF2196F3);
  static const _backgroundColor = Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchResultNotifierProvider(keyword));

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(keyword),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: switch (state) {
        SearchResultStateLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        SearchResultStateError(:final message) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () {
                    ref
                        .read(searchResultNotifierProvider(keyword).notifier)
                        .search();
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
        SearchResultStateData(:final articles) =>
          articles.isEmpty
              ? const Center(child: Text('没有搜索到相关内容'))
              : RefreshIndicator(
                  onRefresh: () {
                    return ref
                        .read(searchResultNotifierProvider(keyword).notifier)
                        .search();
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: articles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return _SearchArticleCard(article: article);
                    },
                  ),
                ),
      },
    );
  }
}

class _SearchArticleCard extends StatelessWidget {
  const _SearchArticleCard({required this.article});

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
          child: article.envelopePic.trim().isEmpty
              ? _TextArticleBody(article: article)
              : _ProjectArticleBody(article: article),
        ),
      ),
    );
  }
}

class _TextArticleBody extends StatelessWidget {
  const _TextArticleBody({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CardHeader(article: article),
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
        _CardFooter(article: article),
      ],
    );
  }
}

class _ProjectArticleBody extends StatelessWidget {
  const _ProjectArticleBody({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CardHeader(article: article),
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
        _CardFooter(article: article),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.article});

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
              textColor: Colors.green,
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

class _CardFooter extends StatelessWidget {
  const _CardFooter({required this.article});

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
        child: Text(label, style: TextStyle(color: textColor, fontSize: 10)),
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
