// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SearchResultState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Article> articles) data,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Article> articles)? data,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Article> articles)? data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchResultStateLoading value) loading,
    required TResult Function(SearchResultStateData value) data,
    required TResult Function(SearchResultStateError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchResultStateLoading value)? loading,
    TResult? Function(SearchResultStateData value)? data,
    TResult? Function(SearchResultStateError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchResultStateLoading value)? loading,
    TResult Function(SearchResultStateData value)? data,
    TResult Function(SearchResultStateError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultStateCopyWith<$Res> {
  factory $SearchResultStateCopyWith(
    SearchResultState value,
    $Res Function(SearchResultState) then,
  ) = _$SearchResultStateCopyWithImpl<$Res, SearchResultState>;
}

/// @nodoc
class _$SearchResultStateCopyWithImpl<$Res, $Val extends SearchResultState>
    implements $SearchResultStateCopyWith<$Res> {
  _$SearchResultStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResultState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SearchResultStateLoadingImplCopyWith<$Res> {
  factory _$$SearchResultStateLoadingImplCopyWith(
    _$SearchResultStateLoadingImpl value,
    $Res Function(_$SearchResultStateLoadingImpl) then,
  ) = __$$SearchResultStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchResultStateLoadingImplCopyWithImpl<$Res>
    extends
        _$SearchResultStateCopyWithImpl<$Res, _$SearchResultStateLoadingImpl>
    implements _$$SearchResultStateLoadingImplCopyWith<$Res> {
  __$$SearchResultStateLoadingImplCopyWithImpl(
    _$SearchResultStateLoadingImpl _value,
    $Res Function(_$SearchResultStateLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchResultState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SearchResultStateLoadingImpl implements SearchResultStateLoading {
  const _$SearchResultStateLoadingImpl();

  @override
  String toString() {
    return 'SearchResultState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Article> articles) data,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Article> articles)? data,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Article> articles)? data,
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
    required TResult Function(SearchResultStateLoading value) loading,
    required TResult Function(SearchResultStateData value) data,
    required TResult Function(SearchResultStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchResultStateLoading value)? loading,
    TResult? Function(SearchResultStateData value)? data,
    TResult? Function(SearchResultStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchResultStateLoading value)? loading,
    TResult Function(SearchResultStateData value)? data,
    TResult Function(SearchResultStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SearchResultStateLoading implements SearchResultState {
  const factory SearchResultStateLoading() = _$SearchResultStateLoadingImpl;
}

/// @nodoc
abstract class _$$SearchResultStateDataImplCopyWith<$Res> {
  factory _$$SearchResultStateDataImplCopyWith(
    _$SearchResultStateDataImpl value,
    $Res Function(_$SearchResultStateDataImpl) then,
  ) = __$$SearchResultStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Article> articles});
}

/// @nodoc
class __$$SearchResultStateDataImplCopyWithImpl<$Res>
    extends _$SearchResultStateCopyWithImpl<$Res, _$SearchResultStateDataImpl>
    implements _$$SearchResultStateDataImplCopyWith<$Res> {
  __$$SearchResultStateDataImplCopyWithImpl(
    _$SearchResultStateDataImpl _value,
    $Res Function(_$SearchResultStateDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchResultState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? articles = null}) {
    return _then(
      _$SearchResultStateDataImpl(
        null == articles
            ? _value._articles
            : articles // ignore: cast_nullable_to_non_nullable
                  as List<Article>,
      ),
    );
  }
}

/// @nodoc

class _$SearchResultStateDataImpl implements SearchResultStateData {
  const _$SearchResultStateDataImpl(final List<Article> articles)
    : _articles = articles;

  final List<Article> _articles;
  @override
  List<Article> get articles {
    if (_articles is EqualUnmodifiableListView) return _articles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_articles);
  }

  @override
  String toString() {
    return 'SearchResultState.data(articles: $articles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultStateDataImpl &&
            const DeepCollectionEquality().equals(other._articles, _articles));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_articles));

  /// Create a copy of SearchResultState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultStateDataImplCopyWith<_$SearchResultStateDataImpl>
  get copyWith =>
      __$$SearchResultStateDataImplCopyWithImpl<_$SearchResultStateDataImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Article> articles) data,
    required TResult Function(String message) error,
  }) {
    return data(articles);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Article> articles)? data,
    TResult? Function(String message)? error,
  }) {
    return data?.call(articles);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Article> articles)? data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(articles);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchResultStateLoading value) loading,
    required TResult Function(SearchResultStateData value) data,
    required TResult Function(SearchResultStateError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchResultStateLoading value)? loading,
    TResult? Function(SearchResultStateData value)? data,
    TResult? Function(SearchResultStateError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchResultStateLoading value)? loading,
    TResult Function(SearchResultStateData value)? data,
    TResult Function(SearchResultStateError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class SearchResultStateData implements SearchResultState {
  const factory SearchResultStateData(final List<Article> articles) =
      _$SearchResultStateDataImpl;

  List<Article> get articles;

  /// Create a copy of SearchResultState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultStateDataImplCopyWith<_$SearchResultStateDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchResultStateErrorImplCopyWith<$Res> {
  factory _$$SearchResultStateErrorImplCopyWith(
    _$SearchResultStateErrorImpl value,
    $Res Function(_$SearchResultStateErrorImpl) then,
  ) = __$$SearchResultStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SearchResultStateErrorImplCopyWithImpl<$Res>
    extends _$SearchResultStateCopyWithImpl<$Res, _$SearchResultStateErrorImpl>
    implements _$$SearchResultStateErrorImplCopyWith<$Res> {
  __$$SearchResultStateErrorImplCopyWithImpl(
    _$SearchResultStateErrorImpl _value,
    $Res Function(_$SearchResultStateErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchResultState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$SearchResultStateErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SearchResultStateErrorImpl implements SearchResultStateError {
  const _$SearchResultStateErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SearchResultState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultStateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SearchResultState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultStateErrorImplCopyWith<_$SearchResultStateErrorImpl>
  get copyWith =>
      __$$SearchResultStateErrorImplCopyWithImpl<_$SearchResultStateErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Article> articles) data,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Article> articles)? data,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Article> articles)? data,
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
    required TResult Function(SearchResultStateLoading value) loading,
    required TResult Function(SearchResultStateData value) data,
    required TResult Function(SearchResultStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchResultStateLoading value)? loading,
    TResult? Function(SearchResultStateData value)? data,
    TResult? Function(SearchResultStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchResultStateLoading value)? loading,
    TResult Function(SearchResultStateData value)? data,
    TResult Function(SearchResultStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SearchResultStateError implements SearchResultState {
  const factory SearchResultStateError(final String message) =
      _$SearchResultStateErrorImpl;

  String get message;

  /// Create a copy of SearchResultState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultStateErrorImplCopyWith<_$SearchResultStateErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}
