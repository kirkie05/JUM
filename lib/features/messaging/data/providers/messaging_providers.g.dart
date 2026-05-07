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

String _$recentConversationsHash() =>
    r'0b184c7991761151d5221601746f6f7e589eed7b';

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
String _$contactsHash() => r'63d5bac53084febb95e4fdff7ec7930000722692';

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
    r'5686e00f7dc793c7c0bfcbbf34842c9f5efde054';

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
