// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sermon_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sermonsHash() => r'5a7bac02ee67388219b35d8b10b6997467bea324';

/// See also [sermons].
@ProviderFor(sermons)
final sermonsProvider = AutoDisposeFutureProvider<List<SermonModel>>.internal(
  sermons,
  name: r'sermonsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sermonsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SermonsRef = AutoDisposeFutureProviderRef<List<SermonModel>>;
String _$latestSermonHash() => r'4accdd6e54dde89bf0008da5e66b0114d7f2bba0';

/// See also [LatestSermon].
@ProviderFor(LatestSermon)
final latestSermonProvider =
    AutoDisposeAsyncNotifierProvider<LatestSermon, SermonModel?>.internal(
      LatestSermon.new,
      name: r'latestSermonProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$latestSermonHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LatestSermon = AutoDisposeAsyncNotifier<SermonModel?>;
String _$sermonPlayerNotifierHash() =>
    r'a317225179e5b0b0de95e66afe33626284c3af27';

/// See also [SermonPlayerNotifier].
@ProviderFor(SermonPlayerNotifier)
final sermonPlayerNotifierProvider =
    AutoDisposeNotifierProvider<
      SermonPlayerNotifier,
      SermonPlayerState
    >.internal(
      SermonPlayerNotifier.new,
      name: r'sermonPlayerNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sermonPlayerNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SermonPlayerNotifier = AutoDisposeNotifier<SermonPlayerState>;
String _$sermonSearchNotifierHash() =>
    r'46efc81b3fff810697abc17044977bfb28eb33e3';

/// See also [SermonSearchNotifier].
@ProviderFor(SermonSearchNotifier)
final sermonSearchNotifierProvider =
    AutoDisposeNotifierProvider<
      SermonSearchNotifier,
      SermonSearchState
    >.internal(
      SermonSearchNotifier.new,
      name: r'sermonSearchNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sermonSearchNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SermonSearchNotifier = AutoDisposeNotifier<SermonSearchState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
