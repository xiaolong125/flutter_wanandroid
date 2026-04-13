// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BannerItemImpl _$$BannerItemImplFromJson(Map<String, dynamic> json) =>
    _$BannerItemImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      imagePath: json['imagePath'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      type: (json['type'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BannerItemImplToJson(_$BannerItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'desc': instance.desc,
      'imagePath': instance.imagePath,
      'order': instance.order,
      'type': instance.type,
    };
