// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_notes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mediaNotesHash() => r'c7eb9c950201d37858f18edc30c577df9fd73a1f';

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

abstract class _$MediaNotes
    extends BuildlessAutoDisposeAsyncNotifier<List<MediaNoteModel>> {
  late final String videoId;

  FutureOr<List<MediaNoteModel>> build(String videoId);
}

/// See also [MediaNotes].
@ProviderFor(MediaNotes)
const mediaNotesProvider = MediaNotesFamily();

/// See also [MediaNotes].
class MediaNotesFamily extends Family<AsyncValue<List<MediaNoteModel>>> {
  /// See also [MediaNotes].
  const MediaNotesFamily();

  /// See also [MediaNotes].
  MediaNotesProvider call(String videoId) {
    return MediaNotesProvider(videoId);
  }

  @override
  MediaNotesProvider getProviderOverride(
    covariant MediaNotesProvider provider,
  ) {
    return call(provider.videoId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mediaNotesProvider';
}

/// See also [MediaNotes].
class MediaNotesProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<MediaNotes, List<MediaNoteModel>> {
  /// See also [MediaNotes].
  MediaNotesProvider(String videoId)
    : this._internal(
        () => MediaNotes()..videoId = videoId,
        from: mediaNotesProvider,
        name: r'mediaNotesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$mediaNotesHash,
        dependencies: MediaNotesFamily._dependencies,
        allTransitiveDependencies: MediaNotesFamily._allTransitiveDependencies,
        videoId: videoId,
      );

  MediaNotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.videoId,
  }) : super.internal();

  final String videoId;

  @override
  FutureOr<List<MediaNoteModel>> runNotifierBuild(
    covariant MediaNotes notifier,
  ) {
    return notifier.build(videoId);
  }

  @override
  Override overrideWith(MediaNotes Function() create) {
    return ProviderOverride(
      origin: this,
      override: MediaNotesProvider._internal(
        () => create()..videoId = videoId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        videoId: videoId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MediaNotes, List<MediaNoteModel>>
  createElement() {
    return _MediaNotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MediaNotesProvider && other.videoId == videoId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, videoId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MediaNotesRef
    on AutoDisposeAsyncNotifierProviderRef<List<MediaNoteModel>> {
  /// The parameter `videoId` of this provider.
  String get videoId;
}

class _MediaNotesProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          MediaNotes,
          List<MediaNoteModel>
        >
    with MediaNotesRef {
  _MediaNotesProviderElement(super.provider);

  @override
  String get videoId => (origin as MediaNotesProvider).videoId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
