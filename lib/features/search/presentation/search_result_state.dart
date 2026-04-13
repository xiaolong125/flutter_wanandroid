import 'package:flutter_wanandroid/features/home/domain/model/article.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result_state.freezed.dart';

@freezed
sealed class SearchResultState with _$SearchResultState {
  const factory SearchResultState.loading() = SearchResultStateLoading;
  const factory SearchResultState.data(List<Article> articles) =
      SearchResultStateData;
  const factory SearchResultState.error(String message) =
      SearchResultStateError;
}
