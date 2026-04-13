// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_hot_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SearchHotItem _$SearchHotItemFromJson(Map<String, dynamic> json) {
  return _SearchHotItem.fromJson(json);
}

/// @nodoc
mixin _$SearchHotItem {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  int get visible => throw _privateConstructorUsedError;

  /// Serializes this SearchHotItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchHotItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchHotItemCopyWith<SearchHotItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchHotItemCopyWith<$Res> {
  factory $SearchHotItemCopyWith(
    SearchHotItem value,
    $Res Function(SearchHotItem) then,
  ) = _$SearchHotItemCopyWithImpl<$Res, SearchHotItem>;
  @useResult
  $Res call({int id, String name, String link, int order, int visible});
}

/// @nodoc
class _$SearchHotItemCopyWithImpl<$Res, $Val extends SearchHotItem>
    implements $SearchHotItemCopyWith<$Res> {
  _$SearchHotItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchHotItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? link = null,
    Object? order = null,
    Object? visible = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            link: null == link
                ? _value.link
                : link // ignore: cast_nullable_to_non_nullable
                      as String,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            visible: null == visible
                ? _value.visible
                : visible // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchHotItemImplCopyWith<$Res>
    implements $SearchHotItemCopyWith<$Res> {
  factory _$$SearchHotItemImplCopyWith(
    _$SearchHotItemImpl value,
    $Res Function(_$SearchHotItemImpl) then,
  ) = __$$SearchHotItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String link, int order, int visible});
}

/// @nodoc
class __$$SearchHotItemImplCopyWithImpl<$Res>
    extends _$SearchHotItemCopyWithImpl<$Res, _$SearchHotItemImpl>
    implements _$$SearchHotItemImplCopyWith<$Res> {
  __$$SearchHotItemImplCopyWithImpl(
    _$SearchHotItemImpl _value,
    $Res Function(_$SearchHotItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchHotItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? link = null,
    Object? order = null,
    Object? visible = null,
  }) {
    return _then(
      _$SearchHotItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        link: null == link
            ? _value.link
            : link // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        visible: null == visible
            ? _value.visible
            : visible // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchHotItemImpl implements _SearchHotItem {
  const _$SearchHotItemImpl({
    required this.id,
    this.name = '',
    this.link = '',
    this.order = 0,
    this.visible = 0,
  });

  factory _$SearchHotItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchHotItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String link;
  @override
  @JsonKey()
  final int order;
  @override
  @JsonKey()
  final int visible;

  @override
  String toString() {
    return 'SearchHotItem(id: $id, name: $name, link: $link, order: $order, visible: $visible)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchHotItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.visible, visible) || other.visible == visible));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, link, order, visible);

  /// Create a copy of SearchHotItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchHotItemImplCopyWith<_$SearchHotItemImpl> get copyWith =>
      __$$SearchHotItemImplCopyWithImpl<_$SearchHotItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchHotItemImplToJson(this);
  }
}

abstract class _SearchHotItem implements SearchHotItem {
  const factory _SearchHotItem({
    required final int id,
    final String name,
    final String link,
    final int order,
    final int visible,
  }) = _$SearchHotItemImpl;

  factory _SearchHotItem.fromJson(Map<String, dynamic> json) =
      _$SearchHotItemImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get link;
  @override
  int get order;
  @override
  int get visible;

  /// Create a copy of SearchHotItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchHotItemImplCopyWith<_$SearchHotItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
