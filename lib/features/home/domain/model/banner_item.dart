import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_item.freezed.dart';
part 'banner_item.g.dart';

@freezed
class BannerItem with _$BannerItem {
  const factory BannerItem({
    required int id,
    @Default('') String title,
    @Default('') String url,
    @Default('') String desc,
    @Default('') String imagePath,
    @Default(0) int order,
    @Default(0) int type,
  }) = _BannerItem;

  factory BannerItem.fromJson(Map<String, dynamic> json) =>
      _$BannerItemFromJson(json);
}
