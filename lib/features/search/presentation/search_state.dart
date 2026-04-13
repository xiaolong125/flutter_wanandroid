import 'package:flutter_wanandroid/features/search/domain/model/search_hot_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState.loading() = SearchStateLoading;
  const factory SearchState.data({
    @Default(<SearchHotItem>[]) List<SearchHotItem> hotKeywords,
    @Default(<String>[]) List<String> history,
  }) = SearchStateData;
  const factory SearchState.error(String message) = SearchStateError;
}
