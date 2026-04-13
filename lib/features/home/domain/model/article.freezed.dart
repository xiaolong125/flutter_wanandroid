// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return _Article.fromJson(json);
}

/// @nodoc
mixin _$Article {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get shareUser => throw _privateConstructorUsedError;
  String get niceDate => throw _privateConstructorUsedError;
  String get superChapterName => throw _privateConstructorUsedError;
  String get chapterName => throw _privateConstructorUsedError;
  String get envelopePic => throw _privateConstructorUsedError;
  String get desc => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;
  bool get fresh => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  List<ArticleTag> get tags => throw _privateConstructorUsedError;
  bool get collect => throw _privateConstructorUsedError;

  /// Serializes this Article to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticleCopyWith<Article> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleCopyWith<$Res> {
  factory $ArticleCopyWith(Article value, $Res Function(Article) then) =
      _$ArticleCopyWithImpl<$Res, Article>;
  @useResult
  $Res call({
    int id,
    String title,
    String author,
    String shareUser,
    String niceDate,
    String superChapterName,
    String chapterName,
    String envelopePic,
    String desc,
    String link,
    bool fresh,
    int type,
    List<ArticleTag> tags,
    bool collect,
  });
}

/// @nodoc
class _$ArticleCopyWithImpl<$Res, $Val extends Article>
    implements $ArticleCopyWith<$Res> {
  _$ArticleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? shareUser = null,
    Object? niceDate = null,
    Object? superChapterName = null,
    Object? chapterName = null,
    Object? envelopePic = null,
    Object? desc = null,
    Object? link = null,
    Object? fresh = null,
    Object? type = null,
    Object? tags = null,
    Object? collect = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            shareUser: null == shareUser
                ? _value.shareUser
                : shareUser // ignore: cast_nullable_to_non_nullable
                      as String,
            niceDate: null == niceDate
                ? _value.niceDate
                : niceDate // ignore: cast_nullable_to_non_nullable
                      as String,
            superChapterName: null == superChapterName
                ? _value.superChapterName
                : superChapterName // ignore: cast_nullable_to_non_nullable
                      as String,
            chapterName: null == chapterName
                ? _value.chapterName
                : chapterName // ignore: cast_nullable_to_non_nullable
                      as String,
            envelopePic: null == envelopePic
                ? _value.envelopePic
                : envelopePic // ignore: cast_nullable_to_non_nullable
                      as String,
            desc: null == desc
                ? _value.desc
                : desc // ignore: cast_nullable_to_non_nullable
                      as String,
            link: null == link
                ? _value.link
                : link // ignore: cast_nullable_to_non_nullable
                      as String,
            fresh: null == fresh
                ? _value.fresh
                : fresh // ignore: cast_nullable_to_non_nullable
                      as bool,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as int,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<ArticleTag>,
            collect: null == collect
                ? _value.collect
                : collect // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArticleImplCopyWith<$Res> implements $ArticleCopyWith<$Res> {
  factory _$$ArticleImplCopyWith(
    _$ArticleImpl value,
    $Res Function(_$ArticleImpl) then,
  ) = __$$ArticleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String author,
    String shareUser,
    String niceDate,
    String superChapterName,
    String chapterName,
    String envelopePic,
    String desc,
    String link,
    bool fresh,
    int type,
    List<ArticleTag> tags,
    bool collect,
  });
}

/// @nodoc
class __$$ArticleImplCopyWithImpl<$Res>
    extends _$ArticleCopyWithImpl<$Res, _$ArticleImpl>
    implements _$$ArticleImplCopyWith<$Res> {
  __$$ArticleImplCopyWithImpl(
    _$ArticleImpl _value,
    $Res Function(_$ArticleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? shareUser = null,
    Object? niceDate = null,
    Object? superChapterName = null,
    Object? chapterName = null,
    Object? envelopePic = null,
    Object? desc = null,
    Object? link = null,
    Object? fresh = null,
    Object? type = null,
    Object? tags = null,
    Object? collect = null,
  }) {
    return _then(
      _$ArticleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        shareUser: null == shareUser
            ? _value.shareUser
            : shareUser // ignore: cast_nullable_to_non_nullable
                  as String,
        niceDate: null == niceDate
            ? _value.niceDate
            : niceDate // ignore: cast_nullable_to_non_nullable
                  as String,
        superChapterName: null == superChapterName
            ? _value.superChapterName
            : superChapterName // ignore: cast_nullable_to_non_nullable
                  as String,
        chapterName: null == chapterName
            ? _value.chapterName
            : chapterName // ignore: cast_nullable_to_non_nullable
                  as String,
        envelopePic: null == envelopePic
            ? _value.envelopePic
            : envelopePic // ignore: cast_nullable_to_non_nullable
                  as String,
        desc: null == desc
            ? _value.desc
            : desc // ignore: cast_nullable_to_non_nullable
                  as String,
        link: null == link
            ? _value.link
            : link // ignore: cast_nullable_to_non_nullable
                  as String,
        fresh: null == fresh
            ? _value.fresh
            : fresh // ignore: cast_nullable_to_non_nullable
                  as bool,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as int,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<ArticleTag>,
        collect: null == collect
            ? _value.collect
            : collect // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleImpl implements _Article {
  const _$ArticleImpl({
    required this.id,
    required this.title,
    this.author = '',
    this.shareUser = '',
    this.niceDate = '',
    this.superChapterName = '',
    this.chapterName = '',
    this.envelopePic = '',
    this.desc = '',
    this.link = '',
    this.fresh = false,
    this.type = 0,
    final List<ArticleTag> tags = const <ArticleTag>[],
    this.collect = false,
  }) : _tags = tags;

  factory _$ArticleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  @JsonKey()
  final String author;
  @override
  @JsonKey()
  final String shareUser;
  @override
  @JsonKey()
  final String niceDate;
  @override
  @JsonKey()
  final String superChapterName;
  @override
  @JsonKey()
  final String chapterName;
  @override
  @JsonKey()
  final String envelopePic;
  @override
  @JsonKey()
  final String desc;
  @override
  @JsonKey()
  final String link;
  @override
  @JsonKey()
  final bool fresh;
  @override
  @JsonKey()
  final int type;
  final List<ArticleTag> _tags;
  @override
  @JsonKey()
  List<ArticleTag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool collect;

  @override
  String toString() {
    return 'Article(id: $id, title: $title, author: $author, shareUser: $shareUser, niceDate: $niceDate, superChapterName: $superChapterName, chapterName: $chapterName, envelopePic: $envelopePic, desc: $desc, link: $link, fresh: $fresh, type: $type, tags: $tags, collect: $collect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.shareUser, shareUser) ||
                other.shareUser == shareUser) &&
            (identical(other.niceDate, niceDate) ||
                other.niceDate == niceDate) &&
            (identical(other.superChapterName, superChapterName) ||
                other.superChapterName == superChapterName) &&
            (identical(other.chapterName, chapterName) ||
                other.chapterName == chapterName) &&
            (identical(other.envelopePic, envelopePic) ||
                other.envelopePic == envelopePic) &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.fresh, fresh) || other.fresh == fresh) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.collect, collect) || other.collect == collect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    author,
    shareUser,
    niceDate,
    superChapterName,
    chapterName,
    envelopePic,
    desc,
    link,
    fresh,
    type,
    const DeepCollectionEquality().hash(_tags),
    collect,
  );

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleImplCopyWith<_$ArticleImpl> get copyWith =>
      __$$ArticleImplCopyWithImpl<_$ArticleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleImplToJson(this);
  }
}

abstract class _Article implements Article {
  const factory _Article({
    required final int id,
    required final String title,
    final String author,
    final String shareUser,
    final String niceDate,
    final String superChapterName,
    final String chapterName,
    final String envelopePic,
    final String desc,
    final String link,
    final bool fresh,
    final int type,
    final List<ArticleTag> tags,
    final bool collect,
  }) = _$ArticleImpl;

  factory _Article.fromJson(Map<String, dynamic> json) = _$ArticleImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get author;
  @override
  String get shareUser;
  @override
  String get niceDate;
  @override
  String get superChapterName;
  @override
  String get chapterName;
  @override
  String get envelopePic;
  @override
  String get desc;
  @override
  String get link;
  @override
  bool get fresh;
  @override
  int get type;
  @override
  List<ArticleTag> get tags;
  @override
  bool get collect;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticleImplCopyWith<_$ArticleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ArticleTag _$ArticleTagFromJson(Map<String, dynamic> json) {
  return _ArticleTag.fromJson(json);
}

/// @nodoc
mixin _$ArticleTag {
  String get name => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  /// Serializes this ArticleTag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArticleTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticleTagCopyWith<ArticleTag> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleTagCopyWith<$Res> {
  factory $ArticleTagCopyWith(
    ArticleTag value,
    $Res Function(ArticleTag) then,
  ) = _$ArticleTagCopyWithImpl<$Res, ArticleTag>;
  @useResult
  $Res call({String name, String url});
}

/// @nodoc
class _$ArticleTagCopyWithImpl<$Res, $Val extends ArticleTag>
    implements $ArticleTagCopyWith<$Res> {
  _$ArticleTagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArticleTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? url = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArticleTagImplCopyWith<$Res>
    implements $ArticleTagCopyWith<$Res> {
  factory _$$ArticleTagImplCopyWith(
    _$ArticleTagImpl value,
    $Res Function(_$ArticleTagImpl) then,
  ) = __$$ArticleTagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String url});
}

/// @nodoc
class __$$ArticleTagImplCopyWithImpl<$Res>
    extends _$ArticleTagCopyWithImpl<$Res, _$ArticleTagImpl>
    implements _$$ArticleTagImplCopyWith<$Res> {
  __$$ArticleTagImplCopyWithImpl(
    _$ArticleTagImpl _value,
    $Res Function(_$ArticleTagImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArticleTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? url = null}) {
    return _then(
      _$ArticleTagImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleTagImpl implements _ArticleTag {
  const _$ArticleTagImpl({this.name = '', this.url = ''});

  factory _$ArticleTagImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleTagImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String url;

  @override
  String toString() {
    return 'ArticleTag(name: $name, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleTagImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, url);

  /// Create a copy of ArticleTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleTagImplCopyWith<_$ArticleTagImpl> get copyWith =>
      __$$ArticleTagImplCopyWithImpl<_$ArticleTagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleTagImplToJson(this);
  }
}

abstract class _ArticleTag implements ArticleTag {
  const factory _ArticleTag({final String name, final String url}) =
      _$ArticleTagImpl;

  factory _ArticleTag.fromJson(Map<String, dynamic> json) =
      _$ArticleTagImpl.fromJson;

  @override
  String get name;
  @override
  String get url;

  /// Create a copy of ArticleTag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticleTagImplCopyWith<_$ArticleTagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
