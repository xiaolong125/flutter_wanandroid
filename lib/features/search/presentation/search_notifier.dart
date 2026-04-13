import 'package:flutter_wanandroid/core/utils/app_logger.dart';
import 'package:flutter_wanandroid/core/utils/error_message.dart';
import 'package:flutter_wanandroid/features/search/data/repository/search_repository.dart';
import 'package:flutter_wanandroid/features/search/domain/model/search_hot_item.dart';
import 'package:flutter_wanandroid/features/search/presentation/search_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_notifier.g.dart';

@riverpod
class SearchNotifier extends _$SearchNotifier {
  @override
  SearchState build() {
    Future.microtask(load);
    return const SearchState.loading();
  }

  Future<void> load() async {
    try {
      final repository = ref.read(searchRepositoryProvider);
      final hotFuture = repository.fetchHotKeywords();
      final historyFuture = repository.readHistory();

      final hotKeywords = await hotFuture;
      final history = await historyFuture;

      state = SearchState.data(hotKeywords: hotKeywords, history: history);
    } catch (error, stackTrace) {
      ref
          .read(appLoggerProvider)
          .e('Load search data failed', error: error, stackTrace: stackTrace);
      state = SearchState.error(readableMessage(error));
    }
  }

  Future<void> saveKeyword(String keyword) async {
    final normalizedKeyword = keyword.trim();
    if (normalizedKeyword.isEmpty) {
      return;
    }

    final history = await ref
        .read(searchRepositoryProvider)
        .saveHistory(normalizedKeyword);

    final currentHotKeywords = switch (state) {
      SearchStateData(:final hotKeywords) => hotKeywords,
      _ => const <SearchHotItem>[],
    };

    state = SearchState.data(hotKeywords: currentHotKeywords, history: history);
  }

  Future<void> removeKeyword(String keyword) async {
    final history = await ref
        .read(searchRepositoryProvider)
        .removeHistory(keyword);

    final currentHotKeywords = switch (state) {
      SearchStateData(:final hotKeywords) => hotKeywords,
      _ => const <SearchHotItem>[],
    };

    state = SearchState.data(hotKeywords: currentHotKeywords, history: history);
  }

  Future<void> clearHistory() async {
    await ref.read(searchRepositoryProvider).clearHistory();

    final currentHotKeywords = switch (state) {
      SearchStateData(:final hotKeywords) => hotKeywords,
      _ => const <SearchHotItem>[],
    };

    state = SearchState.data(
      hotKeywords: currentHotKeywords,
      history: const [],
    );
  }
}
