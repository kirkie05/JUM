// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$communityFeedHash() => r'f2c52e64d2b599120573b070817dc601cd3df9f1';

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

/// See also [communityFeed].
@ProviderFor(communityFeed)
const communityFeedProvider = CommunityFeedFamily();

/// See also [communityFeed].
class CommunityFeedFamily extends Family<AsyncValue<List<PostModel>>> {
  /// See also [communityFeed].
  const CommunityFeedFamily();

  /// See also [communityFeed].
  CommunityFeedProvider call({String? groupId}) {
    return CommunityFeedProvider(groupId: groupId);
  }

  @override
  CommunityFeedProvider getProviderOverride(
    covariant CommunityFeedProvider provider,
  ) {
    return call(groupId: provider.groupId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'communityFeedProvider';
}

/// See also [communityFeed].
class CommunityFeedProvider extends AutoDisposeStreamProvider<List<PostModel>> {
  /// See also [communityFeed].
  CommunityFeedProvider({String? groupId})
    : this._internal(
        (ref) => communityFeed(ref as CommunityFeedRef, groupId: groupId),
        from: communityFeedProvider,
        name: r'communityFeedProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$communityFeedHash,
        dependencies: CommunityFeedFamily._dependencies,
        allTransitiveDependencies:
            CommunityFeedFamily._allTransitiveDependencies,
        groupId: groupId,
      );

  CommunityFeedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String? groupId;

  @override
  Override overrideWith(
    Stream<List<PostModel>> Function(CommunityFeedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CommunityFeedProvider._internal(
        (ref) => create(ref as CommunityFeedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PostModel>> createElement() {
    return _CommunityFeedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommunityFeedProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CommunityFeedRef on AutoDisposeStreamProviderRef<List<PostModel>> {
  /// The parameter `groupId` of this provider.
  String? get groupId;
}

class _CommunityFeedProviderElement
    extends AutoDisposeStreamProviderElement<List<PostModel>>
    with CommunityFeedRef {
  _CommunityFeedProviderElement(super.provider);

  @override
  String? get groupId => (origin as CommunityFeedProvider).groupId;
}

String _$postCommentsHash() => r'90e1e8ce3738d479b6bee643fcf615c3a5987fbf';

/// See also [postComments].
@ProviderFor(postComments)
const postCommentsProvider = PostCommentsFamily();

/// See also [postComments].
class PostCommentsFamily extends Family<AsyncValue<List<CommentModel>>> {
  /// See also [postComments].
  const PostCommentsFamily();

  /// See also [postComments].
  PostCommentsProvider call(String postId) {
    return PostCommentsProvider(postId);
  }

  @override
  PostCommentsProvider getProviderOverride(
    covariant PostCommentsProvider provider,
  ) {
    return call(provider.postId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postCommentsProvider';
}

/// See also [postComments].
class PostCommentsProvider
    extends AutoDisposeFutureProvider<List<CommentModel>> {
  /// See also [postComments].
  PostCommentsProvider(String postId)
    : this._internal(
        (ref) => postComments(ref as PostCommentsRef, postId),
        from: postCommentsProvider,
        name: r'postCommentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$postCommentsHash,
        dependencies: PostCommentsFamily._dependencies,
        allTransitiveDependencies:
            PostCommentsFamily._allTransitiveDependencies,
        postId: postId,
      );

  PostCommentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    FutureOr<List<CommentModel>> Function(PostCommentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostCommentsProvider._internal(
        (ref) => create(ref as PostCommentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CommentModel>> createElement() {
    return _PostCommentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostCommentsProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostCommentsRef on AutoDisposeFutureProviderRef<List<CommentModel>> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _PostCommentsProviderElement
    extends AutoDisposeFutureProviderElement<List<CommentModel>>
    with PostCommentsRef {
  _PostCommentsProviderElement(super.provider);

  @override
  String get postId => (origin as PostCommentsProvider).postId;
}

String _$groupsListHash() => r'3602a5ff6d211129d26145182cdc94747dca7f32';

/// See also [groupsList].
@ProviderFor(groupsList)
final groupsListProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
      groupsList,
      name: r'groupsListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$groupsListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupsListRef =
    AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$createPostNotifierHash() =>
    r'71ea91a295a5074a43b78ae6b94f8a44743759b3';

/// See also [CreatePostNotifier].
@ProviderFor(CreatePostNotifier)
final createPostNotifierProvider =
    AutoDisposeNotifierProvider<CreatePostNotifier, AsyncValue<void>>.internal(
      CreatePostNotifier.new,
      name: r'createPostNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createPostNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CreatePostNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
