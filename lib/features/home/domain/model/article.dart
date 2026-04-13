import 'package:freezed_annotation/freezed_annotation.dart';

part 'article.freezed.dart';
part 'article.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required int id,
    required String title,
    @Default('') String author,
    @Default('') String shareUser,
    @Default('') String niceDate,
    @Default('') String superChapterName,
    @Default('') String chapterName,
    @Default('') String envelopePic,
    @Default('') String desc,
    @Default('') String link,
    @Default(false) bool fresh,
    @Default(0) int type,
    @Default(<ArticleTag>[]) List<ArticleTag> tags,
    @Default(false) bool collect,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}

@freezed
class ArticleTag with _$ArticleTag {
  const factory ArticleTag({
    @Default('') String name,
    @Default('') String url,
  }) = _ArticleTag;

  factory ArticleTag.fromJson(Map<String, dynamic> json) =>
      _$ArticleTagFromJson(json);
}

extension ArticleX on Article {
  String get displayAuthor {
    if (author.trim().isNotEmpty) {
      return author;
    }
    if (shareUser.trim().isNotEmpty) {
      return shareUser;
    }
    return '匿名作者';
  }

  String get subtitle {
    if (superChapterName.trim().isNotEmpty) {
      return superChapterName;
    }
    if (desc.trim().isNotEmpty) {
      return desc;
    }
    return 'Flutter 架构示例文章';
  }

  String get displayCategory {
    final sections = [
      if (superChapterName.trim().isNotEmpty) superChapterName.trim(),
      if (chapterName.trim().isNotEmpty) chapterName.trim(),
    ];
    return sections.isEmpty ? '分类·项目' : sections.join('·');
  }

  String? get primaryTag {
    if (tags.isEmpty) {
      return null;
    }

    final value = tags.first.name.trim();
    return value.isEmpty ? null : value;
  }
}
