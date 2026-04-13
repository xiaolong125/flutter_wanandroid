// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'web_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WebPage {
  String get url => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  bool get isCollected => throw _privateConstructorUsedError;

  /// Create a copy of WebPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WebPageCopyWith<WebPage> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebPageCopyWith<$Res> {
  factory $WebPageCopyWith(WebPage value, $Res Function(WebPage) then) =
      _$WebPageCopyWithImpl<$Res, WebPage>;
  @useResult
  $Res call({String url, String title, int id, bool isCollected});
}

/// @nodoc
class _$WebPageCopyWithImpl<$Res, $Val extends WebPage>
    implements $WebPageCopyWith<$Res> {
  _$WebPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WebPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? title = null,
    Object? id = null,
    Object? isCollected = null,
  }) {
    return _then(
      _value.copyWith(
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            isCollected: null == isCollected
                ? _value.isCollected
                : isCollected // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WebPageImplCopyWith<$Res> implements $WebPageCopyWith<$Res> {
  factory _$$WebPageImplCopyWith(
    _$WebPageImpl value,
    $Res Function(_$WebPageImpl) then,
  ) = __$$WebPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, String title, int id, bool isCollected});
}

/// @nodoc
class __$$WebPageImplCopyWithImpl<$Res>
    extends _$WebPageCopyWithImpl<$Res, _$WebPageImpl>
    implements _$$WebPageImplCopyWith<$Res> {
  __$$WebPageImplCopyWithImpl(
    _$WebPageImpl _value,
    $Res Function(_$WebPageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? title = null,
    Object? id = null,
    Object? isCollected = null,
  }) {
    return _then(
      _$WebPageImpl(
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        isCollected: null == isCollected
            ? _value.isCollected
            : isCollected // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$WebPageImpl implements _WebPage {
  const _$WebPageImpl({
    required this.url,
    this.title = '',
    this.id = 0,
    this.isCollected = false,
  });

  @override
  final String url;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final bool isCollected;

  @override
  String toString() {
    return 'WebPage(url: $url, title: $title, id: $id, isCollected: $isCollected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebPageImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isCollected, isCollected) ||
                other.isCollected == isCollected));
  }

  @override
  int get hashCode => Object.hash(runtimeType, url, title, id, isCollected);

  /// Create a copy of WebPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WebPageImplCopyWith<_$WebPageImpl> get copyWith =>
      __$$WebPageImplCopyWithImpl<_$WebPageImpl>(this, _$identity);
}

abstract class _WebPage implements WebPage {
  const factory _WebPage({
    required final String url,
    final String title,
    final int id,
    final bool isCollected,
  }) = _$WebPageImpl;

  @override
  String get url;
  @override
  String get title;
  @override
  int get id;
  @override
  bool get isCollected;

  /// Create a copy of WebPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WebPageImplCopyWith<_$WebPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
