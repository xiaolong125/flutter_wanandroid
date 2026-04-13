import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_wanandroid/core/storage/shared_preferences_provider.dart';
import 'package:flutter_wanandroid/features/home/domain/model/article.dart';
import 'package:flutter_wanandroid/features/search/data/remote/search_api.dart';
import 'package:flutter_wanandroid/features/search/domain/model/search_hot_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_repository.g.dart';

class SearchRepository {
  SearchRepository(this._api, this._loadPreferences);

  static const _historyKey = 'search_history';
  static const _maxHistoryCount = 10;

  final SearchApi _api;
  final Future<SharedPreferences> Function() _loadPreferences;

  Future<List<SearchHotItem>> fetchHotKeywords() async {
    final response = await _api.getHotKeywords();
    final data = response['data'];

    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map>()
        .map((item) => SearchHotItem.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  Future<List<Article>> searchArticles({
    required String keyword,
    int page = 0,
  }) async {
    final response = await _api.searchArticles(page, keyword);
    final data = response['data'];

    if (data is! Map) {
      return const [];
    }

    final articleList = data['datas'];
    if (articleList is! List) {
      return const [];
    }

    return articleList
        .whereType<Map>()
        .map((item) => Article.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  Future<List<String>> readHistory() async {
    final prefs = await _loadPreferences();
    return List<String>.from(prefs.getStringList(_historyKey) ?? const []);
  }

  Future<List<String>> saveHistory(String keyword) async {
    final normalizedKeyword = keyword.trim();
    if (normalizedKeyword.isEmpty) {
      return readHistory();
    }

    final prefs = await _loadPreferences();
    final history = List<String>.from(
      prefs.getStringList(_historyKey) ?? const [],
    )..remove(normalizedKeyword);

    history.insert(0, normalizedKeyword);
    if (history.length > _maxHistoryCount) {
      history.removeRange(_maxHistoryCount, history.length);
    }

    await prefs.setStringList(_historyKey, history);
    return history;
  }

  Future<List<String>> removeHistory(String keyword) async {
    final prefs = await _loadPreferences();
    final history = List<String>.from(
      prefs.getStringList(_historyKey) ?? const [],
    )..remove(keyword);
    await prefs.setStringList(_historyKey, history);
    return history;
  }

  Future<void> clearHistory() async {
    final prefs = await _loadPreferences();
    await prefs.remove(_historyKey);
  }
}

@riverpod
SearchRepository searchRepository(Ref ref) {
  return SearchRepository(
    ref.watch(searchApiProvider),
    () => ref.read(sharedPreferencesProvider.future),
  );
}
