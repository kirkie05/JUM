// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conversationHash() => r'6146e1ae1272c11473caf66196eb3a3097bb44bc';

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

/// See also [conversation].
@ProviderFor(conversation)
const conversationProvider = ConversationFamily();

/// See also [conversation].
class ConversationFamily extends Family<AsyncValue<List<MessageModel>>> {
  /// See also [conversation].
  const ConversationFamily();

  /// See also [conversation].
  ConversationProvider call(String peerId) {
    return ConversationProvider(peerId);
  }

  @override
  ConversationProvider getProviderOverride(
    covariant ConversationProvider provider,
  ) {
    return call(provider.peerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'conversationProvider';
}

/// See also [conversation].
class ConversationProvider
    extends AutoDisposeStreamProvider<List<MessageModel>> {
  /// See also [conversation].
  ConversationProvider(String peerId)
    : this._internal(
        (ref) => conversation(ref as ConversationRef, peerId),
        from: conversationProvider,
        name: r'conversationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$conversationHash,
        dependencies: ConversationFamily._dependencies,
        allTransitiveDependencies:
            ConversationFamily._allTransitiveDependencies,
        peerId: peerId,
      );

  ConversationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.peerId,
  }) : super.internal();

  final String peerId;

  @override
  Override overrideWith(
    Stream<List<MessageModel>> Function(ConversationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationProvider._internal(
        (ref) => create(ref as ConversationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        peerId: peerId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<MessageModel>> createElement() {
    return _ConversationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationProvider && other.peerId == peerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, peerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConversationRef on AutoDisposeStreamProviderRef<List<MessageModel>> {
  /// The parameter `peerId` of this provider.
  String get peerId;
}

class _ConversationProviderElement
    extends AutoDisposeStreamProviderElement<List<MessageModel>>
    with ConversationRef {
  _ConversationProviderElement(super.provider);

  @override
  String get peerId => (origin as ConversationProvider).peerId;
}

String _$groupConversationHash() => r'1ba9d8f1f79e51bb0ee17c21b43bda2b70f27f19';

/// See also [groupConversation].
@ProviderFor(groupConversation)
const groupConversationProvider = GroupConversationFamily();

/// See also [groupConversation].
class GroupConversationFamily extends Family<AsyncValue<List<MessageModel>>> {
  /// See also [groupConversation].
  const GroupConversationFamily();

  /// See also [groupConversation].
  GroupConversationProvider call(String conversationId) {
    return GroupConversationProvider(conversationId);
  }

  @override
  GroupConversationProvider getProviderOverride(
    covariant GroupConversationProvider provider,
  ) {
    return call(provider.conversationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'groupConversationProvider';
}

/// See also [groupConversation].
class GroupConversationProvider
    extends AutoDisposeStreamProvider<List<MessageModel>> {
  /// See also [groupConversation].
  GroupConversationProvider(String conversationId)
    : this._internal(
        (ref) => groupConversation(ref as GroupConversationRef, conversationId),
        from: groupConversationProvider,
        name: r'groupConversationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$groupConversationHash,
        dependencies: GroupConversationFamily._dependencies,
        allTransitiveDependencies:
            GroupConversationFamily._allTransitiveDependencies,
        conversationId: conversationId,
      );

  GroupConversationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final String conversationId;

  @override
  Override overrideWith(
    Stream<List<MessageModel>> Function(GroupConversationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupConversationProvider._internal(
        (ref) => create(ref as GroupConversationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<MessageModel>> createElement() {
    return _GroupConversationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupConversationProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GroupConversationRef on AutoDisposeStreamProviderRef<List<MessageModel>> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _GroupConversationProviderElement
    extends AutoDisposeStreamProviderElement<List<MessageModel>>
    with GroupConversationRef {
  _GroupConversationProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as GroupConversationProvider).conversationId;
}

String _$recentConversationsHash() =>
    r'fe7244c213d5cb3de1f12276949f30a68f6a3465';

/// See also [recentConversations].
@ProviderFor(recentConversations)
final recentConversationsProvider =
    AutoDisposeStreamProvider<List<RecentConversation>>.internal(
      recentConversations,
      name: r'recentConversationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentConversationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentConversationsRef =
    AutoDisposeStreamProviderRef<List<RecentConversation>>;
String _$contactsHash() => r'dd2ddf872166e902c5ac3ba9b5f1f6f324efccf7';

/// See also [contacts].
@ProviderFor(contacts)
final contactsProvider = AutoDisposeFutureProvider<List<UserModel>>.internal(
  contacts,
  name: r'contactsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contactsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ContactsRef = AutoDisposeFutureProviderRef<List<UserModel>>;
String _$sendMessageNotifierHash() =>
    r'c07950d99b332b4d7594a8b8d2a86c7e4dd0eb75';

/// See also [SendMessageNotifier].
@ProviderFor(SendMessageNotifier)
final sendMessageNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SendMessageNotifier, void>.internal(
      SendMessageNotifier.new,
      name: r'sendMessageNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sendMessageNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SendMessageNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
