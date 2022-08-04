// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_dislike_post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

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

String $likeDislikePostHash() => r'a9bda953f6d464ec7f8752f8a2892f640eb0aecc';

/// See also [likeDislikePost].
class LikeDislikePostProvider extends AutoDisposeFutureProvider<bool> {
  LikeDislikePostProvider({
    required this.request,
  }) : super(
          (ref) => likeDislikePost(
            ref,
            request: request,
          ),
          from: likeDislikePostProvider,
          name: r'likeDislikePostProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $likeDislikePostHash,
        );

  final LikeDislikeRequest request;

  @override
  bool operator ==(Object other) {
    return other is LikeDislikePostProvider && other.request == request;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, request.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef LikeDislikePostRef = AutoDisposeFutureProviderRef<bool>;

/// See also [likeDislikePost].
final likeDislikePostProvider = LikeDislikePostFamily();

class LikeDislikePostFamily extends Family<AsyncValue<bool>> {
  LikeDislikePostFamily();

  LikeDislikePostProvider call({
    required LikeDislikeRequest request,
  }) {
    return LikeDislikePostProvider(
      request: request,
    );
  }

  @override
  AutoDisposeFutureProvider<bool> getProviderOverride(
    covariant LikeDislikePostProvider provider,
  ) {
    return call(
      request: provider.request,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'likeDislikePostProvider';
}
