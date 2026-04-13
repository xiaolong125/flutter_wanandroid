import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_wanandroid/features/home/data/remote/home_api.dart';
import 'package:flutter_wanandroid/features/home/domain/model/article.dart';
import 'package:flutter_wanandroid/features/home/domain/model/banner_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

class HomeRepository {
  HomeRepository(this._api);

  final HomeApi _api;

  Future<({List<Article> articles, List<BannerItem> banners})> fetchHome({
    int page = 0,
  }) async {
    final articlesFuture = _api.getArticles(page);
    final bannersFuture = page == 0 ? _api.getBanners() : null;
    final topArticlesFuture = page == 0 ? _api.getTopArticles() : null;

    final articlesResponse = await articlesFuture;
    final bannersResponse = bannersFuture == null ? null : await bannersFuture;
    final topArticlesResponse = topArticlesFuture == null
        ? null
        : await topArticlesFuture;

    final articles = [
      ..._parseArticleList(topArticlesResponse),
      ..._parsePagedArticles(articlesResponse),
    ];
    final banners = _parseBannerList(bannersResponse);

    return (articles: articles, banners: banners);
  }

  List<Article> _parsePagedArticles(dynamic response) {
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

  List<Article> _parseArticleList(dynamic response) {
    final data = response['data'];
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map>()
        .map((item) => Article.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  List<BannerItem> _parseBannerList(dynamic response) {
    final data = response['data'];
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map>()
        .map((item) => BannerItem.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }
}

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository(ref.watch(homeApiProvider));
}
