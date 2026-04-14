// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_integral.freezed.dart';
part 'profile_integral.g.dart';

String _stringFromJson(dynamic value) => value?.toString() ?? '';

@freezed
class ProfileIntegral with _$ProfileIntegral {
  const factory ProfileIntegral({
    @JsonKey(fromJson: _stringFromJson) @Default('0') String coinCount,
    @JsonKey(fromJson: _stringFromJson) @Default('--') String rank,
    @JsonKey(fromJson: _stringFromJson) @Default('--') String userId,
    @JsonKey(fromJson: _stringFromJson) @Default('') String username,
  }) = _ProfileIntegral;

  factory ProfileIntegral.fromJson(Map<String, dynamic> json) =>
      _$ProfileIntegralFromJson(json);
}
