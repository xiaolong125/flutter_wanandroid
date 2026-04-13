import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_page.freezed.dart';

@freezed
class WebPage with _$WebPage {
  const factory WebPage({
    required String url,
    @Default('') String title,
    @Default(0) int id,
    @Default(false) bool isCollected,
  }) = _WebPage;
}
