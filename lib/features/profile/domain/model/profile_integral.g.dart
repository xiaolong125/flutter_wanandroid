// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_integral.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileIntegralImpl _$$ProfileIntegralImplFromJson(
  Map<String, dynamic> json,
) => _$ProfileIntegralImpl(
  coinCount: json['coinCount'] == null
      ? '0'
      : _stringFromJson(json['coinCount']),
  rank: json['rank'] == null ? '--' : _stringFromJson(json['rank']),
  userId: json['userId'] == null ? '--' : _stringFromJson(json['userId']),
  username: json['username'] == null ? '' : _stringFromJson(json['username']),
);

Map<String, dynamic> _$$ProfileIntegralImplToJson(
  _$ProfileIntegralImpl instance,
) => <String, dynamic>{
  'coinCount': instance.coinCount,
  'rank': instance.rank,
  'userId': instance.userId,
  'username': instance.username,
};
