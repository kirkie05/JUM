// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$liveStreamsStreamHash() => r'503bbaf4685b2668d5ee9796335b1b204434e1a1';

/// See also [liveStreamsStream].
@ProviderFor(liveStreamsStream)
final liveStreamsStreamProvider =
    AutoDisposeStreamProvider<List<LiveStreamModel>>.internal(
      liveStreamsStream,
      name: r'liveStreamsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$liveStreamsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LiveStreamsStreamRef =
    AutoDisposeStreamProviderRef<List<LiveStreamModel>>;
String _$liveChatStreamHash() => r'1a121e82e3f0cb9f1f93055b0c497ae9fc34f460';

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

/// See also [liveChatStream].
@ProviderFor(liveChatStream)
const liveChatStreamProvider = LiveChatStreamFamily();

/// See also [liveChatStream].
class LiveChatStreamFamily extends Family<AsyncValue<List<StreamMessage>>> {
  /// See also [liveChatStream].
  const LiveChatStreamFamily();

  /// See also [liveChatStream].
  LiveChatStreamProvider call(String streamId) {
    return LiveChatStreamProvider(streamId);
  }

  @override
  LiveChatStreamProvider getProviderOverride(
    covariant LiveChatStreamProvider provider,
  ) {
    return call(provider.streamId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'liveChatStreamProvider';
}

/// See also [liveChatStream].
class LiveChatStreamProvider
    extends AutoDisposeStreamProvider<List<StreamMessage>> {
  /// See also [liveChatStream].
  LiveChatStreamProvider(String streamId)
    : this._internal(
        (ref) => liveChatStream(ref as LiveChatStreamRef, streamId),
        from: liveChatStreamProvider,
        name: r'liveChatStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$liveChatStreamHash,
        dependencies: LiveChatStreamFamily._dependencies,
        allTransitiveDependencies:
            LiveChatStreamFamily._allTransitiveDependencies,
        streamId: streamId,
      );

  LiveChatStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.streamId,
  }) : super.internal();

  final String streamId;

  @override
  Override overrideWith(
    Stream<List<StreamMessage>> Function(LiveChatStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LiveChatStreamProvider._internal(
        (ref) => create(ref as LiveChatStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        streamId: streamId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<StreamMessage>> createElement() {
    return _LiveChatStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LiveChatStreamProvider && other.streamId == streamId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, streamId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LiveChatStreamRef on AutoDisposeStreamProviderRef<List<StreamMessage>> {
  /// The parameter `streamId` of this provider.
  String get streamId;
}

class _LiveChatStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<StreamMessage>>
    with LiveChatStreamRef {
  _LiveChatStreamProviderElement(super.provider);

  @override
  String get streamId => (origin as LiveChatStreamProvider).streamId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
