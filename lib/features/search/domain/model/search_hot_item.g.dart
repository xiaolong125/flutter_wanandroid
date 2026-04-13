// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_hot_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchHotItemImpl _$$SearchHotItemImplFromJson(Map<String, dynamic> json) =>
    _$SearchHotItemImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      link: json['link'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      visible: (json['visible'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SearchHotItemImplToJson(_$SearchHotItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'link': instance.link,
      'order': instance.order,
      'visible': instance.visible,
    };
