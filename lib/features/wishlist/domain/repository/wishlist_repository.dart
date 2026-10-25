import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/domain/entities/wishlist_item_entity.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<WishlistItemEntity>>> getWishlist();

  /// Adds the item if it is not in the wishlist, removes it otherwise
  /// Returns the updated wishlist
  Future<Either<Failure, List<WishlistItemEntity>>> toggleWishlist(
    WishlistItemEntity item,
  );
}
