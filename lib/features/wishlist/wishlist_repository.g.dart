// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted wishlist. Static fields (name/category/basePrice/emoji) come
/// from [kWishCatalog]; only the mutable bits (currentPrice + ownedOnDayIndex)
/// live in the DB.

@ProviderFor(WishlistRepository)
final wishlistRepositoryProvider = WishlistRepositoryProvider._();

/// Persisted wishlist. Static fields (name/category/basePrice/emoji) come
/// from [kWishCatalog]; only the mutable bits (currentPrice + ownedOnDayIndex)
/// live in the DB.
final class WishlistRepositoryProvider
    extends $NotifierProvider<WishlistRepository, List<WishItem>> {
  /// Persisted wishlist. Static fields (name/category/basePrice/emoji) come
  /// from [kWishCatalog]; only the mutable bits (currentPrice + ownedOnDayIndex)
  /// live in the DB.
  WishlistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wishlistRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wishlistRepositoryHash();

  @$internal
  @override
  WishlistRepository create() => WishlistRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<WishItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<WishItem>>(value),
    );
  }
}

String _$wishlistRepositoryHash() =>
    r'22ea99e4ea35b82fcfb15d8dfc12f72d22762c3c';

/// Persisted wishlist. Static fields (name/category/basePrice/emoji) come
/// from [kWishCatalog]; only the mutable bits (currentPrice + ownedOnDayIndex)
/// live in the DB.

abstract class _$WishlistRepository extends $Notifier<List<WishItem>> {
  List<WishItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<WishItem>, List<WishItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<WishItem>, List<WishItem>>,
              List<WishItem>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
