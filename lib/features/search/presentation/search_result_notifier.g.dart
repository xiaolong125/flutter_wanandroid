// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchResultNotifierHash() =>
    r'c47744b4e1e9e6fc4fd940eb3c34e4b14dae9964';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SearchResultNotifier
    extends BuildlessAutoDisposeNotifier<SearchResultState> {
  late final String keyword;

  SearchResultState build(String keyword);
}

/// See also [SearchResultNotifier].
@ProviderFor(SearchResultNotifier)
const searchResultNotifierProvider = SearchResultNotifierFamily();

/// See also [SearchResultNotifier].
class SearchResultNotifierFamily extends Family<SearchResultState> {
  /// See also [SearchResultNotifier].
  const SearchResultNotifierFamily();

  /// See also [SearchResultNotifier].
  SearchResultNotifierProvider call(String keyword) {
    return SearchResultNotifierProvider(keyword);
  }

  @override
  SearchResultNotifierProvider getProviderOverride(
    covariant SearchResultNotifierProvider provider,
  ) {
    return call(provider.keyword);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchResultNotifierProvider';
}

/// See also [SearchResultNotifier].
class SearchResultNotifierProvider
    extends
        AutoDisposeNotifierProviderImpl<
          SearchResultNotifier,
          SearchResultState
        > {
  /// See also [SearchResultNotifier].
  SearchResultNotifierProvider(String keyword)
    : this._internal(
        () => SearchResultNotifier()..keyword = keyword,
        from: searchResultNotifierProvider,
        name: r'searchResultNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchResultNotifierHash,
        dependencies: SearchResultNotifierFamily._dependencies,
        allTransitiveDependencies:
            SearchResultNotifierFamily._allTransitiveDependencies,
        keyword: keyword,
      );

  SearchResultNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.keyword,
  }) : super.internal();

  final String keyword;

  @override
  SearchResultState runNotifierBuild(covariant SearchResultNotifier notifier) {
    return notifier.build(keyword);
  }

  @override
  Override overrideWith(SearchResultNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchResultNotifierProvider._internal(
        () => create()..keyword = keyword,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        keyword: keyword,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SearchResultNotifier, SearchResultState>
  createElement() {
    return _SearchResultNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchResultNotifierProvider && other.keyword == keyword;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, keyword.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchResultNotifierRef
    on AutoDisposeNotifierProviderRef<SearchResultState> {
  /// The parameter `keyword` of this provider.
  String get keyword;
}

class _SearchResultNotifierProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          SearchResultNotifier,
          SearchResultState
        >
    with SearchResultNotifierRef {
  _SearchResultNotifierProviderElement(super.provider);

  @override
  String get keyword => (origin as SearchResultNotifierProvider).keyword;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
