import 'package:flutter_wanandroid/features/home/domain/model/article.dart';
import 'package:flutter_wanandroid/features/home/domain/model/banner_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_ui_state.freezed.dart';

@freezed
sealed class HomeUiState with _$HomeUiState {
  const factory HomeUiState.loading() = HomeUiStateLoading;
  const factory HomeUiState.data({
    @Default(<BannerItem>[]) List<BannerItem> banners,
    @Default(<Article>[]) List<Article> articles,
  }) = HomeUiStateData;
  const factory HomeUiState.error(String message) = HomeUiStateError;
}
