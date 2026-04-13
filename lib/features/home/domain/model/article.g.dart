// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleImpl _$$ArticleImplFromJson(Map<String, dynamic> json) =>
    _$ArticleImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      author: json['author'] as String? ?? '',
      shareUser: json['shareUser'] as String? ?? '',
      niceDate: json['niceDate'] as String? ?? '',
      superChapterName: json['superChapterName'] as String? ?? '',
      chapterName: json['chapterName'] as String? ?? '',
      envelopePic: json['envelopePic'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      link: json['link'] as String? ?? '',
      fresh: json['fresh'] as bool? ?? false,
      type: (json['type'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => ArticleTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ArticleTag>[],
      collect: json['collect'] as bool? ?? false,
    );

Map<String, dynamic> _$$ArticleImplToJson(_$ArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'shareUser': instance.shareUser,
      'niceDate': instance.niceDate,
      'superChapterName': instance.superChapterName,
      'chapterName': instance.chapterName,
      'envelopePic': instance.envelopePic,
      'desc': instance.desc,
      'link': instance.link,
      'fresh': instance.fresh,
      'type': instance.type,
      'tags': instance.tags,
      'collect': instance.collect,
    };

_$ArticleTagImpl _$$ArticleTagImplFromJson(Map<String, dynamic> json) =>
    _$ArticleTagImpl(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );

Map<String, dynamic> _$$ArticleTagImplToJson(_$ArticleTagImpl instance) =>
    <String, dynamic>{'name': instance.name, 'url': instance.url};
