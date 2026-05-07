// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sermon_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sermonsHash() => r'eb6cf1b5986dbda28af4414fd0a6965b5a4e632f';

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
String _$sermonPlayerNotifierHash() =>
    r'9057173515f54f475a19b60b8117a75a62554142';

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
    r'7810f7c049ff877c959640b885ebf06cdea2f26c';

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
