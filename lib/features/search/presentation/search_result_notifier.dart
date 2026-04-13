import 'package:flutter_wanandroid/core/utils/app_logger.dart';
import 'package:flutter_wanandroid/core/utils/error_message.dart';
import 'package:flutter_wanandroid/features/search/data/repository/search_repository.dart';
import 'package:flutter_wanandroid/features/search/presentation/search_result_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_result_notifier.g.dart';

@riverpod
class SearchResultNotifier extends _$SearchResultNotifier {
  @override
  SearchResultState build(String keyword) {
    Future.microtask(search);
    return const SearchResultState.loading();
  }

  Future<void> search() async {
    final normalizedKeyword = keyword.trim();
    if (normalizedKeyword.isEmpty) {
      state = const SearchResultState.error('请输入搜索关键字');
      return;
    }

    try {
      final articles = await ref
          .read(searchRepositoryProvider)
          .searchArticles(keyword: normalizedKeyword);
      state = SearchResultState.data(articles);
    } catch (error, stackTrace) {
      ref
          .read(appLoggerProvider)
          .e('Search articles failed', error: error, stackTrace: stackTrace);
      state = SearchResultState.error(readableMessage(error));
    }
  }
}
