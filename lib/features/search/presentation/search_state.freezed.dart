// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SearchState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<SearchHotItem> hotKeywords,
      List<String> history,
    )
    data,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<SearchHotItem> hotKeywords, List<String> history)?
    data,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<SearchHotItem> hotKeywords, List<String> history)?
    data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchStateLoading value) loading,
    required TResult Function(SearchStateData value) data,
    required TResult Function(SearchStateError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchStateLoading value)? loading,
    TResult? Function(SearchStateData value)? data,
    TResult? Function(SearchStateError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchStateLoading value)? loading,
    TResult Function(SearchStateData value)? data,
    TResult Function(SearchStateError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
    SearchState value,
    $Res Function(SearchState) then,
  ) = _$SearchStateCopyWithImpl<$Res, SearchState>;
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res, $Val extends SearchState>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SearchStateLoadingImplCopyWith<$Res> {
  factory _$$SearchStateLoadingImplCopyWith(
    _$SearchStateLoadingImpl value,
    $Res Function(_$SearchStateLoadingImpl) then,
  ) = __$$SearchStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchStateLoadingImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchStateLoadingImpl>
    implements _$$SearchStateLoadingImplCopyWith<$Res> {
  __$$SearchStateLoadingImplCopyWithImpl(
    _$SearchStateLoadingImpl _value,
    $Res Function(_$SearchStateLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SearchStateLoadingImpl implements SearchStateLoading {
  const _$SearchStateLoadingImpl();

  @override
  String toString() {
    return 'SearchState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SearchStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<SearchHotItem> hotKeywords,
      List<String> history,
    )
    data,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<SearchHotItem> hotKeywords, List<String> history)?
    data,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<SearchHotItem> hotKeywords, List<String> history)?
    data,
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
    required TResult Function(SearchStateLoading value) loading,
    required TResult Function(SearchStateData value) data,
    required TResult Function(SearchStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchStateLoading value)? loading,
    TResult? Function(SearchStateData value)? data,
    TResult? Function(SearchStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchStateLoading value)? loading,
    TResult Function(SearchStateData value)? data,
    TResult Function(SearchStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SearchStateLoading implements SearchState {
  const factory SearchStateLoading() = _$SearchStateLoadingImpl;
}

/// @nodoc
abstract class _$$SearchStateDataImplCopyWith<$Res> {
  factory _$$SearchStateDataImplCopyWith(
    _$SearchStateDataImpl value,
    $Res Function(_$SearchStateDataImpl) then,
  ) = __$$SearchStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<SearchHotItem> hotKeywords, List<String> history});
}

/// @nodoc
class __$$SearchStateDataImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchStateDataImpl>
    implements _$$SearchStateDataImplCopyWith<$Res> {
  __$$SearchStateDataImplCopyWithImpl(
    _$SearchStateDataImpl _value,
    $Res Function(_$SearchStateDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? hotKeywords = null, Object? history = null}) {
    return _then(
      _$SearchStateDataImpl(
        hotKeywords: null == hotKeywords
            ? _value._hotKeywords
            : hotKeywords // ignore: cast_nullable_to_non_nullable
                  as List<SearchHotItem>,
        history: null == history
            ? _value._history
            : history // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$SearchStateDataImpl implements SearchStateData {
  const _$SearchStateDataImpl({
    final List<SearchHotItem> hotKeywords = const <SearchHotItem>[],
    final List<String> history = const <String>[],
  }) : _hotKeywords = hotKeywords,
       _history = history;

  final List<SearchHotItem> _hotKeywords;
  @override
  @JsonKey()
  List<SearchHotItem> get hotKeywords {
    if (_hotKeywords is EqualUnmodifiableListView) return _hotKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hotKeywords);
  }

  final List<String> _history;
  @override
  @JsonKey()
  List<String> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'SearchState.data(hotKeywords: $hotKeywords, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchStateDataImpl &&
            const DeepCollectionEquality().equals(
              other._hotKeywords,
              _hotKeywords,
            ) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_hotKeywords),
    const DeepCollectionEquality().hash(_history),
  );

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchStateDataImplCopyWith<_$SearchStateDataImpl> get copyWith =>
      __$$SearchStateDataImplCopyWithImpl<_$SearchStateDataImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<SearchHotItem> hotKeywords,
      List<String> history,
    )
    data,
    required TResult Function(String message) error,
  }) {
    return data(hotKeywords, history);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<SearchHotItem> hotKeywords, List<String> history)?
    data,
    TResult? Function(String message)? error,
  }) {
    return data?.call(hotKeywords, history);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<SearchHotItem> hotKeywords, List<String> history)?
    data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(hotKeywords, history);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchStateLoading value) loading,
    required TResult Function(SearchStateData value) data,
    required TResult Function(SearchStateError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchStateLoading value)? loading,
    TResult? Function(SearchStateData value)? data,
    TResult? Function(SearchStateError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchStateLoading value)? loading,
    TResult Function(SearchStateData value)? data,
    TResult Function(SearchStateError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class SearchStateData implements SearchState {
  const factory SearchStateData({
    final List<SearchHotItem> hotKeywords,
    final List<String> history,
  }) = _$SearchStateDataImpl;

  List<SearchHotItem> get hotKeywords;
  List<String> get history;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchStateDataImplCopyWith<_$SearchStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchStateErrorImplCopyWith<$Res> {
  factory _$$SearchStateErrorImplCopyWith(
    _$SearchStateErrorImpl value,
    $Res Function(_$SearchStateErrorImpl) then,
  ) = __$$SearchStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SearchStateErrorImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchStateErrorImpl>
    implements _$$SearchStateErrorImplCopyWith<$Res> {
  __$$SearchStateErrorImplCopyWithImpl(
    _$SearchStateErrorImpl _value,
    $Res Function(_$SearchStateErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$SearchStateErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SearchStateErrorImpl implements SearchStateError {
  const _$SearchStateErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SearchState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchStateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchStateErrorImplCopyWith<_$SearchStateErrorImpl> get copyWith =>
      __$$SearchStateErrorImplCopyWithImpl<_$SearchStateErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<SearchHotItem> hotKeywords,
      List<String> history,
    )
    data,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<SearchHotItem> hotKeywords, List<String> history)?
    data,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<SearchHotItem> hotKeywords, List<String> history)?
    data,
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
    required TResult Function(SearchStateLoading value) loading,
    required TResult Function(SearchStateData value) data,
    required TResult Function(SearchStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchStateLoading value)? loading,
    TResult? Function(SearchStateData value)? data,
    TResult? Function(SearchStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchStateLoading value)? loading,
    TResult Function(SearchStateData value)? data,
    TResult Function(SearchStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SearchStateError implements SearchState {
  const factory SearchStateError(final String message) = _$SearchStateErrorImpl;

  String get message;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchStateErrorImplCopyWith<_$SearchStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
