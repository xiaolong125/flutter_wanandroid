import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_hot_item.freezed.dart';
part 'search_hot_item.g.dart';

@freezed
class SearchHotItem with _$SearchHotItem {
  const factory SearchHotItem({
    required int id,
    @Default('') String name,
    @Default('') String link,
    @Default(0) int order,
    @Default(0) int visible,
  }) = _SearchHotItem;

  factory SearchHotItem.fromJson(Map<String, dynamic> json) =>
      _$SearchHotItemFromJson(json);
}
