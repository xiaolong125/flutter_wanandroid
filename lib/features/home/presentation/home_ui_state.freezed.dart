// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeUiState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<BannerItem> banners, List<Article> articles)
    data,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<BannerItem> banners, List<Article> articles)? data,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<BannerItem> banners, List<Article> articles)? data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeUiStateLoading value) loading,
    required TResult Function(HomeUiStateData value) data,
    required TResult Function(HomeUiStateError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeUiStateLoading value)? loading,
    TResult? Function(HomeUiStateData value)? data,
    TResult? Function(HomeUiStateError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeUiStateLoading value)? loading,
    TResult Function(HomeUiStateData value)? data,
    TResult Function(HomeUiStateError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeUiStateCopyWith<$Res> {
  factory $HomeUiStateCopyWith(
    HomeUiState value,
    $Res Function(HomeUiState) then,
  ) = _$HomeUiStateCopyWithImpl<$Res, HomeUiState>;
}

/// @nodoc
class _$HomeUiStateCopyWithImpl<$Res, $Val extends HomeUiState>
    implements $HomeUiStateCopyWith<$Res> {
  _$HomeUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$HomeUiStateLoadingImplCopyWith<$Res> {
  factory _$$HomeUiStateLoadingImplCopyWith(
    _$HomeUiStateLoadingImpl value,
    $Res Function(_$HomeUiStateLoadingImpl) then,
  ) = __$$HomeUiStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeUiStateLoadingImplCopyWithImpl<$Res>
    extends _$HomeUiStateCopyWithImpl<$Res, _$HomeUiStateLoadingImpl>
    implements _$$HomeUiStateLoadingImplCopyWith<$Res> {
  __$$HomeUiStateLoadingImplCopyWithImpl(
    _$HomeUiStateLoadingImpl _value,
    $Res Function(_$HomeUiStateLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HomeUiStateLoadingImpl implements HomeUiStateLoading {
  const _$HomeUiStateLoadingImpl();

  @override
  String toString() {
    return 'HomeUiState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeUiStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<BannerItem> banners, List<Article> articles)
    data,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<BannerItem> banners, List<Article> articles)? data,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<BannerItem> banners, List<Article> articles)? data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeUiStateLoading value) loading,
    required TResult Function(HomeUiStateData value) data,
    required TResult Function(HomeUiStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeUiStateLoading value)? loading,
    TResult? Function(HomeUiStateData value)? data,
    TResult? Function(HomeUiStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeUiStateLoading value)? loading,
    TResult Function(HomeUiStateData value)? data,
    TResult Function(HomeUiStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class HomeUiStateLoading implements HomeUiState {
  const factory HomeUiStateLoading() = _$HomeUiStateLoadingImpl;
}

/// @nodoc
abstract class _$$HomeUiStateDataImplCopyWith<$Res> {
  factory _$$HomeUiStateDataImplCopyWith(
    _$HomeUiStateDataImpl value,
    $Res Function(_$HomeUiStateDataImpl) then,
  ) = __$$HomeUiStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<BannerItem> banners, List<Article> articles});
}

/// @nodoc
class __$$HomeUiStateDataImplCopyWithImpl<$Res>
    extends _$HomeUiStateCopyWithImpl<$Res, _$HomeUiStateDataImpl>
    implements _$$HomeUiStateDataImplCopyWith<$Res> {
  __$$HomeUiStateDataImplCopyWithImpl(
    _$HomeUiStateDataImpl _value,
    $Res Function(_$HomeUiStateDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? banners = null, Object? articles = null}) {
    return _then(
      _$HomeUiStateDataImpl(
        banners: null == banners
            ? _value._banners
            : banners // ignore: cast_nullable_to_non_nullable
                  as List<BannerItem>,
        articles: null == articles
            ? _value._articles
            : articles // ignore: cast_nullable_to_non_nullable
                  as List<Article>,
      ),
    );
  }
}

/// @nodoc

class _$HomeUiStateDataImpl implements HomeUiStateData {
  const _$HomeUiStateDataImpl({
    final List<BannerItem> banners = const <BannerItem>[],
    final List<Article> articles = const <Article>[],
  }) : _banners = banners,
       _articles = articles;

  final List<BannerItem> _banners;
  @override
  @JsonKey()
  List<BannerItem> get banners {
    if (_banners is EqualUnmodifiableListView) return _banners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_banners);
  }

  final List<Article> _articles;
  @override
  @JsonKey()
  List<Article> get articles {
    if (_articles is EqualUnmodifiableListView) return _articles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_articles);
  }

  @override
  String toString() {
    return 'HomeUiState.data(banners: $banners, articles: $articles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeUiStateDataImpl &&
            const DeepCollectionEquality().equals(other._banners, _banners) &&
            const DeepCollectionEquality().equals(other._articles, _articles));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_banners),
    const DeepCollectionEquality().hash(_articles),
  );

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeUiStateDataImplCopyWith<_$HomeUiStateDataImpl> get copyWith =>
      __$$HomeUiStateDataImplCopyWithImpl<_$HomeUiStateDataImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<BannerItem> banners, List<Article> articles)
    data,
    required TResult Function(String message) error,
  }) {
    return data(banners, articles);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<BannerItem> banners, List<Article> articles)? data,
    TResult? Function(String message)? error,
  }) {
    return data?.call(banners, articles);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<BannerItem> banners, List<Article> articles)? data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(banners, articles);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeUiStateLoading value) loading,
    required TResult Function(HomeUiStateData value) data,
    required TResult Function(HomeUiStateError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeUiStateLoading value)? loading,
    TResult? Function(HomeUiStateData value)? data,
    TResult? Function(HomeUiStateError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeUiStateLoading value)? loading,
    TResult Function(HomeUiStateData value)? data,
    TResult Function(HomeUiStateError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class HomeUiStateData implements HomeUiState {
  const factory HomeUiStateData({
    final List<BannerItem> banners,
    final List<Article> articles,
  }) = _$HomeUiStateDataImpl;

  List<BannerItem> get banners;
  List<Article> get articles;

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeUiStateDataImplCopyWith<_$HomeUiStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HomeUiStateErrorImplCopyWith<$Res> {
  factory _$$HomeUiStateErrorImplCopyWith(
    _$HomeUiStateErrorImpl value,
    $Res Function(_$HomeUiStateErrorImpl) then,
  ) = __$$HomeUiStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$HomeUiStateErrorImplCopyWithImpl<$Res>
    extends _$HomeUiStateCopyWithImpl<$Res, _$HomeUiStateErrorImpl>
    implements _$$HomeUiStateErrorImplCopyWith<$Res> {
  __$$HomeUiStateErrorImplCopyWithImpl(
    _$HomeUiStateErrorImpl _value,
    $Res Function(_$HomeUiStateErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$HomeUiStateErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$HomeUiStateErrorImpl implements HomeUiStateError {
  const _$HomeUiStateErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'HomeUiState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeUiStateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeUiStateErrorImplCopyWith<_$HomeUiStateErrorImpl> get copyWith =>
      __$$HomeUiStateErrorImplCopyWithImpl<_$HomeUiStateErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<BannerItem> banners, List<Article> articles)
    data,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<BannerItem> banners, List<Article> articles)? data,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<BannerItem> banners, List<Article> articles)? data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeUiStateLoading value) loading,
    required TResult Function(HomeUiStateData value) data,
    required TResult Function(HomeUiStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeUiStateLoading value)? loading,
    TResult? Function(HomeUiStateData value)? data,
    TResult? Function(HomeUiStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeUiStateLoading value)? loading,
    TResult Function(HomeUiStateData value)? data,
    TResult Function(HomeUiStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class HomeUiStateError implements HomeUiState {
  const factory HomeUiStateError(final String message) = _$HomeUiStateErrorImpl;

  String get message;

  /// Create a copy of HomeUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeUiStateErrorImplCopyWith<_$HomeUiStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
