// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_integral.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProfileIntegral _$ProfileIntegralFromJson(Map<String, dynamic> json) {
  return _ProfileIntegral.fromJson(json);
}

/// @nodoc
mixin _$ProfileIntegral {
  @JsonKey(fromJson: _stringFromJson)
  String get coinCount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get rank => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get username => throw _privateConstructorUsedError;

  /// Serializes this ProfileIntegral to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileIntegral
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileIntegralCopyWith<ProfileIntegral> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileIntegralCopyWith<$Res> {
  factory $ProfileIntegralCopyWith(
    ProfileIntegral value,
    $Res Function(ProfileIntegral) then,
  ) = _$ProfileIntegralCopyWithImpl<$Res, ProfileIntegral>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromJson) String coinCount,
    @JsonKey(fromJson: _stringFromJson) String rank,
    @JsonKey(fromJson: _stringFromJson) String userId,
    @JsonKey(fromJson: _stringFromJson) String username,
  });
}

/// @nodoc
class _$ProfileIntegralCopyWithImpl<$Res, $Val extends ProfileIntegral>
    implements $ProfileIntegralCopyWith<$Res> {
  _$ProfileIntegralCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileIntegral
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coinCount = null,
    Object? rank = null,
    Object? userId = null,
    Object? username = null,
  }) {
    return _then(
      _value.copyWith(
            coinCount: null == coinCount
                ? _value.coinCount
                : coinCount // ignore: cast_nullable_to_non_nullable
                      as String,
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfileIntegralImplCopyWith<$Res>
    implements $ProfileIntegralCopyWith<$Res> {
  factory _$$ProfileIntegralImplCopyWith(
    _$ProfileIntegralImpl value,
    $Res Function(_$ProfileIntegralImpl) then,
  ) = __$$ProfileIntegralImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _stringFromJson) String coinCount,
    @JsonKey(fromJson: _stringFromJson) String rank,
    @JsonKey(fromJson: _stringFromJson) String userId,
    @JsonKey(fromJson: _stringFromJson) String username,
  });
}

/// @nodoc
class __$$ProfileIntegralImplCopyWithImpl<$Res>
    extends _$ProfileIntegralCopyWithImpl<$Res, _$ProfileIntegralImpl>
    implements _$$ProfileIntegralImplCopyWith<$Res> {
  __$$ProfileIntegralImplCopyWithImpl(
    _$ProfileIntegralImpl _value,
    $Res Function(_$ProfileIntegralImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileIntegral
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coinCount = null,
    Object? rank = null,
    Object? userId = null,
    Object? username = null,
  }) {
    return _then(
      _$ProfileIntegralImpl(
        coinCount: null == coinCount
            ? _value.coinCount
            : coinCount // ignore: cast_nullable_to_non_nullable
                  as String,
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileIntegralImpl implements _ProfileIntegral {
  const _$ProfileIntegralImpl({
    @JsonKey(fromJson: _stringFromJson) this.coinCount = '0',
    @JsonKey(fromJson: _stringFromJson) this.rank = '--',
    @JsonKey(fromJson: _stringFromJson) this.userId = '--',
    @JsonKey(fromJson: _stringFromJson) this.username = '',
  });

  factory _$ProfileIntegralImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileIntegralImplFromJson(json);

  @override
  @JsonKey(fromJson: _stringFromJson)
  final String coinCount;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String rank;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String userId;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String username;

  @override
  String toString() {
    return 'ProfileIntegral(coinCount: $coinCount, rank: $rank, userId: $userId, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileIntegralImpl &&
            (identical(other.coinCount, coinCount) ||
                other.coinCount == coinCount) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, coinCount, rank, userId, username);

  /// Create a copy of ProfileIntegral
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileIntegralImplCopyWith<_$ProfileIntegralImpl> get copyWith =>
      __$$ProfileIntegralImplCopyWithImpl<_$ProfileIntegralImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileIntegralImplToJson(this);
  }
}

abstract class _ProfileIntegral implements ProfileIntegral {
  const factory _ProfileIntegral({
    @JsonKey(fromJson: _stringFromJson) final String coinCount,
    @JsonKey(fromJson: _stringFromJson) final String rank,
    @JsonKey(fromJson: _stringFromJson) final String userId,
    @JsonKey(fromJson: _stringFromJson) final String username,
  }) = _$ProfileIntegralImpl;

  factory _ProfileIntegral.fromJson(Map<String, dynamic> json) =
      _$ProfileIntegralImpl.fromJson;

  @override
  @JsonKey(fromJson: _stringFromJson)
  String get coinCount;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get rank;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get userId;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get username;

  /// Create a copy of ProfileIntegral
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileIntegralImplCopyWith<_$ProfileIntegralImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
